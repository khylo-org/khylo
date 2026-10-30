# Khylo Server: the server, the web app and a tuned ffmpeg with hardware transcoding, in one image.
#
# Build from the hub folder (it needs both Source/Server and Source/Web):
#   docker build -f Source/Packaging/Docker/Dockerfile -t khylo/server:dev .
# Run it with Source/Packaging/Docker/docker-compose.yml.

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
# The build number the dashboard shows
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

# ---- Runtime ---------------------------------------------------------------------------------
FROM debian:trixie-slim
ARG TARGETARCH
ARG KHYLO_BUILD
ARG FFMPEG_VERSION=8.1.3-1
ARG INTEL_CR_VERSION=26.35.39758.10
ARG INTEL_IGC_VERSION=2.41.5
ARG INTEL_IGC_BUILD=22716
ARG INTEL_GMM_VERSION=22.10.0

# Video drivers for hardware transcoding: Intel (Quick Sync, VA-API, OpenCL tone mapping) on x86,
# AMD and others through Mesa. NVIDIA's libraries come from the host via the NVIDIA Container Toolkit.
RUN sed -i 's/^Components: main$/Components: main contrib non-free non-free-firmware/' /etc/apt/sources.list.d/debian.sources \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates curl xz-utils tzdata locales \
        libicu76 libfontconfig1 fonts-dejavu-core libjemalloc2 \
        mesa-va-drivers libva2 libva-drm2 \
        cifs-utils keyutils nfs-common sudo \
    && if [ "$TARGETARCH" = "amd64" ]; then \
        apt-get install -y --no-install-recommends \
            intel-media-va-driver-non-free libvpl2 libmfx-gen1.2 ocl-icd-libopencl1 \
        # Intel's OpenCL runtime (HDR tone mapping) isn't in Debian; it comes from Intel's own releases
        && mkdir /tmp/intel && cd /tmp/intel \
        && curl -fsSLO "https://github.com/intel/intel-graphics-compiler/releases/download/v${INTEL_IGC_VERSION}/intel-igc-core-2_${INTEL_IGC_VERSION}%2B${INTEL_IGC_BUILD}_amd64.deb" \
        && curl -fsSLO "https://github.com/intel/intel-graphics-compiler/releases/download/v${INTEL_IGC_VERSION}/intel-igc-opencl-2_${INTEL_IGC_VERSION}%2B${INTEL_IGC_BUILD}_amd64.deb" \
        && curl -fsSLO "https://github.com/intel/compute-runtime/releases/download/${INTEL_CR_VERSION}/intel-opencl-icd_${INTEL_CR_VERSION}-0_amd64.deb" \
        && curl -fsSLO "https://github.com/intel/compute-runtime/releases/download/${INTEL_CR_VERSION}/libigdgmm12_${INTEL_GMM_VERSION}_amd64.deb" \
        && apt-get install -y --no-install-recommends ./*.deb \
        && cd / && rm -rf /tmp/intel; \
    fi \
    && sed -i 's/^# *en_US.UTF-8/en_US.UTF-8/' /etc/locale.gen && locale-gen \
    && rm -rf /var/lib/apt/lists/*

# ffmpeg tuned for media servers (hardware encoders, HDR tone mapping), self-contained
RUN case "$TARGETARCH" in amd64) arch=linux64 ;; arm64) arch=linuxarm64 ;; esac \
    && mkdir -p /tmp/ff /usr/lib/khylo-ffmpeg \
    && curl -fsSL "https://github.com/jellyfin/jellyfin-ffmpeg/releases/download/v${FFMPEG_VERSION}/jellyfin-ffmpeg_${FFMPEG_VERSION}_portable_${arch}-gpl.tar.xz" \
        | tar -xJ -C /tmp/ff \
    && find /tmp/ff -type f \( -name ffmpeg -o -name ffprobe \) -exec mv {} /usr/lib/khylo-ffmpeg/ \; \
    && rm -rf /tmp/ff \
    && ln -s /usr/lib/khylo-ffmpeg/ffmpeg /usr/local/bin/ffmpeg \
    && ln -s /usr/lib/khylo-ffmpeg/ffprobe /usr/local/bin/ffprobe \
    && ffmpeg -hide_banner -version | head -1

COPY --from=server /out /khylo
COPY --from=web /src/dist /khylo/web

# Khylo runs as an ordinary user, not root. Mounting network shares needs more power than that, so Khylo asks a
# small program (Source/Packaging/Shared/khylo-mount) that only accepts SMB and NFS shares under /shares.
RUN groupadd --system --gid 10001 khylo \
    && useradd --system --uid 10001 --gid khylo --home-dir /config --shell /usr/sbin/nologin khylo \
    && mkdir -p /config /cache /shares \
    && chown khylo:khylo /config /cache /shares
COPY Source/Packaging/Docker/entrypoint.sh /khylo/entrypoint.sh
COPY Source/Packaging/Shared/khylo-mount /usr/local/bin/khylo-mount
RUN chmod 0755 /khylo/entrypoint.sh /usr/local/bin/khylo-mount \
    && chown root:root /usr/local/bin/khylo-mount \
    && echo 'khylo ALL=(root) NOPASSWD: /usr/local/bin/khylo-mount' > /etc/sudoers.d/khylo \
    && chmod 0440 /etc/sudoers.d/khylo

ENV KHYLO_DATA_DIR=/config \
    KHYLO_CONFIG_DIR=/config/config \
    KHYLO_CACHE_DIR=/cache \
    KHYLO_LOG_DIR=/config/log \
    KHYLO_WEB_DIR=/khylo/web \
    KHYLO_SHARES_DIR=/shares \
    LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    XDG_CACHE_HOME=/cache \
    MALLOC_TRIM_THRESHOLD_=131072 \
    NVIDIA_VISIBLE_DEVICES=all \
    NVIDIA_DRIVER_CAPABILITIES=compute,video,utility

LABEL org.opencontainers.image.title="Khylo Server" \
      org.opencontainers.image.description="Your own media server: movies, shows, music, Khylo TV and Live TV" \
      org.opencontainers.image.version="${KHYLO_BUILD}" \
      org.opencontainers.image.licenses="GPL-2.0-only"

EXPOSE 8096
EXPOSE 7360/udp
VOLUME ["/config", "/cache"]
HEALTHCHECK --interval=30s --timeout=10s --start-period=90s --retries=3 \
    CMD curl -fsS http://localhost:8096/health || exit 1

ENTRYPOINT ["/khylo/entrypoint.sh", "--ffmpeg", "/usr/lib/khylo-ffmpeg/ffmpeg"]
