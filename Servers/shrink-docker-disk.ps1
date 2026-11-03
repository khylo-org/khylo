# Gives Docker's disk space back to Windows. Docker's disk file (docker_data.vhdx) only ever grows, even after
# images and build cache are deleted, so after builds C: stays full. This releases the empty space and shrinks the file.
#
# Run it from an Administrator PowerShell, with no builds running:
#   powershell -ExecutionPolicy Bypass -File Servers\shrink-docker-disk.ps1
# Docker Desktop is stopped for a few minutes and started again at the end.
$ErrorActionPreference = 'Continue'
$vhdx = Join-Path $env:LOCALAPPDATA 'Docker\wsl\disk\docker_data.vhdx'
$log = Join-Path $env:TEMP 'shrink-docker-disk.log'
Start-Transcript -Path $log -Force | Out-Null

function GB($path) { [math]::Round((Get-Item $path).Length / 1GB, 1) }
$before = GB $vhdx
$freeBefore = [math]::Round((Get-PSDrive C).Free / 1GB, 1)
Write-Host "Docker disk file: $before GB, C: free: $freeBefore GB"

Write-Host 'Stopping Docker Desktop...'
Get-Process 'Docker Desktop', 'com.docker.backend', 'com.docker.build' -ErrorAction SilentlyContinue | Stop-Process -Force
Start-Sleep 3
wsl --shutdown
Start-Sleep 5

Write-Host 'Telling the disk which space is empty (fstrim)...'
wsl --mount --vhd $vhdx --name khylo-trim
wsl -d docker-desktop -u root -e sh -c 'fstrim -v /mnt/wsl/khylo-trim' 2>&1 | Out-Host
if ($LASTEXITCODE -ne 0) { wsl -u root -e sh -c 'fstrim -v /mnt/wsl/khylo-trim' 2>&1 | Out-Host }
wsl --unmount $vhdx
wsl --shutdown
Start-Sleep 5

Write-Host 'Shrinking the file...'
$dp = Join-Path $env:TEMP 'shrink-docker-disk.dp'
@("select vdisk file=`"$vhdx`"", 'attach vdisk readonly', 'compact vdisk', 'detach vdisk', 'exit') | Set-Content $dp -Encoding ascii
diskpart /s $dp | Out-Host

$after = GB $vhdx
$freeAfter = [math]::Round((Get-PSDrive C).Free / 1GB, 1)
Write-Host "Docker disk file: $before GB -> $after GB. C: free: $freeBefore GB -> $freeAfter GB"

Write-Host 'Starting Docker Desktop again...'
$exe = @("$env:LOCALAPPDATA\Programs\DockerDesktop\Docker Desktop.exe", "$env:ProgramFiles\Docker\Docker\Docker Desktop.exe") | Where-Object { Test-Path $_ } | Select-Object -First 1
if ($exe) { Start-Process $exe } else { Write-Host 'Start Docker Desktop yourself.' }
Stop-Transcript | Out-Null
