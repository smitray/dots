# Phase 1: Minimal Install (Pre-Reboot)

**Goal**: Partition disks, install base Arch, configure bootloader (GRUB), and do only the minimum needed to reboot into a working system (TTY + network + sudo).

**Non-goals** (Phase 2):
- Dotfiles deployment (stow/symlinks)
- Hyprland / Wayland desktop setup
- NVIDIA driver + CUDA setup (unless explicitly opted-in)

## Inputs
- Partition table: `docs/partition-table.md`
- Target disks: `/dev/nvme0n1` and `/dev/nvme1n1`
- Bootloader: GRUB (UEFI)
- Script: `phase-1/install.sh`
- Step modules: `phase-1/steps/`

## Responsibilities
- Disk partitioning and filesystem creation
- Base system install
- fstab generation
- GRUB installation
- Enable minimal services needed for boot
- Create a user + sudo (so Phase 2 can run comfortably after reboot)
- Kernel: install `linux` (optionally `linux-lts`)

## Optional (opt-in)
If selected during the installer prompts, Phase 1 can also install a “hardware stack” so the first boot already has:
- NVIDIA open driver (`nvidia-open` + `nvidia-utils`) and GRUB modeset flag
- PipeWire + WirePlumber + Bluetooth + EasyEffects
- (Optional) CUDA toolkit (`cuda`)
- (Optional) Podman + NVIDIA Container Toolkit (`nvidia-container-toolkit`)

## Outputs
- Bootable minimal Arch system
- Mount points created as per partition table
- GRUB installed and configured

## TBD
- Decide final defaults for locale/timezone/hostname/username (script currently supports env overrides)
