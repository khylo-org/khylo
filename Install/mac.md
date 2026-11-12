# Khylo Server on Mac

Khylo Server for Mac is a download with an installer script. It installs Khylo into `/usr/local/khylo`, keeps your
library and settings in your own Library folder, and runs Khylo in the background from the moment the Mac starts, as you,
so it can read your media folders.

<!-- khylo-downloads:mac -->
<p align="center">
<a href="https://github.com/khylo-org/khylo/releases/download/DEV-V26.11.11.01/khylo-server-26.11.11.01-macos-arm64.tar.gz"><img alt="Download DEV Mac (Apple silicon)" src="https://img.shields.io/badge/Download%20DEV-Mac%20(Apple%20silicon)-d97732?style=for-the-badge"></a>
<a href="https://github.com/khylo-org/khylo/releases/download/DEV-V26.11.11.01/khylo-server-26.11.11.01-macos-x64.tar.gz"><img alt="Download DEV Mac (Intel)" src="https://img.shields.io/badge/Download%20DEV-Mac%20(Intel)-d97732?style=for-the-badge"></a>
</p>
<!-- /khylo-downloads -->

Apple silicon is every Mac from late 2020 (M1, M2, M3, M4 and newer); older Macs are Intel. Not sure? Apple menu > About This Mac shows "Chip" (Apple silicon) or "Processor" (Intel).

Use a current version of macOS (macOS 14 or newer is the safe choice).

## Install

1. Double-click the downloaded `.tar.gz` to unpack it. A folder named like `khylo-server-<version>-macos-arm64` appears.
2. Open **Terminal** (Applications > Utilities) and go into the folder:

   ```bash
   cd ~/Downloads/khylo-server-<version>-macos-arm64
   ```
3. Run the installer. It asks for your password:

   ```bash
   sudo ./install.sh
   ```
4. Wait for "Khylo is running". Open `http://localhost:8096` and follow the [first-time setup](first-setup.md). From other
   devices use `http://<this Mac's address>:8096`; the installer prints it.

The download is not signed by Apple (that needs an Apple developer account), so the installer clears macOS's "downloaded
from the internet" mark from Khylo for you. If you ever see a message that "khylo can't be opened", run
`sudo xattr -dr com.apple.quarantine /usr/local/khylo`.

## Giving Khylo access to your media

macOS protects some folders. Khylo runs in the background, where macOS cannot show an "allow access" prompt, so grant
access yourself once:

1. Open **System Settings > Privacy & Security > Full Disk Access**.
2. Click **+**, press **Shift-Command-G**, type `/usr/local/khylo/khylo`, and add it. Turn it on.
3. Restart Khylo: `sudo launchctl kickstart -k system/org.khylo.server`.

You need this for media on **external drives**, in **Documents, Downloads, Desktop or Movies**, or on other protected
locations. Media in a plain folder you created (for example `/Users/Shared/Media`) needs nothing.

## Where things are

| What | Where |
| --- | --- |
| The program | `/usr/local/khylo` |
| Library, users, settings (back this up) | `~/Library/Application Support/Khylo` |
| Logs | `~/Library/Application Support/Khylo/log` |
| The startup definition | `/Library/LaunchDaemons/org.khylo.server.plist` |

## Running it

```bash
sudo launchctl print system/org.khylo.server | head      # is it loaded and running?
sudo launchctl kickstart -k system/org.khylo.server      # restart
sudo launchctl bootout system/org.khylo.server           # stop (until the next restart or install)
curl http://localhost:8096/health                        # "Healthy" when ready
```

## Network drives

Connect the share in Finder first (**Go > Connect to Server**, for example `smb://nas/Movies`), then in Khylo add a library
and choose the folder under `/Volumes`. Add the share to **System Settings > General > Login Items** so it reconnects after
a restart. Because Khylo runs as you, it uses the share your account has connected. See [network drives](network-drives.md).

## Keeping the Mac awake

A sleeping Mac can't serve media. In **System Settings > Energy** (or **Battery > Options** on a laptop), turn on
**Prevent automatic sleeping on power adapter when the display is off** and **Wake for network access**.

## Hardware transcoding

Khylo's video converter can use Apple's hardware video engine (VideoToolbox). Khylo's setup checks what your Mac has. See
[hardware transcoding](hardware-transcoding.md).

## Updating

Unpack the new download and run `sudo ./install.sh` again. It stops Khylo, replaces the program and starts it. Your library
and settings are kept.

## Removing it

```bash
sudo ./uninstall.sh                 # keeps your library and settings
sudo ./uninstall.sh --remove-data   # also deletes them (cannot be undone)
```

## Troubleshooting

See [troubleshooting](troubleshooting.md). Mac-specific:

- **A library looks empty or "can't read":** grant Full Disk Access (above), then restart Khylo.
- **Other devices can't open it:** in **System Settings > Network > Firewall**, allow incoming connections for `khylo`, or turn
  the firewall off for your home network.
- **It stops when the Mac sleeps:** see "Keeping the Mac awake".
- **Network share path not found after a restart:** the share wasn't reconnected yet. Add it to Login Items.
- Network shares can't be connected from inside Khylo on a Mac; connect them in Finder instead.
