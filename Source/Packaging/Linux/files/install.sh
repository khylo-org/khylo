#!/bin/sh
# Installs Khylo Server from the .tar.gz on any systemd-based Linux (Fedora, Arch, openSUSE and so on).
# Debian, Ubuntu and Proxmox: use the .deb instead.
#
#   sudo ./install.sh
#
# Needs: ICU libraries (libicu), fontconfig, sudo, and cifs-utils / nfs-utils for network shares.
set -e

if [ "$(id -u)" != "0" ]; then
    echo "Run this with sudo." >&2
    exit 1
fi
here=$(cd "$(dirname "$0")" && pwd)

# Keep the user's settings file when updating
if [ -f /etc/khylo/khylo.env ]; then
    cp /etc/khylo/khylo.env /etc/khylo/khylo.env.keep
fi
cp -a "$here/root/." /
if [ -f /etc/khylo/khylo.env.keep ]; then
    mv /etc/khylo/khylo.env.keep /etc/khylo/khylo.env
fi
# systemd looks in /etc/systemd/system on every distribution
cp /usr/lib/systemd/system/khylo.service /etc/systemd/system/khylo.service 2>/dev/null || true

/usr/lib/khylo/configure.sh
