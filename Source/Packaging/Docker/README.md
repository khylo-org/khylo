# Khylo Server in Docker

**Full guide: [Install/docker.md](../../../Install/docker.md)**

Quick start:

```bash
docker pull ghcr.io/khylo-org/khylo-server:latest          # hosted on GitHub; one name for amd64 and arm64
docker compose up -d                                       # with docker-compose.yml from this folder
```

Update later with `docker compose pull` and `docker compose up -d`. No access to GitHub? Load a release download instead:
`docker load -i khylo-server-docker-<version>-amd64.tar` (or `-arm64.tar`), which gives the image `khylo/server:latest`.

Then open `http://<this machine>:8096` and follow the [first-time setup](../../../Install/first-setup.md).

## In this folder

- `docker-compose.yml`: the compose file (edit the media volume lines). It gives the container no extra privileges.
- `docker-compose.shares.yml`: add this file only if you want Khylo to connect network shares (SMB/NFS); it grants the permissions that needs.
- `Dockerfile`, `Dockerfile.dockerignore`, `entrypoint.sh`: how the image is built and started.
- `build.sh`: builds the image for `amd64` and `arm64` and saves each as a `.tar` in `builds/` (never committed).
- `push-images.sh`: publishes those images to GitHub (`ghcr.io/khylo-org/khylo-server`) as one multi-arch image. `Source/Packaging/publish-release.sh` runs it.
- `../Shared/khylo-mount`: the small helper that connects SMB and NFS shares.

## Building

```bash
Source/Packaging/Docker/build.sh                       # both CPU types, build number from the changelog
Source/Packaging/Docker/build.sh DEV-V26.11.02.01 amd64
```
