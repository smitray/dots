#!/usr/bin/env bash
set -euo pipefail

phase1_hw_stack() {
  if [[ "${INSTALL_HW_STACK:-0}" != "1" ]]; then
    return 0
  fi

  log "Installing hardware stack in chroot (NVIDIA + audio + bluetooth)..."

  cat >/mnt/root/phase-1-hw.sh <<'HW'
#!/usr/bin/env bash
set -euo pipefail

INSTALL_HW_STACK="${INSTALL_HW_STACK:-0}"
INSTALL_CUDA="${INSTALL_CUDA:-0}"
INSTALL_NVIDIA_CONTAINERS="${INSTALL_NVIDIA_CONTAINERS:-0}"

if [[ "$INSTALL_HW_STACK" != "1" ]]; then
  exit 0
fi

pacman -Syu --noconfirm

# NVIDIA (open kernel module) + userland
pacman -S --noconfirm nvidia-open nvidia-utils

# Recommended for Wayland compositors
install -d /etc/modprobe.d
cat >/etc/modprobe.d/blacklist-nouveau.conf <<EOF
blacklist nouveau
options nouveau modeset=0
EOF

# Enable DRM modeset for nvidia (needed for Wayland; safe to keep on)
if [[ -f /etc/default/grub ]]; then
  if grep -q '^GRUB_CMDLINE_LINUX_DEFAULT=' /etc/default/grub; then
    if ! grep -q 'nvidia_drm\.modeset=1' /etc/default/grub; then
      sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT="\\(.*\\)"/GRUB_CMDLINE_LINUX_DEFAULT="\\1 nvidia_drm.modeset=1"/' /etc/default/grub
      grub-mkconfig -o /boot/grub/grub.cfg
    fi
  fi
fi

# Audio stack
pacman -S --noconfirm \
  pipewire pipewire-alsa pipewire-pulse pipewire-jack \
  wireplumber \
  alsa-utils pavucontrol \
  easyeffects \
  bluez bluez-utils \
  fdk-aac libldac libfreeaptx

mkinitcpio -P

systemctl enable bluetooth.service

# Power on bluetooth automatically at boot
install -d /etc/bluetooth
if [[ -f /etc/bluetooth/main.conf ]]; then
  if grep -q '^[#[:space:]]*AutoEnable' /etc/bluetooth/main.conf; then
    sed -i 's/^[#[:space:]]*AutoEnable=.*/AutoEnable=true/' /etc/bluetooth/main.conf
  else
    printf '\\nAutoEnable=true\\n' >>/etc/bluetooth/main.conf
  fi
else
  cat >/etc/bluetooth/main.conf <<EOF
[Policy]
AutoEnable=true
EOF
fi

# WirePlumber: auto-connect bluetooth profiles when devices appear (after you pair+trust once).
install -d /etc/wireplumber/wireplumber.conf.d
cat >/etc/wireplumber/wireplumber.conf.d/50-bluez-autoconnect.conf <<'EOF'
monitor.bluez.properties = {
  bluez5.auto-connect = [ "a2dp_sink" "hfp_hf" ]
}
EOF

if [[ "$INSTALL_CUDA" == "1" ]]; then
  pacman -S --noconfirm cuda
fi

if [[ "$INSTALL_NVIDIA_CONTAINERS" == "1" ]]; then
  pacman -S --noconfirm podman nvidia-container-toolkit

  # Prefer CDI for Podman (system-wide). Podman can then use: --device nvidia.com/gpu=all
  if command -v nvidia-ctk >/dev/null 2>&1; then
    install -d /etc/cdi
    nvidia-ctk cdi generate --output=/etc/cdi/nvidia.yaml
  else
    echo "warning: nvidia-ctk not found; NVIDIA Container Toolkit may need manual CDI config" >&2
  fi
fi
HW

  chmod +x /mnt/root/phase-1-hw.sh

  arch-chroot /mnt env \
    INSTALL_HW_STACK="$INSTALL_HW_STACK" INSTALL_CUDA="$INSTALL_CUDA" INSTALL_NVIDIA_CONTAINERS="$INSTALL_NVIDIA_CONTAINERS" \
    /root/phase-1-hw.sh
}

