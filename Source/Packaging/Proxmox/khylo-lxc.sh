#!/usr/bin/env bash
# Creates a Khylo Server container (LXC) on a Proxmox VE host, or updates one.
#
# On the Proxmox host (as root), with the Khylo .deb next to this script:
#
#   ./khylo-lxc.sh --deb khylo-server_26.10.099_amd64.deb
#
# That's all most people need: it downloads Debian, creates the container, installs Khylo, starts it and
# prints the address to open. Options:
#
#   --deb FILE         the khylo-server .deb to install (required)
#   --ctid N           container number (default: the next free one)
#   --hostname NAME    default: khylo
#   --cores N          default: 2
#   --memory MB        default: 2048
#   --disk GB          default: 8 (Khylo's library and artwork live here; media does not)
#   --storage NAME     where the container's disk goes (default: the first one that can hold containers)
#   --bridge NAME      network bridge (default: vmbr0)
#   --ip CIDR,gw       a fixed address like 192.168.1.50/24,192.168.1.1 (default: DHCP)
#   --media HOST:NAME  share a folder from this host as read-only /media/NAME inside; repeat for more
#   --gpu              give the container the host's graphics device for hardware transcoding
#   --unprivileged     a locked-down container. Safer, but it cannot connect network shares from inside
#                      Khylo (use --media with the share mounted on the host instead)
#   --update CTID      install a newer .deb into an existing container, keeping everything
#
# Network shares (SMB / NFS) added inside Khylo need a privileged container; that is the default here so they
# just work. Proxmox is told to allow only cifs and nfs mounts.
set -euo pipefail

die() { echo "Error: $*" >&2; exit 1; }
say() { echo "==> $*"; }

command -v pct >/dev/null || die "This must be run on a Proxmox VE host (pct was not found)."
[ "$(id -u)" = "0" ] || die "Run this as root."

deb="" ctid="" hostname="khylo" cores=2 memory=2048 disk=8 storage="" bridge="vmbr0" ip="dhcp" gw=""
gpu=0 unpriv=0 update=""
media=()
while [ $# -gt 0 ]; do
	case "$1" in
		--deb) deb=$2; shift 2 ;;
		--ctid) ctid=$2; shift 2 ;;
		--hostname) hostname=$2; shift 2 ;;
		--cores) cores=$2; shift 2 ;;
		--memory) memory=$2; shift 2 ;;
		--disk) disk=$2; shift 2 ;;
		--storage) storage=$2; shift 2 ;;
		--bridge) bridge=$2; shift 2 ;;
		--ip) ip=${2%%,*}; case "$2" in *,*) gw=${2#*,} ;; esac; shift 2 ;;
		--media) media+=("$2"); shift 2 ;;
		--gpu) gpu=1; shift ;;
		--unprivileged) unpriv=1; shift ;;
		--update) update=$2; shift 2 ;;
		-h|--help) sed -n '2,32p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
		*) die "Unknown option: $1 (try --help)" ;;
	esac
done

[ -n "$deb" ] || die "Give the Khylo package with --deb FILE."
[ -f "$deb" ] || die "Can't find $deb"
case "$(dpkg --print-architecture)" in
	amd64) want=amd64 ;; arm64) want=arm64 ;; *) want="" ;;
esac
if [ -n "$want" ] && ! echo "$deb" | grep -q "_${want}\.deb$"; then
	die "This host is $want but the package name doesn't end in _${want}.deb. Use the matching build."
fi

install_deb() {
	local id=$1
	say "Installing Khylo in container $id"
	pct push "$id" "$deb" /tmp/khylo-server.deb
	pct exec "$id" -- bash -c "export DEBIAN_FRONTEND=noninteractive; apt-get update -qq && apt-get install -y -qq /tmp/khylo-server.deb && rm -f /tmp/khylo-server.deb"
}

wait_for_network() {
	local id=$1
	for _ in $(seq 1 60); do
		if pct exec "$id" -- bash -c "getent hosts deb.debian.org >/dev/null 2>&1"; then
			return 0
		fi
		sleep 2
	done
	die "The container did not get network access. Check the bridge ($bridge) and the address settings."
}

address_of() {
	pct exec "$1" -- bash -c "hostname -I | awk '{print \$1}'" 2>/dev/null | tr -d '\r'
}

if [ -n "$update" ]; then
	pct status "$update" >/dev/null 2>&1 || die "Container $update doesn't exist."
	[ "$(pct status "$update" | awk '{print $2}')" = "running" ] || pct start "$update"
	wait_for_network "$update"
	install_deb "$update"
	say "Updated. Your library and settings were not touched."
	exit 0
fi

# ---- A template to build the container from -------------------------------------------------
say "Looking for a Debian template"
pveam update >/dev/null 2>&1 || true
template=$(pveam available --section system | awk '{print $2}' | grep '^debian-12-standard' | sort -V | tail -n1)
[ -n "$template" ] || die "No Debian 12 template is available. Check this host's internet access and run: pveam update"
tstore=$(pvesm status --content vztmpl | awk 'NR>1 {print $1; exit}')
[ -n "$tstore" ] || die "No storage on this host can hold container templates."
if ! pveam list "$tstore" | grep -q "$template"; then
	say "Downloading $template"
	pveam download "$tstore" "$template"
fi

# ---- Where the container lives ---------------------------------------------------------------
if [ -z "$storage" ]; then
	storage=$(pvesm status --content rootdir | awk 'NR>1 {print $1; exit}')
fi
[ -n "$storage" ] || die "No storage on this host can hold containers. Choose one with --storage."
[ -n "$ctid" ] || ctid=$(pvesh get /cluster/nextid)
pct status "$ctid" >/dev/null 2>&1 && die "Container $ctid already exists. Choose another with --ctid, or use --update $ctid."

net="name=eth0,bridge=${bridge}"
if [ "$ip" = "dhcp" ]; then
	net="${net},ip=dhcp"
else
	net="${net},ip=${ip}"
	[ -z "$gw" ] || net="${net},gw=${gw}"
fi

if [ "$unpriv" = "1" ]; then
	features="nesting=1"
else
	# Allows only SMB and NFS mounts inside, so Khylo can connect network shares by itself
	features="nesting=1,mount=nfs;cifs"
fi

say "Creating container $ctid ($hostname) on $storage"
pct create "$ctid" "${tstore}:vztmpl/${template}" \
	--hostname "$hostname" \
	--cores "$cores" --memory "$memory" --swap 512 \
	--rootfs "${storage}:${disk}" \
	--net0 "$net" \
	--unprivileged "$unpriv" \
	--features "$features" \
	--onboot 1 \
	--ostype debian \
	--description "Khylo Server"

# ---- Media folders and graphics --------------------------------------------------------------
i=0
for m in "${media[@]:-}"; do
	[ -n "$m" ] || continue
	hostdir=${m%%:*}
	name=${m#*:}
	[ -d "$hostdir" ] || die "Media folder $hostdir doesn't exist on this host."
	[ "$name" != "$m" ] || name=$(basename "$hostdir")
	pct set "$ctid" "-mp${i}" "${hostdir},mp=/media/${name},ro=1"
	i=$((i + 1))
done

if [ "$gpu" = "1" ]; then
	if [ -e /dev/dri/renderD128 ]; then
		say "Giving the container the graphics device"
		pct set "$ctid" -dev0 /dev/dri/renderD128,mode=0666
	else
		echo "Warning: no /dev/dri/renderD128 on this host, so no graphics device was shared." >&2
	fi
fi

# ---- Start, then install ---------------------------------------------------------------------
say "Starting the container"
pct start "$ctid"
wait_for_network "$ctid"

if [ "$gpu" = "1" ]; then
	# Intel's video driver is in Debian's non-free section
	pct exec "$ctid" -- bash -c 'export DEBIAN_FRONTEND=noninteractive
sed -i -E "s/^(deb .* main)( contrib)?$/ contrib non-free non-free-firmware/" /etc/apt/sources.list 2>/dev/null
apt-get update -qq
apt-get install -y -qq mesa-va-drivers intel-media-va-driver-non-free vainfo || apt-get install -y -qq mesa-va-drivers' || true
fi

install_deb "$ctid"

addr=$(address_of "$ctid")
say "Done."
echo
echo "  Khylo is running in container $ctid."
echo "  Open  http://${addr:-CONTAINER-ADDRESS}:8096  to finish setup."
echo
if [ "$unpriv" = "0" ]; then
	echo "  Network drives: in Khylo, add a library and choose \"Network share\"."
else
	echo "  This container is unprivileged, so Khylo can't connect network shares itself."
	echo "  Mount the share on the Proxmox host and pass it in with --media."
fi
echo "  Update later with:  $0 --update $ctid --deb <new package>"
