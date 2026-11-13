# What's New in Khylo

## November 2026

### Build DEV-V26.11.13.02
**New**
- **Web — Artist Radio.** Start a radio for any artist from their page, from an album, from the music home or from the Now Playing panel. It plays their songs mixed with songs from artists who really sound like them (the same mix as the iPhone app), and never plays a song twice.
- **Web — Make and change your own playlists.** Create a playlist with the + in your library, with the "Add to playlist" button beside any song, or by adding a whole album. Open one of your playlists to rename it, choose whether everyone on the server can see it, search for songs to add, drag songs into a new order (or move them with the arrow keys), take songs out, or delete the playlist. The songs always stay in your library.
**Improved**
- **Web — A new look for music.** The music home, artists, albums, songs, genres and the artist, album and playlist pages have a calmer, more polished look: a banner on the home and artist pages, round artist pictures, play buttons that appear when you point at something, and a soft colour on each page taken from its own cover.
- **Web — The Now Playing page and the player.** The Now Playing page shows a big cover with the title, artist and controls beside the queue, and every queue row has its cover and artist. The player bar at the bottom now floats just above the page.
- **Web — Back 10 and forward 30 seconds only where they help.** Those buttons now show for films, podcasts, audiobooks and long tracks, and no longer crowd the controls on an ordinary song.
- **Web — Khylo opens with far fewer downloads.** The page needs much less to get started, which helps most when Khylo is reached through a slow or busy web address. A slow connection is also tried again before Khylo says the server is unavailable.
**Fixed**
- **Web — Songs no longer show a blank picture.** A song that has no picture of its own now shows its album's cover.

### Build DEV-V26.11.13.01
**Fixed**
- **Server — Minor bug fixes.**
- **Web — Minor bug fixes.**

### Build DEV-V26.11.12.01
**Fixed**
- **Server — Minor bug fixes.**

### Build DEV-V26.11.11.02
**Fixed**
- **Server — Giving Khylo access to a folder now covers every folder inside it (Windows).** After giving Khylo access to a media folder, some folders inside it could still be locked (folders that have permissions of their own, common on file servers), and each needed its own click. One click now covers the whole folder and everything in it, and the page only says it worked when Khylo can really open every folder inside.
- **Server — Khylo no longer skips locked folders without saying so.** A library scan used to leave out any folder Khylo wasn't allowed to open, so titles were just missing. The folder picker and each library now say how many folders Khylo can't read and name one, with the steps to fix it for your kind of server.
- **Web — Select Path takes care of access.** Choosing a folder Khylo can't read for a library now gives Khylo access as part of Select Path, with progress while Windows works through a big folder, instead of leaving you on a lock screen.

### Build DEV-V26.11.11.01
**New**
- **Server — Give Khylo access to a media folder from Khylo itself (Windows).** When Khylo runs as the limited Windows account and isn't allowed into a folder, the folder picker now says so and shows a "Give Khylo access to this folder" button. One click and Khylo can read that folder and what is inside it, and nothing else on the PC. A second option lets Khylo add and delete files there too, for recordings or deleting from Khylo. It usually takes under a minute.
**Fixed**
- **Server — A folder Khylo isn't allowed to open no longer looks empty.** Picking a media folder could show "No subdirectories found" although the folder was full, because Khylo wasn't allowed to read it. On every kind of server (Windows, Linux, Proxmox, Docker and Mac) the folder picker now says that Khylo isn't allowed in, which account it runs as, and the exact steps to fix it on that system.
- **Web — No more "Server Mismatch" after installing Khylo again.** Removing Khylo and installing it fresh on the same PC showed a warning in front of the first-time setup. A new Khylo that nobody has set up yet now opens straight into setup. The warning stays for a different server that is already set up.
- **Server — The note after an update always names the version you are running.** After updating to one build the Updates page could still say "Khylo updated to" the build before it. The note now only ever names the build that is running, and a leftover from an earlier update is thrown away instead of shown.
- **Server — The update shows what it is really doing.** While Khylo updates, the Updates page counts the time from the server's own clock (so it is right after a page reload or a restart), says which version it is installing, and keeps an update log of each step: the signature check, the download, the checksum, the installer, and the new Khylo starting. The log stays on the page afterwards under Show update log.
- **Web — Library switches and buttons show their change straight away.** Turning a library's automatic scanning on or off, renaming it, adding or removing a folder, or removing it now shows the result on the page at once, without a refresh.
- **Web — You can see a library scan working.** Press Scan on a library and its row shows "Scan starting…", then the scan's progress, then a "Finished scanning" message, and keeps showing when it was last scanned.

### Build DEV-V26.11.10.02
**New**
- **Web — Scan just one library.** Every library on the Media Libraries page now has its own Scan button, so you can refresh one library without scanning all of them.
- **Web — Turn automatic scanning on or off for a library.** A library's edit page has a new Automatic Scanning switch. Libraries still update themselves when files are added or changed, and now you can turn that off for one library (or back on) whenever you like. The change takes effect straight away. Folders on a network share (a NAS) often can't report changes, so scan those with the Scan button.
**Fixed**
- **Server — Updating on Windows no longer keeps Khylo stopped for minutes on a big library.** Updating from an older version re-checked the permissions on every file in Khylo's data folder before starting Khylo again, which took about six minutes on a very large library. It now does that in one pass in the background, so Khylo starts straight away, and it does nothing on later updates.
- **Web — The Live TV guide keeps your place.** After you watch a channel and come back, the guide is where you left it: the same channels loaded, the same category and search, the same highlighted channel and the same spot in the list, instead of starting again at the top.
- **Web — White channel logos can be seen.** Channel logos that are white or very light used to disappear on their light tile. They now sit on a dark tile, and dark and colourful logos keep the light one.

### Build DEV-V26.11.10.01
**New**
- **Server — The Docker image is hosted on GitHub.** Khylo's Docker image can now be pulled straight from GitHub (ghcr.io/khylo-org/khylo-server) as one image for Intel/AMD and Arm computers, and updated with "docker compose pull". The downloadable Docker files are still there for computers that can't reach GitHub.
- **Web — Back to Khylo from the server console.** The server console now has a "Back to Khylo" button at the top of its menu, so you can get from the admin pages to the Khylo web app without typing an address.
- **Web — Allowed Websites setting.** Networking now has a place to list the websites that may use your server from a browser.
- **Server — Khylo can run as a limited Windows account.** A new Khylo Server for Windows now runs as Windows' own limited "Local Service" account instead of the all-powerful system account, so a flaw in Khylo can no longer take over the whole PC. The installer lets you pick either one, and an existing install keeps the way it ran until you choose otherwise. Updating from the dashboard still works: Khylo downloads and checks the update, and a small update helper that runs on the PC checks it again on its own before it installs anything.
**Fixed**
- **Server — The update note matches the version you're running.** On the Updates page, the green note ("Khylo updated to…") now shows only while that version is the one running. Before, it could keep naming an older version for up to a day after you had updated again.
- **Server — A clear message for folders Khylo can't open.** When Khylo runs as the limited account and you add a library folder it isn't allowed to open, it now says which account to give access to instead of just failing.
- **Server — An update can't get stuck on a message nobody can see.** If Windows refuses to set up Khylo's startup task during a quiet install or an automatic update, the installer now stops with an error instead of waiting for someone to click OK on a window that is never shown.
**Improved**
- **Server — Docker servers explain how to update.** On Docker, the Update page now gives the actual steps (pull the new image, then recreate the container) instead of a general message. Docker can't replace its own image from the inside, so the install itself is still done where Docker runs.
- **Server — Updates are checked before they are installed.** Before Khylo installs an update it now checks that the update's file list carries Khylo's own signature, and it won't install one that doesn't. Only updates published by Khylo can be installed this way.
- **Server — Khylo's files are private to administrators.** On Windows, the folder that holds your library, settings and plug-ins can now be opened only by administrators and the account Khylo runs as. Before, anyone with a login on the same PC could open it. Installing this version sets it up, including when Khylo updates itself. Khylo also checks this each time it starts, so a portable copy or a folder you chose yourself is covered too, and invitation codes are no longer written to the log.
- **Server — Switching to an administrator's profile needs its PIN.** In a home with profiles, an administrator's profile can now only be entered with its PIN. If it doesn't have one yet, set one while signed in to that profile. PINs are four to eight digits and are now stored in a stronger way.
- **Server — Setting up a new server works only from your home network.** Until the first-time setup is finished, only this computer and your home network can use it, so a new server that is reachable from the internet can't be set up by someone else.
- **Server — Other websites can no longer use your server from a browser.** Your server now answers only its own web address and the websites you list under Networking, Allowed Websites (for example a casting receiver). A server reached over https under a real web address also tells browsers to always use https.
- **Server — Passwords need at least 8 characters.** A blank or very easy password (such as "password" or "12345678") is no longer accepted when someone chooses or changes a password, including in setup and invitations. Passwords that already exist keep working until they are changed.
- **Server — Wrong guesses can't lock you out of your own account.** Someone guessing at an account from elsewhere now only stops themselves, and you can still sign in from a device you already use. Changing a password, and using a reset PIN, are slowed down the same way.
- **Server — Collections follow their permission.** Only people who are allowed to manage collections, and administrators, can create or change them. Profiles without that permission, such as kids profiles, can't.
- **Server — The server statistics page is for administrators.** The page of statistics that monitoring tools read now needs an administrator's access key.
- **Server — Developer test tools are off.** The tools that make up test listening history are now off unless a developer turns them on.
- **Server — Docker no longer gets extra privileges unless you want network shares.** The normal Docker setup now runs with no extra permissions. To connect network shares, add the extra file described in the Docker guide.
- **Web — Networking settings no longer pick up saved logins.** The browser's saved sign-in is no longer filled into the certificate fields.
- **Server — Invitations are safer.** An invitation with one use left can only be used once, even if several people try at the same moment. Trying invitation codes over and over is slowed down, and an invitation that fails no longer shows details of what went wrong inside.
- **Server — Subtitles and fonts need a sign-in away from home.** From your home network they work as before; from the internet the player has to be signed in.
- **Server — Unused devices are signed out after 90 days.** A phone, TV or browser that hasn't used its sign-in for 90 days has to sign in again.
- **Server — Picking channels from a very large playlist uses less memory.** Khylo now keeps only the last few playlists it downloaded.
- **Server — Only administrators can change the program files.** The folder Khylo is installed in can now be changed only by administrators, whichever folder you chose to install it in.

### Build DEV-V26.11.08.09
**Fixed**
- **Server — Mirror finds the TV that's asking.** Starting Mirror no longer fails with "isn't connected to your Khylo Server". The server now recognises the device in more ways, and records in its log exactly what it saw if something still goes wrong.

### Build DEV-V26.11.08.07
**Fixed**
- **Server — Recordings now show up.** Recordings saved to your recordings folder were missing from the Recordings list in the apps. The server now finds the folder reliably and adds new recordings as soon as they finish.
- **Server — Mirror to a phone on the same network.** Mirror no longer fails with "that device isn't online" when a phone's connection blips. The server keeps the device for a short while and the mirror starts as soon as it is back, and the messages now say which device and what to do.

### Build DEV-V26.11.08.04
**Fixed**
- **Server — Handoff and Mirror after an update.** Your devices can be sent to again as soon as the server restarts. Before, each app had to be closed and reopened first, so Mirror and Handoff found nobody after every server update.

### Build DEV-V26.11.08.03
**New**
- **Server — Mirror Live TV and Khylo TV.** Mirror now works while you watch Live TV or a Khylo TV channel. Your other TVs tune to the same channel and follow when you change it.
**Fixed**
- **Web — Mirror errors.** The same plain message appears on the web.

### Build DEV-V26.11.08.02
**New**
- **Web — Record from the player.** When you watch a live channel, the Record button now appears in the player controls and records what is on right now.
**Fixed**
- **Web — Matching channels to the guide.** The guide channel you pick now stays picked straight away instead of looking like it was not saved.
- **Server — Matching channels to the guide.** Picking the same guide channel twice no longer undoes the match.

### Build DEV-V26.11.08.01
**New**
- **Server — Mirror your TVs.** Play something on one of your devices and have your other devices follow it. They start the same movie or episode from the same moment and pause and resume with it. They stay within a fraction of a second of each other and always inside one second. It only ever links your own devices.
- **Web — Mirror from the top bar.** The handoff icon now also lets you mirror what you are watching onto your other screens, and a web screen can follow another device.

### Build DEV-V26.11.05.08
**New**
- **Server — Listening history.** Khylo can now remember what you listen to, privately. It builds your weekly stats, a history list, a review every quarter and a year-end Wrapped, and only you can see them: not even the person who runs the server. You can turn it off or delete all of your history at any time, and it is included in Khylo's backups. It starts recording today, and a play that isn't recorded can't be recovered later.
- **Server — Watching history and server Insights.** Khylo also remembers the movies and shows you watch, for your own weekly stats and a year-end Rewind. The person who runs the server gets an Insights view of what is played and watched across the household: popular items, time per person, which apps and play methods are used, how busy the server has been, and what was added to each library. It never includes anyone's own reviews, and people who turn recording off are left out.
**Fixed**
- **Server — The right version number.** The internal version number is now the real build number too, so the old "13" no longer shows anywhere, including in a backup's details.

### Build DEV-V26.11.05.05
**Fixed**
- **Web — Khylo loads again after updating.** After the version number change, the web page could sit on the loading spinner and never open. It now opens normally and shows the new build number.

### Build DEV-V26.11.05.02
**Fixed**
- **Server — The right version number.** Khylo now shows its real build number everywhere instead of an old "13". You'll see it in the dashboard, the installers, the server log and in the Khylo apps and Manager.
**Improved**
- **Web — Update has its own page.** "Update" now sits in the left menu right under Activity & Logs, so you can check for a new version and install it without hunting for it.

### Build DEV-V26.11.04.04
**Fixed**
- **Web — Backups no longer look broken.** A big backup (artwork and other media details can be many gigabytes) takes several minutes, and the page used to give up waiting and show an error while the backup kept going. Backups now run in the background: the page shows how big it is so far, you can leave and come back, and the finished backup appears in the list. The artwork option also says plainly that it makes the backup much bigger.
- **Web — What's new is readable.** The update box showed a long block of garbled text. It now shows a short, tidy list of what changed in the new version.
**Improved**
- **Web — Updates has its own page.** There is now an **Updates** entry in the left menu under Logs. Installing an update shows what it is doing (downloading with a percentage, installing, restarting), how long it usually takes (2 to 3 minutes), and reports when the new version is running.

### Build DEV-V26.11.04.03
**Improved**
- **Web — The updates box has a better home.** The Khylo updates box moved to Settings, General, next to the other server settings. The Operations page now shows a slim notice only when an update is waiting. The channel you pick (Stable or Dev) lights up orange, and so does the automatic updates switch, so it's clear what's on.

### Build DEV-V26.11.04.02
**New**
- **Server — Khylo updates itself on Windows.** The dashboard now has a **Khylo updates** panel. It tells you when a newer version is out and you can press **Update now**: Khylo downloads the new installer, checks it, installs it and restarts, keeping your library and settings. Pick **Stable releases** or **Every build (dev)**, and turn on automatic updates if you like: they install at 3 am, only when nobody is watching. If a new version doesn't start, Khylo puts the old one back by itself.

### Build DEV-V26.11.04.01
**New**
- **Server — Manage your server from your phone.** Khylo Manager, a new app for administrators, can now work with your server: see how the computer and Khylo are doing, see and stop the transcodes Khylo started, follow the log live, restart Khylo, and reboot the computer with a two-step confirmation. Only administrators can use it, every action is recorded in the activity log, and the Reboot button only appears when Khylo really can reboot the computer.
**Fixed**
- **Server — Network folders work when Khylo runs as the system account.** If a library's folder on a NAS or another PC couldn't be reached, Khylo just kept saying so. The dashboard now offers **Connect with a login** right in that message: enter the share's login once, and Khylo connects it, remembers it, and reconnects it after every restart, without anyone signed in to Windows.

### Build DEV-V26.11.02.02
**New**
- **Server — A normal installer for Windows.** Khylo Server for Windows now comes as a regular setup program you double-click, instead of a script. It puts Khylo in your Start menu and in Windows' list of installed apps, starts it with your PC, and lets you uninstall it from Settings like any other app. You can choose whether Khylo runs as the system or as your own Windows account, which is what network drives need. Windows may warn that it doesn't know the publisher; choose More info, then Run anyway. A portable zip is still available if you just want to try it without installing anything.
**Fixed**
- **Web — Staying signed in.** Refreshing the page no longer signs you out. This also fixes switching profiles, which dropped you back at the sign-in screen: choosing a home profile now switches straight to it.
- **Web — Setup guide and help links.** The Setup Guide button in the first-time setup, and the help links in the dashboard, now open Khylo's real guides instead of a page that doesn't exist.
- **Server — The address for your home network.** The remote access step in setup used to tell you to connect to an address that only works on the server itself. It now shows this computer's real address on your home network (something like http://192.168.1.20:8096), which is what your phone and TV need. The last setup step shows it too.
- **Server — Khylo comes back by itself on Windows.** If Khylo ever stops on Windows, for example because the disk filled up, it now starts itself again within five minutes. Before, it stayed off until the PC restarted.
**Improved**
- **Server — Your mapped network drives, in the folder picker.** The folder picker now lists the network drives mapped on the server's PC (like X: or Y:). Click one to connect it: if Khylo can already open it, it opens, and if not, you enter your login for that share once. Before, only the disks inside the PC showed up. The Windows setup also lets you choose how Khylo runs; the recommended choice is still as the system, so it starts with the PC.
- **Web — A calmer first-time setup.** The setup screens have a cleaner look: one simple column, clearer fields and buttons, and nothing flashy.
- **Web — Moving your watch history, explained.** There's now a step-by-step guide with pictures for bringing everyone's history over from Plex, including exactly where to find your Plex token.

### Build DEV-V26.11.02.01
**Improved**
- **Server — Movie and show details are gentler on the lookup service.** Khylo now looks up posters, descriptions and cast from The Movie Database at a steady, polite pace, and waits and tries again if the service asks it to slow down. Big library scans no longer risk missing details because too many requests went out at once.
- **Server — Khylo's own lookup key.** Movie and show details now use Khylo's own key instead of another project's.

## October 2026

### Build DEV-V26.10.101
**New**
- **Server — A download for every kind of computer.** Khylo Server now comes ready to install on Windows (with an installer that starts it with the PC), on Mac (Apple silicon and Intel, starting at login), on Linux (Debian, Ubuntu, Raspberry Pi and others), as a Docker image, and as a one-step Proxmox container. Each comes with the web app and video conversion built in, and each connects to network drives the way that system allows. Install steps are in each download.

### Build DEV-V26.10.100
**Improved**
- **Web — Moving from another server.** Import Watch History now offers Plex or "Another server" instead of naming specific products.
- **Server — A cleaner foundation for everyone.** The server builds cleanly in both its developer and release modes, and its tests all pass, so people who want to help build Khylo can start without surprises.

### Build DEV-V26.10.099
**New**
- **Server — Install Khylo on Linux without Docker.** Khylo Server now comes as a package for Debian, Ubuntu and Raspberry Pi OS, and as a download for other Linux systems, for both Intel/AMD and ARM computers. It starts by itself, keeps running after a restart, and connecting network drives works the same as in Docker.
- **Server — One-step Proxmox setup.** A ready-made script creates a Khylo container on Proxmox, installs Khylo, starts it and tells you the address to open. It can also share a folder from the Proxmox machine, pass in the graphics chip for hardware playback, and update the container later without touching your library.

### Build DEV-V26.10.095
**Improved**
- **Server — Network drives are easy in Docker.** The setup now has step-by-step settings for Unraid, Synology and Portainer too, and adding a drive from inside Khylo needs nothing more.
- **Server — Demo-only limits removed.** The short-preview limit for demo accounts and the leftover demo accounts are gone.

### Build DEV-V26.10.085
**Improved**
- **Server — Stronger protection for your server.** Wrong profile PINs now pause just like wrong passwords, so a PIN can't be guessed by trying them all. Switching into a turned-off profile, or a kids profile outside its allowed hours, is now refused. Only admins can restart the server. Regular people only see themselves and their household in the user list, and no longer see where your server keeps its files. Sign-in keys no longer show up in the server's log files, and web pages now ship with extra browser protections. The API documentation page is off unless you turn it on.
- **Server — Longer invitation passwords.** Signing up from an invitation now needs a password of at least 8 characters.
- **Server — Safer in Docker.** Khylo now runs as an ordinary user instead of with full control of the container. Network shares still connect through a small helper that only accepts Windows and NFS shares inside the shares folder.
- **Web — Updated reading and playback parts.** The book, comic and PDF readers and other built-in parts were updated to versions without known security problems.

### Build DEV-V26.10.084
**New**
- **Server — Only Khylo apps can find your server.** Khylo now announces itself on your home network with its own signal, so other media apps no longer see your server in their "servers on your network" list. Khylo apps built before this one don't know the new signal yet, so on those add the server's address by hand or use the QR code until they're updated.
**Improved**
- **Server — Khylo's own names on your computer.** The database, settings, plugin settings, backups and folder markers Khylo keeps now carry the Khylo name. A server that already exists renames them by itself the first time it starts, and nothing is lost.
- **Server — No other project's plugin store.** The Plugins page no longer connects to another project's catalogue, and Khylo no longer introduces itself to other services with another project's contact address. You can still add a plugin catalogue of your own.
- **Server — Developer pages stay private.** The page that lists the server's technical details is switched off unless a developer turns it on.
- **Web — Khylo everywhere.** Every message in every language, the installable web app, the device icons on the Devices page and the plugin page say Khylo. Links to other projects were removed.

### Build DEV-V26.10.083
**New**
- **Server — DVD discs.** Khylo now plays DVDs straight from a disc image (ISO file) or a DVD folder, whether it sits at the top of a library or inside its own folder. Nothing has to be converted or mounted. The disc's real length, chapters, audio languages and subtitles show up, and the disc's other titles (bonus clips, extra episodes) are offered as extras.
- **Web — Disc menu.** Open a DVD and choose **Disc menu**: Play or Resume, Scenes with a picture for every chapter, Audio & Subtitles with the disc's own languages, and Extras. The disc's own menu picture sits softly behind it. Khylo builds this menu from what's on the disc, so it looks and works the same everywhere; the disc's original menu isn't replayed.
- **Web — DVDs library.** When you add a library, **DVDs** is now one of the choices.
**Fixed**
- **Server — Watching an extra doesn't touch the movie.** Playing a bonus clip no longer changes where the main film resumes or marks it as watched.
- **Web and Android TV — Copy-protected discs.** A disc copied straight from a store-bought DVD is scrambled and can't be played. Opening its disc menu now says so plainly.

### Build DEV-V26.10.082
**New**
- **Web — A reader made for reading.** Books open on calm, full-page paper with quiet controls that fade away while you read. Tap the right or left side of the page to turn it, or tap the middle to bring the controls back. The top shows the book and the chapter you're in, and the bottom has a progress bar you can drag to jump anywhere, plus how many pages are left in the chapter.
- **Web — Make the page your own.** The **Aa** button lets you change the text size with a slider, pick a font (the book's own, Serif or Sans), and choose your paper: White, Paper, Gray or Night. You can also set the line spacing, the margins, and one or two pages side by side. Khylo remembers your choices for every book.
- **Web — A better comic reader.** Comics get the same calm controls, a page slider with "Page 12 of 48", and reading options: show the whole page or fill the width, one or two pages, right-to-left for manga, and a black, gray or white background.
**Fixed**
- **Web — Books and comics name the right people.** Book pages now say **Authors** (and **Authors & Narrators** for audiobooks) and comic pages say **Creators**, instead of "Cast & Crew".
- **Web — Favorite, not "Add to Library".** Books and comics are already in your library, so the button now says **Favorite**, the same as music.
**Improved**
- **Web — Contents list.** A book's contents open in a clean panel that matches your paper colour.

### Build DEV-V26.10.081
**New**
- **Server — Real notifications.** The bell now tells you when new movies, episodes, albums, books, comics, audiobooks, podcast episodes and photos arrive, grouped sensibly ("3 new episodes of Bonanza"), and only for things you're allowed to see.
- **Web — A proper home for your photos.** Photo libraries open as a clean photo grid, newest first, including pictures dropped straight into the library folder. Click one to see it full screen, move through with the arrows (or swipe), and start a slideshow. Photos never say "Play" any more.
**Fixed**
- **Server — Your IPTV login stays private.** People you share Khylo with could read the server's settings, including your IPTV playlist link and its login. Settings are now for admins only.
- **Server — Only people signed in can play your media.** Movies and music could be streamed by anyone who had a title's link, without signing in. Now every stream needs a signed-in account, and only plays what that person is allowed to see.
- **Server — Protection against password guessing.** After 10 wrong passwords for an account, signing in to it pauses for a few minutes. Nothing gets locked or disabled, and devices already signed in carry on.
- **Server — Invitation and sign-in links can't be redirected.** A new server now learns its web address only when an admin opens it, so nobody else can point invitation links or sign-in QR codes at their own site.
- **Server — Podcasts play.** Podcast episodes wouldn't play anywhere because Khylo never read their length and sound format. It now does, for new episodes and ones already in your library.
- **Web — Comics show up.** Comics & Manga libraries now show their comics, ready to open in the reader.
- **Web — Podcasts show up.** Podcast libraries list their shows, and each show's page lists its episodes, newest first, ready to play.
- **Web — Notifications clear properly.** Mark all read, Clear all and removing a single notification now work, and stay cleared on every device you use.
- **Web — Deleting and renaming libraries works.** After renaming a library, deleting it or removing one of its folders could fail with "does not exist" until you reloaded the page. The dashboard now always uses the library's current name, follows it after a rename, and tells you plainly if something can't be done.
**Improved**
- **Web — Calmer, smaller headers.** Library pages for books, audiobooks, comics, podcasts, photos and the rest open straight onto their shelves with a small title, instead of a full-screen banner. Movies and TV keep their big showcase. Book, comic and podcast pages get the same compact header as music.

### Build DEV-V26.10.079
**New**
- **Server — Sign a phone in by scanning a code.** A device you're already signed in on can now make a QR code that signs a new phone in as you, with no server address, user name or password to type. Each code works once and only for 5 minutes, and the activity log notes which device signed in and from where.
- **Web — Sign in another device.** In your account menu, choose Sign in another device to show a QR code for the Khylo app on your phone. The screen tells you when the phone is signed in. If someone scans it with their phone's camera instead, the link signs that browser in.

### Build DEV-V26.10.077
**Fixed**
- **Web — Choose single IPTV channels.** In the channel picker, clicking a group's name now opens it so you can tick individual channels. Before, only whole groups could be picked because the click never reached the list.

### Build DEV-V26.10.076
**Fixed**
- **Server — Network shares with work or domain logins.** Logins like BB\yourname or yourname@company.com were refused even with the right password. They now work, as do DFS shares and folders inside a share. On Windows, a share the computer can already open (a mapped drive, say) connects straight away.

### Build DEV-V26.10.074
**New**
- **Server — Media from your NAS, connected in Khylo.** When you add a library, choose **Network share** in the folder picker and enter the share: `\\nas\Movies` for Windows and SMB shares, or `nas:/volume1/Movies` for NFS (Synology, TrueNAS, Unraid, Linux). Khylo checks it straight away, tells you plainly if the address or password is wrong, and keeps the share connected after restarts and NAS reboots. Passwords are stored encrypted. Works in Docker and on Windows.

### Build DEV-V26.10.073
**New**
- **Server — Media from your NAS in Docker.** Khylo in Docker can now read movies, shows and music straight from network shares: Windows and SMB shares, and NFS shares on Linux machines and NAS boxes like Synology, TrueNAS and Unraid. Set the share up once and it appears as a folder when you add a library.
**Fixed**
- **Web — Clearer folder picker.** The folder picker no longer says it's looking at a Windows computer when Khylo runs somewhere else.

### Build DEV-V26.10.072
**New**
- **Server — Khylo in Docker.** Khylo Server now comes as a ready-made Docker image with everything inside: the server, the web app, and video tools tuned for hardware transcoding on Intel, AMD and NVIDIA graphics. Point it at your media folders, start it, and open it in your browser. It runs the same on Linux, a NAS, Windows or Mac.
**Improved**
- **Server — Khylo through and through.** Every part of the server now carries the Khylo name, down to its program files. Plugins made for the original server keep working.

### Build DEV-V26.10.071
**Improved**
- **Web — A tidy Invitations page.** Invitations are split into Active and History. Each one says plainly whether it's active, used, expired or revoked, and used ones show who joined with them. You can remove any finished invitation, or clear the whole history at once; the accounts people made are never touched.
- **Server — Old invitations tidy themselves away.** Used, expired and revoked invitations are removed automatically 30 days after they finish.

### Build DEV-V26.10.070
**Fixed**
- **Server — Signing up from an invitation works.** Creating an account from an invitation link failed with an error. It now goes through and signs the person straight in, and if anything ever goes wrong partway, no half-made account is left behind.

### Build DEV-V26.10.069
**Fixed**
- **Web — The real build number in the dashboard.** The dashboard and its sidebar now show the Khylo build your server is running (like DEV-V26.10.069) instead of an internal version number, in a calmer style.

### Build DEV-V26.10.068
**Fixed**
- **Web — The Plugins page opens straight away.** Your installed plugins show immediately instead of after a long wait. If the online plugin catalog can't be reached, the page says so instead of sitting empty.
- **Server — The plugin catalog can't hold things up.** Khylo stops waiting on the online plugin catalog after a few seconds and shows the last copy it downloaded.

### Build DEV-V26.10.067
**Fixed**
- **Web — Invitation links work from anywhere.** Copied invitation links now use your server's web address instead of a home-only one, and the length you choose for an invitation is actually used.
- **Web — A proper sign-up page for invited people.** Opening an invitation link shows a simple "Join" page where the person picks a name and password and is signed straight in. If the invitation has expired or been used, it says so.

### Build DEV-V26.10.066
**New**
- **Server — Apps can switch between home and away by themselves.** Khylo now tells your apps every way to reach it: the fast direct address at home and your web address for when you're out. Apps that support it connect directly at home and switch to the web address when you leave, with no settings to change.
- **Web — Home Address in Server Settings.** If you use a name of your own on your home network (like khylo.mydomain.internal), add it under Home Address and apps will try it first at home. Leave it empty and Khylo uses the server's own home network address.

### Build DEV-V26.10.065
**Improved**
- **Web — Setup shows the address for home-only use.** If you're only using Khylo at home, the setup tells you the address your apps can connect to.

### Build DEV-V26.10.064
**Fixed**
- **Web — Web Address in Server Settings,** to check or change the address Khylo shares.

### Build DEV-V26.10.062
**Fixed**
- **Server — Movies play again after your storage restarts.** If the computer or NAS holding your media reboots, Khylo now reconnects to it by itself, including mapped network drives that Windows leaves disconnected, and tries again the moment you press play. New media also keeps appearing by itself once the storage is back.
- **Web — The dashboard tells you when storage can't be reached.** Instead of always saying Healthy, the dashboard shows which library can't be reached and since when, and marks it Unreachable until it's back.

### Build DEV-V26.10.045
**Fixed**
- **Server — Books get their covers and details.** On Windows servers, Khylo couldn't read the cover, description, author or genres built into EPUB books. It now reads them, and fills in anything missing from Open Library and Google Books: a description, everyday genres like Mystery or Science Fiction, the year the book first came out, and a cover.
- **Server — Audiobooks get book details, not song details.** Audiobooks were looked up like music, so they never got a description. They're now found as books, with a description, genres, year and cover.
- **Server — Podcasts fill themselves in.** Each show is found in Apple's podcast directory, and its own feed gives its description, maker, website, categories and artwork.
**Improved**
- **Server — Tidier book titles.** Books show their main title ("Moby Dick", not "Moby Dick; Or, The Whale").

### Build DEV-V26.10.044
**Fixed**
- **Web — Audiobooks named for the book.** Books and their pages show the book's title instead of the first chapter's name, and the page lists every part.

### Build DEV-V26.10.043
**New**
- **Web — Setup that gets everything ready.** Setting up a new Khylo server now walks you through what matters, and every step can be skipped and done later:
**Improved**
- **Web — Adding libraries during setup** uses the same clear steps as the dashboard.
- **Web — The last setup screen** explains how to watch on your TV, phone and in any browser.

### Build DEV-V26.10.042
**Fixed**
- **Server — The Live TV guide fills in.** If the address you gave Khylo for the TV guide was your provider's channel list instead of its guide, every channel said "No listings". Khylo now spots this and, for providers that have both (the common "get.php" kind), fetches the guide from the right address by itself, using the same login. Your provider login is also no longer written into the server's log files.

### Build DEV-V26.10.041
**Fixed**
- **Server — The same movie shows once.** When a movie is in your library twice (say a Special Edition folder next to a regular copy), it now shows as one title instead of two. After each library scan Khylo joins copies of the same film into one title, and the sharpest copy is the one that plays. Nothing is deleted; both files stay where they are.

### Build DEV-V26.10.037
**Fixed**
- **Server — Library scans no longer crawl.** Scans only read your files now, so new music shows up within minutes, even in a huge library. Artist bios, photos and album covers are filled in afterwards in the background, at a pace each online source is happy with, so Khylo is never cut off for asking too much. Artists and albums someone opens are looked up first. Bios for many artists come in a single request, each artist is matched by its official music ID once and found by that ID from then on, and Khylo keeps only a tiny note of what it has already checked, so it never asks twice.

### Build DEV-V26.10.032
**New**
- **Web — Import Watch History** in the dashboard, under Media & Storage.

### Build DEV-V26.10.030
**Fixed**
- **Server — Away from home is recognized behind any proxy.** When your Khylo address goes through a reverse proxy or web server on your home network (or a tunnel on the same computer), Khylo now follows it back to the real viewer, so phones away from home get the smoother away-from-home stream. Nothing to set up, and nobody can pretend to be at home to get around it.

### Build DEV-V26.10.027
**New**
- **Server — Music keeps filling itself in.** Every night, and whenever the server restarts, Khylo looks again for any artist photo, bio or album cover that's still missing and fills it in. Nothing to set up, and nothing from your own files is ever replaced.

### Build DEV-V26.10.026
**New**
- **Server — Artist photos and bios for any music.** Music without its own details (like Apple Music downloads) now gets artist photos, bios and album details matched by name, from US-based sources first, with others as backups. If a source can't be reached, Khylo moves straight on to the next one instead of stalling.

### Build DEV-V26.10.025
**New**
- **Server — Missing details are filled in from online.** When your files don't carry their own artist photos, bios, genres or album details, Khylo now looks them up online by itself and fills in the gaps. What's already in your files always comes first and is never overwritten. It works out of the box on new servers, and servers that update get it switched on for music too.

### Build DEV-V26.10.024
**Improved**
- **Server — New movies, shows and music appear by themselves.** Khylo now watches your library folders and adds new media within a minute or two of it arriving, with no manual scan. A full scan also runs every 6 hours and every night at 3 am, so nothing is missed even on network drives that can't report changes. New Khylo servers come set up this way.
**Fixed**
- **Web — Adding a library keeps your choices.** The Add library steps now save the Realtime Monitoring, chapter image and preview thumbnail switches you set, instead of quietly ignoring them.

### Build DEV-V26.10.011
**Fixed**
- **Server — Skip Credits and Up Next on more shows.** Khylo now recognizes end credits by the true black behind the text, so it isn't fooled by dark night scenes, and logo cards at the very end no longer throw it off. Shows like Stranger Things, whose credits play different music every episode, now get Skip Credits and the next-episode countdown.
- **Server — Credits start where they really start.** Episodes that only caught the last few seconds (the closing logo sting) now begin Skip Credits when the credits actually roll.
- **Server —** Your library is re-checked in the background, starting with the shows you're in the middle of.

### Build DEV-V26.10.006
**New**
- **Web — Home Profiles in the dashboard** (Access Control → Home Profiles):
**Improved**
- **Server — Profiles never get more than their maker.** A profile gets the same libraries, rating limits, Live TV access and streaming limits as the person who added it, and a kids profile can only be set at or below that person's limit.
- **Server — One stream limit per home.** Everyone in a home shares the stream limit of the person who owns it, so adding profiles doesn't let a home use more of the server.
- **Server —** Kids profile setup only offers Live TV when the person adding it has Live TV.

### Build DEV-V26.10.005
**Fixed**
- **Server —** Seasons no longer show the same episode several times. Bonus material kept in folders such as "DVD Extras" or "Vol. 5 Extras" inside a show's folder is no longer mistaken for episodes.
