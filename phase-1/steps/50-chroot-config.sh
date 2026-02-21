#!/usr/bin/env bash
set -euo pipefail

phase1_system_config() {
  log "Configuring system in chroot..."

  cat >/mnt/root/phase-1-chroot.sh <<'CHROOT'
#!/usr/bin/env bash
set -euo pipefail

HOSTNAME="${HOSTNAME:?}"
USERNAME="${USERNAME:?}"
USER_PASSWORD="${USER_PASSWORD:-}"
TIMEZONE="${TIMEZONE:?}"
LOCALE="${LOCALE:?}"
KEYMAP="${KEYMAP:?}"

# ── Time and Locale ──
ln -sf "/usr/share/zoneinfo/${TIMEZONE}" /etc/localtime
hwclock --systohc
sed -i "s/^#\(${LOCALE} UTF-8\)/\1/" /etc/locale.gen
locale-gen
echo "LANG=${LOCALE}" >/etc/locale.conf
echo "KEYMAP=${KEYMAP}" >/etc/vconsole.conf

# ── Network ──
echo "${HOSTNAME}" >/etc/hostname
cat >/etc/hosts <<EOF
127.0.0.1 localhost
::1       localhost
127.0.1.1 ${HOSTNAME}.localdomain ${HOSTNAME}
EOF

# ── User and Sudo ──
useradd -m -G wheel -s /bin/zsh "${USERNAME}" || true
if [[ -n "$USER_PASSWORD" ]]; then
  echo "${USERNAME}:${USER_PASSWORD}" | chpasswd
fi
sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers

# ── Services ──
systemctl enable NetworkManager

# ── Snapper (CachyOS-aligned) ──
# Snapper creates a default subvolume at /.snapshots on the root partition.
# snap-pac will automatically trigger pre/post snapshots on every pacman transaction.
# grub-btrfsd will watch /.snapshots and update GRUB entries automatically.
umount /.snapshots 2>/dev/null || true
rm -rf /.snapshots
snapper -c root create-config /

# 1-month retention: keep 20 pacman snapshots, 30 daily timeline snapshots.
# Everything older than 30 days is auto-cleaned by snapper-cleanup.timer.
snapper -c root set-config \
  "NUMBER_LIMIT=20" \
  "NUMBER_LIMIT_IMPORTANT=10" \
  "TIMELINE_CLEANUP=yes" \
  "TIMELINE_CREATE=yes" \
  "TIMELINE_LIMIT_HOURLY=0" \
  "TIMELINE_LIMIT_DAILY=30" \
  "TIMELINE_LIMIT_WEEKLY=0" \
  "TIMELINE_LIMIT_MONTHLY=0" \
  "TIMELINE_LIMIT_YEARLY=0"

mkdir -p /.snapshots

systemctl enable snapper-cleanup.timer
systemctl enable snapper-timeline.timer

# ── GRUB ──
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

# grub-btrfsd watches /.snapshots and regenerates GRUB entries when snapshots change
systemctl enable grub-btrfsd.service
CHROOT

  chmod +x /mnt/root/phase-1-chroot.sh

  arch-chroot /mnt env \
    HOSTNAME="$HOSTNAME" USERNAME="$USERNAME" USER_PASSWORD="$USER_PASSWORD" \
    TIMEZONE="$TIMEZONE" LOCALE="$LOCALE" KEYMAP="$KEYMAP" \
    /root/phase-1-chroot.sh
}
