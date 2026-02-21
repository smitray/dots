# dots

Two-phase Arch + Hyprland install and dotfiles.

## Quick Start (Phase 1 from Arch Live ISO)

Boot into the Arch Live ISO, connect to the internet, then run:

```bash
curl -fsSL https://raw.githubusercontent.com/smitray/dots/main/phase-1/install.sh | \
  PHASE1_BASE_URL="https://raw.githubusercontent.com/smitray/dots/main" bash
```

This will:
- Partition and format two NVMe SSDs (system + data)
- Install a minimal Arch Linux with GRUB
- Set up Snapper for automatic Btrfs snapshots (30-day retention)
- Create a user with sudo access
- Reboot into a working TTY + NetworkManager system

## Partition Layout

### System Disk (`/dev/nvme0n1`) -- Disposable, wiped on reinstall

| Part | Size | Mount | Purpose |
|------|------|-------|---------|
| p1 | 2 GiB | `/boot` | EFI (GRUB) |
| p2 | 32 GiB | [swap] | Disk swap + hibernation |
| p3 | 140 GiB | `/` | Root filesystem + Snapper snapshots |
| p4 | 726 GiB | `/downloads` | ISOs, media, temp files |

### Data Disk (`/dev/nvme1n1`) -- Persistent, survives reinstall

| Part | Size | Mount | Purpose |
|------|------|-------|---------|
| p1 | 80 GiB | `/home` | User configs, dotfiles, runtimes |
| p2 | 300 GiB | `/workspace` | Development projects |
| p3 | 80 GiB | `/obsidian` | Notes vault |
| p4 | 440 GiB | `/srv` | Containers, databases, services |

## Snapshot Rollback

Powered by **Snapper** + **snap-pac** + **grub-btrfs-support**:
- Every `pacman -Syu` automatically creates pre/post snapshots
- Snapshots appear in the GRUB boot menu
- Select a snapshot at boot to roll back instantly
- Snapshots older than 30 days are auto-cleaned

## Docs
- `docs/partition-table.md` -- Full partition spec
- `docs/phase-1.md` -- Phase 1 design
- `docs/phase-2.md` -- Phase 2 design (post-reboot)
- `docs/decisions.md` -- Architecture decisions

## Structure
- `phase-1/` -- Minimal install (partitioning + base system + GRUB + Snapper)
- `phase-2/` -- Post-reboot packages + Hyprland + dotfiles (TBD)
- `agents/` -- Agent skills, prompts, and tools

## Project-Local Skills
This repo keeps skills under `agents/skills/`.

- Codex loads skills from `.codex/skills/` (a symlink to `agents/skills/` in this repo).
- The `npx skills` manager installs to `.agents/skills/` (kept as symlinks into `agents/skills/`).

For Codex, run with a repo-local home so skills are picked up from this checkout:

```sh
CODEX_HOME="$PWD/.codex" codex
```
