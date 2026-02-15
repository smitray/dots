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

USERNAME="${USERNAME:-}"

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
  install -d -m 0755 /usr/local/bin
  curl -fsSL https://mise.run | MISE_INSTALL_PATH=/usr/local/bin/mise sh
}

if pacman -Si mise >/dev/null 2>&1; then
  install_mise_pacman
elif install_mise_aur; then
  :
else
  install_mise_curl
fi

command -v mise >/dev/null 2>&1 || { echo "error: mise install failed" >&2; exit 1; }

append_if_missing() {
  local file="$1"
  local marker="$2"
  local content="$3"
  [[ -f "$file" ]] || return 0
  if ! grep -q "$marker" "$file"; then
    printf "\n%s\n%s\n" "$marker" "$content" >>"$file"
  fi
}

# Enable mise for interactive shells out-of-the-box (Phase 2 can override with dotfiles).
append_if_missing "/etc/zsh/zshrc" "# >>> mise >>>" \
'if [[ -o interactive ]] && command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh)"
fi
# <<< mise <<<'

append_if_missing "/etc/bash.bashrc" "# >>> mise >>>" \
'if [[ $- == *i* ]] && command -v mise >/dev/null 2>&1; then
  eval "$(mise activate bash)"
fi
# <<< mise <<<'

cat >/etc/profile.d/phase1-path.sh <<'EOF'
# Ensure common local bin dirs are reachable without sudo.
case ":$PATH:" in
  *:/usr/local/bin:*) ;;
  *) PATH="/usr/local/bin:$PATH" ;;
esac
if [[ -n "${HOME:-}" && -d "$HOME/.local/bin" ]]; then
  case ":$PATH:" in
    *:"$HOME/.local/bin":*) ;;
    *) PATH="$HOME/.local/bin:$PATH" ;;
  esac
fi
export PATH
EOF

if [[ -n "$USERNAME" ]] && id "$USERNAME" >/dev/null 2>&1; then
  # Prime dirs/permissions so runtimes live under /home (persistent on NVMe1).
  install -d -m 0755 -o "$USERNAME" -g "$USERNAME" "/home/${USERNAME}/.config/mise"
  install -d -m 0755 -o "$USERNAME" -g "$USERNAME" "/home/${USERNAME}/.local/share/mise"
fi
MISE

  chmod +x /mnt/root/phase-1-mise.sh

  arch-chroot /mnt env USERNAME="$USERNAME" /root/phase-1-mise.sh
}
