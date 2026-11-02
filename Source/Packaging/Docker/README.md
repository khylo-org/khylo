# Khylo Server in Docker

**Full guide: [Install/docker.md](../../../Install/docker.md)**

Quick start:

```bash
docker load -i khylo-server-docker-<version>-amd64.tar     # or -arm64.tar
docker compose up -d                                       # with docker-compose.yml from this folder
```

Then open `http://<this machine>:8096` and follow the [first-time setup](../../../Install/first-setup.md).

## In this folder

- `docker-compose.yml`: the compose file (edit the media volume lines).
- `Dockerfile`, `Dockerfile.dockerignore`, `entrypoint.sh`: how the image is built and started.
- `build.sh`: builds the image for `amd64` and `arm64` and saves each as a `.tar` in `builds/` (never committed).
- `../Shared/khylo-mount`: the small helper that connects SMB and NFS shares.

## Building

```bash
Source/Packaging/Docker/build.sh                       # both CPU types, build number from the changelog
Source/Packaging/Docker/build.sh DEV-V26.11.02.01 amd64
```
