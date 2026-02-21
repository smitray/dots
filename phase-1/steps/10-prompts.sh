#!/usr/bin/env bash
set -euo pipefail

phase1_prompts() {
  require_root_and_uefi
  require_base_tools
  show_block_devices
  detect_disks

  SYSTEM_DISK="${SYSTEM_DISK:-$DETECTED_DISK_1}"
  DATA_DISK="${DATA_DISK:-$DETECTED_DISK_2}"
  HOSTNAME="${HOSTNAME:-arch}"
  USERNAME="${USERNAME:-debasmitr}"
  TIMEZONE="${TIMEZONE:-Asia/Kolkata}"
  LOCALE="${LOCALE:-en_US.UTF-8}"
  KEYMAP="${KEYMAP:-us}"

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

  read -r -s -p "Password for ${USERNAME}: " INPUT_PASSWORD || true
  echo
  USER_PASSWORD="${INPUT_PASSWORD}"

  read -r -p "Timezone    [${TIMEZONE}]: " INPUT_TIMEZONE || true
  TIMEZONE="${INPUT_TIMEZONE:-$TIMEZONE}"
  
  read -r -p "Locale      [${LOCALE}]: " INPUT_LOCALE || true
  LOCALE="${INPUT_LOCALE:-$LOCALE}"
  
  read -r -p "Keymap      [${KEYMAP}]: " INPUT_KEYMAP || true
  KEYMAP="${INPUT_KEYMAP:-$KEYMAP}"

  echo
  echo "Phase 1 (Minimal) will:"
  echo "- SYSTEM DISK ($SYSTEM_DISK): Wipe & Re-partition (if labels missing), Format always."
  echo "- DATA DISK ($DATA_DISK): Preserve if ARCH_HOME exists, Format ONLY if first install."
  echo "- Install base Arch + GRUB + Snapper"
  echo "- Hostname: $HOSTNAME"
  echo "- User: $USERNAME"
  echo
  read -r -p "Type ERASE to continue: " CONFIRM
  [[ "$CONFIRM" == "ERASE" ]] || die "aborted"
}
