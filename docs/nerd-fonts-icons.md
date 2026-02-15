# Nerd Fonts Icons Library

Source of truth:
- `agents/skills/nerd-fonts-icons/icons.csv` (`name,codepoint_hex,glyph`)

Helpers:
- Lookup/search: `agents/tools/nficon`
- Export: `agents/tools/nficon-export`

## Exports (ready to use)

Generated (sorted by name) in:
- `agents/skills/nerd-fonts-icons/exports/icons.json` (map: name → `{codepoint_hex,glyph,printf_escape}`)
- `agents/skills/nerd-fonts-icons/exports/icons.lua` (Lua table)
- `agents/skills/nerd-fonts-icons/exports/icons.sh` (Bash maps + `nficon_glyph` helper)
- `agents/skills/nerd-fonts-icons/exports/icons.toml` (TOML tables)
- `agents/skills/nerd-fonts-icons/exports/icons.tsv` (tab-separated)

Regenerate:

```sh
agents/tools/nficon-export --format json --mode map --out agents/skills/nerd-fonts-icons/exports/icons.json
agents/tools/nficon-export --format lua --out agents/skills/nerd-fonts-icons/exports/icons.lua
agents/tools/nficon-export --format sh --out agents/skills/nerd-fonts-icons/exports/icons.sh
agents/tools/nficon-export --format toml --out agents/skills/nerd-fonts-icons/exports/icons.toml
agents/tools/nficon-export --format tsv --out agents/skills/nerd-fonts-icons/exports/icons.tsv
```

## Notes

- The icon set is currently a partial import; append more rows to `icons.csv` and re-run the export.
- `printf_escape` is provided for safe embedding in shells/config generators.

