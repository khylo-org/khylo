# Khylo for Android TV and Google TV

The Khylo app for your TV: a big-screen interface for movies, shows, Live TV, Khylo TV, music, audiobooks and books,
made for a remote control.

It needs a **Khylo Server** to connect to. If you haven't set one up yet, start with the [install guides](README.md).

<!-- khylo-downloads:tv -->
<p align="center">
<a href="https://github.com/khylo-org/khylo/releases/download/DEV-V26.11.05.05/khylo-tv.apk"><img alt="Download DEV Android TV" src="https://img.shields.io/badge/Download%20DEV-Android%20TV-d97732?style=for-the-badge"></a>
</p>

<p align="center">Needs a Khylo Server to connect to. <a href="https://github.com/khylo-org/khylo/blob/main/Install/android-tv.md">How to install it on your TV</a></p>
<!-- /khylo-downloads -->

## What you need

- A TV or streaming box that runs **Android TV or Google TV** (Android 6 or newer).
- A running Khylo Server on your network, or one you can reach from outside (see [away from home](remote-access.md)).

## Install it on your TV

The app is a file (`khylo-tv.apk`) that you install yourself. The easiest way is the free **Downloader** app.

### With Downloader (easiest)

1. On your TV, open the app store and install **Downloader**.
2. Open Downloader. When it asks, allow it to **install apps from unknown sources** (on some TVs this is under
   **Settings, Apps, Security and restrictions, Unknown sources**, or **Install unknown apps**).
3. In Downloader's address box, type this and press **Go**:

   ```
   github.com/khylo-org/khylo/releases/latest/download/khylo-tv.apk
   ```

4. When the download finishes, choose **Install**, then **Open**.

### From a USB stick

1. Download `khylo-tv.apk` on a computer with the button above and copy it to a USB stick.
2. Plug the stick into the TV and open the file with a file manager app (install one from the app store if the TV has none).
3. Allow installing from unknown sources when asked, then choose **Install**.

### From a computer with adb

On the TV, turn on developer options (**Settings, About**, press **Build** seven times) and then **USB debugging** or
**Wireless debugging**. Then, from your computer:

```
adb connect <the TV's address>
adb install khylo-tv.apk
```

## First start

1. Open **Khylo**. It looks for Khylo Servers on your home network by itself. Pick yours, or choose to type its address
   (`http://<the server's address>:8096`).
2. Sign in with your **username and password**, or with **Quick Connect**: the TV shows a six-digit code and a QR code,
   and you approve it from a device that is already signed in to Khylo (the web app's Quick Connect page, or the
   iPhone app's **Add a Device**). No typing a password with a remote.
3. Pick your profile and enjoy.

## Updating

Install the new `khylo-tv.apk` the same way. It installs over the old one and keeps you signed in.

## If something doesn't work

- **"App not installed":** there may not be enough free space on the TV. Remove an app you don't use and try again.
- **The TV can't find your server:** the TV and the server must be on the same network. Check that the server is running,
  and that port 8096 (and 7360 for finding the server by itself) is allowed through its firewall. Or type the address.
- More help: [troubleshooting](troubleshooting.md).

The code for this app is in the [khylo-androidtv](https://github.com/khylo-org/khylo-androidtv) repository.
