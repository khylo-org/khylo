#!/bin/sh
# Sets Khylo up on this machine after its files are in place. Used by the .deb (as its postinst) and by
# install.sh for the .tar.gz. Safe to run again on every upgrade; it never touches your library or settings.
set -e

if ! getent group khylo >/dev/null; then
    groupadd --system khylo
fi
if ! getent passwd khylo >/dev/null; then
    useradd --system --gid khylo --home-dir /var/lib/khylo --shell /usr/sbin/nologin khylo
fi
# Graphics devices (hardware transcoding), when this machine has those groups
for g in video render; do
    if getent group "$g" >/dev/null; then
        usermod -a -G "$g" khylo || true
    fi
done

for d in /var/lib/khylo /var/lib/khylo/shares /var/cache/khylo /var/log/khylo; do
    mkdir -p "$d"
    chown khylo:khylo "$d"
done
chmod 0750 /var/lib/khylo

# The mount helper reads where shares go from here (owned by root so Khylo itself cannot change it)
mkdir -p /etc/khylo
cat > /etc/khylo/mount.conf <<'EOF'
SHARES=/var/lib/khylo/shares
CONFIG_DIR=/var/lib/khylo
EOF
chmod 0644 /etc/khylo/mount.conf

chown root:root /usr/lib/khylo/khylo-mount
chmod 0755 /usr/lib/khylo/khylo-mount
mkdir -p /etc/sudoers.d
echo 'khylo ALL=(root) NOPASSWD: /usr/lib/khylo/khylo-mount' > /etc/sudoers.d/khylo
chmod 0440 /etc/sudoers.d/khylo

if [ -d /run/systemd/system ]; then
    systemctl daemon-reload
    systemctl enable khylo >/dev/null 2>&1 || true
    systemctl restart khylo || true
    echo "Khylo is starting. Open http://$(hostname -I 2>/dev/null | awk '{print $1}'):8096 to finish setup."
else
    echo "Khylo is installed. Start it with: systemctl start khylo (or run /opt/khylo/khylo as the khylo user)."
fi
