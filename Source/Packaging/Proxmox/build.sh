#!/usr/bin/env bash
# Builds the Khylo Proxmox download: the container script, its guide, and the Khylo packages it installs, in one
# file:   Source/Packaging/Proxmox/builds/khylo-proxmox-<version>.tar.gz
#
#   Source/Packaging/Proxmox/build.sh                  uses the packages in Source/Packaging/Linux/builds (build them first)
#   Source/Packaging/Proxmox/build.sh DEV-V26.11.02.01   a specific build number
set -euo pipefail
cd "$(dirname "$0")/../../.."

build=${1:-$(grep -m1 -oE 'DEV-V[0-9]{2}\.[0-9]{2}\.[0-9]{2}\.[0-9]{2}' CHANGELOG.md)}
version=${build#DEV-V}
debs=(Source/Packaging/Linux/builds/khylo-server_"${version}"_*.deb)
if [ ! -f "${debs[0]}" ]; then
	echo "No Khylo packages for $build in Source/Packaging/Linux/builds. Run Source/Packaging/Linux/build.sh $build first." >&2
	exit 1
fi

name="khylo-proxmox-${version}"
out=Source/Packaging/Proxmox/builds
tmp=$(mktemp -d)
mkdir -p "$out" "$tmp/$name"
cp Source/Packaging/Proxmox/khylo-lxc.sh Source/Packaging/Proxmox/README.md "$tmp/$name/"
cp "${debs[@]}" "$tmp/$name/"
chmod 0755 "$tmp/$name/khylo-lxc.sh"
sed -i 's/\r$//' "$tmp/$name/khylo-lxc.sh"
tar -czf "$out/$name.tar.gz" -C "$tmp" "$name"
rm -rf "$tmp"
ls -la "$out"
