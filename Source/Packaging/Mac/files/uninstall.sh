#!/bin/bash
# Removes Khylo Server from this Mac. Your library and settings are kept unless you pass --remove-data.
#
#   sudo ./uninstall.sh [--remove-data]
set -euo pipefail

if [ "$(id -u)" != "0" ]; then
	echo "Run this with sudo:  sudo ./uninstall.sh" >&2
	exit 1
fi
OWNER=${SUDO_USER:-}
LABEL=org.khylo.server

if launchctl print "system/$LABEL" >/dev/null 2>&1; then
	launchctl bootout "system/$LABEL" || true
fi
rm -f "/Library/LaunchDaemons/$LABEL.plist"
rm -rf /usr/local/khylo

if [ "${1:-}" = "--remove-data" ] && [ -n "$OWNER" ]; then
	HOME_DIR=$(dscl . -read "/Users/$OWNER" NFSHomeDirectory | awk '{print $2}')
	rm -rf "$HOME_DIR/Library/Application Support/Khylo"
	echo "Khylo and its data were removed."
else
	echo "Khylo was removed. Your library and settings are still in ~/Library/Application Support/Khylo. Delete that folder yourself if you want them gone."
fi
