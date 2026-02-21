#!/usr/bin/env bash
set -euo pipefail

phase1_partition() {
  # ── System Disk ──
  # Snapper stores snapshots on / (root). No separate backup partition needed.
  if blkid -L "ARCH_ROOT" >/dev/null 2>&1; then
    log "ARCH_ROOT label found – skipping system disk repartitioning."
    SYSTEM_DISK_CREATED=0
  else
    log "Partitioning $SYSTEM_DISK..."
    sgdisk --zap-all "$SYSTEM_DISK"
    sgdisk -n 1:0:+2G   -t 1:EF00 -c 1:ARCH_EFI       "$SYSTEM_DISK"
    sgdisk -n 2:0:+32G  -t 2:8200 -c 2:ARCH_SWAP       "$SYSTEM_DISK"
    sgdisk -n 3:0:+140G -t 3:8300 -c 3:ARCH_ROOT       "$SYSTEM_DISK"
    sgdisk -n 4:0:+726G -t 4:8300 -c 4:ARCH_DOWNLOADS  "$SYSTEM_DISK"
    SYSTEM_DISK_CREATED=1
  fi

  # ── Data Disk ──
  # Persistent storage. Only partition on first install.
  if blkid -L "ARCH_HOME" >/dev/null 2>&1; then
    log "ARCH_HOME label found – preserving data disk."
    DATA_DISK_CREATED=0
  else
    log "Partitioning $DATA_DISK..."
    sgdisk --zap-all "$DATA_DISK"
    sgdisk -n 1:0:+80G  -t 1:8300 -c 1:ARCH_HOME      "$DATA_DISK"
    sgdisk -n 2:0:+300G -t 2:8300 -c 2:ARCH_WORKSPACE  "$DATA_DISK"
    sgdisk -n 3:0:+80G  -t 3:8300 -c 3:ARCH_OBSIDIAN   "$DATA_DISK"
    sgdisk -n 4:0:+440G -t 4:8300 -c 4:ARCH_SRV        "$DATA_DISK"
    DATA_DISK_CREATED=1
  fi

  partprobe "$SYSTEM_DISK" || true
  partprobe "$DATA_DISK" || true
  sleep 2
}
