#!/usr/bin/env bash
# Runs the Khylo server on this Windows PC for development, on port 8098, with its data in ./khylo_server.
# Stop any running copy first (the build locks its files). Needs a Release build:
#   dotnet build Source/Server/Khylo.Server/Khylo.Server.csproj -c Release
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"
hub="$(cd "$here/../../.." && pwd)"
export KHYLO_LOG_DIR="$here/khylo_server/log"
exec dotnet "$hub/Source/Server/Khylo.Server/bin/Release/net10.0/khylo.dll" --nowebclient \
	--datadir "$here/khylo_server/data" --configdir "$here/khylo_server/config" \
	--cachedir "$here/khylo_server/cache" --logdir "$here/khylo_server/log"
