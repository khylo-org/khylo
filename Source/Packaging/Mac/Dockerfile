# Builds the Khylo Server download for macOS (a .tar.gz with an installer script) for one CPU type.
# Run Source/Packaging/Mac/build.sh from the hub folder instead of calling this directly.

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
ARG RID=osx-arm64
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
ARG RID=osx-arm64
ARG KHYLO_BUILD
ARG FFMPEG_VERSION=8.1.3-1
RUN apt-get update && apt-get install -y --no-install-recommends curl ca-certificates xz-utils tar gzip \
    && rm -rf /var/lib/apt/lists/*
WORKDIR /pkg
RUN mkdir -p khylo/ffmpeg
COPY --from=server /out/ khylo/
COPY --from=web /src/dist/ khylo/web/
RUN case "$RID" in osx-x64) f=mac64 ;; osx-arm64) f=macarm64 ;; esac \
    && mkdir /tmp/ff \
    && curl -fsSL "https://github.com/jellyfin/jellyfin-ffmpeg/releases/download/v${FFMPEG_VERSION}/jellyfin-ffmpeg_${FFMPEG_VERSION}_portable_${f}-gpl.tar.xz" | tar -xJ -C /tmp/ff \
    && find /tmp/ff -type f \( -name ffmpeg -o -name ffprobe \) -exec mv {} khylo/ffmpeg/ \; \
    && test -f khylo/ffmpeg/ffmpeg && rm -rf /tmp/ff
COPY Source/Packaging/Mac/files/install.sh Source/Packaging/Mac/files/uninstall.sh Source/Packaging/Mac/files/README.txt ./
RUN chmod 0755 khylo/khylo khylo/ffmpeg/ffmpeg khylo/ffmpeg/ffprobe install.sh uninstall.sh \
    && sed -i 's/\r$//' install.sh uninstall.sh README.txt
RUN set -e; \
    version=$(echo "${KHYLO_BUILD}" | sed -E 's/^DEV-V//; s/^DEV$/0.0.0/'); \
    arch=$(echo "$RID" | sed 's/osx-//'); \
    name="khylo-server-${version}-macos-${arch}"; \
    mkdir -p "/out" "$name"; \
    cp -a khylo install.sh uninstall.sh README.txt "$name/"; \
    tar -czf "/out/${name}.tar.gz" --owner=0 --group=0 "$name"

FROM scratch AS out
COPY --from=pack /out/ /
