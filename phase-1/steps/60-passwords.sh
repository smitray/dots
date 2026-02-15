#!/usr/bin/env bash
set -euo pipefail

phase1_passwords() {
  echo
  echo "Set passwords (root + ${USERNAME}) in the chroot."
  echo
  arch-chroot /mnt passwd
  arch-chroot /mnt passwd "$USERNAME"
}

