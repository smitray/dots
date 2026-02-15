# Phase 1 (Minimal): Live USB -> Bootable Arch

This phase is intentionally minimal: partitioning + base install + bootloader + user/network so the system can reboot into a working TTY. **No dotfiles, no stow/symlinks, no Hyprland setup** (that’s Phase 2).

## Run from Arch ISO (recommended)

Option A: clone this repo, then run the script:

```sh
pacman -Sy --noconfirm git
git clone <YOUR_REPO_URL>
cd dots
sudo bash phase-1/install.sh
```

Option B: run directly from a URL (you host it somewhere like GitHub raw):

```sh
bash <(curl -fsSL "<RAW_INSTALL_SH_URL>")
```

Option C (recommended for URL mode): run the entrypoint and let it fetch step modules:

```sh
PHASE1_BASE_URL="<RAW_REPO_BASE_URL>" bash <(curl -fsSL "<RAW_REPO_BASE_URL>/phase-1/install.sh")
```

## What it does
- Partitions and formats `/dev/nvme0n1` + `/dev/nvme1n1` per `docs/partition-table.md`
- Installs base Arch to `/mnt` (Btrfs + FAT32 ESP)
- Installs and configures GRUB (UEFI)
- Creates a user, enables sudo + NetworkManager
- Installs `linux` by default (optionally `linux-lts` too)
- Optionally installs: `nvidia-open` + `nvidia-utils`, PipeWire + WirePlumber, Bluetooth, and CUDA
- Optionally installs: Podman + NVIDIA Container Toolkit (for GPU containers)
- Optionally installs: fonts + `nficon` icon library into the user's XDG dirs (`~/.local/share/nficon`, `~/.local/bin`)

## Script layout
- Entry point: `phase-1/install.sh`
- Steps: `phase-1/steps/` (partitioning, mounts, pacstrap, system config, hw stack)

## Safety
This script is destructive. It will **wipe the target disks** after an explicit confirmation prompt.

## Bluetooth auto-connect note
WirePlumber can auto-connect devices *after* you pair + trust them once. After first boot:

```sh
bluetoothctl
# power on
# agent on
# default-agent
# scan on
# pair <MAC>
# trust <MAC>
# connect <MAC>
```
