#!/usr/bin/env bash
# Builds the Khylo Server download for macOS, for Apple silicon (arm64) and Intel (x64):
#   Source/Packaging/Mac/builds/khylo-server-<version>-macos-<arch>.tar.gz
#
#   Source/Packaging/Mac/build.sh                       build number from the top of CHANGELOG.md
#   Source/Packaging/Mac/build.sh DEV-V26.11.02.01        a specific build number
#   Source/Packaging/Mac/build.sh DEV-V26.11.02.01 arm64  just one CPU type
#
# Needs Docker. Works from anywhere; it runs from the hub folder.
set -euo pipefail
cd "$(dirname "$0")/../../.."

build=${1:-$(grep -m1 -oE 'DEV-V[0-9]{2}\.[0-9]{2}\.[0-9]{2}\.[0-9]{2}' CHANGELOG.md)}
archs=${2:-"arm64 x64"}
out=Source/Packaging/Mac/builds
mkdir -p "$out"

for arch in $archs; do
	echo "== Building $build for macOS $arch"
	docker buildx build \
		--build-arg "KHYLO_BUILD=$build" --build-arg "RID=osx-$arch" \
		--target out --output "type=local,dest=$out" \
		-f Source/Packaging/Mac/Dockerfile .
done
ls -la "$out"
