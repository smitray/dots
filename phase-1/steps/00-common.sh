#!/usr/bin/env bash
set -euo pipefail

die() { echo "error: $*" >&2; exit 1; }
need() { command -v "$1" >/dev/null 2>&1 || die "missing dependency: $1"; }
log() { echo "==> $*"; }

require_root_and_uefi() {
  if [[ "${EUID:-$(id -u)}" -ne 0 ]]; then
    die "run as root (use sudo) from the live ISO"
  fi
  if [[ ! -d /sys/firmware/efi/efivars ]]; then
    die "UEFI not detected (expected /sys/firmware/efi/efivars)"
  fi
}

require_base_tools() {
  need lsblk
  need blkid
  need sgdisk
  need mkfs.fat
  need mkswap
  need mkfs.btrfs
  need mount
  need pacstrap
  need genfstab
  need arch-chroot
}

show_block_devices() {
  log "Detected block devices:"
  lsblk -o NAME,SIZE,TYPE,MODEL | sed 's/^/  /'
  echo
}

# Detect all available disks. Sets DETECTED_DISKS array.
detect_disks() {
  DETECTED_DISKS=()

  while IFS= read -r d; do
    DETECTED_DISKS+=("$d")
  done < <(lsblk -dnpo NAME,TYPE | awk '$2=="disk" {print $1}' | sort)

  if (( ${#DETECTED_DISKS[@]} < 2 )); then
    die "Need at least 2 disks. Found: ${DETECTED_DISKS[*]:-none}"
  fi

  log "Available disks:"
  local i
  for i in "${!DETECTED_DISKS[@]}"; do
    local info
    info="$(lsblk -dno SIZE,MODEL "${DETECTED_DISKS[$i]}" 2>/dev/null || true)"
    log "  [$((i+1))] ${DETECTED_DISKS[$i]}  ${info}"
  done
}

