<#
.SYNOPSIS
  Removes Khylo Server from Windows. Your library and settings in C:\ProgramData\Khylo are kept unless you ask.

.PARAMETER RemoveData
  Also delete the library, users and settings. This cannot be undone.
#>
[CmdletBinding()]
param(
    [string]$InstallDir = (Join-Path $env:ProgramFiles 'Khylo'),
    [string]$DataDir = (Join-Path $env:ProgramData 'Khylo'),
    [switch]$RemoveData
)

$ErrorActionPreference = 'Stop'
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    throw 'Please run this as Administrator.'
}

if (Get-ScheduledTask -TaskName 'Khylo Server' -ErrorAction SilentlyContinue) {
    Stop-ScheduledTask -TaskName 'Khylo Server' -ErrorAction SilentlyContinue
    Unregister-ScheduledTask -TaskName 'Khylo Server' -Confirm:$false
}
Get-Process -Name khylo -ErrorAction SilentlyContinue | Where-Object { $_.Path -like "$InstallDir*" } | Stop-Process -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 2

foreach ($name in 'Khylo Server (web)', 'Khylo Server (discovery)') {
    Get-NetFirewallRule -DisplayName $name -ErrorAction SilentlyContinue | Remove-NetFirewallRule
}

if (Test-Path $InstallDir) { Remove-Item -Recurse -Force $InstallDir }

if ($RemoveData) {
    if (Test-Path $DataDir) { Remove-Item -Recurse -Force $DataDir }
    Write-Host 'Khylo and its data were removed.'
}
else {
    Write-Host "Khylo was removed. Your library and settings are still in $DataDir. Delete that folder yourself if you want them gone."
}
