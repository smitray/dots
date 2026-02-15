#!/usr/bin/env bash
set -euo pipefail

phase1_format_and_mount() {
  EFI_PART="${SYSTEM_DISK}p1"
  SWAP_PART="${SYSTEM_DISK}p2"
  ROOT_PART="${SYSTEM_DISK}p3"
  BACKUP_PART="${SYSTEM_DISK}p4"
  DOWNLOADS_PART="${SYSTEM_DISK}p5"

  HOME_PART="${DATA_DISK}p1"
  WORKSPACE_PART="${DATA_DISK}p2"
  OBSIDIAN_PART="${DATA_DISK}p3"
  SRV_PART="${DATA_DISK}p4"

  for p in "$EFI_PART" "$SWAP_PART" "$ROOT_PART" "$BACKUP_PART" "$DOWNLOADS_PART" "$HOME_PART" "$WORKSPACE_PART" "$OBSIDIAN_PART" "$SRV_PART"; do
    [[ -b "$p" ]] || die "expected partition not found: $p"
  done

  log "Formatting..."
  mkfs.fat -F32 -n ARCH_EFI "$EFI_PART"
  mkswap -L ARCH_SWAP "$SWAP_PART"
  mkfs.btrfs -f -L ARCH_ROOT "$ROOT_PART"
  mkfs.btrfs -f -L ARCH_BACKUP "$BACKUP_PART"
  mkfs.btrfs -f -L ARCH_DOWNLOADS "$DOWNLOADS_PART"
  mkfs.btrfs -f -L ARCH_HOME "$HOME_PART"
  mkfs.btrfs -f -L ARCH_WORKSPACE "$WORKSPACE_PART"
  mkfs.btrfs -f -L ARCH_OBSIDIAN "$OBSIDIAN_PART"
  mkfs.btrfs -f -L ARCH_SRV "$SRV_PART"

  log "Mounting..."
  mount -o rw,relatime,compress=zstd:1,space_cache=v2 "$ROOT_PART" /mnt
  mkdir -p /mnt/boot /mnt/backup /mnt/downloads /mnt/home /mnt/workspace /mnt/obsidian /mnt/srv
  mount "$EFI_PART" /mnt/boot
  mount -o rw,relatime,compress=zstd:1,space_cache=v2 "$BACKUP_PART" /mnt/backup
  mount -o rw,relatime,compress=zstd:1,space_cache=v2 "$DOWNLOADS_PART" /mnt/downloads
  mount -o rw,relatime,compress=zstd:1,space_cache=v2 "$HOME_PART" /mnt/home
  mount -o rw,relatime,compress=zstd:1,space_cache=v2 "$WORKSPACE_PART" /mnt/workspace
  mount -o rw,relatime,compress=zstd:1,space_cache=v2 "$OBSIDIAN_PART" /mnt/obsidian
  mount -o rw,relatime,compress=zstd:1,space_cache=v2 "$SRV_PART" /mnt/srv
  swapon "$SWAP_PART"
}

