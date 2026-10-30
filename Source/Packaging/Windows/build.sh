#!/usr/bin/env bash
# Builds the Khylo Server download for Windows, for Intel/AMD (x64) and ARM (arm64):
#   Source/Packaging/Windows/builds/khylo-server-<version>-windows-<arch>.zip
#
#   Source/Packaging/Windows/build.sh                       build number from the top of CHANGELOG.md
#   Source/Packaging/Windows/build.sh DEV-V26.10.101        a specific build number
#   Source/Packaging/Windows/build.sh DEV-V26.10.101 x64    just one CPU type
#
# Needs Docker. Works from anywhere; it runs from the hub folder.
set -euo pipefail
cd "$(dirname "$0")/../../.."

build=${1:-$(grep -m1 -oE 'DEV-V[0-9]{2}\.[0-9]{2}\.[0-9]{3}' CHANGELOG.md)}
archs=${2:-"x64 arm64"}
out=Source/Packaging/Windows/builds
mkdir -p "$out"

for arch in $archs; do
	echo "== Building $build for Windows $arch"
	docker buildx build \
		--build-arg "KHYLO_BUILD=$build" --build-arg "RID=win-$arch" \
		--target out --output "type=local,dest=$out" \
		-f Source/Packaging/Windows/Dockerfile .
done
ls -la "$out"
