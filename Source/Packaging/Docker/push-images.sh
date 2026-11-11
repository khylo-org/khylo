#!/usr/bin/env bash
# Publishes the Khylo Server Docker image to GitHub's container registry as ONE image that works on Intel/AMD (amd64)
# and ARM (arm64) machines:
#
#   ghcr.io/khylo-org/khylo-server:<version>   for example 26.11.10.01 (that exact build)
#   ghcr.io/khylo-org/khylo-server:dev         the newest development build
#   ghcr.io/khylo-org/khylo-server:latest      the newest build (while there is no stable release yet)
#
# It pushes exactly the images saved in Source/Packaging/Docker/builds/*.tar (the same files people can download from the release),
# so the registry and the release always match. Built on this PC, never on GitHub's computers. Source/Packaging/publish-release.sh
# runs it on every publish.
#
#   Source/Packaging/Docker/push-images.sh DEV-V26.11.10.01
#
# Needs the khylo-org GitHub login on this PC to have the packages permission. One time only:
#   sign gh in as the khylo-org account (gh auth switch --user khylo-org), then: gh auth refresh -h github.com -s write:packages,read:packages
# A package GitHub creates for the first time is private. If the check at the end says so, make it public once on the
# package's page (Package settings > Danger zone > Change visibility > Public); later pushes keep that setting.
set -euo pipefail
cd "$(dirname "$0")/../../.."

build=${1:?Say which build to publish, for example DEV-V26.11.10.01}
version=${build#DEV-V}
image=ghcr.io/khylo-org/khylo-server
account=khylo-org
out=Source/Packaging/Docker/builds
source_repo=https://github.com/khylo-org/khylo-server

for arch in amd64 arm64; do
	[ -f "$out/khylo-server-docker-${version}-${arch}.tar" ] || { echo "Missing $out/khylo-server-docker-${version}-${arch}.tar: build it first (Source/Packaging/Docker/build.sh $build)"; exit 1; }
done

token=$(gh auth token --hostname github.com --user "$account" 2>/dev/null || true)
[ -n "$token" ] || { echo "The $account GitHub login isn't on this PC (gh auth login)."; exit 1; }
scopes=$(curl -fsSI -H "Authorization: Bearer $token" https://api.github.com/user | tr -d '\r' | grep -i '^x-oauth-scopes:' || true)
if ! grep -q 'write:packages' <<<"$scopes"; then
	echo "The $account login doesn't have permission to publish packages yet. Run this once, approve it in the browser, then run this again:"
	echo "  gh auth switch --user $account; gh auth refresh -h github.com -s write:packages,read:packages   (then switch gh back to your working account)"
	exit 2
fi

trap 'docker logout ghcr.io >/dev/null 2>&1 || true' EXIT
printf '%s' "$token" | docker login ghcr.io -u "$account" --password-stdin >/dev/null

# This computer's own type goes last, so it ends up as the local default tags (build.sh does the same)
case "$(uname -m)" in aarch64|arm64) mine=arm64; other=amd64 ;; *) mine=amd64; other=arm64 ;; esac
for arch in "$other" "$mine"; do
	echo "Pushing $image:${version}-${arch}"
	docker load -i "$out/khylo-server-docker-${version}-${arch}.tar" >/dev/null
	docker tag "khylo/server:${version}" "$image:${version}-${arch}"
	docker push "$image:${version}-${arch}" >/dev/null
done

# One name for both CPU types, and the package linked to the public code repository
stable_now=$(python3 -c "import json;print(json.load(open('Source/Packaging/channels.json')).get('stable',''))" 2>/dev/null || true)
tags=(-t "$image:${version}")
if [[ "$build" == DEV-* ]]; then tags+=(-t "$image:dev"); fi
if [ -z "$stable_now" ] || [[ "$build" != DEV-* ]]; then tags+=(-t "$image:latest"); fi
echo "Publishing $image for amd64 and arm64: ${tags[*]//-t /}"
docker buildx imagetools create "${tags[@]}" \
	--annotation "index:org.opencontainers.image.source=$source_repo" \
	--annotation "index:org.opencontainers.image.title=Khylo Server" \
	--annotation "index:org.opencontainers.image.description=Your own media server: movies, shows, music, Khylo TV and Live TV" \
	--annotation "index:org.opencontainers.image.licenses=GPL-2.0-only" \
	--annotation "index:org.opencontainers.image.version=$build" \
	"$image:${version}-amd64" "$image:${version}-arm64"

# Can anyone pull it? Ask the registry as nobody
anon=$(curl -fsS "https://ghcr.io/token?scope=repository:khylo-org/khylo-server:pull" 2>/dev/null | python3 -c 'import sys,json;print(json.load(sys.stdin).get("token",""))' 2>/dev/null || true)
code=$(curl -s -o /dev/null -w '%{http_code}' -H "Authorization: Bearer $anon" \
	-H 'Accept: application/vnd.oci.image.index.v1+json, application/vnd.docker.distribution.manifest.list.v2+json' \
	"https://ghcr.io/v2/khylo-org/khylo-server/manifests/${version}" || true)
if [ "$code" = "200" ]; then
	echo "Done: anyone can now run: docker pull $image:${version}"
else
	echo
	echo "The image is on GitHub but is NOT public yet (the registry answered $code to an anonymous pull)."
	echo "Make it public once: https://github.com/users/$account/packages/container/khylo-server/settings > Danger zone > Change visibility > Public."
	exit 3
fi
