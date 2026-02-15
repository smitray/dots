#!/usr/bin/env bash
set -euo pipefail

phase1_system_config() {
  log "Configuring system in chroot..."

  cat >/mnt/root/phase-1-chroot.sh <<'CHROOT'
#!/usr/bin/env bash
set -euo pipefail

HOSTNAME="${HOSTNAME:?}"
USERNAME="${USERNAME:?}"
TIMEZONE="${TIMEZONE:?}"
LOCALE="${LOCALE:?}"
KEYMAP="${KEYMAP:?}"

ln -sf "/usr/share/zoneinfo/${TIMEZONE}" /etc/localtime
hwclock --systohc

sed -i "s/^#\\(${LOCALE} UTF-8\\)/\\1/" /etc/locale.gen
locale-gen
echo "LANG=${LOCALE}" >/etc/locale.conf
echo "KEYMAP=${KEYMAP}" >/etc/vconsole.conf

echo "${HOSTNAME}" >/etc/hostname
cat >/etc/hosts <<EOF
127.0.0.1 localhost
::1       localhost
127.0.1.1 ${HOSTNAME}.localdomain ${HOSTNAME}
EOF

useradd -m -G wheel -s /bin/zsh "${USERNAME}" || true
sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers

systemctl enable NetworkManager

grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
CHROOT

  chmod +x /mnt/root/phase-1-chroot.sh

  arch-chroot /mnt env \
    HOSTNAME="$HOSTNAME" USERNAME="$USERNAME" TIMEZONE="$TIMEZONE" LOCALE="$LOCALE" KEYMAP="$KEYMAP" \
    /root/phase-1-chroot.sh
}

