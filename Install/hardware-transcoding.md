# Hardware transcoding

Khylo plays most files **directly**. When a screen can't play a file (an unsupported video format, subtitles that have to be
burned in, or you choose a lower quality), the server **transcodes**: it converts the video as it streams. Doing that on the
processor is slow and uses a lot of power. A graphics chip can do it much faster and cooler. This page shows how to turn that
on for each install.

Khylo's setup checks what your computer has (look for **Playback** in setup, or **Playback > Transcoding** in the dashboard), and Khylo's
video converter (ffmpeg) is bundled with every download and built for hardware conversion on Intel, AMD, NVIDIA and Apple chips.

## What you can use

| Graphics | What it gives you |
| --- | --- |
| **Intel** (Quick Sync: most Intel processors with built-in graphics) | The best value: fast, cool, low power. Also supports HDR-to-SDR tone mapping. |
| **NVIDIA** (NVENC) | Very fast conversion on a graphics card. Works on Windows, Linux and Docker. |
| **AMD** (VA-API on Linux, AMF on Windows) | Works on Radeon graphics. |
| **Apple** (VideoToolbox) | Apple silicon and Intel Macs. |
| None | Khylo works, converting on the processor. Fine for a few streams that rarely need conversion. |

## By install

### Windows

Install your graphics card's current driver from Intel, NVIDIA or AMD. Khylo's converter uses Quick Sync, NVENC or AMF
automatically when the driver is present. Then check **Playback > Transcoding** in the dashboard.

### Mac

Nothing to install. Check **Playback > Transcoding** in the dashboard to confirm hardware conversion is on.

### Linux (the `.deb` or `.tar.gz`)

1. Check that the device exists: `ls /dev/dri` should show `renderD128` (Intel and AMD).
2. The installer already adds the `khylo` user to the `video` and `render` groups. If you installed a long time ago or added
   the groups later, run `sudo usermod -aG video,render khylo && sudo systemctl restart khylo`.
3. Install the video driver for your chip:
   - Intel on Debian/Ubuntu: `sudo apt install intel-media-va-driver-non-free vainfo` (needs the `non-free` repository; on
     Debian add `non-free non-free-firmware` to your apt sources first).
   - AMD on Debian/Ubuntu: `sudo apt install mesa-va-drivers vainfo`.
   - Fedora and Arch: install your distribution's `intel-media-driver` or `mesa` VA-API packages.
   - NVIDIA: install NVIDIA's driver.
4. Run `vainfo` to see what the chip supports, restart Khylo, and check **Playback > Transcoding** in the dashboard.

### Docker

On a Linux host, pass the graphics device and its groups to the container (add to your compose file):

```yaml
devices:
  - /dev/dri:/dev/dri
group_add:
  - video
  - render
```

If conversion still fails, your host may use different group numbers for those groups; give the numbers instead
(`group_add: ["44", "105"]`; find them with `getent group video render`).

For NVIDIA, install the NVIDIA Container Toolkit on the host and add the `deploy:` block shown in the
[Docker guide](docker.md). The `amd64` image includes Intel's driver and OpenCL runtime for tone mapping.

Docker Desktop on Windows and Mac cannot reach the graphics card. For hardware conversion there, use the native
[Windows](windows.md) or [Mac](mac.md) install.

### Proxmox

Create the container with `--gpu`: it passes the host's `/dev/dri/renderD128` into the container and installs the Intel and
AMD drivers there (Proxmox VE 8.1 or newer). For NVIDIA on Proxmox, pass the card through with Proxmox's own device
passthrough and install NVIDIA's driver in the container.

## Turn it on in Khylo

In the dashboard, open **Playback > Transcoding**. Choose the hardware type that matches your chip and tick the formats it can handle.
Khylo's setup does this for you when it detects your hardware. Then play something that needs conversion (for example, choose a
lower quality on a TV) and look at **Activity** in the dashboard: a conversion using hardware shows it in its details.

## If it doesn't work

- Turn hardware conversion **off** in **Playback > Transcoding** and try again. If that works, the problem is the driver or device access.
- Read the newest log (see [troubleshooting](troubleshooting.md)); Khylo logs the converter's error when a conversion fails.
- Intel: very old chips have limited format support. Without a supported chip, Khylo falls back to the processor.
- Mixed or old drivers cause most problems: update the graphics driver first.
