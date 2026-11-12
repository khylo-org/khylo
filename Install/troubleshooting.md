# Troubleshooting

Start here when something doesn't work. Each section says how to check, then how to fix.

## Is Khylo running?

Ask it directly. On the server, run:

```
curl http://localhost:8096/health
```

(On Windows PowerShell: `Invoke-WebRequest http://localhost:8096/health`.) It prints **Healthy** when ready. **Degraded** means it is
still starting (the first start takes a minute or two). No answer means it isn't running or something blocks it.

Check the service:

| Install | Command |
| --- | --- |
| Windows | `Get-ScheduledTask 'Khylo Server'` (Task Scheduler shows the last result) |
| Mac | `sudo launchctl print system/org.khylo.server \| head` |
| Linux | `sudo systemctl status khylo` |
| Docker | `docker ps` (look for `healthy`), `docker logs khylo` |
| Proxmox | `pct exec <id> -- systemctl status khylo` |

## Where the logs are

| Install | Logs |
| --- | --- |
| Windows | `C:\ProgramData\Khylo\log` |
| Mac | `~/Library/Application Support/Khylo/log` |
| Linux | `/var/log/khylo` and `journalctl -u khylo` |
| Docker | `docker logs khylo` and the `log` folder inside your `/config` mount |
| Proxmox | inside the container, as on Linux |

The dashboard also shows them under **Logs**. When you ask for help, include the newest log file (remove anything private,
such as addresses and names, first) and your version number.

## I can't open the web page

- **From the server itself** (`http://localhost:8096`): if this fails, Khylo isn't running. See "Is Khylo running?".
- **From another device only:** the firewall is blocking it, or you used the wrong address.
  - Windows: the installer opens the firewall for Private networks. If your network is set to Public, change it to Private.
  - Mac: allow `khylo` in **System Settings > Network > Firewall**.
  - Linux: `sudo ufw allow 8096/tcp` (Ubuntu) or `sudo firewall-cmd --permanent --add-port=8096/tcp && sudo firewall-cmd --reload` (Fedora).
  - Docker: check the port mapping `8096:8096`.
  - Use the server's own address (not `localhost`): `http://192.168.x.x:8096`.
- **"Address already in use" in the log:** another program has port 8096. Stop it, or change Khylo's port in the dashboard under
  **Networking** (and your firewall rule and Docker mapping to match).

## My apps don't find the server

Apps look for servers with a broadcast on UDP port 7360. It doesn't cross some networks. Type the server's address in the app once:
`http://<server's address>:8096` (or your web address). Causes: Docker's default network (see the [Docker guide](docker.md)), a
different network segment (VLAN) or guest Wi-Fi for the TV, a firewall blocking UDP 7360, or a router with client isolation.

## A library is empty, or titles are missing

- **Khylo can't read the folder.** Linux: the `khylo` user needs permission (see the [Linux guide](linux.md)). Mac: give
  `/usr/local/khylo/khylo` **Full Disk Access** (see the [Mac guide](mac.md)). Windows: the account Khylo runs as must be able
  to read the folder. If the folder picker shows a full folder as one Khylo isn't allowed to open, click **Give Khylo access
  to this folder** there; for network shares use `-RunAsUser` (see the [Windows guide](windows.md)). Docker: the path you chose must
  be the one *inside* the container (for example `/media/movies`).
- **The names aren't recognised.** Use the usual layout (see [first-time setup](first-setup.md)). Put movies in their own folders
  with the year, and shows in `Show/Season 01/`.
- **It hasn't finished scanning.** A first scan of a big library takes time. Look at **Dashboard > Scheduled tasks** for the
  library scan, or press **Scan all libraries**.
- **New files don't show up by themselves.** Khylo watches each library's folders and updates the library a short while after
  files are added. Folders on a network share (a NAS) often can't report changes, so scan those yourself: on **Dashboard > Media
  Libraries**, press the **Scan** button on that library's row (this scans only that one). You can turn the watching off or on for
  a library on its edit page, under **Automatic Scanning**.
- **Wrong match.** Open the title, choose **Identify**, and pick the right one.

## Network drive problems

See [network drives](network-drives.md). The common ones: the message "Khylo needs permission to connect network shares" (a
Docker or Proxmox setting), a wrong address or login, and shares that need your Windows login (install with `-RunAsUser`).

## Playback stutters, or "the server is too slow"

- A wired connection to the server and to TVs helps most.
- Check whether the video is being **converted**: **Dashboard > Activity** shows what each stream is doing. Conversion on the processor
  is heavy. Turn on [hardware transcoding](hardware-transcoding.md), or play at the original quality so the file plays directly.
- Subtitles in image formats (PGS, DVD) have to be burned in, which forces conversion. Use text subtitles where you can.
- Weak remote connections: lower the quality in the app, or in **Playback > Streaming**.
- Network shares and slow disks slow the first seconds of playback.

## Video plays but there is no sound (or the wrong language)

Choose the audio track in the player's audio menu. Some TVs can't play certain surround formats directly; Khylo then converts the
audio, which needs the video converter to be working (see [hardware transcoding](hardware-transcoding.md) and the logs).

## I forgot my password

- Another administrator can reset it in the dashboard under **Users**.
- If you are the only administrator and can't sign in, restore a backup made before the password was changed (see
  [backup, restore and update](backup-restore-update.md)). Keep a second administrator account for this reason.

## Khylo is slow right after an update or a restore

Khylo does some housekeeping the first time it starts on a new version and when it finds a lot of new media. The processor and
disk are busy for a while, then settle. Let it finish before judging.

## High processor use all the time

Look at **Dashboard > Activity** and **Scheduled tasks**. A scan, a trickplay (thumbnail) job or a conversion may be running.
They finish on their own. Heavy ones can be rescheduled in **Scheduled tasks**.

## The time is wrong

Set the time zone. Docker: `TZ=Your/Zone` in the compose file. Linux: `sudo timedatectl set-timezone Your/Zone`.
Windows and Mac: the system time zone.

## Still stuck?

Open an issue on the project's GitHub page. Tell us: your install type (Windows, Mac, Linux, Docker or Proxmox), the Khylo
version, what you did, what you expected, what happened, and the newest log (with anything private removed).
