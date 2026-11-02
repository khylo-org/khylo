# Khylo Server on Windows

**Full guide: [Install/windows.md](../../../Install/windows.md)**

Quick start: download `khylo-server-<version>-windows-x64-setup.exe` (ARM PCs: `arm64`) from the Releases page, double-click
it, and follow the setup. Windows may warn that it doesn't know the publisher (the installer isn't signed yet): click
**More info**, then **Run anyway**. Khylo starts with the PC and is at `http://localhost:8096`. Data is in
`C:\ProgramData\Khylo`.

## In this folder

- `build.sh`, `Dockerfile`: build the downloads (x64 and ARM) with Docker. The installer is made with NSIS inside the build,
  so you do not need Windows to build it.
- `files/khylo-setup.nsi`: the installer's recipe. `files/khylo.ico`: its icon.
- `files/Start-Khylo.bat`, `files/README.txt`: what goes in the portable zip.
- `builds/`: where the downloads land (never committed).
- `start-server.sh`, `khylo_server/`: running the server from source on a developer PC (data never committed).

## Building

```bash
Source/Packaging/Windows/build.sh                      # both CPU types, build number from the changelog
Source/Packaging/Windows/build.sh DEV-V26.11.02.01 x64
```

Output in `builds/`: `khylo-server-<version>-windows-<cpu>-setup.exe` (the installer) and
`khylo-server-<version>-windows-<cpu>-portable.zip` (unzip and run, nothing installed).

## Running from source (developers)

```bash
dotnet build Source/Server/Khylo.Server/Khylo.Server.csproj -c Release
Source/Packaging/Windows/start-server.sh
```
