# Builds the Khylo Server downloads for Windows for one CPU type: the installer (.exe) and a portable .zip.
# Run Source/Packaging/Windows/build.sh from the hub folder instead of calling this directly.

ARG KHYLO_BUILD=DEV

# ---- Web app ---------------------------------------------------------------------------------
FROM --platform=$BUILDPLATFORM node:24-bookworm-slim AS web
WORKDIR /src
COPY Source/Web/package.json Source/Web/package-lock.json ./
RUN npm ci --no-audit --no-fund --ignore-scripts
COPY Source/Web/ ./
RUN npm run build:production

# ---- Server ----------------------------------------------------------------------------------
FROM --platform=$BUILDPLATFORM mcr.microsoft.com/dotnet/sdk:10.0 AS server
ARG RID=win-x64
ARG KHYLO_BUILD
WORKDIR /src
COPY Source/Server/ ./
RUN if [ "$KHYLO_BUILD" != "DEV" ]; then \
        sed -i -E "s/AssemblyMetadata\(\"KhyloBuild\", \"[^\"]*\"\)/AssemblyMetadata(\"KhyloBuild\", \"$KHYLO_BUILD\")/" SharedVersion.cs; \
        asm=$(echo "$KHYLO_BUILD" | sed -E 's/^DEV-V0*([0-9]+)\.0*([0-9]+)\.0*([0-9]+)\.0*([0-9]+)$/\1.\2.\3.\4/'); \
        sed -i -E "s/AssemblyVersion\(\"[^\"]*\"\)/AssemblyVersion(\"$asm\")/; s/AssemblyFileVersion\(\"[^\"]*\"\)/AssemblyFileVersion(\"$asm\")/" SharedVersion.cs; \
    fi
RUN dotnet publish Khylo.Server/Khylo.Server.csproj -c Release -r "$RID" --self-contained \
        -p:DebugType=none -p:DebugSymbols=false -o /out

# ---- The download ----------------------------------------------------------------------------
FROM --platform=$BUILDPLATFORM debian:trixie-slim AS pack
ARG RID=win-x64
ARG KHYLO_BUILD
ARG FFMPEG_VERSION=8.1.3-1
RUN apt-get update && apt-get install -y --no-install-recommends zip unzip curl ca-certificates nsis \
    && rm -rf /var/lib/apt/lists/*
WORKDIR /pkg
RUN mkdir -p Khylo/ffmpeg
COPY --from=server /out/ Khylo/
COPY --from=web /src/dist/ Khylo/web/
RUN case "$RID" in win-x64) f=win64 ;; win-arm64) f=winarm64 ;; esac \
    && curl -fsSL -o /tmp/ff.zip "https://github.com/jellyfin/jellyfin-ffmpeg/releases/download/v${FFMPEG_VERSION}/jellyfin-ffmpeg_${FFMPEG_VERSION}_portable_${f}-clang-gpl.zip" \
    && mkdir /tmp/ff && unzip -q /tmp/ff.zip -d /tmp/ff \
    && find /tmp/ff -type f \( -iname ffmpeg.exe -o -iname ffprobe.exe \) -exec mv {} Khylo/ffmpeg/ \; \
    && test -f Khylo/ffmpeg/ffmpeg.exe && rm -rf /tmp/ff /tmp/ff.zip
COPY Source/Packaging/Windows/files/khylo-setup.nsi Source/Packaging/Windows/files/khylo.ico ./
COPY LICENSE ./LICENSE
COPY Source/Packaging/Windows/files/Start-Khylo.bat ./
COPY Source/Packaging/Windows/files/README.txt ./README.txt
RUN set -e; \
    version=$(echo "${KHYLO_BUILD}" | sed -E 's/^DEV-V//; s/^DEV$/0.0.0/'); \
    viversion=$(echo "$version" | sed -E 's/\.0+([0-9])/.\1/g'); \
    while [ "$(echo "$viversion" | tr -cd . | wc -c)" -lt 3 ]; do viversion="$viversion.0"; done; \
    arch=$(echo "$RID" | sed 's/win-//'); \
    mkdir -p /out; \
    makensis -V2 -DBUILD="${KHYLO_BUILD}" -DVERSION="$version" -DVIVERSION="$viversion" -DARCH="$arch" \
        -DOUTFILE="/out/khylo-server-${version}-windows-${arch}-setup.exe" khylo-setup.nsi; \
    zip -q -r "/out/khylo-server-${version}-windows-${arch}-portable.zip" Khylo Start-Khylo.bat README.txt

FROM scratch AS out
COPY --from=pack /out/ /
