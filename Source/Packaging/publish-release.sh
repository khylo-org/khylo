#!/usr/bin/env bash
# Puts a finished build on the GitHub release page: uploads every download, writes the checksums, and rewrites the release
# text (download buttons, table, what's new) so the page always matches the files. Run this every time downloads are pushed.
#
#   Source/Packaging/publish-release.sh                  build number from the top of CHANGELOG.md
#   Source/Packaging/publish-release.sh DEV-V26.11.02.02 a specific build number
#
# Needs the gh command signed in as the account that owns khylo-org/khylo. Only files for this build are uploaded.
set -euo pipefail
cd "$(dirname "$0")/.."

repo=khylo-org/khylo
build=${1:-$(grep -m1 -oE 'DEV-V[0-9]{2}\.[0-9]{2}\.[0-9]{2}\.[0-9]{2}' CHANGELOG.md)}
version=${build#DEV-V}

Source/Packaging/checksums.sh >/dev/null
files=(Source/Packaging/*/builds/*"$version"* Source/Packaging/SHA256SUMS.txt)
echo "Uploading ${#files[@]} files for $build to $repo"

if gh release view "$build" --repo "$repo" >/dev/null 2>&1; then
	gh release upload "$build" --repo "$repo" --clobber "${files[@]}"
else
	gh release create "$build" --repo "$repo" --title "Khylo Server $build" --notes "Khylo Server $build" "${files[@]}"
fi

notes=$(mktemp)
python3 Source/Packaging/release-notes.py "$build" > "$notes"
gh release edit "$build" --repo "$repo" --notes-file "$notes"
rm -f "$notes"
echo "Done: https://github.com/$repo/releases/tag/$build"
