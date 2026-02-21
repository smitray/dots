#!/usr/bin/env bash
set -euo pipefail

phase1_format_and_mount() {
  # ── Partition device paths ──
  local P=""
  [[ "$SYSTEM_DISK" == *"nvme"* ]] && P="p"

  EFI_PART="${SYSTEM_DISK}${P}1"
  SWAP_PART="${SYSTEM_DISK}${P}2"
  ROOT_PART="${SYSTEM_DISK}${P}3"
  DOWNLOADS_PART="${SYSTEM_DISK}${P}4"

  local D=""
  [[ "$DATA_DISK" == *"nvme"* ]] && D="p"

  HOME_PART="${DATA_DISK}${D}1"
  WORKSPACE_PART="${DATA_DISK}${D}2"
  OBSIDIAN_PART="${DATA_DISK}${D}3"
  SRV_PART="${DATA_DISK}${D}4"

  # ── Verify partitions exist ──
  for p in "$EFI_PART" "$SWAP_PART" "$ROOT_PART" "$DOWNLOADS_PART" \
           "$HOME_PART" "$WORKSPACE_PART" "$OBSIDIAN_PART" "$SRV_PART"; do
    [[ -b "$p" ]] || die "expected partition not found: $p"
  done

  # ── Format system disk (always – this is the disposable disk) ──
  log "Formatting system disk ($SYSTEM_DISK)..."
  mkfs.fat -F32 -n ARCH_EFI "$EFI_PART"
  mkswap -L ARCH_SWAP "$SWAP_PART"
  mkfs.btrfs -f -L ARCH_ROOT "$ROOT_PART"
  mkfs.btrfs -f -L ARCH_DOWNLOADS "$DOWNLOADS_PART"

  # ── Format data disk (only on first install) ──
  if [[ "${DATA_DISK_CREATED:-0}" == "1" ]]; then
    log "Formatting data disk ($DATA_DISK) – first install..."
    mkfs.btrfs -f -L ARCH_HOME "$HOME_PART"
    mkfs.btrfs -f -L ARCH_WORKSPACE "$WORKSPACE_PART"
    mkfs.btrfs -f -L ARCH_OBSIDIAN "$OBSIDIAN_PART"
    mkfs.btrfs -f -L ARCH_SRV "$SRV_PART"
  else
    log "Preserving existing data on $DATA_DISK – mount only."
  fi

  # ── Mount everything ──
  local BTRFS_OPTS="rw,relatime,compress=zstd:1,space_cache=v2"

  log "Mounting..."
  mount -o "$BTRFS_OPTS" "$ROOT_PART" /mnt

  mkdir -p /mnt/boot /mnt/downloads /mnt/home /mnt/workspace /mnt/obsidian /mnt/srv

  mount "$EFI_PART" /mnt/boot
  mount -o "$BTRFS_OPTS" "$DOWNLOADS_PART" /mnt/downloads
  mount -o "$BTRFS_OPTS" "$HOME_PART" /mnt/home
  mount -o "$BTRFS_OPTS" "$WORKSPACE_PART" /mnt/workspace
  mount -o "$BTRFS_OPTS" "$OBSIDIAN_PART" /mnt/obsidian
  mount -o "$BTRFS_OPTS" "$SRV_PART" /mnt/srv

  swapon "$SWAP_PART"
}
