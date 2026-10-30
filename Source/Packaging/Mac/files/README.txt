KHYLO SERVER FOR MAC
====================

Pick the file that matches your Mac: "arm64" for Apple silicon (M1 and newer), "x64" for Intel Macs.

INSTALL
   1. Double-click the .tar.gz to unpack it, then open Terminal and go into the new folder:
         cd ~/Downloads/khylo-server-*-macos-*
   2. Run:   sudo ./install.sh
   3. When it says Khylo is running, open http://localhost:8096 and follow the setup.

Khylo starts by itself when the Mac starts and keeps running. It runs as you, so it can read your media folders.
Media on an external drive, or in Documents, Downloads, Desktop or Movies, needs one more step, because macOS cannot ask
about a background program: open System Settings > Privacy & Security > Full Disk Access, click +, press Shift-Command-G,
type /usr/local/khylo/khylo, add it and turn it on. Then run:  sudo launchctl kickstart -k system/org.khylo.server

WHERE THINGS ARE
   Program:                   /usr/local/khylo
   Library, users, settings:  ~/Library/Application Support/Khylo   (back this folder up)

UPDATING
   Unpack the new version and run sudo ./install.sh again. Your library and settings are kept.

REMOVING
   sudo ./uninstall.sh            (keeps your library and settings)
   sudo ./uninstall.sh --remove-data

NETWORK DRIVES
   Connect the share in Finder first (Go > Connect to Server, for example smb://nas/Movies), then in Khylo add a
   library and choose its folder under /Volumes. Ask macOS to reconnect it at login (add it to System Settings >
   General > Login Items) so it is there after a restart.

NOTE
   This download is not signed by Apple, so the installer clears the "downloaded from the internet" mark from
   Khylo for you. Nothing else is needed.
