#!/usr/bin/env bash
# Writes SHA-256 checksums for every built download, so people can check what they downloaded:
#   Source/Packaging/checksums.sh            ->  Source/Packaging/SHA256SUMS.txt
# Verify with:  sha256sum -c SHA256SUMS.txt   (Linux)   or   shasum -a 256 -c SHA256SUMS.txt   (Mac)
set -euo pipefail
cd "$(dirname "$0")"
: > SHA256SUMS.txt
for f in */builds/*; do
	[ -f "$f" ] || continue
	sum=$(sha256sum "$f" | cut -d' ' -f1)
	echo "$sum  $(basename "$f")" >> SHA256SUMS.txt
done
cat SHA256SUMS.txt
