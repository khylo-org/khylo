#!/usr/bin/env bash
# Builds the Khylo Server Docker image for Intel/AMD (amd64) and ARM (arm64), and saves each as a file you can load
# on any machine with Docker:
#   Source/Packaging/Docker/builds/khylo-server-docker-<version>-<arch>.tar     (docker load -i <file>)
# Loading a file gives khylo/server:<version> and khylo/server:latest for that CPU type.
#
#   Source/Packaging/Docker/build.sh                       build number from the top of CHANGELOG.md
#   Source/Packaging/Docker/build.sh DEV-V26.11.02.01        a specific build number
#   Source/Packaging/Docker/build.sh DEV-V26.11.02.01 amd64  just one CPU type
set -euo pipefail
cd "$(dirname "$0")/../../.."

build=${1:-$(grep -m1 -oE 'DEV-V[0-9]{2}\.[0-9]{2}\.[0-9]{2}\.[0-9]{2}' CHANGELOG.md)}
version=${build#DEV-V}
archs=${2:-"amd64 arm64"}
out=Source/Packaging/Docker/builds
mkdir -p "$out"

for arch in $archs; do
	echo "== Building $build for $arch"
	docker buildx build --platform "linux/$arch" --build-arg "KHYLO_BUILD=$build" 		--load -t "khylo/server:${version}-${arch}" -f Source/Packaging/Docker/Dockerfile .
	# Each saved file carries the plain names (khylo/server:<version> and :latest), so loading it on a machine of that
	# CPU type gives exactly what the compose file asks for
	docker tag "khylo/server:${version}-${arch}" "khylo/server:${version}"
	docker tag "khylo/server:${version}-${arch}" khylo/server:latest
	docker save -o "$out/khylo-server-docker-${version}-${arch}.tar" "khylo/server:${version}" khylo/server:latest
done
# Leave this computer's own type as the default tags
case "$(uname -m)" in aarch64|arm64) mine=arm64 ;; *) mine=amd64 ;; esac
if docker image inspect "khylo/server:${version}-${mine}" >/dev/null 2>&1; then
	docker tag "khylo/server:${version}-${mine}" "khylo/server:${version}"
	docker tag "khylo/server:${version}-${mine}" khylo/server:latest
fi
ls -la "$out"
