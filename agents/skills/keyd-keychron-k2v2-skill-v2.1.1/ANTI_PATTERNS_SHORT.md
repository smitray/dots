# ANTI_PATTERNS_SHORT.md - Common Configuration Failures

**Purpose**: Recognize and prevent common keyd configuration mistakes.

---

## 🚫 K2v2 Specific Anti-Patterns

### AP-1: The Fn Key Trap
❌ **WRONG**:
```ini
fn = layer(functions)  # Fn is hardware-level!
```
✅ **CORRECT**:
```ini
rightcontrol = layer(functions)  # Use RightCtrl instead
```

### AP-2: The Light Key Trap (NEW)
❌ **WRONG**:
```ini
light = layer(brightness)  # Light is hardware-level!
```
✅ **CORRECT**:
```bash
# Use software tools instead
brightnessctl set +10%
brightnessctl set 10%-
```

### AP-3: The Meta Key Override
❌ **WRONG**:
```ini
meta = layer(custom)  # Breaks Hyprland!
```
✅ **CORRECT**:
```ini
capslock = layer(custom)  # Use CapsLock instead
```

### AP-4: The Navigation Redundancy
❌ **WRONG**:
```ini
# Creating nav layer from scratch when K2v2 already has nav column
[nav]
u = pageup
d = pagedown
h = home
e = end
```
✅ **CORRECT**:
```ini
# ENHANCE existing nav column
pageup = overload(home, pageup)  # Tap=PgUp, Hold=Home
```

### AP-5: The Overload Explosion
❌ **WRONG**: 15 overload bindings = impossible to remember
✅ **CORRECT**: 5-8 strategic overloads maximum

### AP-6: The Mac Mindset on Linux
❌ **WRONG**: Trying to recreate Cmd+C/V on Linux
✅ **CORRECT**: Embrace Linux Ctrl-based shortcuts

### AP-7: The No-Git Workflow (NEW)
❌ **WRONG**:
```bash
# Editing system file directly
sudo vim /etc/keyd/default.conf
```
✅ **CORRECT**:
```bash
# Edit in dotfiles, deploy from there
vim ~/dotfiles/keyd/default.conf
sudo cp ~/dotfiles/keyd/default.conf /etc/keyd/default.conf
git add ~/dotfiles/keyd/default.conf && git commit -m "update"
```

---

## See Also

For detailed explanations and more anti-patterns:
- **CONSTRAINTS.md** - Hard rules to never violate
- **EXAMPLES_SHORT.md** - Correct configuration examples
- **SKILL.md** - Proper workflow guidance

---

**Version**: 2.1.1  
**Last Updated**: 2024-02-11
