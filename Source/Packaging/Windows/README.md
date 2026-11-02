# Khylo Server on Windows

**Full guide: [Install/windows.md](../../../Install/windows.md)**

Quick start, from an Administrator PowerShell in the unzipped download:

```powershell
powershell -ExecutionPolicy Bypass -File .\Install-Khylo.ps1
```

Khylo starts with the PC and is at `http://localhost:8096`. Data is in `C:\ProgramData\Khylo`.

## In this folder

- `build.sh`, `Dockerfile`: build the download (x64 and ARM) with Docker.
- `files/`: the installer, uninstaller, start script and readme that go into the download.
- `builds/`: where the downloads land (never committed).
- `start-server.sh`, `khylo_server/`: running the server from source on a developer PC (data never committed).

## Building

```bash
Source/Packaging/Windows/build.sh                      # both CPU types, build number from the changelog
Source/Packaging/Windows/build.sh DEV-V26.11.02.01 x64
```

## Running from source (developers)

```bash
dotnet build Source/Server/Khylo.Server/Khylo.Server.csproj -c Release
Source/Packaging/Windows/start-server.sh
```
