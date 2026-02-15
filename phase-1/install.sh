#!/usr/bin/env bash
set -euo pipefail

STEP_FILES=(
  00-common.sh
  10-prompts.sh
  20-partition.sh
  30-format-mount.sh
  40-pacstrap.sh
  50-chroot-config.sh
  60-passwords.sh
  70-hw-stack.sh
  75-fonts-icons.sh
  80-paru.sh
  85-mise.sh
  90-main.sh
)

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
LOCAL_STEPS_DIR="${SCRIPT_DIR}/steps"

load_steps_local() {
  [[ -d "$LOCAL_STEPS_DIR" ]] || return 1
  for f in "${STEP_FILES[@]}"; do
    # shellcheck disable=SC1090
    source "${LOCAL_STEPS_DIR}/${f}"
  done
}

load_steps_remote() {
  [[ -n "${PHASE1_BASE_URL:-}" ]] || return 1
  command -v curl >/dev/null 2>&1 || { echo "error: curl is required for PHASE1_BASE_URL mode" >&2; return 1; }

  local tmp_dir
  tmp_dir="$(mktemp -d /tmp/dots-phase1-steps.XXXXXX)"
  trap 'rm -rf "${tmp_dir}"' RETURN
  for f in "${STEP_FILES[@]}"; do
    curl -fsSL --retry 3 --retry-delay 1 "${PHASE1_BASE_URL%/}/phase-1/steps/${f}" -o "${tmp_dir}/${f}"
  done

  for f in "${STEP_FILES[@]}"; do
    # shellcheck disable=SC1090
    source "${tmp_dir}/${f}"
  done
}

if ! load_steps_local; then
  load_steps_remote || {
    echo "error: could not load step scripts." >&2
    echo "hint: run from a git clone, or set PHASE1_BASE_URL to the repo raw base URL." >&2
    exit 1
  }
fi

phase1_main
