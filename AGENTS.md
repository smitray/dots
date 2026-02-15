# AGENTS

Local agent instructions for this repository.

## Structure
- `agents/skills/`: reusable skills and automations
- `agents/prompts/`: prompt templates
- `agents/tools/`: helper scripts or tool configs
- `.codex/skills/`: symlink to `agents/skills/` (Codex loads skills from here)
- `.agents/skills/`: skill-manager compatible path (keep entries as symlinks into `agents/skills/`)

## Notes
- Keep skills documented with a `SKILL.md` per skill directory.
- Add PRD/specs in `docs/`.
- When adding a new skill, prefer committing it under `agents/skills/<skill>/SKILL.md`, then add a symlink at `.agents/skills/<skill>` pointing to `../../agents/skills/<skill>` for `npx skills` compatibility.
