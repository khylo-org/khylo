<p align="center">
  <img src="Branding/Khylo GITHUB.png" alt="Khylo" width="420">
</p>

<h3 align="center">Your media. Your hardware.</h3>

<p align="center">
  Movies, shows, music, audiobooks, books, comics and live TV, streamed from your own hardware.<br>
  Free, open source and self-hosted. No subscriptions, no cloud account, no tracking.
</p>

<!-- khylo-downloads:all -->
<h2 align="center">Download</h2>

<h3 align="center"><a href="https://github.com/khylo-org/khylo/tree/main/Stable">Stable</a> &nbsp;·&nbsp; <a href="https://github.com/khylo-org/khylo/tree/main/Dev">Dev</a></h3>

<p align="center"><b>Stable</b> is the finished, tested release: the one to install.<br><b>Dev</b> is every build as soon as it is made, with the newest changes.</p>

<p align="center">There is no finished stable release yet, so Stable is empty for now. Dev has the latest.</p>

<h2 align="center">Install guides</h2>

<h3 align="center"><a href="https://github.com/khylo-org/khylo/blob/main/Install/windows.md">Windows</a> &nbsp;·&nbsp; <a href="https://github.com/khylo-org/khylo/blob/main/Install/mac.md">Mac</a> &nbsp;·&nbsp; <a href="https://github.com/khylo-org/khylo/blob/main/Install/linux.md">Linux</a> &nbsp;·&nbsp; <a href="https://github.com/khylo-org/khylo/blob/main/Install/proxmox.md">Proxmox</a> &nbsp;·&nbsp; <a href="https://github.com/khylo-org/khylo/blob/main/Install/docker.md">Docker</a> &nbsp;·&nbsp; <a href="https://github.com/khylo-org/khylo/blob/main/Install/android-tv.md">Android TV</a></h3>

<h2 align="center">Code</h2>

<h3 align="center"><a href="https://github.com/khylo-org/khylo-server">Server</a> &nbsp;·&nbsp; <a href="https://github.com/khylo-org/khylo-web">Web app</a> &nbsp;·&nbsp; <a href="https://github.com/khylo-org/khylo-androidtv">Android TV app</a></h3>

<h2 align="center">More</h2>

<h3 align="center"><a href="https://github.com/khylo-org/khylo/blob/main/CHANGELOG.md">What's new</a> &nbsp;·&nbsp; <a href="https://github.com/khylo-org/khylo/issues">Report a problem</a></h3>
<!-- /khylo-downloads -->

## Get started in three steps

1. **Install the server** on a computer that stays on: use a download above and its [install guide](Install/README.md).
2. **Open it.** Go to `http://<the server's address>:8096` in a browser (on the server itself, `http://localhost:8096`) and follow the [first-time setup](Install/first-setup.md).
3. **Add your screens.** Use the web app in any browser, or install the [Android TV app](Install/android-tv.md). Moving from Plex? [Bring your watch history across](Install/import-watch-history.md).

## Guides

[Windows](Install/windows.md) &middot; [Mac](Install/mac.md) &middot; [Linux](Install/linux.md) &middot; [Proxmox](Install/proxmox.md) &middot;
[Docker](Install/docker.md) &middot; [Android TV](Install/android-tv.md)

[First-time setup](Install/first-setup.md) &middot; [Network drives](Install/network-drives.md) &middot;
[Away from home](Install/remote-access.md) &middot; [Hardware transcoding](Install/hardware-transcoding.md) &middot;
[Backup, restore and update](Install/backup-restore-update.md) &middot; [Troubleshooting](Install/troubleshooting.md)

## All the Khylo repositories

| Repository | What it is | Who it is for |
| --- | --- | --- |
| [**khylo**](https://github.com/khylo-org/khylo) (you are here) | Downloads, install guides and what's new | Everyone |
| [khylo-server](https://github.com/khylo-org/khylo-server) | The server's code (C#, .NET) | Developers |
| [khylo-web](https://github.com/khylo-org/khylo-web) | The web app and dashboard's code (TypeScript, React) | Developers |
| [khylo-androidtv](https://github.com/khylo-org/khylo-androidtv) | The Android TV app's code (Kotlin) | Developers |

Just want to use Khylo? You only need this page. The other repositories are the source code, for people who want to read,
change or build it. The recipes that turn the code into the downloads are in [`Source/Packaging`](Source/README.md).

## Contributing, security and license

[Contributing](.github/CONTRIBUTING.md) &middot; [Security](.github/SECURITY.md) &middot; [Code of conduct](.github/CODE_OF_CONDUCT.md) &middot;
[What's new](CHANGELOG.md)

Khylo is free software under the [GNU General Public License v2](LICENSE). It includes and builds on open-source work,
including the Jellyfin project; their copyright notices are kept as the license requires. See [NOTICE.md](NOTICE.md).
