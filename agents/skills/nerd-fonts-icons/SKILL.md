---
name: nerd-fonts-icons
description: Work with Nerd Fonts glyphs (icon names, codepoints, and glyph characters) and use them consistently across shell prompts, Hyprland/Waybar configs, and scripts.
---

# Nerd Fonts Icons

This skill helps you manage a **project-local Nerd Fonts icon library** so you can reliably reuse the same glyphs across:
- Zsh prompt / Starship
- Waybar / Wofi / Rofi
- Hyprland configs (e.g., workspace labels)
- Scripts that print icons

## Library file

- Icon map: `agents/skills/nerd-fonts-icons/icons.csv`
  - Format: `name,codepoint_hex,glyph`
  - Example: `nf-fa-font_awesome,f2b4,`

## Common workflows

### Use the included lookup tool

This repo includes a tiny helper:
- `agents/tools/nficon`

Examples:

```sh
# search (case-insensitive regex on name)
agents/tools/nficon 'nf-cod-(github|git_commit|debug)'

# exact lookup
agents/tools/nficon --name nf-cod-github

# print just the glyph (useful for scripts/config generation)
agents/tools/nficon --glyph nf-cod-github

# convert a hex codepoint to a printf escape
agents/tools/nficon --to-printf f2b4
```

### Find an icon by name prefix

```sh
rg '^nf-cod-' agents/skills/nerd-fonts-icons/icons.csv | head
rg '^nf-fa-' agents/skills/nerd-fonts-icons/icons.csv | head
```

### Search by keyword

```sh
rg -i 'bluetooth|nvidia|archlinux|hyprland|docker|podman' agents/skills/nerd-fonts-icons/icons.csv
```

### Print a glyph from a codepoint (Bash)

For codepoints **≤ `ffff`**:

```sh
printf '\uf2b4\n'
```

For codepoints **> `ffff`**, use an 8-hex-digit `\UXXXXXXXX` escape (example uses `f16e0`):

```sh
printf '\U000f16e0\n'
```

### Extract just `name` and `glyph`

```sh
awk -F, '{print $1 "\t" $3}' agents/skills/nerd-fonts-icons/icons.csv | head
```

## Practical reminders

- Glyphs only render if your UI component uses a Nerd Font (or a Nerd Fonts symbols font) in its `font-family`.
- Prefer referencing the **glyph character** in configs (Waybar, Hyprland) and keep the **name+codepoint** in `icons.csv` as the source-of-truth.
- When you share configs across machines, keep the font install consistent (same Nerd Font family) to avoid missing glyphs.

## Updating the library

Append new icons as `name,codepoint_hex,glyph` lines to:
- `agents/skills/nerd-fonts-icons/icons.csv`
