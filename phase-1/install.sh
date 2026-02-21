#!/usr/bin/env bash
set -euo pipefail

REPO_BASE_URL="https://raw.githubusercontent.com/smitray/dots/main"

STEP_FILES=(
  00-common.sh
  10-prompts.sh
  20-partition.sh
  30-format-mount.sh
  40-pacstrap.sh
  50-chroot-config.sh
  90-main.sh
)

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" 2>/dev/null && pwd -P || echo "")"
LOCAL_STEPS_DIR="${SCRIPT_DIR:+${SCRIPT_DIR}/steps}"

load_steps_local() {
  [[ -n "$LOCAL_STEPS_DIR" && -d "$LOCAL_STEPS_DIR" ]] || return 1
  for f in "${STEP_FILES[@]}"; do
    # shellcheck disable=SC1090
    source "${LOCAL_STEPS_DIR}/${f}"
  done
}

load_steps_remote() {
  command -v curl >/dev/null 2>&1 || { echo "error: curl is required" >&2; return 1; }

  local tmp_dir
  tmp_dir="$(mktemp -d /tmp/dots-phase1-steps.XXXXXX)"
  trap 'rm -rf "${tmp_dir}"' RETURN
  for f in "${STEP_FILES[@]}"; do
    curl -fsSL --retry 3 --retry-delay 1 "${REPO_BASE_URL}/phase-1/steps/${f}" -o "${tmp_dir}/${f}"
  done

  for f in "${STEP_FILES[@]}"; do
    # shellcheck disable=SC1090
    source "${tmp_dir}/${f}"
  done
}

if ! load_steps_local; then
  load_steps_remote || {
    echo "error: could not load step scripts." >&2
    exit 1
  }
fi

phase1_main
