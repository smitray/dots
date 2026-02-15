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
  log "Done. You can reboot now."
}

