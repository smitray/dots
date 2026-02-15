# Decisions

- Distro: Arch Linux (vanilla)
- Bootloader: GRUB (UEFI)
- Filesystem: Btrfs with `compress=zstd:1`
- Architecture: Two-phase install (pre-reboot minimal, post-reboot full setup)
- GPU driver (NVIDIA): `nvidia-open` kernel module + `nvidia-utils`
- CUDA: install Arch `cuda` toolkit (post-reboot)
- GPU containers: use NVIDIA Container Toolkit (`nvidia-container-toolkit`) with Podman
