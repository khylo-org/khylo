# Khylo Server in Docker

One container holds everything: the Khylo server, the web app, and a video converter (ffmpeg) tuned for hardware
conversion on Intel, AMD and NVIDIA graphics. It runs as an ordinary user inside the container, not as root, and
supports Intel/AMD (`amd64`) and ARM (`arm64`) hosts.

Good for: Synology (Container Manager), Unraid, TrueNAS, QNAP, Portainer, a home server, or any Windows, Mac or Linux
machine with Docker.

## Before you start

1. Install Docker: Docker Desktop on Windows or Mac, Docker Engine on Linux, or your NAS's Docker app.
2. Know where your media is. Local folders are given to the container as volumes (below). Media on a NAS is easiest to
   add from inside Khylo as a [network share](network-drives.md).
3. Make a folder for Khylo, for example `khylo/`. It will hold the compose file and two folders Khylo creates.

## Get the image

**From a file** (a release download):

```bash
docker load -i khylo-server-docker-<version>-amd64.tar    # or -arm64.tar for ARM
```

This adds the image `khylo/server:<version>` (and `khylo/server:latest`). Use the file that matches your processor.
Not sure? On Linux run `uname -m`: `x86_64` is amd64, `aarch64` is arm64.

**Or build it yourself**, from the Khylo project folder:

```bash
docker build -f Source/Packaging/Docker/Dockerfile -t khylo/server:latest .
```

## Run it with Docker Compose (recommended)

Save this as `docker-compose.yml` in your Khylo folder and edit the media line:

```yaml
services:
  khylo:
    image: khylo/server:latest
    container_name: khylo
    restart: unless-stopped
    ports:
      - "8096:8096"        # web app and apps
      - "7360:7360/udp"    # apps finding the server (see "Finding the server" below)
    environment:
      - TZ=America/Chicago        # your time zone, for example Europe/London
    # Needed only to add SMB/NFS network shares from inside Khylo. See "Network drives".
    cap_add:
      - SYS_ADMIN
      - DAC_READ_SEARCH
    security_opt:
      - apparmor:unconfined
    volumes:
      - ./khylo-config:/config       # your library, users and settings (back this up)
      - ./khylo-cache:/cache         # artwork and temporary files (safe to delete)
      - /path/to/movies:/media/movies:ro   # one line per media folder; ":ro" keeps your files safe
      - /path/to/shows:/media/shows:ro
```

Then:

```bash
docker compose up -d
```

Open `http://<this machine's address>:8096` and follow the [first-time setup](first-setup.md). When it asks for media
folders, choose the paths *inside* the container (for example `/media/movies`).

## Run it with plain `docker run`

```bash
docker run -d --name khylo --restart unless-stopped \
  -p 8096:8096 -p 7360:7360/udp \
  -e TZ=America/Chicago \
  --cap-add SYS_ADMIN --cap-add DAC_READ_SEARCH --security-opt apparmor:unconfined \
  -v /path/to/khylo-config:/config \
  -v /path/to/khylo-cache:/cache \
  -v /path/to/movies:/media/movies:ro \
  khylo/server:latest
```

(In PowerShell, put each option on one line or end lines with a backtick instead of a backslash.)

## What lives where

| Inside the container | What it is | On your machine |
| --- | --- | --- |
| `/config` | Library database, users, settings, logs, network-share logins | Keep it. Back it up. |
| `/cache` | Artwork, temporary conversions | Safe to delete |
| `/media/...` | Your media | Your own folders, read-only |
| `/shares` | Where Khylo connects network shares | Managed by Khylo |

If you use a folder instead of a Docker volume for `/config`, Khylo fixes its ownership the first time it starts.
To run as a different user, add `user: "UID:GID"` to the compose file and make sure that user owns `/config` and `/cache`.

## Network drives

Khylo connects SMB (Windows) and NFS shares itself: when you add a library, choose **Network share**. This needs the
three settings shown above (`SYS_ADMIN`, `DAC_READ_SEARCH`, `apparmor:unconfined`). They only allow Khylo's small mount
helper to connect shares; Khylo itself runs without extra power. If you never use network shares, delete those lines
and the container runs with no extra privileges. See [network drives](network-drives.md).

## Hardware transcoding

- **Intel or AMD graphics on Linux:** pass the device and the groups that may use it:

  ```yaml
  devices:
    - /dev/dri:/dev/dri
  group_add:
    - video
    - render
  ```
- **NVIDIA graphics:** install the NVIDIA Container Toolkit on the host, then add

  ```yaml
  deploy:
    resources:
      reservations:
        devices:
          - driver: nvidia
            count: all
            capabilities: [gpu]
  ```
- **Docker Desktop on Windows or Mac** cannot reach the graphics card. Khylo still works, but converts on the processor.
  For heavy conversion on those systems, use the native [Windows](windows.md) or [Mac](mac.md) install instead.

Details: [hardware transcoding](hardware-transcoding.md).

## Finding the server (apps on your network)

Khylo apps look for servers with a short broadcast on UDP port 7360. Docker's default network hides the container from
broadcasts, so either:

- run the container on the host network (Linux only): replace `ports:` with `network_mode: host`; or
- type the server's address (`http://<host address>:8096`) into the app once. It remembers it.

## Updating

```bash
docker load -i khylo-server-docker-<newversion>-amd64.tar
docker compose up -d
```

(`up -d` recreates the container on the new image.) Your library and settings in `./khylo-config` are untouched. If you
use the same image name each time (`khylo/server:latest`), nothing in the compose file changes.

## Useful commands

```bash
docker logs -f khylo                 # live log
docker compose restart khylo         # restart
docker compose stop                  # stop
docker compose down                  # remove the container (data stays in ./khylo-config)
curl http://localhost:8096/health    # prints "Healthy" when it is ready
```

The image also has a built-in health check, so `docker ps` shows `healthy` once Khylo is ready (the first start can take a
minute or two while it sets up its database).

## Removing it

```bash
docker compose down
docker rmi khylo/server:latest
```

Delete `./khylo-config` and `./khylo-cache` yourself if you want the library and settings gone too.

## Troubleshooting

See [troubleshooting](troubleshooting.md). Docker-specific: a message saying Khylo "needs permission to connect network
shares" means the three settings above are missing from your container; a library folder that looks empty usually means
the path you chose isn't the one *inside* the container.
