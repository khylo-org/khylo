# Backup, restore, move and update

## What to back up

Khylo keeps everything that matters in one **data folder**. Back that up and you can rebuild the server anywhere.
Your media files are not in it (they stay where they are), and neither is the artwork cache, which Khylo rebuilds.

| Install | Data folder (back this up) | Safe to delete |
| --- | --- | --- |
| Windows | `C:\ProgramData\Khylo` (the `data` and `config` folders inside) | `cache` |
| Mac | `~/Library/Application Support/Khylo` (`data`, `config`) | `cache` |
| Linux | `/var/lib/khylo`; also `/etc/khylo/khylo.env` if you edited it | `/var/cache/khylo` |
| Proxmox | the whole container (Proxmox backup), or `/var/lib/khylo` inside it | |
| Docker | the folder you mounted as `/config` (for example `./khylo-config`) | the `/cache` folder |

It holds your library database, users and passwords, profiles, watch history, settings, and the saved logins for network
shares.

## Backing up

**From the dashboard:** open **Backups** and create a backup. Khylo saves it as a file in its `backups` folder (Windows:
`C:\ProgramData\Khylo\dataackups`; Mac: `~/Library/Application Support/Khylo/data/backups`; Linux: `/var/lib/khylo/backups`;
Docker: `backups` inside your `/config` mount). Copy that file to a safe place. This is the easiest way and needs no stopping.

**By copying the folder:** stop Khylo first so the database isn't being written, then copy the data folder, then start Khylo.

| Install | Stop | Start |
| --- | --- | --- |
| Windows | `Stop-ScheduledTask 'Khylo Server'` | `Start-ScheduledTask 'Khylo Server'` |
| Mac | `sudo launchctl bootout system/org.khylo.server` | `sudo launchctl bootstrap system /Library/LaunchDaemons/org.khylo.server.plist` |
| Linux | `sudo systemctl stop khylo` | `sudo systemctl start khylo` |
| Docker | `docker compose stop` | `docker compose start` |
| Proxmox | `pct stop 120` (or use Proxmox's own backup, which handles this) | `pct start 120` |

Do this on a schedule (weekly is plenty for a home server), and keep a copy off the machine.

## Restoring

- **From a dashboard backup:** put the backup file in the `backups` folder (see above) of the Khylo you are restoring to, open
  **Backups** in the dashboard, choose it, and restore. Khylo restarts when it is done.
- **From a copied folder:** stop Khylo, replace the data folder with your copy, make sure it has the same owner as before
  (on Linux: `sudo chown -R khylo:khylo /var/lib/khylo`), and start Khylo.

After a restore, your libraries point at the same folders as before. If your media is in the same place, everything works. If
you moved the media, edit each library's folders in the dashboard under **Libraries** and rescan.

## Moving to a new machine or a different kind of install

1. Install Khylo on the new machine (any install type) but don't do the setup yet.
2. Stop Khylo on the old machine and copy its data folder (or take a dashboard backup).
3. On the new machine, stop Khylo and put the data in place (or restore the backup).
4. Start Khylo. Check each library's folder in **Libraries**: paths are stored inside the database, so a Windows library at
   `D:\Movies` won't exist on a Linux machine. Edit the library to the new path.
5. Point your apps at the new address, or give the new machine the old one's address.

Moving between installs of the same kind with the same media paths (for example, one Docker host to another) needs no edits.

## Updating

Updating never touches your data folder.

| Install | How |
| --- | --- |
| Windows | Extract the new zip and run `Install-Khylo.ps1` again. |
| Mac | Unpack the new download and run `sudo ./install.sh` again. |
| Linux `.deb` | `sudo apt install ./khylo-server_<newversion>_amd64.deb` |
| Linux `.tar.gz` | Unpack the new one and run `sudo ./install.sh` again. |
| Proxmox | `./khylo-lxc.sh --update <container number> --deb khylo-server_<newversion>_amd64.deb` |
| Docker | `docker load -i khylo-server-docker-<newversion>-amd64.tar`, then `docker compose up -d` |

Take a backup first if you like. Khylo updates its own database when it starts on a newer version. **Don't go backwards:** a
database that has been updated by a newer version may not open in an older one. To go back, restore a backup made before the
update.

Your version number is shown in the dashboard and in the apps' settings. It looks like `DEV-V26.10.101` (the year, the month,
and the build).

## Removing Khylo completely

Remove the program with the steps in your install guide, then delete the data folder from the table above. That deletes your
library database, users and settings for good.
