# dots

Two-phase Arch + Hyprland install and dotfiles.

## Docs
- `docs/PRD.md`
- `docs/partition-table.md`
- `docs/phase-1.md`
- `docs/phase-2.md`
- `docs/decisions.md`

## Structure
- `phase-1/`: minimal install + partitioning + base system
- `phase-2/`: post-reboot packages + Hyprland + dotfiles
- `agents/`: agent setup, prompts, and skills
- `docs/`: specs and PRD

## Phase 1 entrypoint
- Script: `phase-1/install.sh` (run from the live ISO; interactive prompts; see `phase-1/README.md`)

## Run Phase 1 from Arch ISO (curl)
The Phase 1 installer is **bash** (not POSIX `sh`). When running from the live ISO, you can execute it directly from a hosted repo:

```sh
PHASE1_BASE_URL="<RAW_REPO_BASE_URL>" \
  curl -fsSL "<RAW_REPO_BASE_URL>/phase-1/install.sh" | bash
```

Example (GitHub raw):

```sh
PHASE1_BASE_URL="https://raw.githubusercontent.com/<user>/<repo>/<branch>" \
  curl -fsSL "https://raw.githubusercontent.com/<user>/<repo>/<branch>/phase-1/install.sh" | bash
```

## Project-Local Skills
This repo keeps skills under `agents/skills/`. For Codex, run with a repo-local home so skills are picked up from this checkout:

```sh
CODEX_HOME="$PWD/.codex" codex
```
