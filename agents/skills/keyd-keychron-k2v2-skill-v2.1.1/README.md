# keyd-keychron-k2v2 AI Agent Skill

**Version**: 2.1.1  
**Status**: Production Ready  
**Target Hardware**: Keychron K2 v2 (75% ANSI, 84 keys)  
**Target System**: Arch Linux + Hyprland (Wayland)  
**Target User**: Advanced developer, Neovim user, terminal-first, Git-tracked dotfiles workflow

---

## 📦 What is This?

This is a comprehensive AI agent skill that enables coding assistants (Claude, Cursor, Copilot, Antigravity, OpenCode, Qwen, etc.) to provide **personalized, hardware-specific, context-aware** keyd configuration advice for Keychron K2 v2 keyboards with Git-tracked dotfiles workflow.

### What's New in v2.1.1 (Consistency Fixes)

🔧 **Fixed EXAMPLES_SHORT.md** - Removed Week/Month timeline labels  
🔧 **Fixed QUICK_REFERENCE.md** - Added Git workflow throughout  
🔧 **Fixed ANTI_PATTERNS_SHORT.md** - Fixed cross-references, added Git anti-pattern  
🔧 **Fixed REFERENCE_WIKI.md** - Updated backup to Git, removed Week timeline  
🔧 **Fixed context.json** - hot_swappable now accurately "varies_by_revision"  

**All reference files now 100% consistent with Git-first, continuous iteration philosophy!**

---

## 🚀 Quick Install

```bash
# 1. Extract and move to skills directory
unzip keyd-keychron-k2v2-skill-v2.1.1.zip
mv keyd-keychron-k2v2-skill-v2.1.1 ~/.skills/keyd-keychron-k2v2

# 2. Verify
ls ~/.skills/keyd-keychron-k2v2/SKILL.md

# 3. Test with your AI agent
# Prompt: "What keyboard do I have?"
# Expected: "Keychron K2 v2, 75% ANSI, 84 keys..."
```

---

## ✅ Verification

Test these prompts with your AI agent:

1. **"What keyboard do I have?"**  
   ✅ Should mention "Keychron K2 v2, 75% ANSI, 84 keys"

2. **"Can I remap the Fn key?"**  
   ✅ Should say "No, Fn is hardware-level. Use RightCtrl instead"

3. **"Can I remap the Light key?"**  
   ✅ Should say "No, Light is hardware-level for backlight control"

4. **"Help me configure CapsLock"**  
   ✅ Should use Git workflow: edit ~/dotfiles/keyd/default.conf

5. **"Show me an example config"**  
   ✅ Should NOT mention "Week 1" or "Beginner" with timeline

---

## 🎯 Key Features

### 100% Consistent Workflow
✅ All files emphasize Git-tracked dotfiles  
✅ No timeline-based progression (continuous iteration)  
✅ All examples include full Git workflow  
✅ Reference files aligned with core philosophy

### Hardware-Specific
✅ Knows your exact K2v2 layout (84 keys, ANSI, nav column)  
✅ Never suggests impossible mappings (Fn/Light keys)  
✅ Leverages K2v2 advantages (dedicated nav, arrows)  
✅ Accurate hardware info (hot-swap varies by revision)

### Git-First Workflow
✅ Always edits ~/dotfiles/keyd/ first  
✅ Deploys to /etc/keyd/ after validation  
✅ Includes git commit in every workflow  
✅ Rollback instructions with git revert

---

## 🔄 Git Workflow (PRIMARY Pattern)

```bash
# Agent will ALWAYS suggest this workflow:

# 1. Edit in dotfiles
vim ~/dotfiles/keyd/default.conf

# 2. Validate
sudo keyd check ~/dotfiles/keyd/default.conf

# 3. Deploy
sudo cp ~/dotfiles/keyd/default.conf /etc/keyd/default.conf
sudo keyd reload

# 4. Test and commit
git add ~/dotfiles/keyd/default.conf
git commit -m "feat: description"

# 5. Rollback if needed
git revert HEAD
sudo cp ~/dotfiles/keyd/default.conf /etc/keyd/default.conf
sudo keyd reload
```

---

## 📚 Documentation

- **SKILL.md** - Start here for file reading order
- **CONSTRAINTS.md** - What NOT to do
- **INTENT.md** - User profile and philosophy
- **KEYBOARD_LAYOUT.md** - K2v2 hardware specs
- **EXAMPLES_SHORT.md** - Configuration examples (Git workflow)
- **QUICK_REFERENCE.md** - Commands with Git workflow
- **REFERENCE_WIKI.md** - Complete keyd guide (Git-consistent)
- **APP_REMAPPING.md** - Per-application bindings
- **ANTI_PATTERNS_SHORT.md** - Common mistakes

---

## 🚫 Critical Constraints

**Hardware-Only Keys (Cannot Remap)**:
- ❌ Fn key (firmware-level)
- ❌ Light key (firmware-level)

**System Constraints**:
- ❌ Never override Meta key (Hyprland uses it)
- ❌ Always use Git workflow (no direct /etc editing)
- ❌ Wayland-only features (layer_indicator broken)

**Philosophy**:
- ❌ No fixed timelines (Week 1/2/3)
- ✅ Continuous iteration
- ✅ Git makes experimentation safe

---

## 📊 Success Metrics

**v2.1.1 improvements**:
- ✅ 100% file consistency (all reference docs aligned)
- ✅ Git workflow in ALL examples and guides
- ✅ No misleading timeline labels
- ✅ Accurate hardware specifications
- ✅ Fixed all cross-reference issues

---

## 🔧 Compatible AI Agents

Tested and working with:
- Claude (Code, Desktop, Web)
- Cursor
- GitHub Copilot
- Continue
- Antigravity
- OpenCode
- Qwen Code CLI
- Windsurf
- Cody
- Aider

---

## 📝 Quick Start Example

**Your first prompt:**
```
"I have a Keychron K2 v2. Help me set up keyd for the first time.
I want CapsLock to be Control/Escape."
```

**Expected response:**
```
Edit your dotfiles:
vim ~/dotfiles/keyd/default.conf

Add:
[ids]
04d9:0356

[main]
capslock = overload(control, esc)

Validate and deploy:
sudo keyd check ~/dotfiles/keyd/default.conf
sudo cp ~/dotfiles/keyd/default.conf /etc/keyd/default.conf
sudo keyd reload

Commit:
cd ~/dotfiles/keyd/
git add default.conf
git commit -m "feat: initial keyd setup with capslock"
```

---

## 🔗 External Resources

- **keyd**: https://github.com/rvaiya/keyd
- **K2v2 Manual**: https://www.keychron.com/pages/k2-user-manual
- **Arch Wiki**: https://wiki.archlinux.org/
- **Hyprland**: https://wiki.hyprland.org/

---

**Version**: 2.1.1  
**Last Updated**: 2024-02-11  
**License**: MIT  
**Status**: Production Ready ✅
