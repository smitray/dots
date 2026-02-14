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

## Project-Local Skills
This repo keeps skills under `agents/skills/`. For Codex, run with a repo-local home so skills are picked up from this checkout:

```sh
CODEX_HOME="$PWD/.codex" codex
```
