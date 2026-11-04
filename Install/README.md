# Khylo Server: install and run it

Khylo Server is the part of Khylo that lives on your own hardware. It keeps your library (movies, shows, music,
audiobooks, books, comics, podcasts, photos, DVDs and live TV), fetches artwork and details, converts video when a
screen can't play it directly, and streams to the Khylo apps on your TVs, phones and browsers. Nothing is sent to a
Khylo cloud, and there is no account to create with us.

This guide covers every way to run it.

<!-- khylo-downloads:all -->
<p align="center">
<a href="https://github.com/khylo-org/khylo/releases/download/DEV-V26.11.04.02/khylo-server-26.11.04.02-windows-x64-setup.exe"><img alt="Download Windows" src="https://img.shields.io/badge/Download-Windows-d97732?style=for-the-badge"></a>
<a href="https://github.com/khylo-org/khylo/releases/download/DEV-V26.11.04.01/khylo-server-26.11.04.01-macos-arm64.tar.gz"><img alt="Download Mac (Apple silicon)" src="https://img.shields.io/badge/Download-Mac%20(Apple%20silicon)-d97732?style=for-the-badge"></a>
<a href="https://github.com/khylo-org/khylo/releases/download/DEV-V26.11.04.01/khylo-server-26.11.04.01-macos-x64.tar.gz"><img alt="Download Mac (Intel)" src="https://img.shields.io/badge/Download-Mac%20(Intel)-d97732?style=for-the-badge"></a>
<a href="https://github.com/khylo-org/khylo/releases/download/DEV-V26.11.04.01/khylo-server_26.11.04.01_amd64.deb"><img alt="Download Linux (Ubuntu, Debian)" src="https://img.shields.io/badge/Download-Linux%20(Ubuntu,%20Debian)-d97732?style=for-the-badge"></a>
</p>

<p align="center"><sub>Click your system and it starts downloading.<br>Arm computers, Proxmox and Docker:</sub></p>

<p align="center">
<a href="https://github.com/khylo-org/khylo/releases/download/DEV-V26.11.04.02/khylo-server-26.11.04.02-windows-arm64-setup.exe"><img alt="Download Windows (Arm)" src="https://img.shields.io/badge/Download-Windows%20(Arm)-d97732?style=flat"></a>
<a href="https://github.com/khylo-org/khylo/releases/download/DEV-V26.11.04.01/khylo-server_26.11.04.01_arm64.deb"><img alt="Download Linux (Arm)" src="https://img.shields.io/badge/Download-Linux%20(Arm)-d97732?style=flat"></a>
<a href="https://github.com/khylo-org/khylo/releases/download/DEV-V26.11.04.01/khylo-proxmox-26.11.04.01.tar.gz"><img alt="Download Proxmox" src="https://img.shields.io/badge/Download-Proxmox-d97732?style=flat"></a>
<a href="https://github.com/khylo-org/khylo/releases/download/DEV-V26.11.04.01/khylo-server-docker-26.11.04.01-amd64.tar"><img alt="Download Docker" src="https://img.shields.io/badge/Download-Docker-d97732?style=flat"></a>
<a href="https://github.com/khylo-org/khylo/releases/download/DEV-V26.11.04.01/khylo-server-docker-26.11.04.01-arm64.tar"><img alt="Download Docker (Arm)" src="https://img.shields.io/badge/Download-Docker%20(Arm)-d97732?style=flat"></a>
</p>

<p align="center"><sub>The Khylo app for your Android TV or Google TV:</sub></p>

<p align="center">
<a href="https://github.com/khylo-org/khylo/releases/download/DEV-V26.11.04.01/khylo-tv.apk"><img alt="Download Android TV" src="https://img.shields.io/badge/Download-Android%20TV-d97732?style=for-the-badge"></a>
</p>

<p align="center"><sub>Install guides: <a href="https://github.com/khylo-org/khylo/blob/main/Install/windows.md">Windows</a> · <a href="https://github.com/khylo-org/khylo/blob/main/Install/mac.md">Mac</a> · <a href="https://github.com/khylo-org/khylo/blob/main/Install/linux.md">Linux</a> · <a href="https://github.com/khylo-org/khylo/blob/main/Install/proxmox.md">Proxmox</a> · <a href="https://github.com/khylo-org/khylo/blob/main/Install/docker.md">Docker</a> · <a href="https://github.com/khylo-org/khylo/blob/main/Install/android-tv.md">Android TV</a> · <a href="https://github.com/khylo-org/khylo/releases/tag/DEV-V26.11.04.02">All files</a></sub></p>

<p align="center"><sub>There is no finished stable release yet, so these are dev builds.</sub></p>

<p align="center"><sub>All downloads: <a href="https://github.com/khylo-org/khylo/tree/main/Stable"><b>Stable</b></a> (finished releases) · <a href="https://github.com/khylo-org/khylo/tree/main/Dev"><b>Dev</b></a> (every build, newest first)</sub></p>
<!-- /khylo-downloads -->

## Pick your install

| You have | Use | Guide |
| --- | --- | --- |
| Windows 10 or 11 PC | The Windows download | [Windows](windows.md) |
| A Mac (Apple silicon or Intel) | The Mac download | [Mac](mac.md) |
| Debian, Ubuntu, Linux Mint, Raspberry Pi OS | The `.deb` package | [Linux](linux.md) |
| Fedora, Arch, openSUSE or other Linux with systemd | The `.tar.gz` package | [Linux](linux.md) |
| A Proxmox VE host | One script that makes a container | [Proxmox](proxmox.md) |
| A NAS (Synology, Unraid, TrueNAS, QNAP), or any machine with Docker | The Docker image | [Docker](docker.md) |
| A TV or streaming box with Android TV or Google TV | The Khylo app (it connects to a server you installed above) | [Android TV](android-tv.md) |

Not sure? On a computer that is on all the time, use the native download for its system (Windows, Mac or Linux). On a
NAS, use Docker. On a Proxmox box, use the Proxmox script.

## What you need

| | Minimum | Comfortable |
| --- | --- | --- |
| Processor | Any 64-bit Intel, AMD or ARM processor from the last ten years | Four or more cores; a graphics chip that can convert video (see [hardware transcoding](hardware-transcoding.md)) |
| Memory | 2 GB free | 4 GB or more |
| Disk for Khylo itself | 2 GB for the program, plus space for artwork and metadata (a few GB for a large library) | An SSD for Khylo's folder |
| Media | Anywhere Khylo can read: local drives, or network shares | |
| Network | Wired is best for the server and for TVs | |

Khylo plays most files **directly**, with no conversion, which uses almost no processor. Conversion (transcoding) only
happens when a screen can't play a file, or when you pick a lower quality to save bandwidth.

## Ports

| Port | Used for | Needed |
| --- | --- | --- |
| 8096 / TCP | The web app, the apps, and the API | Yes |
| 7360 / UDP | Apps on your network finding the server by themselves | Optional (you can type the address instead) |

The installers for Windows, Mac, Linux and Proxmox use these ports. Docker maps them in the compose file. You can change
the web port later in the dashboard under **Networking**.

## After installing

1. Open `http://<the server's address>:8096` in a browser. On the server itself that is `http://localhost:8096`.
2. Follow the [first-time setup](first-setup.md): create your account, add your media, and choose your options.
3. Connect your apps (TV, phone, tablet). They find the server by themselves on your home network, or you type its address.

## More guides

- [Android TV app](android-tv.md): install the Khylo app on your Android TV or Google TV.
- [First-time setup](first-setup.md): the setup steps, how to organize your media, and connecting apps.
- [Moving your watch history](import-watch-history.md): bring everyone's history across from Plex or another server.
- [Network drives](network-drives.md): SMB and NFS shares on every system.
- [Manage your server from your phone](manage-from-phone.md): the admin-only Khylo Manager app.
- [Away from home](remote-access.md): HTTPS, reverse proxies, and watching outside your network.
- [Hardware transcoding](hardware-transcoding.md): Intel, AMD, NVIDIA and Apple graphics.
- [Backup, restore, move and update](backup-restore-update.md)
- [Troubleshooting](troubleshooting.md)

## The files

Each release has one download per system. `<version>` looks like `26.10.101` (the year, the month and the build).

| System | File |
| --- | --- |
| Windows (Intel/AMD) | `khylo-server-<version>-windows-x64-setup.exe` |
| Windows (ARM) | `khylo-server-<version>-windows-arm64-setup.exe` |
| Mac (Apple silicon) | `khylo-server-<version>-macos-arm64.tar.gz` |
| Mac (Intel) | `khylo-server-<version>-macos-x64.tar.gz` |
| Debian, Ubuntu, Raspberry Pi OS | `khylo-server_<version>_amd64.deb` or `_arm64.deb` |
| Other Linux | `khylo-server-<version>-linux-amd64.tar.gz` or `-linux-arm64.tar.gz` |
| Proxmox | `khylo-proxmox-<version>.tar.gz` |
| Docker | `khylo-server-docker-<version>-amd64.tar` or `-arm64.tar`, or the image `khylo/server` |
| Android TV and Google TV app | `khylo-tv.apk` |

`amd64`/`x64` means Intel and AMD processors. `arm64` means ARM processors (Apple silicon Macs, Raspberry Pi 4 and 5,
ARM servers). Each file contains the server, the web app, and the video converter (ffmpeg); there is nothing else to
download.

Khylo is free software under the GNU General Public License v2.
