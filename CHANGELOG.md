# What's New in Khylo

## November 2026

### Build DEV-V26.11.02.02
**New**
- **Server — A normal installer for Windows.** Khylo Server for Windows now comes as a regular setup program you double-click, instead of a script. It puts Khylo in your Start menu and in Windows' list of installed apps, starts it with your PC, and lets you uninstall it from Settings like any other app. You can choose whether Khylo runs as the system or as your own Windows account, which is what network drives need. Windows may warn that it doesn't know the publisher; choose More info, then Run anyway. A portable zip is still available if you just want to try it without installing anything.

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
