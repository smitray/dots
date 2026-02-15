#!/usr/bin/env bash
set -euo pipefail

phase1_partition() {
  log "Partitioning $SYSTEM_DISK..."
  sgdisk --zap-all "$SYSTEM_DISK"
  sgdisk -n 1:0:+2G   -t 1:EF00 -c 1:ARCH_EFI "$SYSTEM_DISK"
  sgdisk -n 2:0:+32G  -t 2:8200 -c 2:ARCH_SWAP "$SYSTEM_DISK"
  sgdisk -n 3:0:+140G -t 3:8300 -c 3:ARCH_ROOT "$SYSTEM_DISK"
  sgdisk -n 4:0:+180G -t 4:8300 -c 4:ARCH_BACKUP "$SYSTEM_DISK"
  sgdisk -n 5:0:+546G -t 5:8300 -c 5:ARCH_DOWNLOADS "$SYSTEM_DISK"

  log "Partitioning $DATA_DISK..."
  sgdisk --zap-all "$DATA_DISK"
  sgdisk -n 1:0:+80G  -t 1:8300 -c 1:ARCH_HOME "$DATA_DISK"
  sgdisk -n 2:0:+300G -t 2:8300 -c 2:ARCH_WORKSPACE "$DATA_DISK"
  sgdisk -n 3:0:+80G  -t 3:8300 -c 3:ARCH_OBSIDIAN "$DATA_DISK"
  sgdisk -n 4:0:+440G -t 4:8300 -c 4:ARCH_SRV "$DATA_DISK"

  partprobe "$SYSTEM_DISK" || true
  partprobe "$DATA_DISK" || true
  sleep 2
}

