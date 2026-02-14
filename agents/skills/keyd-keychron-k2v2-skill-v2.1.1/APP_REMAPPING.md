# APP_REMAPPING.md - Application-Specific Key Bindings

**Version**: 2.1.0  
**Purpose**: Guide for configuring per-application keyboard bindings with keyd

---

## 📋 Overview

keyd supports application-specific remapping via **keyd-application-mapper**. This allows different key bindings for different applications while keeping your main keyboard config intact.

**Use Cases**:
- Firefox: Alt-based tab switching (Meta reserved for Hyprland)
- Terminal: Special copy/paste shortcuts
- IDE: Application-specific shortcuts
- Browser: Custom navigation bindings

---

## 🚀 Setup (One-Time)

### Step 1: Add User to keyd Group

```bash
# Add your user to the keyd group
sudo usermod -aG keyd $USER

# Log out and log back in, or run:
newgrp keyd

# Verify membership:
groups | grep keyd
```

### Step 2: Create App Config Directory

```bash
# Create config directory in dotfiles
mkdir -p ~/dotfiles/keyd/
```

### Step 3: Create app.conf File

```bash
# Create the app config file
vim ~/dotfiles/keyd/app.conf
```

---

## 📝 Configuration Syntax

### Basic Structure

```ini
# Application name in square brackets
[application_name]
# Bindings: input = output
key.modifier = action

# Another application
[another_app]
key = action
```

### Finding Application Names

```bash
# Method 1: Use keyd-application-mapper in test mode
keyd-application-mapper -t

# Then switch to the application and see its name printed

# Method 2: Check window class/title manually
# (Application names are usually lowercase executable names)
```

**Common Application Names**:
- `firefox` - Firefox browser
- `chromium` - Chromium/Chrome
- `alacritty` - Alacritty terminal
- `kitty` - Kitty terminal
- `code` - VS Code
- `neovim` - Neovim (if GUI)
- `obsidian` - Obsidian notes

---

## 🎯 Example Configurations

### Example 1: Firefox Tab Navigation

**Problem**: Hyprland uses Meta key, but Firefox tab shortcuts are Ctrl+Tab

```ini
# ~/dotfiles/keyd/app.conf

[firefox]
# Use Alt for tab switching (Meta reserved for Hyprland)
alt.tab = C-tab              # Alt+Tab → Ctrl+Tab (next tab)
alt.shift.tab = C-S-tab      # Alt+Shift+Tab → Ctrl+Shift+Tab (prev tab)

# Quick actions
meta.t = C-t                 # Meta+T → Ctrl+T (new tab)
meta.w = C-w                 # Meta+W → Ctrl+W (close tab)
meta.shift.t = C-S-t         # Meta+Shift+T → Ctrl+Shift+T (reopen tab)

# Address bar
meta.l = C-l                 # Meta+L → Ctrl+L (focus address bar)
```

### Example 2: Terminal Copy/Paste

**Problem**: Ctrl+C/V conflict with terminal signals

```ini
[alacritty]
# Use Meta for copy/paste (Meta available in terminal)
meta.c = C-S-c               # Meta+C → Ctrl+Shift+C (copy)
meta.v = C-S-v               # Meta+V → Ctrl+Shift+V (paste)

# Optional: Quick commands
meta.t = C-S-t               # New tab
meta.w = C-S-w               # Close tab
```

### Example 3: Multiple Terminals

```ini
[alacritty]
meta.c = C-S-c
meta.v = C-S-v

[kitty]
meta.c = C-S-c
meta.v = C-S-v

[wezterm]
meta.c = C-S-c
meta.v = C-S-v
```

### Example 4: VS Code (if you use it)

```ini
[code]
# Quick file operations
meta.p = C-p                 # Command palette
meta.shift.p = C-S-p         # Command palette (alt)
meta.b = C-b                 # Toggle sidebar

# Navigation
meta.shift.e = C-S-e         # Explorer
meta.shift.f = C-S-f         # Search
```

### Example 5: Obsidian Notes

```ini
[obsidian]
# Quick note commands
meta.n = C-n                 # New note
meta.o = C-o                 # Quick switcher
meta.e = C-e                 # Toggle edit/preview

# Formatting (if needed)
meta.b = C-b                 # Bold
meta.i = C-i                 # Italic
```

---

## 🔧 Deployment Workflow

### Initial Deployment

```bash
# 1. Create config in dotfiles
vim ~/dotfiles/keyd/app.conf

# 2. Copy to system config location
mkdir -p ~/.config/keyd
cp ~/dotfiles/keyd/app.conf ~/.config/keyd/app.conf

# 3. Start the mapper daemon
keyd-application-mapper -d

# 4. Test in your applications
# Switch to Firefox, press Alt+Tab to test

# 5. If working, commit to Git
cd ~/dotfiles/keyd/
git add app.conf
git commit -m "feat: add firefox and terminal app bindings"
```

### Updating Config

```bash
# 1. Edit in dotfiles
vim ~/dotfiles/keyd/app.conf

# 2. Deploy changes
cp ~/dotfiles/keyd/app.conf ~/.config/keyd/app.conf

# 3. Restart mapper
pkill keyd-application-mapper
keyd-application-mapper -d

# 4. Test changes

# 5. Commit if successful
cd ~/dotfiles/keyd/
git add app.conf
git commit -m "feat: add obsidian shortcuts"
```

### Rollback

```bash
# If something breaks:
cd ~/dotfiles/keyd/
git revert HEAD

# Deploy old version
cp app.conf ~/.config/keyd/app.conf

# Restart mapper
pkill keyd-application-mapper
keyd-application-mapper -d
```

---

## 🎮 Running the Mapper

### Manual Start

```bash
# Start in foreground (for testing)
keyd-application-mapper

# Start in background (daemon mode)
keyd-application-mapper -d

# Stop the mapper
pkill keyd-application-mapper
```

### Auto-Start with System

**Method 1: Hyprland exec-once** (Recommended)

```bash
# Add to ~/.config/hypr/hyprland.conf
exec-once = keyd-application-mapper -d
```

**Method 2: systemd User Service** (Alternative)

```bash
# Create service file
cat > ~/.config/systemd/user/keyd-application-mapper.service << 'EOFSVC'
[Unit]
Description=Keyd Application Mapper
After=graphical-session.target

[Service]
Type=simple
ExecStart=/usr/bin/keyd-application-mapper -d
Restart=on-failure

[Install]
WantedBy=default.target
EOFSVC

# Enable and start
systemctl --user enable keyd-application-mapper
systemctl --user start keyd-application-mapper

# Check status
systemctl --user status keyd-application-mapper
```

---

## 🐛 Troubleshooting

### Mapper Not Working

**Check if running:**
```bash
ps aux | grep keyd-application-mapper
```

**Check permissions:**
```bash
# Verify you're in keyd group
groups | grep keyd

# If not, add and re-login:
sudo usermod -aG keyd $USER
# Then log out and log back in
```

**Test mode (see application names):**
```bash
keyd-application-mapper -t
# Switch to different applications and watch output
```

### Bindings Not Triggering

**Verify application name:**
```bash
# Run in test mode and check exact name
keyd-application-mapper -t
```

**Check config syntax:**
```bash
# Ensure proper format:
# [app_name]
# key.modifier = action

# NOT:
# [app_name]
# key+modifier = action  # Wrong! Use dot, not plus
```

**Restart mapper:**
```bash
pkill keyd-application-mapper
keyd-application-mapper -d
```

### Conflicts with Main Config

**Remember**: App-specific bindings override main keyd config ONLY in that app.

Example:
```ini
# Main config: ~/dotfiles/keyd/default.conf
[main]
capslock = overload(control, esc)

# App config: ~/dotfiles/keyd/app.conf
[firefox]
# capslock still works as ctrl/esc in Firefox
# Only explicitly remapped keys change
alt.tab = C-tab
```

---

## 📊 Best Practices

### DO:
✅ Keep app.conf in Git-tracked dotfiles
✅ Test bindings before committing
✅ Use descriptive commit messages
✅ Document non-obvious bindings with comments
✅ Group related applications together
✅ Restart mapper after changes

### DON'T:
❌ Override Meta in applications (Hyprland needs it)
❌ Create too many app-specific bindings (cognitive load)
❌ Forget to add user to keyd group
❌ Edit ~/.config/keyd/app.conf directly (use dotfiles!)
❌ Commit untested configurations

---

## 📁 File Structure in Git

**Recommended dotfiles structure:**

```
~/dotfiles/keyd/
├── default.conf         # Main keyboard config
├── app.conf             # Application-specific bindings
├── README.md            # Your personal notes
└── .git/                # Version control

Deployed to:
├── /etc/keyd/default.conf           (from default.conf)
└── ~/.config/keyd/app.conf          (from app.conf)
```

**Deployment script** (optional):

```bash
#!/bin/bash
# ~/dotfiles/keyd/deploy.sh

set -e

echo "Deploying keyd configurations..."

# Deploy main config
echo "→ Deploying default.conf to /etc/keyd/"
sudo keyd check ~/dotfiles/keyd/default.conf
sudo cp ~/dotfiles/keyd/default.conf /etc/keyd/default.conf
sudo keyd reload

# Deploy app config
echo "→ Deploying app.conf to ~/.config/keyd/"
mkdir -p ~/.config/keyd
cp ~/dotfiles/keyd/app.conf ~/.config/keyd/app.conf

# Restart mapper
echo "→ Restarting keyd-application-mapper"
pkill keyd-application-mapper 2>/dev/null || true
keyd-application-mapper -d

echo "✅ Deployment complete!"
```

Make it executable:
```bash
chmod +x ~/dotfiles/keyd/deploy.sh
```

---

## 🎯 Common Patterns

### Pattern 1: Browser Shortcuts

```ini
[firefox]
[chromium]
[brave]
# Share same bindings across all browsers
alt.tab = C-tab
alt.shift.tab = C-S-tab
meta.t = C-t
meta.w = C-w
meta.l = C-l
```

### Pattern 2: Terminal Shortcuts

```ini
[alacritty]
[kitty]
[wezterm]
[foot]
# Consistent across all terminals
meta.c = C-S-c
meta.v = C-S-v
```

### Pattern 3: Editor Shortcuts

```ini
[code]
[code-insiders]
# VS Code variants
meta.p = C-p
meta.shift.p = C-S-p
```

---

## 📚 Advanced Usage

### Chaining Actions

```ini
[firefox]
# Not supported directly in keyd-application-mapper
# Use main keyd config with macros instead
```

### Conditional Bindings

```ini
# Not supported - use separate applications sections
# [firefox-work]  # Not possible
# [firefox-personal]  # Not possible
```

### Layer Support

```ini
# Layers don't work in app.conf
# Use main default.conf for layers
```

---

## 🔗 Related Files

- **SKILL.md**: Overall workflow and Git emphasis
- **CONSTRAINTS.md**: Don't override Meta key (Hyprland uses it)
- **INTENT.md**: User's application usage patterns
- **QUICK_REFERENCE.md**: Main keyd syntax reference

---

## 📝 Example Complete Setup

```bash
# Initial setup (one-time)
sudo usermod -aG keyd $USER
# Log out and back in

# Create config
mkdir -p ~/dotfiles/keyd/
vim ~/dotfiles/keyd/app.conf
```

```ini
# ~/dotfiles/keyd/app.conf

# Firefox browser
[firefox]
alt.tab = C-tab
alt.shift.tab = C-S-tab
meta.t = C-t
meta.w = C-w

# Alacritty terminal
[alacritty]
meta.c = C-S-c
meta.v = C-S-v

# Obsidian notes
[obsidian]
meta.n = C-n
meta.o = C-o
```

```bash
# Deploy
mkdir -p ~/.config/keyd
cp ~/dotfiles/keyd/app.conf ~/.config/keyd/app.conf
keyd-application-mapper -d

# Add to Hyprland
echo "exec-once = keyd-application-mapper -d" >> ~/.config/hypr/hyprland.conf

# Commit
cd ~/dotfiles/keyd/
git add app.conf
git commit -m "feat: initial app-specific bindings"
```

---

**Version**: 2.1.0  
**Last Updated**: 2024-02-11  
**Status**: Production  
**Prerequisite**: User must be in `keyd` group
