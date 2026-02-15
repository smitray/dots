#!/usr/bin/env bash
set -euo pipefail

phase1_prompts() {
  require_root_and_uefi
  require_base_tools
  show_block_devices

  SYSTEM_DISK="${SYSTEM_DISK:-/dev/nvme0n1}"
  DATA_DISK="${DATA_DISK:-/dev/nvme1n1}"
  HOSTNAME="${HOSTNAME:-arch}"
  USERNAME="${USERNAME:-debasmitr}"
  TIMEZONE="${TIMEZONE:-UTC}"
  LOCALE="${LOCALE:-en_US.UTF-8}"
  KEYMAP="${KEYMAP:-us}"

  INSTALL_LTS="${INSTALL_LTS:-0}" # set to 1 to also install linux-lts
  INSTALL_HW_STACK="${INSTALL_HW_STACK:-0}" # nvidia-open + pipewire/wireplumber/bluetooth
  INSTALL_CUDA="${INSTALL_CUDA:-0}" # only relevant if INSTALL_HW_STACK=1
  INSTALL_NVIDIA_CONTAINERS="${INSTALL_NVIDIA_CONTAINERS:-0}" # podman + nvidia container toolkit (only if INSTALL_HW_STACK=1)
  INSTALL_FONTS_ICONS="${INSTALL_FONTS_ICONS:-0}" # fonts + nficon tools + icons.csv into user's XDG dirs
  INSTALL_PARU="${INSTALL_PARU:-0}" # AUR helper (built in chroot)

  [[ -b "$SYSTEM_DISK" ]] || die "SYSTEM_DISK not found: $SYSTEM_DISK"
  [[ -b "$DATA_DISK" ]] || die "DATA_DISK not found: $DATA_DISK"

  read -r -p "System disk [${SYSTEM_DISK}]: " INPUT_SYSTEM_DISK || true
  SYSTEM_DISK="${INPUT_SYSTEM_DISK:-$SYSTEM_DISK}"
  read -r -p "Data disk   [${DATA_DISK}]: " INPUT_DATA_DISK || true
  DATA_DISK="${INPUT_DATA_DISK:-$DATA_DISK}"
  [[ -b "$SYSTEM_DISK" ]] || die "SYSTEM_DISK not found: $SYSTEM_DISK"
  [[ -b "$DATA_DISK" ]] || die "DATA_DISK not found: $DATA_DISK"

  read -r -p "Hostname    [${HOSTNAME}]: " INPUT_HOSTNAME || true
  HOSTNAME="${INPUT_HOSTNAME:-$HOSTNAME}"
  read -r -p "Username    [${USERNAME}]: " INPUT_USERNAME || true
  USERNAME="${INPUT_USERNAME:-$USERNAME}"
  read -r -p "Timezone    [${TIMEZONE}] (e.g. Asia/Kolkata): " INPUT_TIMEZONE || true
  TIMEZONE="${INPUT_TIMEZONE:-$TIMEZONE}"
  read -r -p "Locale      [${LOCALE}] (e.g. en_US.UTF-8): " INPUT_LOCALE || true
  LOCALE="${INPUT_LOCALE:-$LOCALE}"
  read -r -p "Keymap      [${KEYMAP}] (e.g. us): " INPUT_KEYMAP || true
  KEYMAP="${INPUT_KEYMAP:-$KEYMAP}"

  read -r -p "Also install linux-lts? [y/N]: " INPUT_LTS || true
  case "${INPUT_LTS:-}" in
    y|Y|yes|YES) INSTALL_LTS=1 ;;
    *) INSTALL_LTS=0 ;;
  esac

  read -r -p "Install NVIDIA (open) + PipeWire/WirePlumber + Bluetooth now? [y/N]: " INPUT_HW || true
  case "${INPUT_HW:-}" in
    y|Y|yes|YES) INSTALL_HW_STACK=1 ;;
    *) INSTALL_HW_STACK=0 ;;
  esac

  if [[ "$INSTALL_HW_STACK" == "1" ]]; then
    read -r -p "Also install CUDA toolkit now? [y/N]: " INPUT_CUDA || true
    case "${INPUT_CUDA:-}" in
      y|Y|yes|YES) INSTALL_CUDA=1 ;;
      *) INSTALL_CUDA=0 ;;
    esac

    read -r -p "Install Podman + NVIDIA Container Toolkit (GPU containers) now? [y/N]: " INPUT_NVIDIA_CONTAINERS || true
    case "${INPUT_NVIDIA_CONTAINERS:-}" in
      y|Y|yes|YES) INSTALL_NVIDIA_CONTAINERS=1 ;;
      *) INSTALL_NVIDIA_CONTAINERS=0 ;;
    esac
  else
    INSTALL_CUDA=0
    INSTALL_NVIDIA_CONTAINERS=0
  fi

  read -r -p "Install fonts + nficon icon library (XDG) now? [y/N]: " INPUT_FONTS_ICONS || true
  case "${INPUT_FONTS_ICONS:-}" in
    y|Y|yes|YES) INSTALL_FONTS_ICONS=1 ;;
    *) INSTALL_FONTS_ICONS=0 ;;
  esac

  read -r -p "Install paru (AUR helper) now? [y/N]: " INPUT_PARU || true
  case "${INPUT_PARU:-}" in
    y|Y|yes|YES) INSTALL_PARU=1 ;;
    *) INSTALL_PARU=0 ;;
  esac

  echo "Phase 1 (minimal) will:"
  echo "- WIPE and repartition: $SYSTEM_DISK and $DATA_DISK"
  echo "- Install base Arch to: /mnt"
  echo "- Bootloader: GRUB (UEFI)"
  echo "- Hostname: $HOSTNAME"
  echo "- User: $USERNAME"
  if [[ "$INSTALL_LTS" == "1" ]]; then
    echo "- Kernels: linux + linux-lts"
  else
    echo "- Kernel: linux"
  fi
  if [[ "$INSTALL_HW_STACK" == "1" ]]; then
    echo "- Extra: nvidia-open + PipeWire/WirePlumber + Bluetooth"
    if [[ "$INSTALL_CUDA" == "1" ]]; then
      echo "- Extra: CUDA toolkit"
    fi
    if [[ "$INSTALL_NVIDIA_CONTAINERS" == "1" ]]; then
      echo "- Extra: Podman + NVIDIA Container Toolkit"
    fi
  fi
  if [[ "$INSTALL_FONTS_ICONS" == "1" ]]; then
    echo "- Extra: fonts + nficon icon library (XDG user install)"
  fi
  if [[ "$INSTALL_PARU" == "1" ]]; then
    echo "- Extra: paru (AUR helper) installed in system"
  fi
  echo
  read -r -p "Type ERASE to continue: " CONFIRM
  [[ "$CONFIRM" == "ERASE" ]] || die "aborted"
}
