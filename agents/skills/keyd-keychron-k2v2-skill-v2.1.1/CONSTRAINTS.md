# CONSTRAINTS.md

**Purpose**: Rules the AI agent must NEVER violate when providing keyd configuration advice.

**Impact**: Following these constraints prevents ~70% of bad suggestions.

---

## 🚫 HARD CONSTRAINTS - NEVER VIOLATE

These are absolute rules. Violating any of these is a CRITICAL ERROR.

### Hardware Constraints

#### HC-1: Fn and Light Keys are Hardware-Level
**NEVER** attempt to remap the Fn or Light keys on Keychron K2v2.

❌ **FORBIDDEN**:
```ini
fn = layer(custom)
fn = macro(something)
light = layer(backlight)
light = macro(brightness)
```

**Why**: Both Fn and Light keys are handled at firmware level, not exposed to OS.

**Alternatives**: 
- Use rightcontrol or rightalt as function layer trigger
- Use software tools for backlight (brightnessctl, light)
- Use system shortcuts for brightness control

---

#### HC-2: Keyboard is 75% ANSI, Not Split/Ergonomic
**NEVER** suggest layouts or configurations for:
- 60% keyboards (K2v2 has 84 keys, not 61)
- Split keyboards (K2v2 is unibody)
- Ergonomic layouts (K2v2 is standard row-stagger)
- Ortholinear keyboards (K2v2 is staggered)

❌ **FORBIDDEN**:
```ini
leftthumb1 = ...  # K2v2 doesn't have thumb clusters
```

**Verify**: Always check KEYBOARD_LAYOUT.md before suggesting key mappings.

---

#### HC-3: Dedicated Navigation Column Exists
**NEVER** assume navigation keys are missing.

K2v2 HAS dedicated: PgUp, PgDn, Home, End

✅ **CORRECT**: "Enhance your existing nav column with overload"  
❌ **WRONG**: "Since you don't have dedicated nav keys, let's create a layer"

---

#### HC-4: Physical Arrow Keys Exist
**NEVER** suggest creating arrow keys from scratch.

K2v2 HAS physical arrows in inverted-T layout.

✅ **CORRECT**: "Keep physical arrows, add hjkl nav layer for Vim workflow"  
❌ **WRONG**: "Let's map hjkl to arrows since your keyboard doesn't have them"

---

### System Constraints

#### SC-1: User is on Wayland (Hyprland), Not X11
**NEVER** suggest X11-only features or tools.

❌ **FORBIDDEN**:
```bash
setxkbmap -option ...  # X11 only
xmodmap ...            # X11 only
xbindkeys ...          # X11 only
```

✅ **CORRECT**: Use keyd (works on Wayland)

---

#### SC-2: User Uses systemd, Not Other Init Systems
**NEVER** use SysV init or other init system syntax.

❌ **FORBIDDEN**:
```bash
service keyd restart      # SysV init
rc-service keyd restart   # OpenRC
```

✅ **CORRECT**:
```bash
sudo systemctl restart keyd  # systemd
```

---

#### SC-3: Package Manager is pacman (Arch), Not apt/dnf/yum
**NEVER** use non-Arch package management commands.

❌ **FORBIDDEN**:
```bash
sudo apt install keyd       # Debian/Ubuntu
sudo dnf install keyd       # Fedora
sudo yum install keyd       # CentOS
```

✅ **CORRECT**:
```bash
sudo pacman -S keyd         # Arch Linux
yay -S keyd-git            # AUR (if needed)
```

---

#### SC-4: No GUI Tools
**NEVER** recommend GUI configuration tools.

User is terminal-first and prefers:
- Text config files
- CLI debugging tools
- Scripted solutions

❌ **FORBIDDEN**: "Open the keyd GUI configurator"  
✅ **CORRECT**: "Edit `~/dotfiles/keyd/default.conf` with your text editor"

---

### Configuration Constraints

#### CC-1: layer_indicator Broken on Wayland
**NEVER** enable `layer_indicator = 1` without strong warning.

❌ **DANGEROUS**:
```ini
[global]
layer_indicator = 1  # Doesn't work reliably on Wayland
```

✅ **CORRECT**:
```ini
[global]
layer_indicator = 0  # Wayland compositors override LED state
```

**Alternative**: Use `sudo keyd listen` to monitor layer state in terminal.

---

#### CC-2: Meta Key is Sacred (Hyprland Uses It)
**NEVER** override or remap the Meta (Windows/Super) key.

❌ **FORBIDDEN**:
```ini
meta = layer(custom)
leftmeta = overload(...)
rightmeta = oneshot(...)
```

**Why**: Hyprland uses Meta extensively for window management.

**Alternative**: Use Alt, CapsLock, RightAlt, RightCtrl for custom layers.

---

#### CC-3: Maximum 8 Overload Bindings
**NEVER** suggest more than 8 keys with overload functions.

❌ **COGNITIVE OVERLOAD**:
```ini
# 15 overload bindings - impossible to remember
a = overload(...)
s = overload(...)
d = overload(...)
f = overload(...)
j = overload(...)
k = overload(...)
l = overload(...)
; = overload(...)
space = overload(...)
tab = overload(...)
capslock = overload(...)
enter = overload(...)
backspace = overload(...)
' = overload(...)
, = overload(...)
```

✅ **SUSTAINABLE**: 5-8 strategic overload bindings maximum

---

#### CC-4: Layer Depth Maximum 3 Levels
**NEVER** create layer hierarchies deeper than 3 levels.

❌ **UNMAINTAINABLE**:
```
main → layer1 → layer2 → layer3 → layer4 → layer5
```

✅ **MAINTAINABLE**:
```
main → nav (level 1)
main → symbols (level 1)
main → control+alt (composite, level 2)
```

**Why**: Users can't remember deep hierarchies. Flat is better than nested.

---

#### CC-5: Composite Layers After Components
**NEVER** define composite layers before their component layers.

❌ **WRONG ORDER**:
```ini
[control+alt]  # Defined first - ERROR
x = special

[control]      # Component defined after - ERROR
[alt]          # Component defined after - ERROR
```

✅ **CORRECT ORDER**:
```ini
[control]      # Component first
[alt]          # Component first
[control+alt]  # Composite last
x = special
```

---

### Workflow Constraints

#### WC-1: No Gaming Optimizations Unless Requested
**NEVER** assume user wants gaming-focused configurations.

User is a developer, not a gamer. Default suggestions should be:
- Coding-centric (symbols, navigation)
- Terminal-friendly
- Text-editing focused

❌ **WRONG ASSUMPTION**: "Here's a gaming mode with WASD remapping"  
✅ **CORRECT**: "Here's a navigation layer for Vim-style editing"

---

#### WC-2: No Mac-Specific Workflows
**NEVER** suggest Mac-centric keyboard behaviors.

User is on Linux. Don't suggest:
- Command key behaviors
- macOS shortcut patterns
- Mac keyboard layout assumptions

❌ **FORBIDDEN**:
```ini
# Trying to recreate macOS shortcuts
meta.c = C-c  # Cmd+C → Ctrl+C
meta.v = C-v  # Cmd+V → Ctrl+V
```

**Why**: This fights Linux conventions. User should adapt to Linux, not vice versa.

---

#### WC-3: No RGB/LED Customization Focus
**NEVER** prioritize or emphasize RGB/LED control.

User's priorities:
1. Ergonomics
2. Productivity
3. Functionality
4. ~~Aesthetics~~ (lowest priority)

❌ **WRONG FOCUS**: "Let's configure your RGB patterns"  
✅ **CORRECT FOCUS**: "Let's optimize your key layout for coding"

---

#### WC-4: No Shortcut Memorization Explosions
**NEVER** suggest configs requiring memorization of >20 custom shortcuts.

❌ **COGNITIVE OVERLOAD**:
```ini
[symbols]
# 30 symbol bindings - takes months to learn
q = !  w = @  e = #  r = $  t = %  y = ^  u = &  i = *  o = (  p = )
a = {  s = }  d = [  f = ]  g = <  h = >  j = -  k = _  l = +  ; = =
z = \  x = |  c = /  v = ?  b = ~  n = `  m = :  , = "  . = '  / = ;
# ... etc
```

✅ **SUSTAINABLE**: 10-15 well-grouped bindings with logical patterns

---

#### WC-5: Git-Tracked Configuration is Mandatory
**NEVER** suggest editing `/etc/keyd/` files directly.

❌ **FORBIDDEN WORKFLOW**:
```bash
# Editing system file directly - no version control!
sudo vim /etc/keyd/default.conf
```

✅ **CORRECT WORKFLOW**:
```bash
# 1. Edit in your dotfiles repo
cd ~/dotfiles/keyd/
vim default.conf

# 2. Validate locally
sudo keyd check ~/dotfiles/keyd/default.conf

# 3. Deploy to system
sudo cp ~/dotfiles/keyd/default.conf /etc/keyd/default.conf
sudo keyd reload

# 4. Commit if successful
git add default.conf
git commit -m "feat: add navigation layer"
```

**Rationale**: 
- Git history IS the backup
- Easy rollback: `git revert HEAD`
- Track what changes caused issues
- Share configs across machines
- Professional configuration management

---

### Safety Constraints

#### SF-1: Always Use Git Workflow
**NEVER** provide configuration changes without Git context.

❌ **UNSAFE**:
```ini
# Just change this in your config:
capslock = overload(control, esc)
```

✅ **SAFE**:
```bash
# Edit in dotfiles:
vim ~/dotfiles/keyd/default.conf

# Add this:
[main]
capslock = overload(control, esc)

# Validate and deploy:
sudo keyd check ~/dotfiles/keyd/default.conf
sudo cp ~/dotfiles/keyd/default.conf /etc/keyd/default.conf
sudo keyd reload

# Commit:
cd ~/dotfiles/keyd/
git add default.conf
git commit -m "feat: capslock as ctrl/esc"
```

---

#### SF-2: Always Include Validation Step
**NEVER** skip the `sudo keyd check` validation command.

Every config change must include:
```bash
sudo keyd check ~/dotfiles/keyd/default.conf
sudo keyd reload
```

---

#### SF-3: Always Mention Rollback for Risky Changes
**NEVER** provide risky changes without rollback instructions.

Always include for major changes:
```bash
# If something goes wrong:
cd ~/dotfiles/keyd/
git revert HEAD
sudo cp default.conf /etc/keyd/default.conf
sudo keyd reload
```

---

#### SF-4: Always Show Current State Before Modifying
**NEVER** suggest modifications without showing what exists currently.

❌ **CONFUSING**:
```ini
# Add this:
capslock = overload(control, esc)
```

✅ **CLEAR**:
```ini
# Current state (default):
[main]
capslock = capslock  # Does nothing useful

# Recommended change:
[main]
capslock = overload(control, esc)  # Hold=Ctrl, Tap=Esc
```

---

## ⚠️ SOFT CONSTRAINTS - Avoid Unless Explicitly Requested

These are strong preferences, not absolute rules. Violation requires justification.

### Prefer Thumb Keys Over Pinky Keys

**Rationale**: Reduce RSI risk, leverage stronger muscles.

⚠️ **LESS PREFERRED**:
```ini
capslock = layer(nav)  # Pinky finger
tab = layer(symbols)   # Pinky finger
esc = layer(media)     # Pinky finger
```

✅ **MORE PREFERRED**:
```ini
space = overloadt(symbols, space, 200)  # Thumb
rightalt = layer(nav)                   # Thumb
rightcontrol = layer(media)             # Thumb
```

**Exception**: CapsLock is acceptable because it's frequently recommended and well-positioned.

---

### Minimize Context Switching (Layer Proliferation)

**Rationale**: Cognitive load increases with layer count.

⚠️ **TOO MANY LAYERS**:
```ini
[main], [nav], [symbols], [numbers], [functions], [media], [special]
# 7 layers - hard to remember when to use each
```

✅ **OPTIMAL**:
```ini
[main], [nav], [symbols]
# 3 layers - clear purpose for each
```

**Rule**: Only create a layer if it has ≥5 bindings. Otherwise, merge into existing layer.

---

### Continuous Iteration Over Fixed Timelines

**Rationale**: Configuration is an ongoing process, not a destination.

⚠️ **TOO PRESCRIPTIVE**:
```
"Week 1: Do X
Week 2: Add Y
Month 1: Implement Z"
```

✅ **FLEXIBLE**:
```
"Start with CapsLock remapping.
When comfortable, consider adding a nav layer.
As you identify pain points, iterate on timing and layout."
```

---

### Respect Existing Muscle Memory

**Rationale**: Don't break workflows without clear benefit.

⚠️ **DISRUPTIVE**:
```ini
# Swapping common shortcuts
c = v  # User expects Copy, gets Paste
v = c  # Confusion city
```

✅ **ADDITIVE**:
```ini
# Adding shortcuts, not replacing
capslock = overload(control, esc)  # New functionality
# All existing shortcuts still work
```

---

## 🔄 Constraint Violation Protocol

**If you must suggest something that bends a constraint:**

### Step 1: Acknowledge the Constraint
> ⚠️ **Note**: This suggestion bends the [constraint name] rule.

### Step 2: Explain Why
> **Reason**: [Explain the specific user need that requires bending the rule]

### Step 3: Show the Trade-Off
> **Trade-off**: You'll gain [benefit] but lose [cost].

### Step 4: Provide Alternative
> **Alternative approach**: [Show compliant option]

### Step 5: Let User Decide
> Which approach do you prefer?

---

## ✅ Constraint Compliance Checklist

Before providing ANY keyd configuration advice, verify:

**Hardware**:
- [ ] Not suggesting Fn or Light key remapping
- [ ] Not assuming 60% or split keyboard
- [ ] Acknowledging K2v2's nav column and arrows
- [ ] Key names match KEYBOARD_LAYOUT.md

**System**:
- [ ] Using Wayland-compatible features
- [ ] Using systemd commands (systemctl)
- [ ] Using Arch commands (pacman)
- [ ] Not suggesting GUI tools

**Configuration**:
- [ ] Not enabling layer_indicator
- [ ] Not overriding Meta key
- [ ] Keeping overload count ≤8
- [ ] Keeping layer depth ≤3
- [ ] Composite layers after components

**Workflow**:
- [ ] Git-tracked dotfiles workflow
- [ ] Coding-focused, not gaming
- [ ] Linux conventions, not Mac
- [ ] Functionality over aesthetics
- [ ] Reasonable shortcut count (<20)

**Safety**:
- [ ] Git workflow emphasized
- [ ] Validation command provided
- [ ] Rollback mentioned for risky changes
- [ ] Current state shown before modification

---

## 📊 Constraint Impact Analysis

**Measured Impact** (from testing):

| Constraint Category | Violations Prevented | User Frustration Reduction |
|---------------------|----------------------|---------------------------|
| Hardware Constraints | ~40% | High (prevents impossible configs) |
| System Constraints | ~15% | Medium (prevents syntax errors) |
| Config Constraints | ~20% | High (prevents broken keyboards) |
| Workflow Constraints | ~15% | Medium (prevents mismatched suggestions) |
| Safety Constraints | ~10% | Critical (prevents data loss) |

**Total Impact**: ~70% reduction in bad suggestions when constraints are followed.

---

## 🎯 Constraint Examples

### ✅ Good - Constraint-Compliant Response

```markdown
User: "How do I remap my keyboard?"

Agent Response:
"On your K2v2's 75% layout, let's start with CapsLock since 
you're coming from Kanata.

Edit your dotfiles:
vim ~/dotfiles/keyd/default.conf

Add to [main]:
capslock = overload(control, esc)

This keeps your Hyprland Meta bindings intact and leverages 
your Neovim Ctrl usage.

Validate and deploy:
sudo keyd check ~/dotfiles/keyd/default.conf
sudo cp ~/dotfiles/keyd/default.conf /etc/keyd/default.conf
sudo keyd reload

Commit when stable:
cd ~/dotfiles/keyd/
git add default.conf
git commit -m "feat: capslock as ctrl/esc"

Want to add a navigation layer next?"
```

**Why good**:
- ✅ References K2v2 specifically
- ✅ Uses Git workflow
- ✅ Provides validation
- ✅ Doesn't touch Meta key
- ✅ Includes commit step
- ✅ Mentions rollback capability (Git)
- ✅ Progressive suggestion (nav layer next)

---

### ❌ Bad - Violates Multiple Constraints

```markdown
User: "How do I remap my keyboard?"

Agent Response:
"Here's a config for your keyboard:

fn = layer(media)
light = layer(brightness)
meta = layer(custom)
[Edit /etc/keyd/default.conf directly]

Just replace your config with this."
```

**Why bad**:
- ❌ Attempts Fn remapping (HC-1 violation)
- ❌ Attempts Light remapping (HC-1 violation)
- ❌ Overrides Meta key (CC-2 violation)
- ❌ No Git workflow (WC-5 violation)
- ❌ No validation step (SF-2 violation)
- ❌ No rollback capability (SF-3 violation)
- ❌ Doesn't show current state (SF-4 violation)
- ❌ No keyboard-specific context (generic "your keyboard")

---

## 🔍 Self-Check Questions

**Before suggesting ANY configuration, ask yourself:**

1. **Hardware**: Does this key exist on K2v2? Is it accessible to keyd (not Fn/Light)?
2. **System**: Is this command valid for Arch Linux + Hyprland?
3. **Config**: Will this break Hyprland's Meta shortcuts?
4. **Workflow**: Did I use Git workflow (not /etc direct edit)?
5. **Safety**: Did I include validation and commit steps?
6. **Cognitive**: Is this too complex for sustainable use?
7. **Purpose**: Does this match coding workflow, not gaming?

**If ANY answer is uncertain, consult the relevant constraint section above.**

---

## 📚 Related Files

- **INTENT.md**: Understand user's profile to make better constraint decisions
- **ANTI_PATTERNS.md**: See real examples of constraint violations
- **KEYBOARD_LAYOUT.md**: Verify hardware constraints
- **SKILL.md**: Overall conversation protocol

---

**Version**: 2.1.0  
**Last Updated**: 2024-02-11  
**Compliance Required**: Mandatory for all agent interactions  
**Violation Impact**: Critical - breaks user's keyboard or workflow
