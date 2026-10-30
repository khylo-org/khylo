#!/bin/sh
# Starts Khylo as an ordinary user, not root.
#
# The container begins as root only long enough to make sure the settings and cache folders belong to Khylo's
# user (needed once for volumes made by earlier versions, which ran as root). Then it drops to that user, keeping
# any extra groups the container was given (for example the group that owns the graphics device).
set -e

if [ "$(id -u)" = "0" ]; then
    for dir in /config /cache; do
        if [ -d "$dir" ] && [ "$(stat -c %u "$dir")" != "$(id -u khylo)" ]; then
            echo "Giving $dir to Khylo's user (one time)..."
            chown -R khylo:khylo "$dir"
        fi
    done
    exec setpriv --reuid=khylo --regid=khylo --keep-groups -- /khylo/khylo "$@"
fi

# Already running as an ordinary user (the container was started with "user:")
exec /khylo/khylo "$@"
