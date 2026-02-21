# Session Review: Project Critique
**Date**: 2026-02-17  
**Time**: Morning session  
**Next Session**: After 3pm IST, same day

---

## 📋 Project Understanding

### What This Is
A **two-phase Arch Linux + Hyprland dotfiles and installer project** for a dual-NVMe workstation with NVIDIA GPU.

### Architecture Summary

**Dual-NVMe Philosophy**:
| Disk | Purpose | Partitions |
|------|---------|------------|
| **NVMe 0 (System)** | Disposable OS | `/boot` (2GB), `[swap]` (32GB), `/` (140GB), `/backup` (180GB), `/downloads` (546GB) |
| **NVMe 1 (Data)** | Persistent data | `/home` (80GB), `/workspace` (300GB), `/obsidian` (80GB), `/srv` (440GB) |

**Key Design Choices**:
- Btrfs with `compress=zstd:1` on all data partitions
- 10% unallocated headroom on both drives
- GRUB (UEFI) bootloader
- `nvidia-open` + `nvidia-utils` + CUDA
- Podman + NVIDIA Container Toolkit
- mise for tool version management
- keyd for keyboard remapping (Keychron K2v2)

---

## 🔴 Critical Flaws (Must Fix)

### 1. Phase 2 is Empty
The entire post-reboot setup—Hyprland, dotfiles, services, stow—is **completely missing**. This is the most valuable part of a dotfiles repo.

**Impact**: Users get a bootable TTY with no path to a working desktop.

**Fix Required**: Implement `phase-2/` with:
- Package installation (Hyprland, apps, utilities)
- Dotfiles deployment (stow or symlink manager)
- Service enablement (audio, network, bluetooth)
- NVIDIA driver verification
- CUDA + Container toolkit setup

---

### 2. No Testing / Validation
- Zero automated tests for scripts
- No `shellcheck` configuration
- No CI/CD pipeline
- No validation that the installed system actually boots
- No error recovery mechanisms

**Fix Required**:
- Add `shellcheck` to all bash scripts
- Create test harness for script logic
- Add validation steps post-install
- Consider VM-based testing (QEMU)

---

### 3. Hardcoded Disk Assumptions
```bash
SYSTEM_DISK="/dev/nvme0n1"
DATA_DISK="/dev/nvme1n1"
```

**Risk**: Script will silently wipe wrong disks if device names don't match.

**Fix Required**:
- Auto-detect available NVMe drives
- Show detected disks with models/sizes
- Require explicit confirmation per disk
- Add `--dry-run` mode

---

### 4. No Rollback Mechanism
Once Phase 1 runs, there's no undo. Mid-install failure = partially partitioned bricks.

**Fix Required**:
- Document manual recovery steps
- Consider pre-partition backup warning
- Add rescue mode documentation

---

### 5. PRD is a Placeholder
`docs/PRD.md` has 3 lines saying "TBD". Implementation exists before requirements are defined.

**Fix Required**: Write actual PRD with:
- User stories
- Acceptance criteria
- Non-goals
- Success metrics

---

## 🟡 Design Concerns (Should Fix)

### 6. Curl | Bash Security Theater
```bash
curl -fsSL "<url>/phase-1/install.sh" | bash
```

**Issues**:
- No integrity verification (no checksums, no GPG)
- MITM vulnerability during download
- No offline installation option

**Fix Required**:
- Add SHA256 checksums for all scripts
- Document offline installation (git clone method)
- Consider GPG signing for releases

---

### 7. Skill System Over-Engineering
9 skills for a dotfiles repo is excessive. Quality varies significantly:

| Skill | Assessment |
|-------|------------|
| `git-commit` | ✅ Solid, useful |
| `hyprland` | ✅ Comprehensive (92 docs indexed) |
| `mise-expert` | ✅ High quality, detailed |
| `keyd-keychron-k2v2` | ⚠️ 2000+ lines for one keyboard |
| `nerd-fonts-icons` | ⚠️ Over-engineered |
| `zsh` | ❌ Thin (30 lines of obvious advice) |
| `bash-linux` | ⚠️ Overlaps with bash-scripting |
| `bash-scripting` | ⚠️ Overlaps with bash-linux |
| `font-stack` | ? Content unknown |

**Fix Required**:
- Merge `bash-linux` + `bash-scripting`
- Consider trimming `keyd` skill
- Expand or remove `zsh` skill

---

### 8. Nerd Fonts Icon Library is Over-Engineered
A CSV with glyphs, export tools in 5 formats (JSON, Lua, Shell, TOML, TSV), and lookup utilities... for what?

**Reality Check**: Most users just copy-paste glyphs from nerd-fonts.com

**Fix Required**: Justify or simplify. Consider:
- Keep only `icons.csv` + simple lookup
- Remove multi-format exports unless actually used

---

### 9. No User Customization Story
Install uses environment variables:
```bash
LOCALE="en_US.UTF-8" USERNAME="foo" ...
```

But there's no:
- Example `.env` file
- Interactive prompts documented
- Post-install customization guide
- Migration path for existing users

**Fix Required**:
- Add `.env.example` file
- Document all customizable variables
- Add FAQ for common customizations

---

### 10. Btrfs Without Subvolumes
Using Btrfs but not leveraging subvolumes for snapshots. The `/backup` partition waits for Timeshift, but there's no subvolume layout (`@`, `@home`, `@snapshots`).

**Fix Required**:
- Add subvolume layout to partition scheme
- Update `30-format-mount.sh` for subvolumes
- Document snapshot workflow

---

## 🟢 What's Actually Good (Keep)

1. ✅ **Partition table documentation** — Excellent, clear, specific, with fstab template
2. ✅ **Two-phase architecture** — Correct mental model
3. ✅ **Disposable OS / Persistent Data** — Sound philosophy
4. ✅ **10% headroom on Btrfs** — Shows filesystem understanding
5. ✅ **GRUB + UEFI** — Boring, correct choice
6. ✅ **mise over asdf** — Good call for 2025
7. ✅ **Podman over Docker** — Aligns with rootless future
8. ✅ **Step module separation** — Clean organization in Phase 1

---

## 📊 Verdict

| Category | Score | Notes |
|----------|-------|-------|
| Architecture | 7/10 | Right ideas, incomplete execution |
| Implementation | 5/10 | Phase 1 works, Phase 2 missing |
| Documentation | 6/10 | Good specs, missing user guides |
| Safety | 4/10 | Destructive with minimal guardrails |
| Polish | 3/10 | No tests, no CI, no validation |
| Agent Skills | 5/10 | Over-engineered, uneven quality |

**Overall: 5/10 — Promising foundation, incomplete product**

---

## 🔧 Priority Fixes (Ordered)

1. **Build Phase 2** — This is the actual dotfiles
2. **Add subvolume layout** — Make Btrfs matter
3. **Add disk detection + confirmation** — Show what will be wiped
4. **Add checksums** — At least SHA256 for scripts
5. **Write the PRD** — Define "done"
6. **Cut the skill bloat** — Merge overlapping skills, delete thin ones
7. **Add a dry-run mode** — Let users see what would happen

---

## 📝 Session Notes

### Files Reviewed
- `README.md` — Project overview
- `AGENTS.md` — Agent configuration
- `docs/PRD.md` — Empty placeholder
- `docs/partition-table.md` — Detailed spec
- `docs/phase-1.md`, `docs/phase-2.md` — Phase specs
- `docs/decisions.md` — Tech choices
- `phase-1/install.sh` — Entrypoint script
- `phase-1/steps/*.sh` — 12 step modules
- `phase-2/` — Empty directory
- `agents/skills/*/SKILL.md` — 9 skill documents

### Key Commands Discovered

**Run Phase 1 from Arch ISO**:
```bash
# From git clone
pacman -Sy --noconfirm git
git clone <repo>
cd dots
sudo bash phase-1/install.sh

# From URL (raw)
PHASE1_BASE_URL="<raw-url>" \
  curl -fsSL "<raw-url>/phase-1/install.sh" | bash
```

**Nerd Fonts tools**:
```bash
# Lookup icons
agents/tools/nficon 'nf-cod-github'

# Export library
agents/tools/nficon-export --format json --out icons.json
```

**Codex with local skills**:
```bash
CODEX_HOME="$PWD/.codex" codex
```

---

## 🎯 Next Session Agenda (After 3pm IST)

1. Decide which priority fixes to tackle first
2. Plan Phase 2 implementation
3. Discuss skill consolidation strategy
4. Review subvolume design for Btrfs

---

*Generated by Qwen Code during project review session.*
