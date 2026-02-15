#!/usr/bin/env bash
set -euo pipefail

phase1_fonts_icons() {
  if [[ "${INSTALL_FONTS_ICONS:-0}" != "1" ]]; then
    return 0
  fi

  [[ -n "${USERNAME:-}" ]] || die "USERNAME is not set (unexpected)"

  log "Installing fonts + nficon tools/library (XDG) in chroot..."

  local tmp_assets
  tmp_assets="$(mktemp -d /tmp/dots-phase1-assets.XXXXXX)"
  trap 'rm -rf "${tmp_assets}"' RETURN

  local script_dir repo_root
  script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
  repo_root=""

  local candidate
  candidate="$(cd -- "${script_dir}/../.." >/dev/null 2>&1 && pwd -P || true)"
  if [[ -n "$candidate" && -f "${candidate}/agents/skills/nerd-fonts-icons/icons.csv" ]]; then
    repo_root="$candidate"
  elif [[ -f "$(pwd)/agents/skills/nerd-fonts-icons/icons.csv" ]]; then
    repo_root="$(pwd)"
  fi

  if [[ -n "$repo_root" ]]; then
    cp -f "${repo_root}/agents/tools/nficon" "${tmp_assets}/nficon"
    cp -f "${repo_root}/agents/tools/nficon-export" "${tmp_assets}/nficon-export"
    cp -f "${repo_root}/agents/skills/nerd-fonts-icons/icons.csv" "${tmp_assets}/icons.csv"
    cp -f "${repo_root}/agents/skills/font-stack/assets/60-preferred-fonts.conf" "${tmp_assets}/60-preferred-fonts.conf"
    mkdir -p "${tmp_assets}/exports"
    cp -f "${repo_root}/agents/skills/nerd-fonts-icons/exports/"* "${tmp_assets}/exports/"
  else
    [[ -n "${PHASE1_BASE_URL:-}" ]] || die "missing repo assets; run from a git clone or set PHASE1_BASE_URL"
    command -v curl >/dev/null 2>&1 || die "curl is required to fetch assets in PHASE1_BASE_URL mode"

    curl -fsSL --retry 3 --retry-delay 1 "${PHASE1_BASE_URL%/}/agents/tools/nficon" -o "${tmp_assets}/nficon"
    curl -fsSL --retry 3 --retry-delay 1 "${PHASE1_BASE_URL%/}/agents/tools/nficon-export" -o "${tmp_assets}/nficon-export"
    curl -fsSL --retry 3 --retry-delay 1 "${PHASE1_BASE_URL%/}/agents/skills/nerd-fonts-icons/icons.csv" -o "${tmp_assets}/icons.csv"
    curl -fsSL --retry 3 --retry-delay 1 "${PHASE1_BASE_URL%/}/agents/skills/font-stack/assets/60-preferred-fonts.conf" -o "${tmp_assets}/60-preferred-fonts.conf"

    mkdir -p "${tmp_assets}/exports"
    local export_files=(icons.json icons.lua icons.sh icons.toml icons.tsv)
    local f
    for f in "${export_files[@]}"; do
      curl -fsSL --retry 3 --retry-delay 1 "${PHASE1_BASE_URL%/}/agents/skills/nerd-fonts-icons/exports/${f}" -o "${tmp_assets}/exports/${f}"
    done
  fi

  chmod +x "${tmp_assets}/nficon" "${tmp_assets}/nficon-export"

  arch-chroot /mnt pacman -S --noconfirm --needed \
    fontconfig \
    noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra \
    ttf-dejavu ttf-liberation \
    python

  # Personal-preference monospace fonts (best-effort; names can vary by repo state).
  arch-chroot /mnt pacman -S --noconfirm --needed \
    ttf-jetbrains-mono ttf-iosevka \
    ttf-nerd-fonts-symbols ttf-nerd-fonts-symbols-mono >/dev/null 2>&1 || true

  # Best-effort tofu killers for rare glyphs (don’t fail installer if unavailable).
  arch-chroot /mnt pacman -S --noconfirm --needed \
    gnu-unifont ttf-hanazono >/dev/null 2>&1 || true

  install -d "/mnt/home/${USERNAME}/.local/bin"
  install -m 0755 "${tmp_assets}/nficon" "/mnt/home/${USERNAME}/.local/bin/nficon"
  install -m 0755 "${tmp_assets}/nficon-export" "/mnt/home/${USERNAME}/.local/bin/nficon-export"

  install -d "/mnt/home/${USERNAME}/.local/share/nficon/exports"
  install -m 0644 "${tmp_assets}/icons.csv" "/mnt/home/${USERNAME}/.local/share/nficon/icons.csv"
  install -m 0644 "${tmp_assets}/exports/"* "/mnt/home/${USERNAME}/.local/share/nficon/exports/"

  install -d "/mnt/home/${USERNAME}/.config/fontconfig/conf.d"
  install -m 0644 "${tmp_assets}/60-preferred-fonts.conf" "/mnt/home/${USERNAME}/.config/fontconfig/conf.d/60-preferred-fonts.conf"

  arch-chroot /mnt chown -R "${USERNAME}:${USERNAME}" \
    "/home/${USERNAME}/.local" \
    "/home/${USERNAME}/.config/fontconfig"

  arch-chroot /mnt fc-cache -f >/dev/null 2>&1 || true
}
