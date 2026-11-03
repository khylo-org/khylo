# Building Khylo from source

Everything here is **for developers**. If you just want to run Khylo, use the downloads on the
[front page](../README.md) and the guides in [`Install/`](../Install/README.md).

The code is in separate repositories, one per app:

| Repository | What it is |
| --- | --- |
| [khylo-server](https://github.com/khylo-org/khylo-server) | The Khylo Server itself (C#, .NET 10). `dotnet build`, `dotnet test`. |
| [khylo-web](https://github.com/khylo-org/khylo-web) | The web app and the server dashboard (TypeScript, React). It is built into every server download. `npm ci`, `npm start`. |
| [khylo-androidtv](https://github.com/khylo-org/khylo-androidtv) | The Android TV app (Kotlin). `./gradlew assembleDebug`. |

This repository holds the recipes that turn the server and web app into the downloads:

| Folder | What it is |
| --- | --- |
| [`Packaging/`](Packaging/README.md) | Docker, Linux, Proxmox, Windows and Mac packages. |

## Building the downloads

You need Docker, and the server and web repositories cloned next to the build recipes as `Source/Server` and `Source/Web`:

```bash
git clone https://github.com/khylo-org/khylo.git
cd khylo
git clone https://github.com/khylo-org/khylo-server.git Source/Server
git clone https://github.com/khylo-org/khylo-web.git Source/Web
Source/Packaging/build-all.sh DEV-V26.11.02.01     # every download
Source/Packaging/Linux/build.sh                    # or just one system (Docker, Linux, Mac, Proxmox, Windows)
```

The results are written to `Source/Packaging/<system>/builds/`, which git ignores. `Source/Packaging/checksums.sh` writes
their SHA-256 checksums.

## Source and compiled, side by side

| | Source (the code repositories) | Compiled (Releases page) |
| --- | --- | --- |
| What | Code you can read and change | Finished programs ready to install |
| Who needs it | Developers and contributors | Everyone who just wants to use Khylo |
| Where | the `khylo-` repositories | the `.exe`, `.zip`, `.tar.gz`, `.deb`, `.tar` and `.apk` files attached to each release |
