# Source code

Everything here is **source**: the code and the recipes that build it. If you just want to run Khylo Server, you don't need
this folder: use the downloads on the [Releases page](../../../releases/latest) and the guides in [`Install/`](../Install/README.md).

| Folder | What it is | Repository |
| --- | --- | --- |
| [`Server/`](Server) | The Khylo Server itself (C#, .NET 10). | [khylo-server](https://github.com/khylo-org/khylo-server) |
| [`Web/`](Web) | The web app and the server dashboard (TypeScript, React). It is built into every server download. | [khylo-web](https://github.com/khylo-org/khylo-web) |
| [`Packaging/`](Packaging/README.md) | The recipes that turn the source into the downloads: Docker, Linux, Proxmox, Windows and Mac. | this repository |

`Server/` and `Web/` are separate repositories, linked here. Get everything with:

```bash
git clone --recurse-submodules https://github.com/khylo-org/khylo.git
```

## Source and compiled, side by side

| | Source (this repository) | Compiled (Releases page) |
| --- | --- | --- |
| What | Code you can read and change | Finished programs ready to install |
| Who needs it | Developers and contributors | Everyone who just wants to use Khylo |
| Where | `Source/` | the `.zip`, `.tar.gz`, `.deb` and `.tar` files attached to each release |

## Building the downloads

You need Docker. From the root of this repository:

```bash
Source/Packaging/build-all.sh DEV-V26.10.101     # every download
Source/Packaging/Linux/build.sh                  # or just one system (Docker, Linux, Mac, Proxmox, Windows)
```

The results are written to `Source/Packaging/<system>/builds/`, which git ignores. `Source/Packaging/checksums.sh` writes
their SHA-256 checksums.

## Working on the code

- **Server:** see [`Server/README.md`](Server/README.md) (`dotnet build`, `dotnet test`).
- **Web app:** see [`Web/README.md`](Web/README.md) (`npm ci`, `npm start`).
