#!/usr/bin/env bash
# Builds the Khylo Server Linux packages for Intel/AMD (amd64) and ARM (arm64):
#   Source/Packaging/Linux/builds/khylo-server_<version>_<arch>.deb               Debian, Ubuntu, Proxmox
#   Source/Packaging/Linux/builds/khylo-server-<version>-linux-<arch>.tar.gz      any other systemd Linux
#
#   Source/Packaging/Linux/build.sh                       build number from the top of CHANGELOG.md
#   Source/Packaging/Linux/build.sh DEV-V26.10.096        a specific build number
#   Source/Packaging/Linux/build.sh DEV-V26.10.096 amd64  just one CPU type
#
# Needs Docker. Run it from anywhere; it works from the hub folder.
set -euo pipefail
cd "$(dirname "$0")/../../.."

build=${1:-$(grep -m1 -oE 'DEV-V[0-9]{2}\.[0-9]{2}\.[0-9]{3}' CHANGELOG.md)}
archs=${2:-"amd64 arm64"}
out=Source/Packaging/Linux/builds
mkdir -p "$out"

for arch in $archs; do
	echo "== Building $build for $arch"
	docker buildx build \
		--platform "linux/$arch" \
		--build-arg "KHYLO_BUILD=$build" \
		--target out \
		--output "type=local,dest=$out" \
		-f Source/Packaging/Linux/Dockerfile .
done
ls -la "$out"
