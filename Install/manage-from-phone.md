# Manage your server from your phone

**Khylo Manager** is a separate app for the people who run a Khylo server. Only administrators can sign in to it. It shows how
the server and the computer it runs on are doing, what Khylo is busy with, and its log, and it can restart Khylo or reboot the
computer. It works at home and over the internet, through the same address you already use for Khylo.

Nothing here is for ordinary users: every part needs an administrator's sign-in, also from your home network.

## What Manager can do

| Part | What it does |
| --- | --- |
| Machine | The computer's name, system, processor and memory use, how long it and Khylo have been running. |
| Processes | Khylo's own work only: the server and the transcodes it started, with who is watching. You can stop a transcode. Khylo never lists, or touches, anything else on the computer. |
| Logs | Follow a log live, newest lines at the bottom. |
| Restart Khylo | Restarts the server. People watching are interrupted for a moment. |
| Reboot the computer | Two steps so it can't happen by accident: Manager asks for a code, then you confirm it. The computer restarts about ten seconds later, and Khylo starts by itself afterwards. |

Every action is written to the **Activity** log in the dashboard with the administrator's name, for example "Khylo Manager:
Dan restarted the server".

## What the server needs for Reboot

The Reboot button only appears when Khylo really can reboot the computer it runs on. If it can't, Manager hides it.

| Install | Reboot works when |
| --- | --- |
| Windows | Khylo runs as the system account (the default installer choice), or as an administrator. |
| Linux, Proxmox | Khylo runs as root (the installer's default), so it can run `shutdown -r now`. |
| Mac | Khylo runs as an administrator account that is allowed to restart the Mac. |
| Docker | Never. A container can't reboot the computer under it, so the button is hidden. Restart Khylo still works. |

## Safety

- Only fixed actions exist. Khylo never runs a command someone typed, and never accepts a file path.
- The reboot code is single-use, works for one minute and belongs to the administrator who asked for it. A wrong, used or
  expired code is refused, and too many tries are slowed down.
- Servers that haven't been updated don't have these parts; Manager says so.
