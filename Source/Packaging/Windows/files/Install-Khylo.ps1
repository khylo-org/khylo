<#
.SYNOPSIS
  Installs Khylo Server on Windows and starts it. Run from the unzipped Khylo folder, as Administrator.

.DESCRIPTION
  Copies Khylo to Program Files, keeps its library and settings in C:\ProgramData\Khylo, starts it when the PC
  starts, restarts it if it ever stops, and opens the firewall for the web app (8096) and for apps finding the
  server on your network (7360). Running it again updates Khylo and keeps your library and settings.

.PARAMETER RunAsUser
  Run Khylo as this Windows account instead of the system account. Use this when your media is on a network share
  that needs your login (for example \\nas\Movies): Windows only passes your login to programs running as you.
  You will be asked for the account's password.

.EXAMPLE
  .\Install-Khylo.ps1
  .\Install-Khylo.ps1 -RunAsUser "$env:USERDOMAIN\$env:USERNAME"
#>
[CmdletBinding()]
param(
    [string]$InstallDir = (Join-Path $env:ProgramFiles 'Khylo'),
    [string]$DataDir = (Join-Path $env:ProgramData 'Khylo'),
    [string]$RunAsUser = ''
)

$ErrorActionPreference = 'Stop'
$TaskName = 'Khylo Server'

$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    throw 'Please run this as Administrator: right-click PowerShell, choose "Run as administrator", then run it again.'
}

$source = Join-Path $PSScriptRoot 'Khylo'
if (-not (Test-Path (Join-Path $source 'khylo.exe'))) {
    throw "Can't find the Khylo folder next to this script. Run it from the folder you unzipped."
}

Write-Host 'Installing Khylo Server...'

# Stop a running copy (an update)
if (Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue) {
    Stop-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 3
}
Get-Process -Name khylo -ErrorAction SilentlyContinue | Where-Object { $_.Path -like "$InstallDir*" } | Stop-Process -Force -ErrorAction SilentlyContinue

# Files
New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null
Copy-Item -Path (Join-Path $source '*') -Destination $InstallDir -Recurse -Force

# Library, settings, cache and logs live apart from the program, so updates never touch them
foreach ($d in 'data', 'config', 'cache', 'log') {
    New-Item -ItemType Directory -Force -Path (Join-Path $DataDir $d) | Out-Null
}

# Starts at boot, restarts on failure
$exe = Join-Path $InstallDir 'khylo.exe'
$arguments = @(
    '--service',
    "--webdir `"$(Join-Path $InstallDir 'web')`"",
    "--ffmpeg `"$(Join-Path $InstallDir 'ffmpeg\ffmpeg.exe')`"",
    "--datadir `"$(Join-Path $DataDir 'data')`"",
    "--configdir `"$(Join-Path $DataDir 'config')`"",
    "--cachedir `"$(Join-Path $DataDir 'cache')`"",
    "--logdir `"$(Join-Path $DataDir 'log')`""
) -join ' '
$action = New-ScheduledTaskAction -Execute $exe -Argument $arguments -WorkingDirectory $InstallDir
$trigger = New-ScheduledTaskTrigger -AtStartup
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable `
    -RestartCount 999 -RestartInterval (New-TimeSpan -Minutes 1) -ExecutionTimeLimit ([TimeSpan]::Zero) -MultipleInstances IgnoreNew

if ($RunAsUser) {
    $credential = Get-Credential -UserName $RunAsUser -Message 'The password Khylo should run under'
    $principal = New-ScheduledTaskPrincipal -UserId $credential.UserName -LogonType Password -RunLevel Highest
    Register-ScheduledTask -TaskName $TaskName -Action $action -Trigger $trigger -Settings $settings -Principal $principal `
        -User $credential.UserName -Password $credential.GetNetworkCredential().Password -Force | Out-Null
}
else {
    $principal = New-ScheduledTaskPrincipal -UserId 'SYSTEM' -LogonType ServiceAccount -RunLevel Highest
    Register-ScheduledTask -TaskName $TaskName -Action $action -Trigger $trigger -Settings $settings -Principal $principal -Force | Out-Null
}

# Firewall: the web app and apps finding the server
foreach ($rule in @(
        @{ Name = 'Khylo Server (web)'; Protocol = 'TCP'; Port = 8096 },
        @{ Name = 'Khylo Server (discovery)'; Protocol = 'UDP'; Port = 7360 })) {
    if (-not (Get-NetFirewallRule -DisplayName $rule.Name -ErrorAction SilentlyContinue)) {
        New-NetFirewallRule -DisplayName $rule.Name -Direction Inbound -Action Allow -Protocol $rule.Protocol -LocalPort $rule.Port -Profile Private, Domain | Out-Null
    }
}

Start-ScheduledTask -TaskName $TaskName

Write-Host 'Starting Khylo...'
$up = $false
for ($i = 0; $i -lt 60; $i++) {
    Start-Sleep -Seconds 2
    try {
        $r = Invoke-WebRequest -Uri 'http://localhost:8096/health' -UseBasicParsing -TimeoutSec 3
        if ($r.StatusCode -eq 200) { $up = $true; break }
    }
    catch { }
}

$address = (Get-NetIPAddress -AddressFamily IPv4 -ErrorAction SilentlyContinue | Where-Object { $_.IPAddress -notlike '127.*' -and $_.IPAddress -notlike '169.254.*' } | Select-Object -First 1).IPAddress
if ($up) {
    Write-Host ''
    Write-Host "Khylo is running. Open  http://localhost:8096  to finish setup." -ForegroundColor Green
    if ($address) { Write-Host "From other devices: http://${address}:8096" }
    Write-Host "Your library and settings are in $DataDir (back that folder up)."
}
else {
    Write-Warning "Khylo was installed but hasn't answered yet. Give it a minute, then open http://localhost:8096. Logs are in $DataDir\log."
}
