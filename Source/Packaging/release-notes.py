#!/usr/bin/env python3
"""Writes the text for a release page on GitHub: a centered row of download buttons at the very top (the usual systems
first, then Arm, Proxmox and Docker), a few notes, then what's new (taken from CHANGELOG.md).

    Source/Packaging/release-notes.py DEV-V26.11.02.02 > notes.md

Normally you don't run this yourself: Source/Packaging/publish-release.sh uploads the downloads and runs this, so the page always
matches the files. Run from the repository root. iOS and Android entries are left out: the public project is the server only.
"""
import re
import sys

# Windows would otherwise write the dashes in the changelog in its own encoding
sys.stdout.reconfigure(encoding='utf-8')

build = sys.argv[1] if len(sys.argv) > 1 else None
if not build or not re.fullmatch(r'DEV-V\d{2}\.\d{2}\.\d{2}\.\d{2}', build):
    sys.exit('Usage: Source/Packaging/release-notes.py DEV-V26.11.02.02')

version = build[len('DEV-V'):]
repo = 'khylo-org/khylo'
site = f'https://github.com/{repo}'
download = f'{site}/releases/download/{build}'
guides = f'{site}/blob/main/Install'


def button(message, filename, style='for-the-badge'):
    """A download button: a picture that links straight to the file."""
    text = message.replace('-', '--').replace('_', '__').replace(' ', '%20')
    return (f'<a href="{download}/{filename}"><img alt="Download {message}" '
            f'src="https://img.shields.io/badge/Download-{text}-d97732?style={style}"></a>')


# The buttons people want first, then Arm computers and the rest
main_buttons = '\n'.join([
    button('Windows', f'khylo-server-{version}-windows-x64-setup.exe'),
    button('Mac (Apple silicon)', f'khylo-server-{version}-macos-arm64.tar.gz'),
    button('Mac (Intel)', f'khylo-server-{version}-macos-x64.tar.gz'),
    button('Linux (Ubuntu, Debian)', f'khylo-server_{version}_amd64.deb'),
])
other_buttons = '\n'.join([
    button('Windows (Arm)', f'khylo-server-{version}-windows-arm64-setup.exe', 'flat'),
    button('Linux (Arm)', f'khylo-server_{version}_arm64.deb', 'flat'),
    button('Proxmox', f'khylo-proxmox-{version}.tar.gz', 'flat'),
    button('Docker', f'khylo-server-docker-{version}-amd64.tar', 'flat'),
    button('Docker (Arm)', f'khylo-server-docker-{version}-arm64.tar', 'flat'),
])

# What's new: this build's section of the changelog, server and web entries only
changelog = open('CHANGELOG.md', encoding='utf-8').read()
match = re.search(rf'### Build {re.escape(build)}\r?\n(.*?)(?=\r?\n### Build |\r?\n## |\Z)', changelog, re.S)
whats_new = ''
if match:
    whats_new = '\n'.join(line for line in match.group(1).splitlines()
                          if not line.startswith(('- **iOS', '- **Android —'))).strip()

print(f'''<p align="center">
{main_buttons}
</p>

<p align="center"><sub>Click your system and it starts downloading.<br>Arm computers, Proxmox and Docker:</sub></p>

<p align="center">
{other_buttons}
</p>

<p align="center"><sub>Install guides: <a href="{guides}/windows.md">Windows</a> · <a href="{guides}/mac.md">Mac</a> · <a href="{guides}/linux.md">Linux</a> (also the plain <code>.tar.gz</code> for other Linux) · <a href="{guides}/proxmox.md">Proxmox</a> · <a href="{guides}/docker.md">Docker</a></sub></p>

Not sure whether you have Intel/AMD or Arm? Most Windows PCs and Linux servers are Intel/AMD, and every Mac from late 2020
onward is Arm (Apple silicon). The guides show how to check.

**Everything else on this page is optional:** the `-portable.zip` files (further down) are a Windows version that installs
nothing (just unzip and double-click), and `SHA256SUMS.txt` lets you check that a download wasn't damaged.

**Windows will say it doesn't know the publisher.** The installer isn't signed (signing costs money and Khylo is free). Click
**More info**, then **Run anyway**.

After installing, open `http://<the server's address>:8096` in a browser and follow the
[first-time setup]({guides}/first-setup.md).

## What's new in this build

{whats_new}

Full list: [what's new]({site}/blob/main/CHANGELOG.md).''')
