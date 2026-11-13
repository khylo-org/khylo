# Khylo Server on Windows

Khylo Server for Windows is a normal installer. It puts Khylo in `C:\Program Files\Khylo`, keeps your library and
settings in `C:\ProgramData\Khylo`, starts Khylo when the PC starts, starts it again within five minutes if it ever stops, opens the firewall for it, and
adds Khylo to your Start menu and to Windows' **Installed apps**. Windows 10 and 11 are supported, on Intel/AMD (`x64`) and
ARM (`arm64`) PCs.

<!-- khylo-downloads:windows -->
<p align="center">
<a href="https://github.com/khylo-org/khylo/releases/download/DEV-V26.11.13.02/khylo-server-26.11.13.02-windows-x64-setup.exe"><img alt="Download DEV Windows" src="https://img.shields.io/badge/Download%20DEV-Windows-d97732?style=for-the-badge"></a>
<a href="https://github.com/khylo-org/khylo/releases/download/DEV-V26.11.13.02/khylo-server-26.11.13.02-windows-arm64-setup.exe"><img alt="Download DEV Windows (Arm)" src="https://img.shields.io/badge/Download%20DEV-Windows%20(Arm)-d97732?style=flat"></a>
</p>

<p align="center">Windows may say it doesn't know the publisher (the installer isn't signed). Click <b>More info</b>, then <b>Run anyway</b>.</p>
<!-- /khylo-downloads -->

Intel/AMD is most PCs. Arm is for Surface Pro X and Snapdragon laptops. Not sure? Open Settings > System > About and read "System type".


## Install

1. Click the button above for your PC.
2. Double-click it.
3. **Windows may say "Windows protected your PC."** Khylo's installer isn't signed yet (signing costs money, and Khylo is
   free), so Windows doesn't know it. Click **More info**, then **Run anyway**. You can check the download against
   `SHA256SUMS.txt` on the same page first if you like.
4. Click **Yes** when Windows asks to allow changes, then follow the setup: accept the licence, choose a folder (the
   default is fine), and choose how Khylo runs (see below).
5. When it finishes, leave **Open Khylo in my web browser** ticked and click **Finish**. Follow the
   [first-time setup](first-setup.md). From other devices use `http://<this PC's address>:8096`.

The first start can take a minute or two while Khylo prepares its database.

### How Khylo runs (the third step of the setup)

- **As a limited account made for services (recommended).** Khylo starts before anyone logs in and keeps running, as
  Windows' built-in *Local Service* account. If someone ever broke into Khylo, they would get that small account, not the
  whole PC. Khylo can open the folders that every user of the PC can open. For any other folder, the folder picker says
  that Khylo isn't allowed in and shows **Give Khylo access to this folder**: click it and, usually within a minute, Khylo
  can read that folder and everything inside it, including folders that have their own permissions (tick the box to also let
  it add and delete files there, for recordings or deleting from Khylo). Choosing a folder with **Select Path** does this for
  you. A very big folder takes Windows longer, and the page shows how many folders are still locked until it is done. Each
  library also says when Khylo can't read some of its folders, so a scan never skips them without telling you. Khylo is never given Windows' own folders, the programs, or
  a whole user profile this way: keep media in a folder of its own. You can also do it by hand: give *LOCAL SERVICE* access
  to the folder (right-click it, Properties, Security). Network folders work
  through the login you give Khylo for them (see below). The dashboard can't restart or shut down the PC itself in this
  mode (restarting Khylo works).
- **As the system, with full access (how earlier versions ran).** Khylo starts before anyone logs in and can open any
  folder. Windows keeps drive letters private to each login, so the system can't use your `X:` directly. Instead, the folder
  picker lists the drives mapped on this PC under their letters (for example `X: \\bb02.\dfs01`). Click one: if Khylo can open
  it, it opens; if not, it asks for your login for that share once, remembers it, and keeps it connected.
- **As me, while I'm logged in.** Khylo runs in your own desktop session, so your mapped drive letters work directly, but it
  only runs while you're logged in.
- **As me, even when I'm logged out.** Starts with the PC and needs your Windows password once (Windows keeps it, Khylo never
  sees it). Uses full addresses like `\\nas\Movies` rather than drive letters.

Running the installer again keeps the way Khylo ran before, so nothing changes unless you choose a different one. To
change from the system to the limited account (or back), run the installer again and pick it on that page.

A mapped drive that shows a red X in File Explorer is disconnected. Connecting it from Khylo's folder picker reconnects it
for Khylo. See [network drives](network-drives.md).

## Where things are

| What | Where |
| --- | --- |
| The program | `C:\Program Files\Khylo` |
| Library, users, settings (back this up) | `C:\ProgramData\Khylo` |
| Logs | `C:\ProgramData\Khylo\log` |
| Artwork and temporary files | `C:\ProgramData\Khylo\cache` |
| The video converter (ffmpeg) | `C:\Program Files\Khylo\ffmpeg` |
| The last update's installer, log and backup (kept by the system, open to administrators only) | `C:\ProgramData\KhyloUpdate` |

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

Khylo checks the release page by itself and tells you in the dashboard (**Updates**, in the left menu under Logs) when there's a
newer build. Press **Update now**: it shows its progress and takes about 2 to 3 minutes. It downloads the new installer, checks it against the published checksum, and installs it.
Your library and settings are kept, and Khylo is back within a minute or two.

- **Channel:** choose **Stable releases** (finished versions only) or **Every build (dev)**.
- **Install by themselves:** off by default. Turn it on and Khylo installs a new version at 3 am, and only when nobody is
  watching. Otherwise it waits for the next night.
- **If something goes wrong:** before installing, Khylo keeps a copy of the working version. If the new one doesn't start and
  answer within about three minutes, the old one is put back and the dashboard says so.
- **Skip this one** ignores a build; the next newer one is offered again.

If Khylo runs as the system or as an administrator it installs the update itself. If it runs as the limited account (or as
a regular Windows user), it can't install anything, so the installer also sets up a small **update helper**, a task that runs
as the system every minute. Khylo downloads the update and checks it, then leaves it for the helper, which checks the
signature and the checksum again on its own, installs only a newer build, and puts the old version back if the new one
doesn't start. In the dashboard it works the same way, with an extra minute or two. If the helper is missing (the
installer couldn't set it up), the panel says so and you update the old way: download the new installer and run it. Either
way, running the installer yourself still works, and it keeps the way Khylo runs.

## Removing it

Settings > Apps > Installed apps > **Khylo Server** > Uninstall. This removes the program, the startup and update tasks and the firewall
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

`/S` installs silently. A first install runs Khylo as the limited account; an update keeps the way Khylo already runs (an
install from before this choice existed ran as the system, and stays that way). `/D=` must be last and the folder should be called `Khylo`. A silent
uninstall keeps your library and settings.

## Troubleshooting

See [troubleshooting](troubleshooting.md). Windows-specific:

- **"Windows protected your PC":** click **More info**, then **Run anyway**. The installer isn't signed yet.
- **Other devices can't open it:** check the firewall rules above and that the network profile is **Private**.
- **Khylo doesn't start after a reboot:** open Task Scheduler, find **Khylo Server**, and check its last run result; read the
  newest file in `C:\ProgramData\Khylo\log`.
- **My network drives (like X:) aren't in Khylo's drive list:** open the folder picker and look for them under their letters (like `X:`). Click one and enter your login for the share. Only drives mapped by someone who is logged in are listed. If you want your drive letters to work directly, run the installer again and choose **As me, while I'm logged in**.
- **The installer says Windows would not set Khylo to start with the PC:** the account name or password was rejected. Run it
  again and check them, or choose **The system**.
- **Port 8096 is in use:** another program has it. Stop that program, or change Khylo's port in the dashboard under
  **Networking** (and the firewall rule to match).
