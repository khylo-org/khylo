<p align="center">
  <img src="Branding/Khylo GITHUB.png" alt="Khylo" width="420">
</p>

<h3 align="center">Your media. Your hardware.</h3>

<p align="center">
  Movies, shows, music, audiobooks, books, comics and live TV, streamed from your own hardware.<br>
  Free, open source and self-hosted. No subscriptions, no cloud account, no tracking.
</p>

<!-- khylo-downloads:all -->
<p align="center">
<a href="https://github.com/khylo-org/khylo/releases/download/DEV-V26.11.02.02/khylo-server-26.11.02.02-windows-x64-setup.exe"><img alt="Download Windows" src="https://img.shields.io/badge/Download-Windows-d97732?style=for-the-badge"></a>
<a href="https://github.com/khylo-org/khylo/releases/download/DEV-V26.11.02.02/khylo-server-26.11.02.02-macos-arm64.tar.gz"><img alt="Download Mac (Apple silicon)" src="https://img.shields.io/badge/Download-Mac%20(Apple%20silicon)-d97732?style=for-the-badge"></a>
<a href="https://github.com/khylo-org/khylo/releases/download/DEV-V26.11.02.02/khylo-server-26.11.02.02-macos-x64.tar.gz"><img alt="Download Mac (Intel)" src="https://img.shields.io/badge/Download-Mac%20(Intel)-d97732?style=for-the-badge"></a>
<a href="https://github.com/khylo-org/khylo/releases/download/DEV-V26.11.02.02/khylo-server_26.11.02.02_amd64.deb"><img alt="Download Linux (Ubuntu, Debian)" src="https://img.shields.io/badge/Download-Linux%20(Ubuntu,%20Debian)-d97732?style=for-the-badge"></a>
</p>

<p align="center"><sub>Click your system and it starts downloading.<br>Arm computers, Proxmox and Docker:</sub></p>

<p align="center">
<a href="https://github.com/khylo-org/khylo/releases/download/DEV-V26.11.02.02/khylo-server-26.11.02.02-windows-arm64-setup.exe"><img alt="Download Windows (Arm)" src="https://img.shields.io/badge/Download-Windows%20(Arm)-d97732?style=flat"></a>
<a href="https://github.com/khylo-org/khylo/releases/download/DEV-V26.11.02.02/khylo-server_26.11.02.02_arm64.deb"><img alt="Download Linux (Arm)" src="https://img.shields.io/badge/Download-Linux%20(Arm)-d97732?style=flat"></a>
<a href="https://github.com/khylo-org/khylo/releases/download/DEV-V26.11.02.02/khylo-proxmox-26.11.02.02.tar.gz"><img alt="Download Proxmox" src="https://img.shields.io/badge/Download-Proxmox-d97732?style=flat"></a>
<a href="https://github.com/khylo-org/khylo/releases/download/DEV-V26.11.02.02/khylo-server-docker-26.11.02.02-amd64.tar"><img alt="Download Docker" src="https://img.shields.io/badge/Download-Docker-d97732?style=flat"></a>
<a href="https://github.com/khylo-org/khylo/releases/download/DEV-V26.11.02.02/khylo-server-docker-26.11.02.02-arm64.tar"><img alt="Download Docker (Arm)" src="https://img.shields.io/badge/Download-Docker%20(Arm)-d97732?style=flat"></a>
</p>

<p align="center">
<a href="https://github.com/khylo-org/khylo/releases/download/DEV-V26.11.02.02/khylo-tv.apk"><img alt="Download Android TV (.apk)" src="https://img.shields.io/badge/Download-Android%20TV%20(.apk)-d97732?style=flat"></a>
</p>

<p align="center"><sub>Install guides: <a href="https://github.com/khylo-org/khylo/blob/main/Install/windows.md">Windows</a> · <a href="https://github.com/khylo-org/khylo/blob/main/Install/mac.md">Mac</a> · <a href="https://github.com/khylo-org/khylo/blob/main/Install/linux.md">Linux</a> · <a href="https://github.com/khylo-org/khylo/blob/main/Install/proxmox.md">Proxmox</a> · <a href="https://github.com/khylo-org/khylo/blob/main/Install/docker.md">Docker</a> · <a href="https://github.com/khylo-org/khylo/releases/latest">All files</a></sub></p>
<!-- /khylo-downloads -->

## After you install

1. Open `http://<the server's address>:8096` in a browser. On the server itself that is `http://localhost:8096`.
2. Follow the [first-time setup](Install/first-setup.md).
3. Moving from Plex? [Bring your watch history across](Install/import-watch-history.md).

## Guides

[Windows](Install/windows.md) · [Mac](Install/mac.md) · [Linux](Install/linux.md) · [Proxmox](Install/proxmox.md) ·
[Docker](Install/docker.md)

[First-time setup](Install/first-setup.md) · [Network drives](Install/network-drives.md) ·
[Away from home](Install/remote-access.md) · [Hardware transcoding](Install/hardware-transcoding.md) ·
[Backup, restore and update](Install/backup-restore-update.md) · [Troubleshooting](Install/troubleshooting.md)

## Source code

Everything for people who want to read, change or build Khylo Server is in [`Source/`](Source/README.md): the
[server](https://github.com/khylo-org/khylo-server), the [web app](https://github.com/khylo-org/khylo-web) and the recipes
that turn them into the downloads above. With Docker installed, `Source/Packaging/build-all.sh` builds every download.

## Contributing, security and license

[Contributing](.github/CONTRIBUTING.md) · [Security](.github/SECURITY.md) · [Code of conduct](.github/CODE_OF_CONDUCT.md) ·
[What's new](CHANGELOG.md)

Khylo is free software under the [GNU General Public License v2](LICENSE). It includes and builds on open-source work,
including the Jellyfin project; their copyright notices are kept as the license requires. See [NOTICE.md](NOTICE.md).
