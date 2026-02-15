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
  )
  if [[ "${INSTALL_LTS:-0}" == "1" ]]; then
    PACSTRAP_PKGS+=(linux-lts)
  fi

  pacstrap -K /mnt "${PACSTRAP_PKGS[@]}"
  genfstab -U /mnt >>/mnt/etc/fstab
}

