# Phase 2: Full Setup (Post-Reboot)

**Goal**: Install Hyprland stack, utilities, dotfiles, and services.

## Responsibilities
- Full package install (Hyprland + apps)
- Dotfiles deploy (stow)
- Utilities setup (keyd, etc.)
- Services enablement
- NVIDIA: install open kernel module driver + userland (`nvidia-open`, `nvidia-utils`)
- CUDA: install toolkit (`cuda`) and verify `nvidia-smi` + toolchain

## TBD
- Exact package lists
- Dotfiles layout and stow targets
- Service set (audio, network, containers)
