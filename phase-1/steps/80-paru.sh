#!/usr/bin/env bash
set -euo pipefail

phase1_paru() {
  if [[ "${INSTALL_PARU:-0}" != "1" ]]; then
    return 0
  fi

  [[ -n "${USERNAME:-}" ]] || die "USERNAME is not set (unexpected)"

  log "Installing paru (AUR helper) in chroot..."

  cat >/mnt/root/phase-1-paru.sh <<'PARU'
#!/usr/bin/env bash
set -euo pipefail

USERNAME="${USERNAME:?}"

pacman -Syu --noconfirm
pacman -S --noconfirm --needed base-devel git

build_root="$(mktemp -d /tmp/dots-paru.XXXXXX)"
trap 'rm -rf "${build_root}"' EXIT
chown -R "${USERNAME}:${USERNAME}" "${build_root}"

install_from_aur() {
  local pkg="$1"

  if [[ "$pkg" == "paru" ]]; then
    pacman -S --noconfirm --needed rust cargo
  fi

  su - "${USERNAME}" -c "
    set -euo pipefail
    cd '${build_root}'
    rm -rf '${pkg}'
    git clone --depth 1 'https://aur.archlinux.org/${pkg}.git' '${pkg}'
    cd '${pkg}'
    makepkg -f
  "

  mapfile -t pkgfiles < <(find "${build_root}/${pkg}" -maxdepth 1 -type f -name '*.pkg.tar.*' ! -name '*.sig' | sort)
  if (( ${#pkgfiles[@]} == 0 )); then
    echo \"error: no package produced for ${pkg}\" >&2
    return 1
  fi

  pacman -U --noconfirm --needed "${pkgfiles[-1]}"
}

# Prefer prebuilt binary package to avoid heavy toolchains.
install_from_aur paru-bin || install_from_aur paru
PARU

  chmod +x /mnt/root/phase-1-paru.sh

  arch-chroot /mnt env USERNAME="$USERNAME" /root/phase-1-paru.sh
}
