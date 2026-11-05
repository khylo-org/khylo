# Khylo Server on Linux

Khylo Server runs as a normal background service on Linux, starts when the machine starts, and restarts if it stops.
It runs as its own `khylo` user, not as root. There are two downloads:

<!-- khylo-downloads:linux -->
<p align="center">
<a href="https://github.com/khylo-org/khylo/releases/download/DEV-V26.11.05.02/khylo-server_26.11.05.02_amd64.deb"><img alt="Download DEV Ubuntu, Debian (.deb)" src="https://img.shields.io/badge/Download%20DEV-Ubuntu,%20Debian%20(.deb)-d97732?style=for-the-badge"></a>
<a href="https://github.com/khylo-org/khylo/releases/download/DEV-V26.11.05.02/khylo-server_26.11.05.02_arm64.deb"><img alt="Download DEV Ubuntu, Debian, Arm (.deb)" src="https://img.shields.io/badge/Download%20DEV-Ubuntu,%20Debian,%20Arm%20(.deb)-d97732?style=flat"></a>
</p>

<p align="center">
<a href="https://github.com/khylo-org/khylo/releases/download/DEV-V26.11.05.02/khylo-server-26.11.05.02-linux-amd64.tar.gz"><img alt="Download DEV Other Linux (.tar.gz)" src="https://img.shields.io/badge/Download%20DEV-Other%20Linux%20(.tar.gz)-d97732?style=flat"></a>
<a href="https://github.com/khylo-org/khylo/releases/download/DEV-V26.11.05.02/khylo-server-26.11.05.02-linux-arm64.tar.gz"><img alt="Download DEV Other Linux, Arm (.tar.gz)" src="https://img.shields.io/badge/Download%20DEV-Other%20Linux,%20Arm%20(.tar.gz)-d97732?style=flat"></a>
</p>
<!-- /khylo-downloads -->

The `.deb` is for Debian, Ubuntu, Linux Mint and Raspberry Pi OS. The `.tar.gz` is for Fedora, Arch, openSUSE and anything else with systemd.

`amd64` is Intel/AMD. `arm64` is ARM (Raspberry Pi 4/5, ARM servers). Check yours with `uname -m`: `x86_64` is amd64,
`aarch64` is arm64.

Tested on Debian 12 and Ubuntu 24.04 (Debian 13 and Ubuntu 22.04 and newer should also work). Running Proxmox? Use the
[Proxmox script](proxmox.md), which installs this same package in a container for you.

## Install on Debian, Ubuntu and friends

```bash
sudo apt install ./khylo-server_<version>_amd64.deb
```

`apt` also installs what Khylo needs (`curl`, `sudo`, `cifs-utils`, `nfs-common`, `fontconfig`, and the ICU library).
When it finishes, Khylo is already running. Open `http://<this machine's address>:8096` and follow the
[first-time setup](first-setup.md).

## Install on other Linux (Fedora, Arch, openSUSE...)

1. Install the few things Khylo needs:

   | Distribution | Command |
   | --- | --- |
   | Fedora | `sudo dnf install libicu fontconfig sudo curl cifs-utils nfs-utils` |
   | Arch | `sudo pacman -S icu fontconfig sudo curl cifs-utils nfs-utils` |
   | openSUSE | `sudo zypper install libicu fontconfig sudo curl cifs-utils nfs-client` |

   (`cifs-utils` and `nfs-utils` are only needed for [network drives](network-drives.md).)
2. Unpack and install:

   ```bash
   tar -xzf khylo-server-<version>-linux-amd64.tar.gz
   cd khylo-server-<version>-linux-amd64
   sudo ./install.sh
   ```
3. Open `http://<this machine's address>:8096`.

The installer creates the `khylo` user, copies the program to `/opt/khylo`, installs a systemd service, and starts it.

## Where things are

| What | Where |
| --- | --- |
| Library, users, settings (back this up) | `/var/lib/khylo` |
| Artwork and temporary files (safe to delete) | `/var/cache/khylo` |
| Logs | `/var/log/khylo` (and `journalctl -u khylo`) |
| The program | `/opt/khylo` |
| Settings you can change | `/etc/khylo/khylo.env` |
| The video converter (ffmpeg) | `/usr/lib/khylo/ffmpeg` |
| Network shares are connected under | `/var/lib/khylo/shares` |

## Running it

```bash
sudo systemctl status khylo          # is it running?
sudo systemctl restart khylo
sudo systemctl stop khylo
sudo systemctl disable khylo         # don't start at boot
journalctl -u khylo -f               # live log
curl http://localhost:8096/health    # prints "Healthy" when ready (the first start takes a minute)
```

## Letting Khylo read your media

Khylo runs as the `khylo` user, so that user must be allowed to read your media folders. The simplest ways:

- Files already readable by everyone (the default for many setups) need nothing.
- Give the `khylo` user access with a shared group:

  ```bash
  sudo usermod -aG media khylo      # "media" is the group that owns your media; use yours
  sudo systemctl restart khylo
  ```
- Or grant it directly (needs the `acl` tools): `sudo setfacl -R -m u:khylo:rX /path/to/media`

Media on a NAS or another computer is easier: add it from inside Khylo as a [network share](network-drives.md). Nothing to
set up on Linux.

## Changing settings

`/etc/khylo/khylo.env` holds the folders Khylo uses. Most people never edit it. After a change, run
`sudo systemctl restart khylo`. The web port and network options are in the dashboard under **Networking**, not in that file.

## Hardware transcoding

Intel and AMD graphics work when the device `/dev/dri` exists. The installer adds the `khylo` user to the `video` and
`render` groups. You may also need your distribution's video driver:

- Intel: `intel-media-va-driver-non-free` (Debian/Ubuntu; needs the `non-free` repository) or `intel-media-driver` (Fedora)
- AMD: `mesa-va-drivers` (Debian/Ubuntu) or `mesa-va-drivers` / `libva-mesa-driver` (Fedora/Arch)

Then restart Khylo. NVIDIA works with NVIDIA's own driver. More in [hardware transcoding](hardware-transcoding.md).

## Updating

Install the new package the same way you installed the first one:

```bash
sudo apt install ./khylo-server_<newversion>_amd64.deb      # Debian/Ubuntu
# or, for the .tar.gz:  unpack it and run  sudo ./install.sh  again
```

Your library and settings in `/var/lib/khylo`, and your edits in `/etc/khylo/khylo.env`, are kept. Khylo restarts by itself.

## Removing it

Debian/Ubuntu:

```bash
sudo apt remove khylo-server
```

This removes the program but keeps your library and settings. Delete them yourself if you want them gone:
`sudo rm -rf /var/lib/khylo /var/cache/khylo /var/log/khylo`.

Other Linux (installed from the `.tar.gz`):

```bash
sudo systemctl disable --now khylo
sudo rm -rf /opt/khylo /usr/lib/khylo /etc/sudoers.d/khylo
sudo rm -f /etc/systemd/system/khylo.service /usr/lib/systemd/system/khylo.service
sudo systemctl daemon-reload
# optional: remove the user and data
sudo userdel khylo; sudo rm -rf /var/lib/khylo /var/cache/khylo /var/log/khylo /etc/khylo
```

## Troubleshooting

See [troubleshooting](troubleshooting.md). Linux-specific:

- **Can't open the page from another computer:** check the firewall. On Ubuntu: `sudo ufw allow 8096/tcp` and
  `sudo ufw allow 7360/udp`. On Fedora: `sudo firewall-cmd --permanent --add-port=8096/tcp --add-port=7360/udp && sudo firewall-cmd --reload`.
- **A library looks empty:** the `khylo` user can't read the folder. See "Letting Khylo read your media".
- **Won't start:** `journalctl -u khylo -n 100` shows why. A common cause is another program already using port 8096.
