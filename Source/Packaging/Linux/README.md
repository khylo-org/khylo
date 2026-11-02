# Khylo Server for Linux

**Full guide: [Install/linux.md](../../../Install/linux.md)**

Quick start:

```bash
sudo apt install ./khylo-server_<version>_amd64.deb        # Debian, Ubuntu, Raspberry Pi OS
# other Linux with systemd:
tar -xzf khylo-server-<version>-linux-amd64.tar.gz && cd khylo-server-<version>-linux-amd64 && sudo ./install.sh
```

Khylo starts by itself; open `http://<this machine>:8096`. Data is in `/var/lib/khylo`.

## In this folder

- `build.sh`, `Dockerfile`, `Dockerfile.dockerignore`: build the packages (Intel/AMD and ARM) with Docker.
- `files/`: the service file, settings file, installer and package scripts that go into the packages.
- `builds/`: where the packages land (never committed).

## Building

```bash
Source/Packaging/Linux/build.sh                        # both CPU types, build number from the changelog
Source/Packaging/Linux/build.sh DEV-V26.11.02.01 amd64
```
