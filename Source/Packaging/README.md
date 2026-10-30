# Packaging: how the source becomes the downloads

This folder holds the recipes that turn the source code (`../Server` and `../Web`) into the compiled downloads you find on the
[Releases page](../../../../releases/latest). Nothing here is something you install: if you just want to run Khylo, use the
downloads and the [install guides](../../Install/README.md).

| Folder | Builds | Output (in that folder's `builds/`, ignored by git) |
| --- | --- | --- |
| [`Docker/`](Docker/README.md) | The Docker image, for Intel/AMD and ARM | `khylo-server-docker-<version>-<arch>.tar` |
| [`Linux/`](Linux/README.md) | The Debian package and the generic Linux package | `khylo-server_<version>_<arch>.deb`, `khylo-server-<version>-linux-<arch>.tar.gz` |
| [`Proxmox/`](Proxmox/README.md) | The Proxmox container script, bundled with the Linux packages | `khylo-proxmox-<version>.tar.gz` |
| [`Windows/`](Windows/README.md) | The Windows download with its installer script | `khylo-server-<version>-windows-<arch>.zip` |
| [`Mac/`](Mac/README.md) | The Mac download with its installer script | `khylo-server-<version>-macos-<arch>.tar.gz` |
| `Shared/` | Pieces more than one of the above use (the network-drive helper). Not something to run. | |

## Build everything

You need Docker. From the root of the repository:

```bash
Source/Packaging/build-all.sh DEV-V26.10.101
Source/Packaging/checksums.sh        # writes SHA256SUMS.txt for everything built
```

Or build one system: `Source/Packaging/Linux/build.sh`, `Source/Packaging/Windows/build.sh` and so on. Each takes an optional
build number and CPU type (for example `Source/Packaging/Linux/build.sh DEV-V26.10.101 amd64`).

The builds run inside Docker, so they work the same on Windows, Mac and Linux, and need nothing else installed. The first build
takes a while (it compiles the web app and the server); later ones reuse what hasn't changed.
