#!/usr/bin/env bash
set -euo pipefail

phase1_main() {
  phase1_prompts
  phase1_partition
  phase1_format_and_mount
  phase1_pacstrap
  phase1_system_config
  phase1_passwords
  phase1_hw_stack
  phase1_fonts_icons
  phase1_paru
  log "Done. You can reboot now."
}
