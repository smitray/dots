---
name: font-stack
description: Install and configure preferred fonts (Iosevka Nerd Font, JetBrainsMono Nerd Font) plus multilingual fallbacks (Bengali, Hindi/Devanagari, CJK, emoji) on Arch Linux so terminals and browsers don’t show tofu boxes.
---

# Font Stack (Arch Linux)

Use this skill when setting up fonts on Arch (Hyprland/Waybar/terminal/browsers) with:
- **Monospace**: Iosevka Nerd Font, JetBrainsMono Nerd Font
- **Fallback coverage**: global coverage via Noto (CJK, emoji, symbols, Indic, etc.)

Note: there is no single font file that covers all of Unicode perfectly; on Linux you get “works everywhere” by installing a strong *fallback stack* and letting **fontconfig** pick the right face per script.

## Install packages

### Core coverage (recommended)

```sh
sudo pacman -S --needed \
  noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra \
  ttf-dejavu ttf-liberation
```

### Personal monospace (recommended)

If you want your UI/terminal monospace to be JetBrains/Iosevka while still keeping global fallback coverage:

```sh
sudo pacman -S --needed ttf-jetbrains-mono ttf-iosevka
```

If you want Nerd Font icons without installing a full Nerd-patched monospace, install symbol fallbacks:

```sh
sudo pacman -S --needed ttf-nerd-fonts-symbols ttf-nerd-fonts-symbols-mono
```

### Last-resort tofu killers (optional)

If you still see boxes for rare/obscure codepoints (historic scripts, very rare CJK extensions), add one or both:

```sh
sudo pacman -S --needed gnu-unifont ttf-hanazono
```

### Indic coverage (if you still see boxes)

Try one (availability varies by repo state):

```sh
sudo pacman -S --needed ttf-indic-otf
```

### Nerd Fonts (preferred monospace)

These are often from AUR (name varies). Search first:

```sh
pacman -Ss 'iosevka.*nerd|jetbrains.*nerd' || true
```

If you use an AUR helper:

```sh
paru -S --needed ttf-iosevka-nerd ttf-jetbrains-mono-nerd
```

If those package names don’t exist, search AUR and install the closest matches (common alternates include `nerd-fonts-iosevka` / `nerd-fonts-jetbrains-mono`).

## Configure fontconfig defaults

This repo includes a ready-to-drop fontconfig snippet:
- `agents/skills/font-stack/assets/60-preferred-fonts.conf`

Install it for your user:

```sh
mkdir -p ~/.config/fontconfig/conf.d
cp -f agents/skills/font-stack/assets/60-preferred-fonts.conf ~/.config/fontconfig/conf.d/
fc-cache -f
```

Verify what will be chosen:

```sh
fc-match monospace
fc-match sans
fc-match serif
```

## Browser notes

- Firefox/Chromium on Linux generally follow **fontconfig** fallbacks.
- If a specific script still renders as boxes, confirm the font is installed, then check:
  - `fc-match 'sans:lang=bn'`
  - `fc-match 'sans:lang=hi'`
  - `fc-match 'sans:lang=ja'` / `zh-cn` / `ko`
