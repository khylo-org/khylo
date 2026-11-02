# Khylo Server on Windows

Khylo Server for Windows is a normal installer. It puts Khylo in `C:\Program Files\Khylo`, keeps your library and
settings in `C:\ProgramData\Khylo`, starts Khylo when the PC starts, restarts it if it stops, opens the firewall for it, and
adds Khylo to your Start menu and to Windows' **Installed apps**. Windows 10 and 11 are supported, on Intel/AMD (`x64`) and
ARM (`arm64`) PCs.

| Your PC | Download |
| --- | --- |
| Most PCs (Intel, AMD) | `khylo-server-<version>-windows-x64-setup.exe` |
| ARM PCs (Surface Pro X, Snapdragon laptops) | `khylo-server-<version>-windows-arm64-setup.exe` |

Not sure? Open Settings > System > About and read "System type".

## Install

1. Download the installer for your PC from the [Releases page](https://github.com/khylo-org/khylo/releases/latest).
2. Double-click it.
3. **Windows may say "Windows protected your PC."** Khylo's installer isn't signed yet (signing costs money, and Khylo is
   free), so Windows doesn't know it. Click **More info**, then **Run anyway**. You can check the download against
   `SHA256SUMS.txt` on the same page first if you like.
4. Click **Yes** when Windows asks to allow changes, then follow the setup: accept the licence, choose a folder (the
   default is fine), and choose who Khylo runs as (see below).
5. When it finishes, leave **Open Khylo in my web browser** ticked and click **Finish**. Follow the
   [first-time setup](first-setup.md). From other devices use `http://<this PC's address>:8096`.

The first start can take a minute or two while Khylo prepares its database.

### Who Khylo runs as

- **The system (recommended).** Khylo starts with Windows before anyone logs in. Fine for media on this PC's drives and USB
  drives, and for network shares that allow guests.
- **My Windows account.** Choose this if your media is on a network share that asks for a login, such as `\\nas\Movies`.
  Windows only passes your saved network logins to programs that run as you. You enter your Windows password once; Windows
  keeps it, and Khylo never sees it. If you change your Windows password later, run the installer again.

See [network drives](network-drives.md).

## Where things are

| What | Where |
| --- | --- |
| The program | `C:\Program Files\Khylo` |
| Library, users, settings (back this up) | `C:\ProgramData\Khylo` |
| Logs | `C:\ProgramData\Khylo\log` |
| Artwork and temporary files | `C:\ProgramData\Khylo\cache` |
| The video converter (ffmpeg) | `C:\Program Files\Khylo\ffmpeg` |

## Running it

Khylo runs in the background as a scheduled task named **Khylo Server** that starts at boot. Open **Task Scheduler** to
see it, stop it or start it. Or, from an Administrator Command Prompt:

```
schtasks /Query /TN "Khylo Server"
schtasks /Run /TN "Khylo Server"
schtasks /End /TN "Khylo Server"
curl http://localhost:8096/health
```

The last one answers `Healthy` when Khylo is ready. The Start menu also has **Khylo > Open Khylo**.

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

Download the new installer and run it. It stops Khylo, replaces the program, and starts it again. Your library and
settings are kept. (Run it again as the same account choice you used before.)

## Removing it

Settings > Apps > Installed apps > **Khylo Server** > Uninstall. This removes the program, the startup task and the firewall
rules. It asks whether to delete your library and settings in `C:\ProgramData\Khylo` too; choose **No** to keep them.

## Just try it, without installing

The **portable** download (`khylo-server-<version>-windows-<cpu>-portable.zip`) installs nothing. Extract it and
double-click `Start-Khylo.bat`; Khylo runs in that window until you close it, and keeps its library in
`%LOCALAPPDATA%\Khylo`. Good for a look around; use the installer for a server that stays on.

## Installing without clicking (IT and advanced users)

```
khylo-server-<version>-windows-x64-setup.exe /S
khylo-server-<version>-windows-x64-setup.exe /S /D=D:\Apps\Khylo
"C:\Program Files\Khylo\Uninstall.exe" /S
```

`/S` installs silently and runs Khylo as the system. `/D=` must be last and the folder should be called `Khylo`. A silent
uninstall keeps your library and settings.

## Troubleshooting

See [troubleshooting](troubleshooting.md). Windows-specific:

- **"Windows protected your PC":** click **More info**, then **Run anyway**. The installer isn't signed yet.
- **Other devices can't open it:** check the firewall rules above and that the network profile is **Private**.
- **Khylo doesn't start after a reboot:** open Task Scheduler, find **Khylo Server**, and check its last run result; read the
  newest file in `C:\ProgramData\Khylo\log`.
- **A network share looks empty:** run the installer again and choose **My Windows account**.
- **The installer says Windows would not set Khylo to start with the PC:** the account name or password was rejected. Run it
  again and check them, or choose **The system**.
- **Port 8096 is in use:** another program has it. Stop that program, or change Khylo's port in the dashboard under
  **Networking** (and the firewall rule to match).
