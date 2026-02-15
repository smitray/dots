#!/usr/bin/env bash
set -euo pipefail

phase1_mise() {
  if [[ "${INSTALL_MISE:-0}" != "1" ]]; then
    return 0
  fi

  [[ -n "${USERNAME:-}" ]] || die "USERNAME is not set (unexpected)"

  log "Installing mise (runtime manager) in chroot..."

  cat >/mnt/root/phase-1-mise.sh <<'MISE'
#!/usr/bin/env bash
set -euo pipefail

pacman -Syu --noconfirm

install_mise_pacman() {
  pacman -S --noconfirm --needed mise
}

install_mise_aur() {
  if command -v paru >/dev/null 2>&1; then
    paru -S --noconfirm --needed mise-bin || paru -S --noconfirm --needed mise
    return 0
  fi
  return 1
}

install_mise_curl() {
  pacman -S --noconfirm --needed curl ca-certificates
  curl -fsSL https://mise.run | sh
}

if pacman -Si mise >/dev/null 2>&1; then
  install_mise_pacman
elif install_mise_aur; then
  :
else
  install_mise_curl
fi
MISE

  chmod +x /mnt/root/phase-1-mise.sh

  arch-chroot /mnt /root/phase-1-mise.sh
}

