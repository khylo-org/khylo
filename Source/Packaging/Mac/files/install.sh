#!/bin/bash
# Installs Khylo Server on a Mac and starts it, so it runs whenever the Mac is on.
#
#   sudo ./install.sh
#
# Khylo runs as YOU (so it can read your media folders), keeps its library and settings in
# ~/Library/Application Support/Khylo, and starts at boot. Running this again updates Khylo and keeps everything.
set -euo pipefail

if [ "$(id -u)" != "0" ]; then
	echo "Run this with sudo:  sudo ./install.sh" >&2
	exit 1
fi
OWNER=${SUDO_USER:-}
if [ -z "$OWNER" ] || [ "$OWNER" = "root" ]; then
	echo "Run it with sudo from your own account (not as root directly), so Khylo knows whose files to use." >&2
	exit 1
fi
HOME_DIR=$(dscl . -read "/Users/$OWNER" NFSHomeDirectory | awk '{print $2}')
HERE=$(cd "$(dirname "$0")" && pwd)
INSTALL=/usr/local/khylo
DATA="$HOME_DIR/Library/Application Support/Khylo"
LABEL=org.khylo.server
PLIST=/Library/LaunchDaemons/$LABEL.plist

echo "Installing Khylo Server for $OWNER..."

# Stop a running copy (an update)
if launchctl print "system/$LABEL" >/dev/null 2>&1; then
	launchctl bootout "system/$LABEL" || true
	sleep 2
fi

mkdir -p "$INSTALL"
rsync -a --delete "$HERE/khylo/" "$INSTALL/"
# Downloaded programs are quarantined by macOS until they are opened once; allow Khylo to run
xattr -dr com.apple.quarantine "$INSTALL" 2>/dev/null || true
chmod 0755 "$INSTALL/khylo" "$INSTALL/ffmpeg/ffmpeg" "$INSTALL/ffmpeg/ffprobe"

for d in data config cache log; do
	mkdir -p "$DATA/$d"
done
chown -R "$OWNER" "$DATA"

cat > "$PLIST" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Label</key><string>$LABEL</string>
	<key>UserName</key><string>$OWNER</string>
	<key>ProgramArguments</key>
	<array>
		<string>$INSTALL/khylo</string>
		<string>--service</string>
		<string>--webdir</string><string>$INSTALL/web</string>
		<string>--ffmpeg</string><string>$INSTALL/ffmpeg/ffmpeg</string>
		<string>--datadir</string><string>$DATA/data</string>
		<string>--configdir</string><string>$DATA/config</string>
		<string>--cachedir</string><string>$DATA/cache</string>
		<string>--logdir</string><string>$DATA/log</string>
	</array>
	<key>WorkingDirectory</key><string>$INSTALL</string>
	<key>RunAtLoad</key><true/>
	<key>KeepAlive</key><true/>
	<key>StandardOutPath</key><string>$DATA/log/launchd.out.log</string>
	<key>StandardErrorPath</key><string>$DATA/log/launchd.err.log</string>
</dict>
</plist>
EOF
chown root:wheel "$PLIST"
chmod 0644 "$PLIST"

launchctl bootstrap system "$PLIST"

echo "Starting Khylo..."
for _ in $(seq 1 60); do
	if curl -fsS http://localhost:8096/health >/dev/null 2>&1; then
		ADDRESS=$(ipconfig getifaddr en0 2>/dev/null || ipconfig getifaddr en1 2>/dev/null || true)
		echo
		echo "Khylo is running. Open  http://localhost:8096  to finish setup."
		[ -n "$ADDRESS" ] && echo "From other devices: http://$ADDRESS:8096"
		echo "Your library and settings are in: $DATA (back that folder up)."
		exit 0
	fi
	sleep 2
done
echo "Khylo was installed but hasn't answered yet. Give it a minute, then open http://localhost:8096. Logs are in $DATA/log."
