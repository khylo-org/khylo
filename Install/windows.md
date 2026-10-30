# Khylo Server on Windows

Khylo Server for Windows comes as a zip with an installer script. The installer puts Khylo in `C:\Program Files\Khylo`,
keeps your library and settings in `C:\ProgramData\Khylo`, starts Khylo when the PC starts, restarts it if it stops, and
opens the firewall for it. Windows 10 and 11 are supported, on Intel/AMD (`x64`) and ARM (`arm64`) PCs.

| Your PC | Download |
| --- | --- |
| Most PCs (Intel, AMD) | `khylo-server-<version>-windows-x64.zip` |
| ARM PCs (Surface Pro X, Snapdragon laptops) | `khylo-server-<version>-windows-arm64.zip` |

Not sure? Open Settings > System > About and read "System type".

## Install

1. **Unblock the zip first** (so Windows doesn't warn about every file): right-click the zip, choose **Properties**, tick
   **Unblock** at the bottom if it is there, and click OK.
2. Right-click the zip and choose **Extract All**. A folder opens with `Install-Khylo.ps1`, `Start-Khylo.bat`, a `Khylo`
   folder and a short `README.txt`.
3. Open PowerShell **as Administrator**: right-click the Start button and choose **Terminal (Admin)** or
   **Windows PowerShell (Admin)**.
4. Go to the extracted folder and run the installer:

   ```powershell
   cd "C:\Users\<you>\Downloads\khylo-server-<version>-windows-x64"
   powershell -ExecutionPolicy Bypass -File .\Install-Khylo.ps1
   ```
5. Wait. It prints "Khylo is running" with the address to open. Open `http://localhost:8096` and follow the
   [first-time setup](first-setup.md). From other devices use `http://<this PC's address>:8096`; the installer prints it.

The first start can take a minute or two while Khylo prepares its database.

### If your media is on a network share that needs your login

Windows only passes your saved network logins to programs running as you. If your media is on `\\nas\Movies` (or any
share that asks for a password), install Khylo so it runs as you:

```powershell
powershell -ExecutionPolicy Bypass -File .\Install-Khylo.ps1 -RunAsUser "$env:USERDOMAIN\$env:USERNAME"
```

You are asked for your Windows password once. (Without this, Khylo runs as the system account, which is fine for media
on local drives and for shares that allow guest access.) See [network drives](network-drives.md).

## Just try it, without installing

Double-click `Start-Khylo.bat`. Khylo runs in that window until you close it, and keeps its library in
`%LOCALAPPDATA%\Khylo`. Good for a look around; use the installer for a server that stays on.

## Where things are

| What | Where |
| --- | --- |
| The program | `C:\Program Files\Khylo` |
| Library, users, settings (back this up) | `C:\ProgramData\Khylo` |
| Logs | `C:\ProgramData\Khylo\log` |
| Artwork and temporary files | `C:\ProgramData\Khylo\cache` |
| The video converter (ffmpeg) | `C:\Program Files\Khylo\ffmpeg` |

## Running it

Khylo runs as a scheduled task named **Khylo Server** that starts at boot. From an Administrator PowerShell:

```powershell
Get-ScheduledTask 'Khylo Server'                 # is it there, and its state
Start-ScheduledTask 'Khylo Server'               # start
Stop-ScheduledTask 'Khylo Server'                # stop
Invoke-WebRequest http://localhost:8096/health   # "Healthy" when ready
```

You can also see and control it in **Task Scheduler**.

## Firewall

The installer adds two rules for private and domain networks: TCP 8096 (the web app and apps) and UDP 7360 (apps finding
the server). If your network is set to **Public** in Windows, change it to **Private** (Settings > Network & internet >
your connection > Network profile) so other devices can reach Khylo.

## Hardware transcoding

Khylo's video converter can use Intel (Quick Sync), NVIDIA (NVENC) and AMD (AMF) graphics when the graphics driver is
installed. Khylo's setup checks what your PC has. See [hardware transcoding](hardware-transcoding.md).

## Keeping the PC awake

A sleeping PC can't serve media. In Settings > System > Power & battery, set **Screen and sleep** so the PC never goes to
sleep while plugged in.

## Updating

Download the new zip, extract it, and run the installer again (same command as before; add `-RunAsUser ...` again if you
used it). It stops Khylo, replaces the program, and starts it. Your library and settings are kept.

## Removing it

```powershell
powershell -ExecutionPolicy Bypass -File .\Uninstall-Khylo.ps1
```

This removes the program, the startup task and the firewall rules, and keeps `C:\ProgramData\Khylo`. Add `-RemoveData` to
delete the library and settings too (this cannot be undone).

## Troubleshooting

See [troubleshooting](troubleshooting.md). Windows-specific:

- **"Running scripts is disabled" or a script policy error:** use the `-ExecutionPolicy Bypass` form shown above.
- **The installer says to run as Administrator:** open PowerShell with **Run as administrator**.
- **Other devices can't open it:** check the firewall rules above and that the network profile is **Private**.
- **Khylo doesn't start after a reboot:** open Task Scheduler, find **Khylo Server**, and check its last run result; read the
  newest file in `C:\ProgramData\Khylo\log`.
- **A network share looks empty:** install with `-RunAsUser` (above).
- **Port 8096 is in use:** another program has it. Stop that program, or change Khylo's port in the dashboard under
  **Networking** (and the firewall rule to match).
