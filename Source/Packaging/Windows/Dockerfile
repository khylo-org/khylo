# Builds the Khylo Server download for Windows (a .zip with an installer script) for one CPU type.
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
    fi
RUN dotnet publish Khylo.Server/Khylo.Server.csproj -c Release -r "$RID" --self-contained \
        -p:DebugType=none -p:DebugSymbols=false -o /out

# ---- The download ----------------------------------------------------------------------------
FROM --platform=$BUILDPLATFORM debian:trixie-slim AS pack
ARG RID=win-x64
ARG KHYLO_BUILD
ARG FFMPEG_VERSION=8.1.3-1
RUN apt-get update && apt-get install -y --no-install-recommends zip unzip curl ca-certificates \
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
COPY Source/Packaging/Windows/files/Install-Khylo.ps1 Source/Packaging/Windows/files/Uninstall-Khylo.ps1 Source/Packaging/Windows/files/Start-Khylo.bat ./
COPY Source/Packaging/Windows/files/README.txt ./README.txt
RUN set -e; \
    version=$(echo "${KHYLO_BUILD}" | sed -E 's/^DEV-V//; s/^DEV$/0.0.0/'); \
    arch=$(echo "$RID" | sed 's/win-//'); \
    mkdir -p /out; \
    zip -q -r "/out/khylo-server-${version}-windows-${arch}.zip" Khylo Install-Khylo.ps1 Uninstall-Khylo.ps1 Start-Khylo.bat README.txt

FROM scratch AS out
COPY --from=pack /out/ /
