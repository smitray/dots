# Phase 1: Minimal Install (Pre-Reboot)

**Goal**: Partition disks, install base Arch, configure GRUB + Snapper, and do only the minimum needed to reboot into a working system (TTY + network + sudo + snapshot rollback).

**Non-goals** (Phase 2):
- Dotfiles deployment (stow/symlinks)
- Hyprland / Wayland desktop setup
- NVIDIA driver + CUDA setup
- Fonts, AUR helpers, runtime managers

## Quick Start

From the Arch Live ISO:

```bash
curl -fsSL https://raw.githubusercontent.com/smitray/dots/main/phase-1/install.sh | \
  PHASE1_BASE_URL="https://raw.githubusercontent.com/smitray/dots/main" bash
```

Or from a local clone:

```bash
sudo ./phase-1/install.sh
```

## Inputs
- Partition table: `docs/partition-table.md`
- Target disks: `/dev/nvme0n1` (system) and `/dev/nvme1n1` (data)
- Bootloader: GRUB (UEFI)
- Script: `phase-1/install.sh`
- Step modules: `phase-1/steps/`

## Installation Flow

| Step | Script | What it does |
| :--- | :--- | :--- |
| 1 | `00-common.sh` | Defines helpers (`die`, `log`, `need`), checks root + UEFI, validates tools |
| 2 | `10-prompts.sh` | Collects: disk paths, hostname, username, password, timezone, locale, keymap |
| 3 | `20-partition.sh` | Detects existing partitions via `blkid`. Creates partitions only if missing |
| 4 | `30-format-mount.sh` | Formats system disk (always). Formats data disk (first install only). Mounts all |
| 5 | `40-pacstrap.sh` | Installs base system + snapper + snap-pac + grub-btrfs-support. Generates fstab |
| 6 | `50-chroot-config.sh` | Configures locale, network, user, sudo, Snapper, GRUB inside chroot |
| 7 | `90-main.sh` | Orchestrates the above steps in order |

## Partition Detection Logic

| Disk | Label Check | Found | Not Found |
| :--- | :--- | :--- | :--- |
| System (`nvme0n1`) | `blkid -L ARCH_ROOT` | Skip repartition, format always | Repartition + format |
| Data (`nvme1n1`) | `blkid -L ARCH_HOME` | Mount only (data preserved) | Repartition + format |

## Packages Installed

```
base linux linux-firmware amd-ucode btrfs-progs
grub efibootmgr networkmanager sudo git zsh vim
snapper snap-pac grub-btrfs-support
```

## Snapshot Configuration

| Setting | Value |
| :--- | :--- |
| `NUMBER_LIMIT` | 20 (max pacman-triggered snapshots) |
| `NUMBER_LIMIT_IMPORTANT` | 10 |
| `TIMELINE_LIMIT_DAILY` | 30 (30-day retention) |
| `TIMELINE_LIMIT_HOURLY/WEEKLY/MONTHLY/YEARLY` | 0 (disabled) |

Services enabled:
- `snapper-cleanup.timer` -- auto-deletes old snapshots
- `snapper-timeline.timer` -- periodic timeline snapshots
- `grub-btrfsd.service` -- watches `/.snapshots`, updates GRUB menu

## Outputs
- Bootable minimal Arch system with TTY + NetworkManager
- Mount points created as per `docs/partition-table.md`
- GRUB installed and configured with snapshot boot entries
- Snapper configured with 30-day retention policy
- User created with sudo access

## What Happens After Reboot
1. Log in with your username and password
2. `NetworkManager` is running -- connect to wifi with `nmcli` if needed
3. Ready for Phase 2 (Hyprland, NVIDIA, dotfiles, mise, etc.)
