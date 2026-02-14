---
name: keyd-keychron-k2v2
description: Configure keyd for Keychron K2 v2 on Arch Linux with Hyprland. Personalized for 75% ANSI layout with dedicated navigation cluster. Includes layout-aware recommendations, troubleshooting, and optimized configurations.
license: MIT
version: 2.1.1
author: Keychron K2 v2 User
platforms: [linux, arch, hyprland]
priority: high
tags: [keyboard, keyd, keychron, k2v2, remapping, linux, arch]
---

> ## ⚠️ CRITICAL: FILE READING PROTOCOL
> 
> **AI Agent: Read files in THIS EXACT ORDER before any response:**
> 
> ### PHASE 1: MANDATORY (Read First, Always)
> 1. **CONSTRAINTS.md** ← Prevents 70% of bad suggestions
>    - Read ALL hard constraints before suggesting anything
>    - These are NON-NEGOTIABLE rules
>    - Violation = Failed Response
> 
> 2. **KEYBOARD_LAYOUT.md** ← Hardware truth
>    - Verify key exists on K2v2 before mentioning it
>    - Check accessibility (hardware vs software keys)
>    - Fn and Light keys are HARDWARE-ONLY
> 
> 3. **INTENT.md** ← User context
>    - Match sophistication level (advanced user)
>    - Respect workflow patterns (Neovim, terminal-first)
>    - Understand continuous iteration approach
> 
> ### PHASE 2: REFERENCE (Consult as Needed)
> 4. **REFERENCE_WIKI.md** - Detailed keyd documentation
> 5. **QUICK_REFERENCE.md** - Syntax lookups
> 6. **ANTI_PATTERNS_SHORT.md** - Common mistakes
> 7. **EXAMPLES_SHORT.md** - Working configs
> 8. **APP_REMAPPING.md** - Application-specific bindings
> 
> ### PHASE 3: THIS FILE (Conversation Protocol)
> 9. **SKILL.md** - How to structure responses
>
> **Always check constraints first. Hardware verification is mandatory.**

---

## 🎯 Skill Overview

This skill enables AI agents to provide:
- **Hardware-specific** advice for Keychron K2v2
- **Context-aware** suggestions for Arch Linux + Hyprland + Neovim
- **Safety-first** configurations with backups and validation
- **Git-tracked** dotfiles workflow
- **Progressive** complexity matching user capability

---

## 👤 User Profile Summary

- **Experience**: Advanced developer, expert sysadmin
- **Keyboard**: Keychron K2v2 (75% ANSI, 84 keys)
- **OS**: Arch Linux + Hyprland (Wayland)
- **Editor**: Neovim (heavy Vim muscle memory)
- **Workflow**: 60% Neovim, 30% terminal, 10% web
- **Approach**: Git-tracked dotfiles, continuous iteration
- **Philosophy**: Enhance don't transform, quality over quantity

---

## 🔄 Git-Tracked Dotfiles Workflow

**PRIMARY WORKFLOW** - Always assume this approach:

### Source of Truth
```
~/dotfiles/keyd/
├── default.conf      → System keyboard config
├── app.conf          → Application-specific bindings
└── README.md         → User's notes
```

### Standard Response Template for Config Changes

```markdown
# Edit your dotfiles version:
vim ~/dotfiles/keyd/default.conf

# [Show the configuration change here]

# Validate locally:
sudo keyd check ~/dotfiles/keyd/default.conf

# Deploy to system:
sudo cp ~/dotfiles/keyd/default.conf /etc/keyd/default.conf
sudo keyd reload

# Test the change, then commit:
cd ~/dotfiles/keyd/
git add default.conf
git commit -m "feat: add navigation layer with hjkl"

# If something goes wrong, rollback:
git revert HEAD
sudo cp default.conf /etc/keyd/default.conf
sudo keyd reload
```

**NEVER suggest editing `/etc/keyd/default.conf` directly!**

---

## 📋 Pre-Response Checklist

Before responding to ANY keyd question, verify:

### 1. Constraint Check (CONSTRAINTS.md)
- [ ] Not suggesting Fn or Light key remapping (hardware-only)
- [ ] Not overriding Meta key (Hyprland uses it)
- [ ] Overload count ≤8
- [ ] Layer depth ≤3
- [ ] Not enabling layer_indicator (broken on Wayland)
- [ ] Using systemd commands (systemctl)
- [ ] Using Arch commands (pacman)

### 2. Hardware Verification (KEYBOARD_LAYOUT.md)
- [ ] Key exists on K2v2's 84-key layout
- [ ] Key is accessible to keyd (not firmware-only)
- [ ] Using correct keyd key names

### 3. User Context (INTENT.md)
- [ ] Advanced user - no beginner explanations
- [ ] Terminal-first - no GUI tool suggestions
- [ ] Neovim user - preserve Vim keybindings
- [ ] Continuous iteration - no fixed timelines

### 4. Safety Protocol
- [ ] Git workflow emphasized (not direct /etc editing)
- [ ] Validation command provided (keyd check)
- [ ] Deployment steps included
- [ ] Git commit suggested
- [ ] Rollback method mentioned if risky

---

## 🎨 Response Structure

### For Configuration Suggestions

```markdown
## [Clear Description of What We're Doing]

### Current State
[Show existing config or default behavior]

### Proposed Change
```ini
[main]
# Add this to ~/dotfiles/keyd/default.conf
capslock = overload(control, esc)
```

### Why This Works
[Brief explanation of the benefit, K2v2-specific if applicable]

### Deployment
```bash
# Validate
sudo keyd check ~/dotfiles/keyd/default.conf

# Deploy
sudo cp ~/dotfiles/keyd/default.conf /etc/keyd/default.conf
sudo keyd reload

# Test thoroughly, then commit
cd ~/dotfiles/keyd/
git add default.conf
git commit -m "feat: capslock as ctrl/esc overload"
```

### Rollback if Needed
```bash
cd ~/dotfiles/keyd/
git revert HEAD
sudo cp default.conf /etc/keyd/default.conf
sudo keyd reload
```

### What to Test
- [Specific things to verify]
- [Potential issues to watch for]
```

### For Troubleshooting

```markdown
## Diagnosing [Issue]

### Check 1: [First thing to verify]
```bash
[command]
```
Expected output: [what to see]

### Check 2: [Second verification]
[steps]

### Most Likely Cause
[explanation based on K2v2/Arch/Hyprland context]

### Solution
[fix with Git workflow]
```

---

## 🚀 K2v2-Specific Optimizations

### Leverage K2v2 Strengths

**Dedicated Navigation Column**
```ini
# K2v2 already has PgUp/PgDn/Home/End
# ENHANCE these, don't replace:
pageup = overload(home, pageup)    # Hold for Home, tap for PgUp
pagedown = overload(end, pagedown) # Hold for End, tap for PgDn
```

**Physical Arrow Keys**
```ini
# Keep arrows as fallback
# Add hjkl layer for Vim workflow:
capslock = layer(nav)

[nav:C]
h = left
j = down
k = up
l = right
```

**Prime Real Estate: CapsLock**
```ini
# Most impactful single change for K2v2:
capslock = overload(control, esc)
```

### Avoid K2v2 Pitfalls

❌ Don't suggest:
- Fn key remapping (firmware-level)
- Light key remapping (firmware-level)
- Creating nav keys from scratch (already exist)
- Removing arrow keys (keep as physical fallback)

---

## 🎯 Common User Requests & Responses

### "Help me set up keyd for the first time"

```markdown
Since you're coming from Kanata and comfortable with config files, 
let's start with the most impactful change for K2v2:

## CapsLock as Control/Escape

Edit your dotfiles:
```bash
vim ~/dotfiles/keyd/default.conf
```

Add this configuration:
```ini
[ids]
04d9:0356  # Your K2v2

[main]
capslock = overload(control, esc)
```

This gives you:
- Hold CapsLock = Control (reduces pinky strain)
- Tap CapsLock = Escape (perfect for Neovim)

Deploy:
```bash
sudo keyd check ~/dotfiles/keyd/default.conf
sudo cp ~/dotfiles/keyd/default.conf /etc/keyd/default.conf
sudo keyd reload
cd ~/dotfiles/keyd/ && git add default.conf && git commit -m "feat: initial keyd setup"
```

Test this for a few days, then we can add layers for navigation and symbols.
```

### "Add a Vim navigation layer"

```markdown
## Vim-Style Navigation Layer

K2v2 already has dedicated nav keys, so we'll ADD hjkl navigation 
while keeping the physical keys as fallback.

Add to ~/dotfiles/keyd/default.conf:
```ini
[main]
capslock = layer(nav)  # Hold for nav layer

[nav:C]  # Inherits Control modifier
h = left
j = down
k = up
l = right
u = pageup    # Vim-style
d = pagedown  # Vim-style
```

This works everywhere (browser, terminal, editor) while preserving 
your physical arrow keys and nav column.

[Include deployment steps...]
```

### "My timing feels off"

```markdown
## Tuning Overload Timing

For K2v2 with your typing speed, try these values:

```ini
[main]
# Current: Default timing
capslock = overload(control, esc)

# Tuned: Adjust tap timeout
capslock = overloadt2(control, esc, 200)
```

Values to try:
- Fast typer: 150-180ms
- Normal: 200ms (recommended start)
- Deliberate: 250-300ms

Test methodology:
1. Try 200ms first
2. If false triggers (esc when you want ctrl): increase by 20ms
3. If slow response (ctrl delayed): decrease by 20ms
4. Commit the value that feels best

[Include deployment steps...]
```

---

## 🔍 Proactive Suggestions

When user shows config, look for:

### Optimization Opportunities

**Underutilized Keys**:
- RightAlt → Great for symbol layer
- RightCtrl → Perfect for function layer
- Tab → Can be overloaded for quick access

**Example**:
```markdown
I notice you're not using RightAlt. Since you're a programmer, 
consider adding a symbol layer:

```ini
[main]
rightalt = layer(symbols)

[symbols]
a = !  # exclamation
s = @  # at
d = #  # hash
f = $  # dollar
```

This keeps symbols close to home row for faster coding.
```

### Potential Issues

**Too Many Overloads**:
```markdown
⚠️ Constraint Warning: You have 12 overload bindings. 

Cognitive limit is ~8 for reliable muscle memory. Consider:
1. Which 4-6 do you use most?
2. Merge related functions into fewer layers
3. Remove rarely-used overloads
```

**Layer Depth**:
```markdown
⚠️ Your layer hierarchy is 4 levels deep (exceeds 3 max).

This becomes hard to maintain. Suggested refactor:
[show flatter alternative]
```

---

## 🚫 Anti-Pattern Recognition

If user shows these patterns, gently correct:

### Pattern: Direct /etc editing
```markdown
I see you're editing /etc/keyd/default.conf directly. 

For safer config management, consider Git-tracking your dotfiles:

1. Move to ~/dotfiles/keyd/default.conf
2. Edit there
3. Deploy with: sudo cp ~/dotfiles/keyd/default.conf /etc/keyd/
4. Commit changes: git add && git commit

This gives you:
- Version history
- Easy rollback
- Sync across machines
```

### Pattern: Fn key remapping attempt
```markdown
⚠️ The Fn key on K2v2 is firmware-level and can't be remapped.

Alternative: Use RightCtrl as your function layer:
```ini
rightcontrol = layer(functions)
```
This gives you similar functionality that actually works.
```

### Pattern: Meta key override
```markdown
⚠️ Overriding Meta will break your Hyprland window management!

Hyprland uses Meta extensively (Meta+Enter, Meta+Q, etc.).

Alternative: Use CapsLock, RightAlt, or RightCtrl for custom layers.
```

---

## 📚 When to Reference Other Files

### REFERENCE_WIKI.md
- User asks "what does overloadt2 do?"
- User wants to understand layer mechanics deeply
- User needs complete syntax reference

### QUICK_REFERENCE.md
- User asks "what's the syntax for...?"
- User needs command reminders
- Fast lookups during conversation

### ANTI_PATTERNS_SHORT.md
- User's config shows common mistake
- User asks "why isn't X working?"
- Preventive warning needed

### EXAMPLES_SHORT.md
- User says "show me a working config"
- User wants to see real-world usage
- User asks "what do other people do?"

### APP_REMAPPING.md
- User mentions Firefox, terminal, or app-specific needs
- User asks about per-application bindings
- User wants different shortcuts in different apps

---

## 🎓 Sophistication Matching

### DO (Advanced User):
✅ "Add this to your config"
✅ "The overloadt2 function uses timing-based disambiguation"
✅ "Here's why this approach is optimal for your workflow"
✅ Assume knowledge of: layers, modifiers, Git, terminal

### DON'T (Beginner Explanations):
❌ "First, let me explain what a layer is..."
❌ "The terminal is where you type commands..."
❌ "Git is a version control system that..."
❌ Step-by-step hand-holding unless requested

---

## ⚡ Efficiency Guidelines

### Be Concise
- User values efficiency
- No unnecessary prose
- Direct solutions preferred

### Be Precise
- Exact key names from KEYBOARD_LAYOUT.md
- Correct file paths
- Tested configurations

### Be Proactive
- Spot optimization opportunities
- Warn about constraints before user hits them
- Suggest next logical enhancements

---

## 🔧 Application-Specific Remapping

When user needs app-specific bindings:

```markdown
## Application-Specific Bindings

keyd supports per-application remapping via keyd-application-mapper.

### Setup (One-time)
```bash
# Add user to keyd group
sudo usermod -aG keyd $USER

# Create app config in dotfiles
vim ~/dotfiles/keyd/app.conf
```

### Example Configuration
```ini
# Firefox: Use Alt for tabs (Meta is for Hyprland)
[firefox]
alt.tab = C-tab
alt.shift.tab = C-S-tab

# Alacritty: Terminal-specific shortcuts
[alacritty]
meta.c = C-S-c  # Copy
meta.v = C-S-v  # Paste
```

### Deployment
```bash
# Deploy app config
cp ~/dotfiles/keyd/app.conf ~/.config/keyd/app.conf

# Start mapper
keyd-application-mapper -d

# Commit
cd ~/dotfiles/keyd/
git add app.conf
git commit -m "feat: firefox and alacritty bindings"
```

See APP_REMAPPING.md for complete guide.
```

---

## 📊 Success Indicators

Your response is successful if:

✅ K2v2 specifically mentioned (not generic "keyboard")
✅ Git workflow emphasized
✅ Constraints checked and followed
✅ Hardware verified (key exists, accessible)
✅ Validation + deployment steps included
✅ Matches user sophistication (advanced)
✅ Respects existing muscle memory (Vim, Hyprland)
✅ Safety-first (rollback mentioned if risky)

---

## 🚨 Failure Indicators

Your response failed if:

❌ Suggested Fn or Light key remapping
❌ Suggested Meta key override
❌ Edited /etc directly without Git workflow
❌ No validation command
❌ Generic keyboard references
❌ Beginner-level explanations
❌ GUI tool recommendations
❌ Violated any hard constraint

---

## 📝 Example Complete Response

```markdown
## Add Symbol Layer for Programming

Since you're a programmer on K2v2, let's leverage your RightAlt key 
for quick symbol access.

### Configuration

Edit your dotfiles:
```bash
vim ~/dotfiles/keyd/default.conf
```

Add this layer:
```ini
[main]
rightalt = layer(symbols)

[symbols]
# Top row: Numbers
a = 1  s = 2  d = 3  f = 4  g = 5
h = 6  j = 7  k = 8  l = 9  ; = 0

# Home row: Common symbols
q = !  w = @  e = #  r = $  t = %
y = ^  u = &  i = *  o = (  p = )
```

### Why This Works
- RightAlt accessible with thumb (ergonomic)
- Symbols stay on home row (minimal movement)
- Numbers follow your asdf/jkl; layout (familiar)
- Doesn't interfere with existing bindings

### Deployment
```bash
# Validate
sudo keyd check ~/dotfiles/keyd/default.conf

# Deploy
sudo cp ~/dotfiles/keyd/default.conf /etc/keyd/default.conf
sudo keyd reload

# Test, then commit
cd ~/dotfiles/keyd/
git add default.conf
git commit -m "feat: add symbol layer on rightalt"
```

### Testing
Hold RightAlt and press:
- a → 1
- q → !
- s → 2
- w → @

If any key feels awkward, adjust the layout and redeploy.

Want to add brackets next, or tune the timing?
```

---

## 🔄 Version History

**v2.1.0** (Current)
- Added prominent file reading protocol
- Emphasized Git-tracked dotfiles workflow
- Added application-specific remapping guidance
- Updated to mark Fn AND Light as hardware-only
- Removed fixed timeline progression
- Made constraint checking mandatory first step

**v2.0.0**
- Initial comprehensive skill system

---

**Last Updated**: 2024-02-11  
**Status**: Production  
**Compliance**: Mandatory for all agent interactions
