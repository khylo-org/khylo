# Khylo Server on Mac

**Full guide: [Install/mac.md](../../../Install/mac.md)**

Quick start, from Terminal in the unpacked download:

```bash
sudo ./install.sh
```

Khylo starts at boot, runs as you, and is at `http://localhost:8096`. Data is in `~/Library/Application Support/Khylo`.
Give `/usr/local/khylo/khylo` Full Disk Access if your media is on an external drive or in a protected folder.

## In this folder

- `build.sh`, `Dockerfile`: build the downloads (Apple silicon and Intel) with Docker, on any computer.
- `files/`: the installer, uninstaller and readme that go into the download.
- `builds/`: where the downloads land (never committed).

## Building

```bash
Source/Packaging/Mac/build.sh                          # both CPU types, build number from the changelog
Source/Packaging/Mac/build.sh DEV-V26.10.101 arm64
```

The download is not signed or notarized (that needs an Apple developer account).
