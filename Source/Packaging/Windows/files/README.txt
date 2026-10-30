KHYLO SERVER FOR WINDOWS
========================

Two ways to run it. Unzip this folder first (right-click, Extract All).

1. INSTALL IT (recommended: starts by itself and keeps running)
   - Right-click the Start menu, choose "Terminal (Admin)" or "Windows PowerShell (Admin)".
   - Go to this folder and run:      powershell -ExecutionPolicy Bypass -File .\Install-Khylo.ps1
   - When it says Khylo is running, open http://localhost:8096 and follow the setup.

   Your media is on a network share that needs your Windows login (for example \\nas\Movies)?
   Install it so it runs as you:
       powershell -ExecutionPolicy Bypass -File .\Install-Khylo.ps1 -RunAsUser "$env:USERDOMAIN\$env:USERNAME"
   You will be asked for your Windows password once.

2. JUST TRY IT (nothing is installed)
   Double-click Start-Khylo.bat. Close its window to stop Khylo.

WHERE THINGS ARE
   Program:                   C:\Program Files\Khylo
   Library, users, settings:  C:\ProgramData\Khylo   (back this folder up)

UPDATING
   Unzip the new version and run Install-Khylo.ps1 again. Your library and settings are kept.

REMOVING
   powershell -ExecutionPolicy Bypass -File .\Uninstall-Khylo.ps1
   (add -RemoveData to delete the library and settings too)

NETWORK DRIVES
   In Khylo, add a library and type the share's address, for example \\nas\Movies, or map the drive in Windows
   first. Windows only lets programs running as you use your saved logins, so use -RunAsUser (above) for those.

Windows may ask once whether to allow Khylo through the firewall; the installer already opens the right ports for
private and domain networks.
