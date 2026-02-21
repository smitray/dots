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

# Auto-detect NVMe (or other) disks. Sets DETECTED_DISK_1 and DETECTED_DISK_2.
# Prefers NVMe devices; falls back to any block disk if fewer than 2 NVMe found.
detect_disks() {
  local -a disks=()

  # Collect all NVMe whole-disk devices first, sorted by name
  while IFS= read -r d; do
    disks+=("$d")
  done < <(lsblk -dnpo NAME,TYPE | awk '$2=="disk" && /nvme/' | awk '{print $1}' | sort)

  # If fewer than 2 NVMe, also consider other disk types (sda, vda, etc.)
  if (( ${#disks[@]} < 2 )); then
    while IFS= read -r d; do
      # Skip if already in the list
      local dup=0
      for existing in "${disks[@]}"; do
        [[ "$existing" == "$d" ]] && dup=1
      done
      (( dup )) || disks+=("$d")
    done < <(lsblk -dnpo NAME,TYPE | awk '$2=="disk"' | awk '{print $1}' | sort)
  fi

  if (( ${#disks[@]} < 2 )); then
    die "Need at least 2 disks. Found: ${disks[*]:-none}"
  fi

  DETECTED_DISK_1="${disks[0]}"
  DETECTED_DISK_2="${disks[1]}"

  log "Auto-detected disks:"
  log "  Disk 1 (system): $DETECTED_DISK_1"
  log "  Disk 2 (data):   $DETECTED_DISK_2"
}

