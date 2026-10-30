# Khylo Server on Proxmox

**Full guide: [Install/proxmox.md](../../../Install/proxmox.md)**

Quick start, as root on the Proxmox host, with the download unpacked:

```bash
./khylo-lxc.sh --deb khylo-server_<version>_amd64.deb      # use _arm64.deb on an ARM host
```

It creates a Debian container, installs Khylo, starts it, and prints the address. Options: `--ctid`, `--ip`, `--cores`,
`--memory`, `--disk`, `--storage`, `--media`, `--gpu`, `--unprivileged`, `--update`. Run it with `--help` to see them all.

## In this folder

- `khylo-lxc.sh`: the script.
- `build.sh`: bundles the script, this guide and the Linux packages into `builds/khylo-proxmox-<version>.tar.gz` (run
  `Source/Packaging/Linux/build.sh` first).
