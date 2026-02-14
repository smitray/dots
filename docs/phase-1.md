# Phase 1: Minimal Install (Pre-Reboot)

**Goal**: Partition disks, install base Arch, configure bootloader (GRUB), and set up mount points.

## Inputs
- Partition table: `docs/partition-table.md`
- Target disks: `/dev/nvme0n1` and `/dev/nvme1n1`
- Bootloader: GRUB (UEFI)

## Responsibilities
- Disk partitioning and filesystem creation
- Base system install
- fstab generation
- GRUB installation
- Enable minimal services needed for boot

## Outputs
- Bootable minimal Arch system
- Mount points created as per partition table
- GRUB installed and configured

## TBD
- Package list for base install
- Locale, timezone, hostname
- User creation
- Network setup
