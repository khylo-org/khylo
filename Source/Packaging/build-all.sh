#!/usr/bin/env bash
# Builds every Khylo Server download: Docker, Linux, Proxmox, Windows and Mac.
#
#   Source/Packaging/build-all.sh                  build number from the top of CHANGELOG.md
#   Source/Packaging/build-all.sh DEV-V26.10.101   a specific build number
#
# Results land in each folder's builds/ directory (never committed). Needs Docker.
set -euo pipefail
cd "$(dirname "$0")/../.."
build=${1:-$(grep -m1 -oE 'DEV-V[0-9]{2}\.[0-9]{2}\.[0-9]{3}' CHANGELOG.md)}
echo "Building every server for $build"
Source/Packaging/Linux/build.sh "$build"
Source/Packaging/Proxmox/build.sh "$build"
Source/Packaging/Windows/build.sh "$build"
Source/Packaging/Mac/build.sh "$build"
Source/Packaging/Docker/build.sh "$build"
echo
echo "Done. Packages:"
ls -1 Source/Packaging/*/builds/* 2>/dev/null
