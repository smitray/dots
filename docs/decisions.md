# Decisions

- Bootloader: GRUB (UEFI)
- Filesystem: Btrfs with `compress=zstd:1`
- Architecture: Two-phase install (pre-reboot minimal, post-reboot full setup)
