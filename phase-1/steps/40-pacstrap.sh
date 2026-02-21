#!/usr/bin/env bash
set -euo pipefail

phase1_pacstrap() {
  log "Installing base system (pacstrap)..."
  PACSTRAP_PKGS=(
    base
    linux
    linux-firmware
    amd-ucode
    btrfs-progs
    grub
    efibootmgr
    networkmanager
    sudo
    git
    zsh
    vim
    snapper
    snap-pac
    grub-btrfs-support
  )

  pacstrap -K /mnt "${PACSTRAP_PKGS[@]}"
  genfstab -U /mnt >> /mnt/etc/fstab
}
