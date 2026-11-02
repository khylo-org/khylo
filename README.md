<p align="center">
  <img src="Branding/Khylo GITHUB.png" alt="Khylo" width="560">
</p>

<h1 align="center">Khylo Server</h1>

<p align="center">
  Your movies, shows, music, audiobooks, books, comics and live TV, streamed from your own hardware.<br>
  Free, open source and self-hosted. No subscriptions, no cloud account, no tracking.
</p>

---

## Download

Ready-to-run downloads for every system are on the **[Releases page](../../releases/latest)**. Pick the one for your system:

| You have | Download | Guide |
| --- | --- | --- |
| Windows 10 or 11 | `khylo-server-<version>-windows-x64-setup.exe` (ARM PCs: `-arm64-setup.exe`) | [Install on Windows](Install/windows.md) |
| A Mac | `khylo-server-<version>-macos-arm64.tar.gz` (Intel Macs: `-x64.tar.gz`) | [Install on Mac](Install/mac.md) |
| Debian, Ubuntu, Raspberry Pi OS | `khylo-server_<version>_amd64.deb` (ARM: `_arm64.deb`) | [Install on Linux](Install/linux.md) |
| Other Linux | `khylo-server-<version>-linux-amd64.tar.gz` (ARM: `-arm64.tar.gz`) | [Install on Linux](Install/linux.md) |
| Proxmox | `khylo-proxmox-<version>.tar.gz` | [Install on Proxmox](Install/proxmox.md) |
| A NAS, or any machine with Docker | `khylo-server-docker-<version>-amd64.tar` (ARM: `-arm64.tar`) | [Install with Docker](Install/docker.md) |

Each download already contains the server, the web app and the video converter. Nothing else to get.
Every release also lists a `SHA256SUMS.txt` so you can check your download.

**Then:** open `http://<the server's address>:8096` in a browser and follow the [first-time setup](Install/first-setup.md).

## Guides

All of them are in [`Install/`](Install/README.md): [first-time setup](Install/first-setup.md),
[network drives](Install/network-drives.md), [away from home](Install/remote-access.md),
[hardware transcoding](Install/hardware-transcoding.md), [backup, restore and update](Install/backup-restore-update.md)
and [troubleshooting](Install/troubleshooting.md).

## What is in this repository

This repository holds the **source code** and the **recipes that turn it into the downloads**. The finished,
compiled downloads are not kept here: they are on the Releases page.

| Folder | What it is |
| --- | --- |
| [`Install/`](Install/README.md) | Guides for people installing and running Khylo Server. Start here if you just want to use it. |
| [`Source/`](Source/README.md) | Everything for people who want to read, change or build Khylo Server. |
| `Branding/` | Logos. |

## Building it yourself

See [`Source/README.md`](Source/README.md). In short, with Docker installed: `Source/Packaging/build-all.sh` builds every download
from the source and puts the results in `Source/Packaging/*/builds/`.

## Contributing and security

Read [CONTRIBUTING.md](CONTRIBUTING.md) and [SECURITY.md](SECURITY.md) first. Please follow the [code of conduct](CODE_OF_CONDUCT.md).

## License

Khylo is free software under the [GNU General Public License v2](LICENSE). It includes and builds on open-source work,
including the Jellyfin project; their copyright notices are kept as the license requires. See [NOTICE.md](NOTICE.md).
