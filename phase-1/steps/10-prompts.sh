#!/usr/bin/env bash
set -euo pipefail

phase1_prompts() {
  require_root_and_uefi
  require_base_tools
  show_block_devices
  detect_disks

  # Let the user pick system and data disks from detected list
  if [[ -z "${SYSTEM_DISK:-}" ]]; then
    echo "Select SYSTEM disk (will be formatted on every install):"
    local i
    for i in "${!DETECTED_DISKS[@]}"; do
      local info
      info="$(lsblk -dno SIZE,MODEL "${DETECTED_DISKS[$i]}" 2>/dev/null || true)"
      echo "  [$((i+1))] ${DETECTED_DISKS[$i]}  ${info}"
    done
    read -r -p "System disk [1]: " INPUT_SYS_IDX || true
    INPUT_SYS_IDX="${INPUT_SYS_IDX:-1}"
    SYSTEM_DISK="${DETECTED_DISKS[$((INPUT_SYS_IDX-1))]}"
  fi

  if [[ -z "${DATA_DISK:-}" ]]; then
    echo "Select DATA disk (persistent, preserved on reinstall):"
    local j
    for j in "${!DETECTED_DISKS[@]}"; do
      [[ "${DETECTED_DISKS[$j]}" == "$SYSTEM_DISK" ]] && continue
      local info
      info="$(lsblk -dno SIZE,MODEL "${DETECTED_DISKS[$j]}" 2>/dev/null || true)"
      echo "  [$((j+1))] ${DETECTED_DISKS[$j]}  ${info}"
    done
    read -r -p "Data disk [number]: " INPUT_DATA_IDX || true
    DATA_DISK="${DETECTED_DISKS[$((INPUT_DATA_IDX-1))]}"
  fi

  [[ -b "$SYSTEM_DISK" ]] || die "SYSTEM_DISK not found: $SYSTEM_DISK"
  [[ -b "$DATA_DISK" ]] || die "DATA_DISK not found: $DATA_DISK"
  [[ "$SYSTEM_DISK" != "$DATA_DISK" ]] || die "SYSTEM_DISK and DATA_DISK cannot be the same device"

  log "System disk: $SYSTEM_DISK"
  log "Data disk:   $DATA_DISK"

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
