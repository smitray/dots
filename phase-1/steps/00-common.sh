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

