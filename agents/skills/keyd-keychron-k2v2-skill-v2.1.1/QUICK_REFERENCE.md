# KEYD QUICK REFERENCE CHEAT SHEET

## 🔄 Git Workflow (PRIMARY)

```bash
# ALWAYS use this workflow:

# 1. Edit in dotfiles
vim ~/dotfiles/keyd/default.conf

# 2. Validate
sudo keyd check ~/dotfiles/keyd/default.conf

# 3. Deploy
sudo cp ~/dotfiles/keyd/default.conf /etc/keyd/default.conf
sudo keyd reload

# 4. Commit
cd ~/dotfiles/keyd/
git add default.conf
git commit -m "feat: description"

# 5. Rollback if needed
git revert HEAD
sudo cp default.conf /etc/keyd/default.conf
sudo keyd reload
```

---

## Essential Commands

```bash
# Monitor keypresses (find key names)
sudo keyd monitor
sudo keyd monitor -t  # with timing

# Configuration management
sudo keyd reload      # Reload configs
sudo keyd check       # Validate configs
keyd list-keys        # List all valid key names

# Debugging
sudo journalctl -eu keyd  # View logs
sudo keyd listen          # Monitor layer changes
KEYD_DEBUG=2 sudo keyd    # Verbose logging

# IPC (dynamic bindings)
sudo keyd bind 'key = action'
sudo keyd bind reset

# Emergency exit
Backspace + Escape + Enter  # Kill keyd
```

---

## Config File Template (Git-Tracked)

```bash
# Edit this file:
vim ~/dotfiles/keyd/default.conf
```

```ini
[ids]
*  # All keyboards (or specific ID: 04d9:0356)

[global]
# Optional timing settings
chord_timeout = 50
oneshot_timeout = 0
overload_tap_timeout = 0

[main]
# Your bindings here
capslock = overload(control, esc)

[layer_name]
# Additional layer bindings
```

```bash
# Deploy:
sudo keyd check ~/dotfiles/keyd/default.conf
sudo cp ~/dotfiles/keyd/default.conf /etc/keyd/default.conf
sudo keyd reload

# Commit:
cd ~/dotfiles/keyd/ && git add default.conf && git commit -m "update"
```

---

## All Overload Functions

| Function | Syntax | Use Case |
|----------|--------|----------|
| **overload** | `overload(layer, action)` | Basic tap/hold |
| **overloadt** | `overloadt(layer, action, timeout)` | Layer after timeout |
| **overloadt2** | `overloadt2(layer, action, timeout)` | Smart timeout (best for mods) |
| **overloadi** | `overloadi(action1, action2, idle)` | Context-aware (typing vs idle) |
| **lettermod** | `lettermod(layer, key, idle, hold)` | Homerow mods simplified |
| **oneshotk** | `oneshotk(layer, key)` | Oneshot + key fallback |
| **timeout** | `timeout(action1, timeout, action2)` | General timeout action |

---

## Layer Actions

```ini
# Temporary activation (while held)
key = layer(nav)

# One keypress only
key = oneshot(shift)

# Permanent toggle
key = toggle(caps)

# Replace active layer
key = swap(newlayer)

# Clear all active layers
key = clear()

# Change layout
key = setlayout(dvorak)
```

---

## Macro Syntax

```ini
# Simple keys
macro(a b c)

# Modifiers
macro(C-a)        # Control+a
macro(M-f)        # Meta+f
macro(A-tab)      # Alt+tab
macro(C-S-t)      # Control+Shift+t

# Simultaneous keys
macro(a+b+c)      # Press together

# With delays
macro(C-c 100ms C-v)

# Text/Unicode
macro(Hello World)
```

---

## Common Patterns

### CapsLock as Control/Escape (Git Workflow)
```bash
# Edit
vim ~/dotfiles/keyd/default.conf
```
```ini
capslock = overload(control, esc)
esc = capslock  # Optional: Move CapsLock to Esc
```
```bash
# Deploy
sudo keyd check ~/dotfiles/keyd/default.conf
sudo cp ~/dotfiles/keyd/default.conf /etc/keyd/default.conf
sudo keyd reload
git add ~/dotfiles/keyd/default.conf && git commit -m "feat: capslock ctrl/esc"
```

### Oneshot Modifiers
```ini
shift = oneshot(shift)
control = oneshot(control)
meta = oneshot(meta)
```

### Navigation Layer
```ini
capslock = layer(nav)

[nav]
h = left
j = down
k = up
l = right
```

### Homerow Mods (Basic)
```ini
a = lettermod(meta, a, 150, 200)
s = lettermod(alt, s, 150, 200)
d = lettermod(control, d, 150, 200)
f = lettermod(shift, f, 150, 200)
```

### Homerow Mods (Advanced)
```ini
a = overloadi(a, overloadt2(meta, a, 200), 150)
# Types 'a' when typing quickly
# Acts as Meta when held or idle
```

### Chords
```ini
[global]
chord_timeout = 50

[main]
j+k = esc
h+j = pagedown
```

### Symbol Layer
```ini
space = overloadt(symbols, space, 200)

[symbols]
a = !
s = @
d = #
f = $
```

---

## Modifiers Quick Reference

| Symbol | Modifier |
|--------|----------|
| C | Control |
| M | Meta/Super |
| A | Alt |
| S | Shift |
| G | AltGr |

---

## Layer Types

```ini
[main]           # Default layer
[nav]            # Regular layer
[nav:C]          # Layer with Control modifier
[nav:C-A]        # Control+Alt modifier
[ctrl+alt]       # Composite layer
[dvorak:layout]  # Layout (letters only)
```

---

## Timeout Values Guide

| Setting | Fast Typer | Normal | Deliberate |
|---------|------------|--------|------------|
| **Idle Timeout** | 100-120ms | 150ms | 200-250ms |
| **Hold Timeout** | 150-180ms | 200ms | 250-300ms |
| **Chord Timeout** | 30-40ms | 50ms | 60-80ms |

---

## Application-Specific Remapping

See **APP_REMAPPING.md** for complete guide.

```bash
# 1. Setup (one-time)
sudo usermod -aG keyd $USER
mkdir -p ~/dotfiles/keyd/

# 2. Create app config
vim ~/dotfiles/keyd/app.conf
```

```ini
[firefox]
alt.tab = C-tab
meta.t = C-t

[alacritty]
meta.c = C-S-c
meta.v = C-S-v
```

```bash
# 3. Deploy
cp ~/dotfiles/keyd/app.conf ~/.config/keyd/app.conf
keyd-application-mapper -d

# 4. Commit
cd ~/dotfiles/keyd/
git add app.conf
git commit -m "feat: app-specific bindings"
```

---

## Aliases

```ini
[aliases]
thumbkey = space       # Create alias
leftalt = meta         # Swap key identity

[main]
thumbkey = layer(nav)  # Use alias
```

---

## Global Settings Reference

```ini
[global]
macro_timeout = 600              # Initial repeat (ms)
macro_repeat_timeout = 50        # Repeat rate (ms)
macro_sequence_timeout = 0       # Between macro keys (μs)
layer_indicator = 0              # LED indicator (0/1) - BROKEN ON WAYLAND
chord_timeout = 50               # Chord window (ms)
chord_hold_timeout = 0           # Chord hold time (ms)
oneshot_timeout = 0              # Oneshot expiry (ms, 0=never)
overload_tap_timeout = 0         # Ignore tap after (ms)
default_layout = main            # Starting layout
```

---

## File Inclusion

```ini
# In config file
include common
include layouts/dvorak

# Files must be in:
# - /etc/keyd/
# - /usr/share/keyd/
```

---

## Special Keys

```ini
# Disable key
key = noop

# Repeat last action
key = repeat()

# Execute command (as root!)
key = command(brightness up)
```

---

## Debugging Checklist

- [ ] Config file has `[ids]` section
- [ ] Config file ends in `.conf`
- [ ] Device ID matches (check with `sudo keyd monitor`)
- [ ] No duplicate device IDs in multiple configs
- [ ] Layer names are valid (max 64 chars)
- [ ] Composite layers defined after components
- [ ] Check logs: `sudo journalctl -eu keyd`
- [ ] Validate: `sudo keyd check ~/dotfiles/keyd/default.conf`
- [ ] Committed to Git: `git log ~/dotfiles/keyd/`

---

## Common Mistakes

❌ **Wrong:**
```ini
capslock = overload(rightcontrol, esc)  # Can't specify left/right
[layer1+layer2]  # Defined before layer1
[ids]            # Missing this section
```

✅ **Correct:**
```ini
capslock = overload(control, esc)  # Use generic modifier
[layer1]
[layer2]
[layer1+layer2]  # After components
[ids]
*
```

---

## Emergency Recovery

If keyboard becomes unusable:

1. **Press:** `Backspace + Escape + Enter` (simultaneously)
2. **Boot to TTY:** `Ctrl+Alt+F2`
3. **Stop service:** `sudo systemctl stop keyd`
4. **Rollback via Git:**
   ```bash
   cd ~/dotfiles/keyd/
   git revert HEAD
   sudo cp default.conf /etc/keyd/default.conf
   ```
5. **Restart:** `sudo systemctl start keyd`

---

## Example Configs (Git Workflow)

All examples assume you edit in `~/dotfiles/keyd/default.conf` and deploy to `/etc/keyd/`.

### Minimal (Essential Ergonomics)
```ini
[ids]
04d9:0356

[main]
capslock = overload(control, esc)
shift = oneshot(shift)
```

### Intermediate (Vim Navigation)
```ini
[ids]
04d9:0356

[main]
capslock = layer(nav)
space = overloadt(symbols, space, 200)

[nav:C]
h = left
j = down
k = up
l = right

[symbols]
a = 1
s = 2
d = 3
```

### Advanced (Homerow Mods)
```ini
[ids]
04d9:0356

[global]
oneshot_timeout = 2000

[main]
a = lettermod(meta, a, 150, 200)
s = lettermod(alt, s, 150, 200)
d = lettermod(control, d, 150, 200)
f = lettermod(shift, f, 150, 200)

j = lettermod(shift, j, 150, 200)
k = lettermod(control, k, 150, 200)
l = lettermod(alt, l, 150, 200)
; = lettermod(meta, ;, 150, 200)

capslock = layer(nav)

[nav]
h = left
j = down
k = up
l = right
u = pageup
d = pagedown
```

**After creating any config:**
```bash
sudo keyd check ~/dotfiles/keyd/default.conf
sudo cp ~/dotfiles/keyd/default.conf /etc/keyd/default.conf
sudo keyd reload
cd ~/dotfiles/keyd/ && git add default.conf && git commit -m "description"
```

---

## Resources

- **GitHub:** https://github.com/rvaiya/keyd
- **Man Page:** `man keyd`
- **IRC:** #keyd on OFTC
- **Key Names:** `keyd list-keys`
- **This Skill:** See SKILL.md, CONSTRAINTS.md, EXAMPLES_SHORT.md, APP_REMAPPING.md

---

## Version Info

Check your version:
```bash
keyd --version
```

Latest stable release tags: https://github.com/rvaiya/keyd/tags

---

**Git workflow is mandatory - all changes should be version controlled!**

**Version**: 2.1.1  
**Last Updated**: 2024-02-11
