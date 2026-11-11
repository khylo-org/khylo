# First-time setup

Once Khylo is [installed](README.md) and running, open it in a browser: `http://localhost:8096` on the server itself, or
`http://<the server's address>:8096` from another device. The first time, Khylo walks you through setup. Every Khylo-specific
step can be skipped and done later from the dashboard.

## The setup steps

(The order can differ slightly between versions.)

1. **Language, then your account.** Choose your language and create the administrator account (a name and a password).
   This is the account that manages the server. Use a strong password.
2. **Your media libraries.** Add each folder of media and tell Khylo what is in it (see below).
3. **Playback.** Khylo checks what your computer has for converting video (see [hardware transcoding](hardware-transcoding.md))
   and asks how you'll watch away from home.
4. **Your household.** Add profiles for the people at home. Each person gets their own watch history and an optional PIN, and
   switches without signing in again. Kids profiles can be limited to ratings and libraries you choose; only an administrator
   can change those limits.
5. **Moving from Plex or another server?** Bring everyone's watch history, favorites and music plays across. Connect to the old
   server, choose who goes where, preview, then import. (Skip this on a fresh start.) Step by step, with pictures: [moving your watch history](import-watch-history.md).
6. **Khylo TV.** Always-on TV channels built from your own library. Turn on the channels you like.
7. **Live TV.** Optional: add an IPTV playlist (M3U) or an HDHomeRun tuner and an XMLTV guide.
8. **Signing in your TVs.** How to add a TV with a short code or a QR code.

When you finish, Khylo scans your libraries. The first scan of a large library can take a while (it fetches artwork and
details for every title); you can use Khylo while it works.

After that, a library updates itself a short while after files are added or changed (this can be turned off for a library on its
edit page, under **Automatic Scanning**). To refresh just one library by hand, press **Scan** on its row under **Dashboard >
Media Libraries**.

## Adding media libraries

In setup, or later in the dashboard under **Libraries**, add a library for each kind of media:

| Library type | What goes in it |
| --- | --- |
| Movies | Films |
| TV Shows | Series, with episodes |
| Music | Albums and songs |
| Audiobooks | Audiobook folders or files |
| Books | EPUB, PDF, MOBI/AZW and similar |
| Comics | CBZ, CBR, CB7, CBT and PDF comics |
| Podcasts | Podcast episodes |
| Photos | Pictures, with albums |
| DVDs | DVD discs as `.iso` files or `VIDEO_TS` folders, with a disc menu |
| Live TV | Added separately, from your IPTV or tuner |

For each library you choose a folder. Where the folder is depends on your install:

- **Docker:** the path *inside* the container, such as `/media/movies` (the right-hand side of your volume line).
- **Windows, Mac, Linux, Proxmox:** a normal folder path. Khylo must be allowed to read it (see your install guide).
- **A NAS or another computer:** choose **Network share** in the folder picker. See [network drives](network-drives.md).

One kind of media per library works best. A single library can have several folders.

### Naming and folders

Khylo reads names and folders to recognise titles. The usual layout works well:

```
Movies/
  The Movie (2010)/
    The Movie (2010).mkv
TV Shows/
  The Show (2015)/
    Season 01/
      The Show - S01E01 - Pilot.mkv
Music/
  Artist/
    Album (2019)/
      01 - Song.flac
```

Put extras (trailers, behind-the-scenes) in folders such as `extras`, `trailers` or `featurettes` inside the title's folder. A
title split across several files can be named `Movie (2010) - part1.mkv`, `- part2.mkv`.

## Finding the server from your apps

- **On your home network:** Khylo apps look for servers automatically (UDP port 7360). Open the app and pick yours.
  If it doesn't appear, type the address: `http://<server's address>:8096`. (In Docker, see "Finding the server" in the
  [Docker guide](docker.md).)
- **TVs:** choose **Sign in with a code** on the TV, then approve it from the Khylo app on your phone or browser, or scan the
  QR code. No typing on a remote.
- **Away from home:** see [away from home](remote-access.md).

## Add more people

In the dashboard under **Users**, create accounts for family or friends and choose which libraries they can see. For people
who share a home screen, use **Home profiles** instead; profiles switch without a password (with an optional PIN).
You can also send **invitations**: a link that lets someone create their own account.

## What to do next

- Connect your [network drives](network-drives.md) if your media is on a NAS.
- Set up [hardware transcoding](hardware-transcoding.md) for smoother conversion.
- Plan a [backup](backup-restore-update.md) of Khylo's data folder.
- Read [away from home](remote-access.md) before opening Khylo to the internet.
