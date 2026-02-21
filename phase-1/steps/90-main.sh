#!/usr/bin/env bash
set -euo pipefail

phase1_main() {
  phase1_prompts
  phase1_partition
  phase1_format_and_mount
  phase1_pacstrap
  phase1_system_config
  log "Phase 1 Complete. You can now reboot into your new system."
}
