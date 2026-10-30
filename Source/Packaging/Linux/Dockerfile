# Builds the Khylo Server Linux packages (.deb and .tar.gz) for one CPU type.
# Run Source/Packaging/Linux/build.sh from the hub folder instead of calling this directly.

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
ARG TARGETARCH
ARG KHYLO_BUILD
WORKDIR /src
COPY Source/Server/ ./
RUN if [ "$KHYLO_BUILD" != "DEV" ]; then \
        sed -i -E "s/AssemblyMetadata\(\"KhyloBuild\", \"[^\"]*\"\)/AssemblyMetadata(\"KhyloBuild\", \"$KHYLO_BUILD\")/" SharedVersion.cs; \
    fi
RUN case "$TARGETARCH" in \
        amd64) rid=linux-x64 ;; \
        arm64) rid=linux-arm64 ;; \
        *) echo "Unsupported architecture: $TARGETARCH" && exit 1 ;; \
    esac \
    && dotnet publish Khylo.Server/Khylo.Server.csproj -c Release -r "$rid" --self-contained \
        -p:DebugType=none -p:DebugSymbols=false -o /out

# ---- Packages --------------------------------------------------------------------------------
FROM --platform=$BUILDPLATFORM debian:trixie-slim AS pack
ARG TARGETARCH
ARG KHYLO_BUILD
ARG FFMPEG_VERSION=8.1.3-1
RUN apt-get update && apt-get install -y --no-install-recommends dpkg-dev curl ca-certificates xz-utils tar gzip \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /pkg
RUN mkdir -p root/opt/khylo root/usr/lib/khylo root/usr/lib/systemd/system root/etc/khylo
COPY --from=server /out/ root/opt/khylo/
COPY --from=web /src/dist/ root/opt/khylo/web/

# ffmpeg tuned for media servers (hardware encoders, HDR tone mapping), self-contained
RUN case "$TARGETARCH" in amd64) arch=linux64 ;; arm64) arch=linuxarm64 ;; esac \
    && mkdir -p /tmp/ff \
    && curl -fsSL "https://github.com/jellyfin/jellyfin-ffmpeg/releases/download/v${FFMPEG_VERSION}/jellyfin-ffmpeg_${FFMPEG_VERSION}_portable_${arch}-gpl.tar.xz" \
        | tar -xJ -C /tmp/ff \
    && find /tmp/ff -type f \( -name ffmpeg -o -name ffprobe \) -exec mv {} root/usr/lib/khylo/ \; \
    && rm -rf /tmp/ff

COPY Source/Packaging/Linux/files/khylo.service root/usr/lib/systemd/system/khylo.service
COPY Source/Packaging/Linux/files/khylo.env root/etc/khylo/khylo.env
COPY Source/Packaging/Linux/files/configure.sh root/usr/lib/khylo/configure.sh
COPY Source/Packaging/Shared/khylo-mount root/usr/lib/khylo/khylo-mount
COPY Source/Packaging/Linux/files/postinst Source/Packaging/Linux/files/prerm Source/Packaging/Linux/files/postrm /scripts/
COPY Source/Packaging/Linux/files/install.sh /tarball/install.sh

RUN chmod 0755 root/opt/khylo/khylo root/usr/lib/khylo/* /scripts/* /tarball/install.sh \
    && chmod 0644 root/usr/lib/systemd/system/khylo.service root/etc/khylo/khylo.env \
    && sed -i 's/\r$//' root/usr/lib/khylo/configure.sh root/usr/lib/khylo/khylo-mount /scripts/* /tarball/install.sh \
       root/usr/lib/systemd/system/khylo.service root/etc/khylo/khylo.env

RUN set -e; \
    version=$(echo "${KHYLO_BUILD}" | sed -E 's/^DEV-V//; s/^DEV$/0.0.0/'); \
    mkdir -p /out deb/DEBIAN; \
    cp -a root/. deb/; \
    cp /scripts/postinst /scripts/prerm /scripts/postrm deb/DEBIAN/; \
    echo /etc/khylo/khylo.env > deb/DEBIAN/conffiles; \
    size=$(du -sk deb | cut -f1); \
    printf '%s\n' \
      "Package: khylo-server" \
      "Version: ${version}" \
      "Architecture: ${TARGETARCH}" \
      "Maintainer: Khylo <noreply@khylo.invalid>" \
      "Installed-Size: ${size}" \
      "Depends: ca-certificates, curl, sudo, cifs-utils, nfs-common, libfontconfig1, libicu76 | libicu74 | libicu72 | libicu70 | libicu67 | libicu66" \
      "Recommends: libjemalloc2, mesa-va-drivers" \
      "Section: video" \
      "Priority: optional" \
      "Homepage: https://github.com/khylo-org/khylo" \
      "Description: Khylo Server, your own media server" \
      " Movies, shows, music, books, Khylo TV and Live TV from your own library," \
      " with the web app and hardware transcoding built in." \
      > deb/DEBIAN/control; \
    dpkg-deb --root-owner-group --build deb "/out/khylo-server_${version}_${TARGETARCH}.deb"; \
    mkdir -p "khylo-server-${version}-linux-${TARGETARCH}"; \
    cp -a root "khylo-server-${version}-linux-${TARGETARCH}/root"; \
    cp /tarball/install.sh "khylo-server-${version}-linux-${TARGETARCH}/install.sh"; \
    tar -czf "/out/khylo-server-${version}-linux-${TARGETARCH}.tar.gz" --owner=0 --group=0 "khylo-server-${version}-linux-${TARGETARCH}"

FROM scratch AS out
COPY --from=pack /out/ /
