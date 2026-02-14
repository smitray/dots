# EXAMPLES.md - K2v2 Configuration Examples

Quick-start configs with Git workflow. See REFERENCE_WIKI.md for detailed explanations.

**All examples use Git-tracked dotfiles workflow:**
```bash
# Edit in dotfiles
vim ~/dotfiles/keyd/default.conf

# Validate and deploy
sudo keyd check ~/dotfiles/keyd/default.conf
sudo cp ~/dotfiles/keyd/default.conf /etc/keyd/default.conf
sudo keyd reload

# Commit
cd ~/dotfiles/keyd/
git add default.conf
git commit -m "feat: your change description"
```

---

## Example 1: Essential Ergonomics (Starting Point)

**Goal**: Reduce pinky strain, make CapsLock useful

```ini
[ids]
04d9:0356  # Your K2v2

[main]
capslock = overload(control, esc)
shift = oneshot(shift)
```

**What this does**:
- CapsLock: Hold=Control, Tap=Escape (perfect for Neovim)
- Shift: Tap once, types one capital letter, auto-releases

**Test it**: Type normally, hold CapsLock+C for copy, tap CapsLock for Escape

---

## Example 2: Vim Navigation Layer

**Goal**: hjkl navigation everywhere (browser, terminal, editor)

```ini
[ids]
04d9:0356

[main]
capslock = layer(nav)
rightalt = layer(symbols)

[nav:C]
h = left
j = down
k = up
l = right
u = pageup
d = pagedown

[symbols]
a = !  s = @  d = #  f = $  g = %
```

**What this does**:
- Hold CapsLock: hjkl becomes arrows, u/d for page up/down
- Inherits Control (`:C`) so Ctrl+CapsLock+H = Ctrl+Left
- RightAlt: Quick symbol access on home row

**Test it**: Hold CapsLock, press h/j/k/l in browser

---

## Example 3: Programmer's Layout

**Goal**: Fast symbol access, brackets, numbers

```ini
[ids]
04d9:0356

[global]
oneshot_timeout = 2000

[main]
capslock = overload(control, esc)
rightalt = layer(symbols)
rightcontrol = layer(brackets)
space = overloadt(numbers, space, 200)

[symbols]
a = !  s = @  d = #  f = $  g = %
h = ^  j = &  k = *  l = (  ; = )

[brackets]
q = {  w = }  e = [  r = ]  t = <  y = >

[numbers]
a = 1  s = 2  d = 3  f = 4  g = 5
h = 6  j = 7  k = 8  l = 9  ; = 0
```

**What this does**:
- CapsLock: Control/Escape overload
- RightAlt: Symbols on home row
- RightCtrl: Brackets for coding
- Space: Hold for numbers layer (200ms timeout)

**Test it**: Hold RightAlt+A for !, RightCtrl+Q for {

---

## Example 4: Enhanced Navigation Column

**Goal**: Make K2v2's existing nav keys dual-purpose

```ini
[ids]
04d9:0356

[main]
capslock = overload(control, esc)

# Enhance existing nav column
pageup = overload(home, pageup)      # Hold=Home, Tap=PgUp
pagedown = overload(end, pagedown)   # Hold=End, Tap=PgDn
home = overload(pageup, home)        # Hold=PgUp, Tap=Home
end = overload(pagedown, end)        # Hold=PgDn, Tap=End
```

**What this does**:
- Leverages K2v2's dedicated nav column
- Each key does two things (tap vs hold)
- No hand movement from typing position

**Test it**: Tap PgUp normally, hold for Home

---

## Example 5: Application-Specific Bindings

**Goal**: Different shortcuts in Firefox vs Terminal

**Main config** (`~/dotfiles/keyd/default.conf`):
```ini
[ids]
04d9:0356

[main]
capslock = overload(control, esc)
```

**App config** (`~/dotfiles/keyd/app.conf`):
```ini
[firefox]
# Use Alt for tabs (Meta reserved for Hyprland)
alt.tab = C-tab
alt.shift.tab = C-S-tab
meta.t = C-t
meta.w = C-w

[alacritty]
# Terminal copy/paste with Meta
meta.c = C-S-c
meta.v = C-S-v
```

**Deployment**:
```bash
# Main config
sudo cp ~/dotfiles/keyd/default.conf /etc/keyd/default.conf
sudo keyd reload

# App config
cp ~/dotfiles/keyd/app.conf ~/.config/keyd/app.conf
keyd-application-mapper -d

# Commit both
cd ~/dotfiles/keyd/
git add default.conf app.conf
git commit -m "feat: add app-specific bindings"
```

See **APP_REMAPPING.md** for complete guide.

---

## Choosing Your Starting Point

**If you want**: Minimal change, maximum impact
→ **Start with Example 1** (CapsLock ergonomics)

**If you're**: Heavy Vim user, want hjkl everywhere
→ **Start with Example 2** (Navigation layer)

**If you need**: Fast symbol/bracket access for coding
→ **Start with Example 3** (Programmer layout)

**If you want**: To enhance K2v2's existing strengths
→ **Start with Example 4** (Nav column enhancement)

**If you need**: Different shortcuts per application
→ **Start with Example 5** + read APP_REMAPPING.md

---

## Iteration Strategy

**Don't copy-paste everything at once!**

1. **Pick ONE example** that solves your biggest pain point
2. **Deploy and test** for a few days
3. **Tune timing** if needed (adjust 200ms values)
4. **Commit when stable**
5. **Add next feature** when muscle memory is solid

**Git makes experimentation safe:**
```bash
# Try something new
vim ~/dotfiles/keyd/default.conf
# ... test ...

# Doesn't work? Rollback:
git revert HEAD
sudo cp ~/dotfiles/keyd/default.conf /etc/keyd/default.conf
sudo keyd reload
```

---

## Timing Tuning Guide

If you get false triggers or delayed responses:

**Overload timing values**:
- Fast typer: 150-180ms
- Normal: 200ms (recommended starting point)
- Deliberate: 250-300ms

**How to tune**:
1. Start at 200ms
2. If you get false triggers (Esc when you want Ctrl): increase by 20ms
3. If response feels delayed: decrease by 20ms
4. Test for a day, commit when it feels right

**Example**:
```ini
# Too sensitive (adjust from 200ms to 220ms)
capslock = overloadt2(control, esc, 220)
```

---

## Complete K2v2 Reference Config

**Combining multiple examples** (advanced):

```ini
[ids]
04d9:0356

[global]
oneshot_timeout = 2000

[main]
# Essential ergonomics
capslock = overload(control, esc)
shift = oneshot(shift)

# Layer triggers
rightalt = layer(symbols)
rightcontrol = layer(nav)

# Enhanced nav column
pageup = overload(home, pageup)
pagedown = overload(end, pagedown)

[nav:C]
# Vim navigation
h = left
j = down
k = up
l = right
u = pageup
d = pagedown

[symbols]
# Programmer symbols
a = !  s = @  d = #  f = $  g = %
h = ^  j = &  k = *  l = (  ; = )
q = {  w = }  e = [  r = ]
```

**Deployment**:
```bash
vim ~/dotfiles/keyd/default.conf
# Paste config above

sudo keyd check ~/dotfiles/keyd/default.conf
sudo cp ~/dotfiles/keyd/default.conf /etc/keyd/default.conf
sudo keyd reload

cd ~/dotfiles/keyd/
git add default.conf
git commit -m "feat: complete K2v2 ergonomic config"
```

---

## Common Mistakes to Avoid

❌ **Don't**: Copy the entire reference config without testing incrementally  
✅ **Do**: Start with one example, test, then add more

❌ **Don't**: Edit `/etc/keyd/default.conf` directly  
✅ **Do**: Edit `~/dotfiles/keyd/default.conf`, then deploy

❌ **Don't**: Forget to commit working configs  
✅ **Do**: `git commit` after every successful change

❌ **Don't**: Try to remap Fn or Light keys  
✅ **Do**: Use RightCtrl or RightAlt as alternatives

❌ **Don't**: Override Meta key (Hyprland needs it)  
✅ **Do**: Use Alt, CapsLock, RightAlt, RightCtrl for layers

---

## Next Steps

1. **Pick an example** that matches your needs
2. **Read the relevant SKILL.md sections** for context
3. **Deploy using Git workflow**
4. **Test thoroughly** before committing
5. **Iterate gradually** - don't rush
6. **Check ANTI_PATTERNS_SHORT.md** to avoid common mistakes
7. **Read APP_REMAPPING.md** if you need per-app bindings

---

**See also**:
- **SKILL.md** - Complete workflow guidance
- **CONSTRAINTS.md** - What NOT to do
- **KEYBOARD_LAYOUT.md** - K2v2 hardware reference
- **APP_REMAPPING.md** - Application-specific bindings
- **REFERENCE_WIKI.md** - Deep dive into keyd features
- **QUICK_REFERENCE.md** - Command syntax cheat sheet

**Version**: 2.1.1  
**Last Updated**: 2024-02-11
