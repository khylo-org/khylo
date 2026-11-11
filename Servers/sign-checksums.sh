#!/usr/bin/env bash
# Signs a release's checksum list with Khylo's update key. Servers only install an update whose checksum list carries
# this signature, so nobody who merely controls the release page can make a server install something else.
#
#   Source/Packaging/sign-checksums.sh path/to/SHA256SUMS.txt     writes path/to/SHA256SUMS.txt.sig beside it
#
# The private key lives on this PC only, never in a repository: %LOCALAPPDATA%\KhyloBuild\khylo-update-signing.pem
# (or the file KHYLO_UPDATE_KEY names). KEEP A BACKUP OF IT OFFLINE: if it is lost, no installed server can update itself
# again (each would have to be reinstalled by hand with a new key built in). The matching public key is built into the
# server (Khylo.Server.Core/Updates/KhyloUpdateSignature.cs); this script checks what it signed against that key.
# Source/Packaging/publish-release.sh runs this for every release.
set -euo pipefail

sums=${1:?Say which checksum list to sign, for example Source/Packaging/SHA256SUMS.txt}
[ -f "$sums" ] || { echo "No checksum list at $sums"; exit 1; }
here=$(cd "$(dirname "$0")" && pwd)

key=${KHYLO_UPDATE_KEY:-}
if [ -z "$key" ]; then
	if command -v cygpath >/dev/null 2>&1; then
		key="$(cygpath -u "$LOCALAPPDATA")/KhyloBuild/khylo-update-signing.pem"
	else
		key="$HOME/.khylo/khylo-update-signing.pem"
	fi
fi
[ -f "$key" ] || { echo "The update signing key isn't at $key, so the release can't be signed."; exit 1; }

pub=$(mktemp)
trap 'rm -f "$pub"' EXIT
sed -n '/BEGIN PUBLIC KEY/,/END PUBLIC KEY/p' "$here/Source/Khylo.Server.Core/Updates/KhyloUpdateSignature.cs" | tr -d '\r' | sed 's/^[[:space:]]*//' > "$pub"
[ -s "$pub" ] || { echo "Couldn't read the public key from KhyloUpdateSignature.cs"; exit 1; }

openssl dgst -sha256 -sign "$key" -out "$sums.sig" "$sums"
if ! openssl dgst -sha256 -verify "$pub" -signature "$sums.sig" "$sums" >/dev/null; then
	rm -f "$sums.sig"
	echo "The signature doesn't match the public key built into the server, so servers would refuse this release. Not signed."
	exit 1
fi
echo "Signed $(basename "$sums") (checked against the key built into the server)"
