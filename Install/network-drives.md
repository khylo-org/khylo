# Network drives (SMB and NFS)

Khylo can read media from a NAS or another computer. How you connect it depends on your install.

| Install | How |
| --- | --- |
| [Docker](docker.md), [Linux](linux.md), [Proxmox](proxmox.md) | Inside Khylo: **Add library > Network share**. Khylo connects it, keeps it connected, and reconnects it after a restart. |
| [Windows](windows.md) | Type the share's address (`\\nas\Movies`) as the folder, or map it as a drive letter first. |
| [Mac](mac.md) | Connect it in Finder first, then choose its folder under `/Volumes`. |

## Connecting a share inside Khylo (Docker, Linux, Proxmox)

1. In setup, or in the dashboard under **Libraries**, add a library and open the folder picker.
2. Choose **Network share**.
3. Pick the kind and fill it in:
   - **Windows / SMB** (a Windows PC, Synology, TrueNAS, Unraid, QNAP and most NAS devices): the address looks like
     `\\nas\Movies` or `\\192.168.1.10\Movies`. Enter the user name and password that can read the share.
   - **NFS** (Linux machines, TrueNAS, Synology, Unraid): the address looks like `nas:/volume1/Movies`. The NAS must allow this
     machine's address to use the export. There is no login.
4. Khylo checks it right away and says plainly if the address or login is wrong. When it works, the share appears next to
   your drives in the folder picker. Choose the folder you want.

Shares are connected **read-only** by default, so Khylo does not change files on your NAS. Passwords are stored encrypted in Khylo's
settings folder, and a connected share is used only by Khylo.

You can disconnect a share from the same place; nothing on the share is changed.

### What this needs

- **Docker:** the three container settings in the [Docker guide](docker.md) (`SYS_ADMIN`, `DAC_READ_SEARCH`, `apparmor:unconfined`).
- **Linux:** nothing extra; the installer sets up a small mount helper that only accepts SMB and NFS shares.
- **Proxmox:** a privileged container (the default). With `--unprivileged`, mount the share on the Proxmox host and pass it in with `--media`.
- The NAS must be reachable from the server (same network, or routed), and its share must allow your user to read it.
- For SMB, use a NAS login with at least read access. Guest access works if the NAS allows it.

### Tips

- Give the NAS a fixed address (or a name your router resolves) so the share keeps working after restarts.
- If the NAS starts later than the server, Khylo keeps retrying and reconnects when it appears.
- Use the NAS's IP address in the share if names don't resolve.
- Older NAS devices may offer only old SMB versions. Newer is better: turn on SMB 2 or 3 on the NAS.

## Windows

Windows reads network shares natively, but there is one catch: Windows only passes your saved logins and mapped drive letters to
programs that run **as you**. Khylo's default install runs as the system account, so it can't use them.

Khylo handles this for you. When a library's network folder can't be reached, the dashboard says so and offers
**Connect with a login**. Enter the user name and password that can read the share (for example `\\nas\Media`), and Khylo
connects it itself, remembers the login (stored encrypted), and reconnects after every restart or reboot, with nobody signed in.
One login covers every library on that share. You can also do it before adding libraries: in the folder picker, choose
**Network share**.

You do not need to reinstall Khylo as your own account, and you do not need a mapped drive letter.

## Mac

macOS connects shares through Finder. Use **Go > Connect to Server** (`smb://nas/Movies` or `nfs://nas/volume1/Movies`), enter
your login, and tick "Remember this password in my keychain". Then add a library in Khylo and choose the folder under
`/Volumes/Movies`. Add the share to **System Settings > General > Login Items** so it reconnects after a restart. Khylo needs
**Full Disk Access** to read external volumes; see the [Mac guide](mac.md).

## Troubleshooting

| What you see | What it means |
| --- | --- |
| "Khylo needs permission to connect network shares" | Docker: the three settings are missing. Proxmox: the container is unprivileged. Linux: the mount helper is missing (reinstall the package). |
| "Couldn't connect ... " with the NAS's message | The address, share name, user name or password is wrong, or the NAS refused this machine. |
| The share connects but the folder is empty | The login can see the share but not the files inside. Check the NAS's permissions for that user. |
| It worked, then stopped after a NAS reboot | Khylo reconnects by itself within a minute or so after the NAS is back. If not, remove the share and add it again. |
| Slow scanning | Network shares are slower than local disks. A wired connection and a recent SMB version help. |

More in [troubleshooting](troubleshooting.md).
