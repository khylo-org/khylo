#!/usr/bin/env python3
"""Writes the text for a release page on GitHub: one table of download buttons (Intel/AMD and Arm side by side),
a few notes, then what's new (taken from CHANGELOG.md).

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


def button(label, filename):
    """A download button: a picture that links straight to the file. Empty cell if there is no such file."""
    if not filename:
        return '<sub>-</sub>'
    text = label.replace('-', '--').replace(' ', '%20')
    return (f'<a href="{download}/{filename}"><img alt="Download {label}" '
            f'src="https://img.shields.io/badge/Download-{text}-d97732?style=for-the-badge"></a>')


def row(system, note, intel, arm, guide, page):
    note = f'<br><sub>{note}</sub>' if note else ''
    return (f'  <tr>\n    <td><b>{system}</b>{note}</td>\n    <td align="center">{intel}</td>\n    <td align="center">{arm}</td>\n'
            f'    <td><a href="{guides}/{page}">{guide}</a></td>\n  </tr>')


def single(system, note, cell, guide, page):
    return (f'  <tr>\n    <td><b>{system}</b><br><sub>{note}</sub></td>\n    <td align="center" colspan="2">{cell}</td>\n'
            f'    <td><a href="{guides}/{page}">{guide}</a></td>\n  </tr>')


rows = '\n'.join([
    row('Windows 10 or 11', 'the installer', button('.exe', f'khylo-server-{version}-windows-x64-setup.exe'),
        button('.exe', f'khylo-server-{version}-windows-arm64-setup.exe'), 'Windows guide', 'windows.md'),
    row('Mac', 'Intel chip, or Apple silicon (M1 or newer)', button('.tar.gz', f'khylo-server-{version}-macos-x64.tar.gz'),
        button('.tar.gz', f'khylo-server-{version}-macos-arm64.tar.gz'), 'Mac guide', 'mac.md'),
    row('Ubuntu, Debian, Raspberry Pi OS', 'the package (.deb)', button('.deb', f'khylo-server_{version}_amd64.deb'),
        button('.deb', f'khylo-server_{version}_arm64.deb'), 'Linux guide', 'linux.md'),
    row('Other Linux', 'a plain archive', button('.tar.gz', f'khylo-server-{version}-linux-amd64.tar.gz'),
        button('.tar.gz', f'khylo-server-{version}-linux-arm64.tar.gz'), 'Linux guide', 'linux.md'),
    single('Proxmox', 'one file for both', button('.tar.gz', f'khylo-proxmox-{version}.tar.gz'), 'Proxmox guide', 'proxmox.md'),
    row('A NAS, or any machine with Docker', 'the Docker image', button('.tar', f'khylo-server-docker-{version}-amd64.tar'),
        button('.tar', f'khylo-server-docker-{version}-arm64.tar'), 'Docker guide', 'docker.md'),
])

# What's new: this build's section of the changelog, server and web entries only
changelog = open('CHANGELOG.md', encoding='utf-8').read()
match = re.search(rf'### Build {re.escape(build)}\r?\n(.*?)(?=\r?\n### Build |\r?\n## |\Z)', changelog, re.S)
whats_new = ''
if match:
    whats_new = '\n'.join(line for line in match.group(1).splitlines()
                          if not line.startswith(('- **iOS', '- **Android —'))).strip()

print(f'''## Download Khylo Server

Pick your system and click the button. It starts downloading right away.

<table>
  <tr>
    <th align="left">Your computer</th>
    <th>Intel or AMD<br><sub>most PCs</sub></th>
    <th>Arm<br><sub>Apple silicon Macs, Arm PCs, Raspberry Pi</sub></th>
    <th align="left">How to install</th>
  </tr>
{rows}
</table>

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
