# Khylo Server on Proxmox

One script on your Proxmox VE host creates a small Debian container, installs Khylo in it, starts it, and tells you the
address to open. The same script updates the container later. Your library stays inside the container's disk, so
Proxmox's normal container backups cover it.

<!-- khylo-downloads:proxmox -->
<p align="center">
<a href="https://github.com/khylo-org/khylo/releases/download/DEV-V26.11.05.08/khylo-proxmox-26.11.05.08.tar.gz"><img alt="Download DEV Proxmox" src="https://img.shields.io/badge/Download%20DEV-Proxmox-d97732?style=for-the-badge"></a>
</p>
<!-- /khylo-downloads -->

## Before you start

- A Proxmox VE host (7 or newer) with internet access, and a storage that can hold containers.
- Root access on the host (the Proxmox web shell, or SSH).
- The download `khylo-proxmox-<version>.tar.gz`. It contains the script, this guide, and the Khylo packages for both
  Intel/AMD (`amd64`) and ARM (`arm64`) hosts.

## Create the container

1. Copy the download to the Proxmox host (for example with `scp`) and unpack it:

   ```bash
   tar -xzf khylo-proxmox-<version>.tar.gz
   cd khylo-proxmox-<version>
   ```
2. Find your host's type: `dpkg --print-architecture` prints `amd64` or `arm64`.
3. Run the script with the matching package:

   ```bash
   ./khylo-lxc.sh --deb khylo-server_<version>_amd64.deb
   ```

The script downloads a Debian 12 template if the host doesn't have one, creates the container (2 cores, 2 GB memory,
8 GB disk, DHCP address, starts at boot), installs Khylo, and prints the address. Open it and follow the
[first-time setup](first-setup.md).

## Options

```
--ctid 120                         container number (default: the next free one)
--hostname khylo                   container name
--cores 4 --memory 4096 --disk 16  more room (memory in MB, disk in GB)
--storage local-zfs                where the container's disk goes
--bridge vmbr0                     network bridge
--ip 192.168.1.50/24,192.168.1.1   a fixed address and gateway instead of DHCP
--media /tank/movies:movies        share a host folder, read-only, as /media/movies inside Khylo
--gpu                              give the container the host's graphics device (hardware transcoding)
--unprivileged                     locked-down container (see "Network drives")
--update 120                       update the container 120 (see "Updating")
```

Example with a fixed address, a media folder and graphics:

```bash
./khylo-lxc.sh --deb khylo-server_<version>_amd64.deb --ctid 120 --ip 192.168.1.50/24,192.168.1.1 \
  --media /tank/movies:movies --media /tank/shows:shows --gpu
```

## Your media

Two ways, and you can mix them:

- **Host folders** (`--media /host/path:name`): the folder appears inside Khylo as `/media/name`, read-only. Good for
  ZFS datasets and local disks. You can add more later with `pct set 120 -mp1 /host/path,mp=/media/name,ro=1`.
- **Network shares** (SMB or NFS): add them from inside Khylo, **Add library > Network share**. See
  [network drives](network-drives.md).

## Network drives and the container type

By default the container is **privileged** and allows only `cifs` and `nfs` mounts, so Khylo's own **Network share**
option works with nothing else to set up. If you prefer an **unprivileged** container (more isolated), use
`--unprivileged`: Khylo then can't connect shares itself, so mount the share on the Proxmox host (for example in
`/etc/fstab`) and pass it in with `--media`.

## Hardware transcoding

`--gpu` passes the host's `/dev/dri/renderD128` into the container and installs the Intel/AMD video drivers inside it.
It works for Intel and AMD graphics on the host and needs Proxmox VE 8.1 or newer. See [hardware transcoding](hardware-transcoding.md).

## Updating

Unpack the newer download and run:

```bash
./khylo-lxc.sh --update 120 --deb khylo-server_<newversion>_amd64.deb
```

Khylo is replaced in place; your library and settings are untouched.

## Everyday commands

```bash
pct enter 120                                   # a shell inside the container
pct exec 120 -- systemctl status khylo          # is Khylo running?
pct exec 120 -- journalctl -u khylo -n 100      # the log
pct stop 120 && pct start 120                   # restart the container
```

Inside the container, Khylo lives where it does on any [Linux install](linux.md): data in `/var/lib/khylo`, program in
`/opt/khylo`, settings in `/etc/khylo/khylo.env`.

## Backups

Back up the container with Proxmox (Datacenter > Backup, or `vzdump 120`). That covers Khylo's library and settings.
Media on host folders or network shares is not part of that backup. See [backup, restore and update](backup-restore-update.md).

## Removing it

```bash
pct stop 120 && pct destroy 120
```

This deletes the container and Khylo's library inside it. Your media on the host is untouched.

## Troubleshooting

See [troubleshooting](troubleshooting.md). Proxmox-specific:

- **"The container did not get network access":** check the bridge name (`--bridge`) and the address settings.
- **Khylo says it can't connect network shares:** the container is unprivileged. Recreate it without `--unprivileged`, or
  mount the share on the host and use `--media`.
- **Nothing in the library:** a `--media` folder is read-only and owned by someone Khylo can't read as. The folder must be
  readable by everyone, or by the container's `khylo` user.
