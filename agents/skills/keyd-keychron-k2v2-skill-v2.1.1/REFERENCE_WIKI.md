# KEYD - The Complete Wiki & Configuration Guide

**Version:** Comprehensive Guide (Updated February 2026)  
**Author:** Community-sourced from GitHub, Reddit, and Official Documentation

---

## Table of Contents

1. [Introduction](#introduction)
2. [Installation](#installation)
3. [Core Concepts](#core-concepts)
4. [Configuration File Structure](#configuration-file-structure)
5. [Complete Keyword Reference](#complete-keyword-reference)
6. [Actions - Complete List](#actions-complete-list)
7. [Overload Functions Deep Dive](#overload-functions-deep-dive)
8. [Layers System](#layers-system)
9. [Macros](#macros)
10. [Chords](#chords)
11. [Aliases](#aliases)
12. [Global Settings](#global-settings)
13. [Application-Specific Remapping](#application-specific-remapping)
14. [Advanced Techniques](#advanced-techniques)
15. [Extensive Examples](#extensive-examples)
16. [Troubleshooting](#troubleshooting)
17. [Best Practices](#best-practices)

---

## Introduction

### What is keyd?

keyd is a **system-wide key remapping daemon for Linux** that operates at the kernel level using evdev and uinput. It provides features traditionally found only in custom keyboard firmware (like QMK) to any standard keyboard.

### Why Use keyd?

- **Universal**: Works across X11, Wayland, and TTY
- **Fast**: Written in C, <<1ms input loop
- **Powerful**: Layers, oneshot modifiers, tap/hold, chords
- **Simple**: Intuitive INI-style configuration
- **Persistent**: Survives display server changes

### Key Features

✓ **Layers** - Multiple keymaps active simultaneously  
✓ **Key Overloading** - Different behavior on tap vs hold  
✓ **Oneshot Modifiers** - Tap modifier, then key (like sticky keys)  
✓ **Chords** - Key combinations treated as single unit  
✓ **Macros** - Complex key sequences  
✓ **Unicode Support** - Type any character  
✓ **Application-Specific** - Different mappings per application  
✓ **Keyboard-Specific** - Different configs per device

---

## Installation

### From Source (Recommended)

```bash
# Clone repository
git clone https://github.com/rvaiya/keyd
cd keyd

# Build and install
make && sudo make install

# Enable and start service
sudo systemctl enable --now keyd
```

### Package Managers

**Arch Linux:**
```bash
sudo pacman -S keyd
```

**Ubuntu 25.04+:**
```bash
sudo apt install keyd
```

**Fedora:**
```bash
sudo dnf copr enable alternateved/keyd
sudo dnf install keyd
```

**Debian 13+:**
```bash
sudo apt install keyd
```

**Alpine:**
```bash
apk add keyd
```

**Void Linux:**
```bash
sudo xbps-install -Su keyd
```

### Post-Installation

```bash
# Check status
sudo systemctl status keyd

# View logs
sudo journalctl -eu keyd

# Monitor key events
sudo keyd monitor

# List valid key names
keyd list-keys
```

---

## Core Concepts

### How keyd Works

1. **Input Layer**: keyd grabs input devices at the kernel level (evdev)
2. **Processing**: Applies your configuration rules
3. **Output Layer**: Emits transformed events via virtual keyboard (uinput)

### Key Terminology

- **Layer**: A collection of key bindings (like a keymap)
- **Binding**: Maps a key to an action
- **Action**: What happens when a key is pressed (key, macro, layer change, etc.)
- **Overload**: Key with different tap vs hold behavior
- **Oneshot**: Modifier that applies to next keypress only
- **Chord**: Multiple keys pressed simultaneously

---

## Configuration File Structure

### File Location

- **Global configs**: `/etc/keyd/`
- **User configs**: `~/.config/keyd/` (for application mapper)
- **Layouts**: `/usr/share/keyd/layouts/`

### File Naming

- Must end with `.conf` for main configs
- Files without `.conf` can be included

### Basic Structure

```ini
[ids]
# Device identifiers

[global]
# Global settings (optional)

[main]
# Main layer - always active

[layer_name]
# Additional layers

[composite_layer1+layer2]
# Composite layers
```

---

## Complete Keyword Reference

### Section Headers

#### `[ids]`
**Purpose**: Identifies which keyboards this config applies to

**Forms:**

1. **Explicit matching:**
```ini
[ids]
0123:4567  # Specific device ID
k:0123:4567  # Explicitly keyboard only
m:046d:b01d  # Explicitly mouse only
```

2. **Wildcard matching:**
```ini
[ids]
*  # All keyboards
-0123:4567  # Exclude this device
```

**Important Notes:**
- Get device IDs via `sudo keyd monitor`
- Wildcard `*` matches keyboards only by default
- One device ID can only be in one config file
- Mice must be explicitly listed (experimental)

#### `[global]`
**Purpose**: System-wide settings affecting all layers

**Available Options:**
```ini
[global]
macro_timeout = 600              # Initial macro repeat delay (ms)
macro_repeat_timeout = 50        # Successive macro repeat (ms)
layer_indicator = 0              # LED feedback for layers (0/1)
macro_sequence_timeout = 0       # Delay between macro keys (μs)
chord_timeout = 50               # Max time for chord keys (ms)
chord_hold_timeout = 0           # Hold time before chord activates (ms)
oneshot_timeout = 0              # Oneshot expiration time (ms)
disable_modifier_guard = 0       # Disable extra modifier protection (0/1)
overload_tap_timeout = 0         # Ignore tap if held this long (ms)
default_layout = main            # Starting layout name
```

#### `[main]`
**Purpose**: The default layer - always active

**Example:**
```ini
[main]
capslock = overload(control, esc)
j = down
k = up
```

#### `[layer_name]` or `[layer_name:MODIFIERS]`
**Purpose**: Named layers with optional modifier emulation

**Modifier Syntax:**
- `C` = Control
- `M` = Meta/Super
- `A` = Alt
- `S` = Shift
- `G` = AltGr

**Examples:**
```ini
[nav]              # Plain layer
h = left

[capslock:C]       # Layer that acts as Control
j = down           # capslock+j = down (no Control)

[symbols:S-C]      # Layer with Shift+Control
a = 1              # Will be Shift+Control+1
```

#### `[composite_layer1+layer2]`
**Purpose**: Activated when multiple layers are active

**Rules:**
- Must be defined AFTER component layers
- Cannot have modifiers
- Provides precedence when multiple layers active

**Example:**
```ini
[control]
x = a

[alt]  
y = b

[control+alt]
z = c  # Takes precedence when both active
```

#### `[aliases]`
**Purpose**: Define alternative names for keys

```ini
[aliases]
thumbkey = space
leftmeta = meta
rightmeta = meta
```

---

## Actions - Complete List

### Basic Actions

#### `layer(<layer_name>)`
Activate layer while key is held

```ini
capslock = layer(nav)
```

#### `oneshot(<layer_name>)`
Activate layer for next keypress only

```ini
shift = oneshot(shift)  # Tap shift, then letter
```

#### `toggle(<layer_name>)`
Permanently toggle layer on/off

```ini
[nav]
t = toggle(nav)  # Toggle nav layer
```

#### `swap(<layer_name>)`
Swap currently active layer with new one

```ini
[control]
x = swap(xlayer)  # Deactivates control, activates xlayer
```

#### `clear()`
Deactivate all toggled/oneshot layers

```ini
esc = clear()
```

#### `setlayout(<layout_name>)`
Change the active layout

```ini
[control]
1 = setlayout(dvorak)
2 = setlayout(colemak)
```

### Macro-Enhanced Actions

#### `layerm(<layer>, <macro>)`
Activate layer and execute macro

```ini
space = layerm(nav, macro(Hello))
```

#### `oneshotm(<layer>, <macro>)`
Oneshot layer with macro

```ini
shift = oneshotm(shift, macro(C-a))
```

#### `togglem(<layer>, <macro>)`
Toggle layer with macro

```ini
capslock = togglem(caps, macro(beep))
```

#### `swapm(<layer>, <macro>)`
Swap layer with macro

```ini
tab = swapm(newlayer, macro(C-t))
```

#### `clearm(<macro>)`
Clear layers and execute macro

```ini
esc = clearm(macro(C-c))
```

### Overload Actions

#### `overload(<layer>, <action>)`
**The most fundamental overload**

- **Hold**: Activates layer
- **Tap**: Executes action

```ini
capslock = overload(control, esc)
# Hold capslock = Control
# Tap capslock = Escape
```

#### `overloadt(<layer>, <action>, <timeout>)`
**Timeout-based overload**

- Layer activates ONLY if held for `<timeout>` ms
- Otherwise behaves as tap
- Adds visual delay when typing

```ini
a = overloadt(nav, a, 200)
# Hold >200ms = activate nav layer
# Otherwise = 'a'
```

#### `overloadt2(<layer>, <action>, <timeout>)`
**Smart timeout overload**

- Like `overloadt` BUT
- Also resolves as hold if another key is tapped while held
- Best for modifier keys

```ini
f = overloadt2(shift, f, 200)
# Hold 200ms = shift
# Hold + tap another key = shift  
# Quick tap = 'f'
```

#### `overloadi(<action1>, <action2>, <idle_timeout>)`
**Idle-aware overload**

Decides based on time since last non-action key:

- Recent activity (<timeout) → action1
- Long idle (>timeout) → action2

```ini
a = overloadi(a, overloadt2(control, a, 200), 150)
# If typing quickly: 'a'
# If idle >150ms: control when held
```

#### `lettermod(<layer>, <key>, <idle_timeout>, <hold_timeout>)`
**Homerow mods helper**

Alias for: `overloadi(<key>, overloadt2(<layer>, <key>, <hold_timeout>), <idle_timeout>)`

Perfect for homerow modifiers:

```ini
a = lettermod(meta, a, 150, 200)
s = lettermod(alt, s, 150, 200)
d = lettermod(control, d, 150, 200)
f = lettermod(shift, f, 150, 200)

# Right hand
j = lettermod(shift, j, 150, 200)
k = lettermod(control, k, 150, 200)
l = lettermod(alt, l, 150, 200)
; = lettermod(meta, ;, 150, 200)
```

**How it works:**
- Typing word quickly → letters appear immediately
- Holding key →modifier activates
- Holding + typing another key → modifier applies to that key

#### `oneshotk(<layer>, <key>)`
**Oneshot with key fallback**

- Tap: Oneshot layer for next key
- Hold: Acts as specified key

```ini
shift = oneshotk(shift, a)
# Tap: oneshot shift
# Hold: 'a'
```

#### `timeout(<action1>, <timeout>, <action2>)`
**General timeout action**

- No keys within timeout → action2
- Otherwise → action1

```ini
space = timeout(space, 500, layer(nav))
# Hold 500ms without pressing other keys = nav layer
# Otherwise = space
```

### Macro Actions

#### `macro(<expression>)`
Execute a sequence of keys/text

```ini
f1 = macro(Hello World)
f2 = macro(C-a)  # Control+a
f3 = macro(C-c 100ms C-v)  # Copy, wait 100ms, paste
```

#### `macro2(<timeout>, <repeat_timeout>, <macro>)`
Macro with custom timing

```ini
down = macro2(400, 50, down)  # Custom repeat rate
```

### Utility Actions

#### `repeat()`
Repeat last key or macro

```ini
r = repeat()
```

#### `command(<shell_command>)`
Execute shell command (runs as keyd user, usually root)

```ini
f1 = command(brightness up)
f2 = command(/home/user/script.sh)
```

#### `noop`
Do nothing (disable a key)

```ini
capslock = noop
```

---

## Overload Functions Deep Dive

### Comparison Matrix

| Function | Tap Behavior | Hold Behavior | Special Features |
|----------|--------------|---------------|------------------|
| `overload` | Execute action | Activate layer | Basic tap/hold |
| `overloadt` | Execute action | Activate layer after timeout | Adds visual delay |
| `overloadt2` | Execute action | Activate layer after timeout OR on intervening tap | Smart for modifiers |
| `overloadi` | Depends on idle time | Depends on idle time | Context-aware |
| `lettermod` | Key (when typing) | Layer (when idle) | Homerow mods optimized |
| `oneshotk` | Oneshot layer | Act as key | Dual purpose |
| `timeout` | Action1 (default) | Action2 (after timeout) | General timeout |

### When to Use Each

**`overload`**: Simple tap/hold scenarios
```ini
capslock = overload(control, esc)  # Most common use
```

**`overloadt`**: Reduce accidental activations, can tolerate delay
```ini
space = overloadt(symbols, space, 200)
```

**`overloadt2`**: Modifier keys, need quick response for shortcuts
```ini
tab = overloadt2(alt, tab, 180)
```

**`overloadi`**: Homerow mods, letter keys with modifiers
```ini
a = overloadi(a, overloadt2(meta, a, 200), 150)
```

**`lettermod`**: Homerow mods (simplified syntax)
```ini
f = lettermod(shift, f, 150, 200)
```

### Timeout Values Guide

**Typical Ranges:**
- **Idle timeout**: 100-200ms (how quickly you type)
- **Hold timeout**: 150-250ms (how long to distinguish hold)
- **Chord timeout**: 30-80ms (how simultaneously you press)

**Fast typers**: Lower values (100-150ms)  
**Deliberate typers**: Higher values (200-300ms)

**Testing approach:**
1. Start with defaults (150/200)
2. Monitor for misfires
3. Adjust in 25ms increments
4. Type sample text repeatedly

---

## Layers System

### Layer Types

#### 1. Standard Layers
```ini
[main]
a = b

[symbols]
a = 1
b = 2
```

#### 2. Modifier Layers
```ini
[nav:C]  # Emits Control
h = left  # Sends just 'left', not Control+left

[edit:C-A]  # Emits Control+Alt
s = macro(save)
```

#### 3. Composite Layers
```ini
[control]
[alt]
[control+alt]  # Active when BOTH control and alt active
x = special_action
```

#### 4. Layouts
Special layers for letter mappings:
```ini
[dvorak:layout]
q = '
w = ,
e = .
# etc...

[main]
f1 = setlayout(dvorak)
```

### Layer Activation Methods

```ini
# 1. layer() - While held
capslock = layer(nav)

# 2. oneshot() - Next key only  
shift = oneshot(shift)

# 3. toggle() - Permanent until toggled again
scrolllock = toggle(numpad)

# 4. swap() - Replace current layer
tab = swap(newlayer)
```

### Layer Stacking

Layers stack in activation order:
```
[Most recent layer]  ← Checked first
[Second layer]
[Third layer]
[main]              ← Checked last
```

### Pre-defined Layers

keyd automatically defines:
```ini
[control:C]
[meta:M]
[shift:S]
[alt:A]
[altgr:G]
```

And binds:
```ini
leftcontrol = layer(control)
leftmeta = layer(meta)
# etc...
```

You can extend these:
```ini
[control]
j = down  # Control+j = down
```

---

## Macros

### Basic Syntax

```ini
key = macro(<expression>)
```

### Expression Tokens

#### 1. Key Codes
```ini
macro(a b c)  # Types "abc"
macro(left left up)  # Presses arrows
```

#### 2. Modifiers + Key
```ini
macro(C-a)      # Control+a
macro(A-tab)    # Alt+tab
macro(C-S-t)    # Control+Shift+t
macro(M-f1)     # Meta+f1
```

#### 3. Simultaneous Keys
```ini
macro(leftcontrol+leftalt)  # Both pressed together
macro(a+b+c)  # Three keys as unit
```

#### 4. Unicode Characters
```ini
macro(Hello World)  # Types text
macro(こんにちは)    # Unicode support
```

#### 5. Delays
```ini
macro(C-c 100ms C-v)  # Copy, wait, paste
macro(a 500ms b 500ms c)  # Slow typing
```

#### 6. Nested Macros
```ini
macro(C-t macro(google.com) enter)
```

### Type 2 Macros (Inline)

```ini
key = C-a  # Equivalent to macro(C-a)
key = A-tab
```

### Escaping Special Characters

Split into tokens to escape:
```ini
macro(s p a c e)  # Literal "space", not spacebar
macro(3 + 5)      # Literal "3+5"
macro(3+5)        # Keys 3 and 5 together
```

### Examples

```ini
# Common shortcuts
f1 = macro(C-t https://github.com enter)
f2 = macro(C-a C-c)  # Select all, copy
f3 = macro(#!/bin/bash enter)

# Text expansion
dot = macro(. space)
sig = macro(Best space regards, enter John)

# Complex sequences
build = macro(C-s 100ms A-tab 50ms C-b)
```

---

## Chords

### What Are Chords?

Multiple keys pressed simultaneously treated as single action.

### Syntax

```ini
key1+key2 = action
key1+key2+key3 = action
```

### Configuration

```ini
[global]
chord_timeout = 50        # Max time between keys (ms)
chord_hold_timeout = 0    # Min hold time (ms)
```

### Examples

```ini
# Vim-style escape
j+k = esc

# Navigation
h+j = pagedown
h+k = pageup

# Modifier combos
z+x = layer(control)
z+x+c = layer(control+alt)

# Symbols
,+. = macro(->)
.+/ = macro(=>)

# Bottom row mods (TextBlade style)
z+x = layer(leftcontrol)
x+c = layer(leftalt)
c+v = layer(leftmeta)
z+x+c = layer(leftcontrolalt)
```

### Tips

- Start with low timeout (30-50ms) for deliberate chording
- Increase timeout if too many missed chords
- Use chord_hold_timeout to prevent accidental activation
- Common combos: `j+k`, `f+d`, `h+j+k+l`

---

## Aliases

### Purpose

Give keys alternative names for easier configuration.

### Syntax

```ini
[aliases]
key = alias_name
```

### Default Aliases

```ini
# Already defined by keyd:
leftmeta = meta
rightmeta = meta
leftshift = shift
rightshift = shift
# etc...
```

### Custom Aliases

```ini
[aliases]
space = spc
capslock = caps
leftalt = lalt

[main]
caps = esc  # Now capslock = esc
spc = layer(nav)
```

### Key Reassignment

If alias matches valid key name, the key is redefined:

```ini
[aliases]
leftalt = meta  # leftalt BECOMES meta key
rightmeta = alt  # rightmeta BECOMES alt key

[main]
meta = oneshot(meta)  # Now works for both
```

### Use Case: Portable Configs

```ini
# common.conf
meta = oneshot(meta)
alt = oneshot(alt)

# macbook.conf
[aliases]
leftalt = meta    # Mac: Alt and Meta are swapped
rightmeta = alt

include common

# normal_keyboard.conf  
include common  # Works as-is
```

---

## Global Settings

### Complete Reference

```ini
[global]
# Macro timings
macro_timeout = 600              # First repeat delay (ms)
macro_repeat_timeout = 50        # Subsequent repeats (ms)
macro_sequence_timeout = 0       # Between keys in sequence (μs)

# Layer features
layer_indicator = 0              # CapsLock LED for layer (0/1)
default_layout = main            # Starting layout

# Chord settings
chord_timeout = 50               # Max key interval for chord (ms)
chord_hold_timeout = 0           # Min hold before chord fires (ms)

# Oneshot settings
oneshot_timeout = 0              # Oneshot expiration (ms, 0=never)

# Overload settings
overload_tap_timeout = 0         # Ignore tap if held longer (ms)

# Safety
disable_modifier_guard = 0       # Disable mod protection (0/1)
```

### Detailed Explanations

#### `macro_timeout`
Time before first macro repeat when key held.
- **Default**: 600ms
- **Lower**: Faster initial repeat
- **Use**: Holding arrow key, backspace, etc.

#### `macro_repeat_timeout`
Time between subsequent repeats.
- **Default**: 50ms (20 repeats/second)
- **Lower**: Faster repeat rate
- **Higher**: Slower, more controlled

#### `macro_sequence_timeout`
Microsecond delay between each keystroke in macro.
- **Default**: 0
- **Use**: Some systems need this to avoid input buffer overflow
- **Try**: 1000-5000 if macros behave oddly

#### `layer_indicator`
Uses CapsLock LED to show when layer is active.
- **0**: Off (default)
- **1**: On
- **Note**: Some Wayland compositors override this

#### `chord_timeout`
Maximum milliseconds between keys in chord.
- **Default**: 50ms
- **Lower**: More deliberate chording needed
- **Higher**: Easier to trigger, more accidental chords

#### `oneshot_timeout`
Auto-deactivate oneshot after this time.
- **Default**: 0 (never expires)
- **500-2000**: Useful to prevent stuck states

#### `overload_tap_timeout`
If key held longer than this, ignore tap action.
- **Default**: 0 (disabled)
- **Use**: Prevent accidental taps on long holds

---

## Application-Specific Remapping

> **📖 See Also**: For a complete guide including Git workflow, examples for Firefox/terminals/editors, and deployment best practices, see **APP_REMAPPING.md**.

### Setup

1. **Add user to keyd group:**
```bash
sudo usermod -aG keyd $USER
```

2. **Create app config:**
```bash
mkdir -p ~/.config/keyd
nano ~/.config/keyd/app.conf
```

3. **Start application mapper:**
```bash
keyd-application-mapper -d
```

4. **Auto-start (add to startup):**
```bash
# For X11: ~/.xinitrc
# For Wayland: varies by compositor
keyd-application-mapper -d
```

### Configuration Format

```ini
[application_name]
# Bindings are layer.key = action format
alt.tab = C-tab
control.t = C-t
```

### Finding Application Names

```bash
# Run mapper in foreground
keyd-application-mapper

# Switch to application - name will be printed
# Example output: "firefox"
```

### Examples

```ini
# ~/.config/keyd/app.conf

[alacritty]
# Terminal-friendly shortcuts
alt.] = macro(C-g n)  # Next tab
alt.[ = macro(C-g p)  # Previous tab
alt.t = macro(C-g c)  # New tab

[chromium]
# Browser shortcuts
alt.[ = C-S-tab
alt.] = C-tab
alt.w = C-F4

[code]
# VSCode
alt.enter = C-enter
meta./ = C-/

[zoom]
# Zoom shortcuts
meta.a = A-a  # Mute/unmute

[firefox]
# Firefox-specific
control.tab = macro(C-tab)
alt.1 = C-1
alt.2 = C-2
```

### Layer Syntax

```ini
[firefox]
# main.key for main layer
alt.tab = C-tab

# layer.key for specific layer
control.x = C-x
shift.enter = S-enter
```

---

## Advanced Techniques

### Homerow Mods (Complete Guide)

**Concept**: Use home row keys as modifiers when held.

**Basic Implementation:**
```ini
[main]
# Left hand: Meta, Alt, Control, Shift
a = lettermod(meta, a, 150, 200)
s = lettermod(alt, s, 150, 200)
d = lettermod(control, d, 150, 200)
f = lettermod(shift, f, 150, 200)

# Right hand: Shift, Control, Alt, Meta
j = lettermod(shift, j, 150, 200)
k = lettermod(control, k, 150, 200)
l = lettermod(alt, l, 150, 200)
; = lettermod(meta, ;, 150, 200)
```

**Advanced (with overloadi):**
```ini
[main]
a = overloadi(a, overloadt2(meta, a, 200), 150)
s = overloadi(s, overloadt2(alt, s, 200), 150)
d = overloadi(d, overloadt2(control, d, 200), 150)
f = overloadi(f, overloadt2(shift, f, 200), 150)
```

**Explanation:**
- **150ms idle timeout**: If typing quickly, acts as letter immediately
- **200ms hold timeout**: If held alone, becomes modifier
- **Intervening key**: If held + another key tapped, becomes modifier

**Tuning Tips:**
1. Start with 150/200
2. If too many accidental modifiers: increase idle timeout
3. If modifiers don't activate fast enough: decrease hold timeout
4. Test by typing common words: "father", "sale", "desk"

### Custom Shift Layer

Invert shift behavior for numbers:

```ini
[main]
1 = !
2 = @
3 = #
4 = $
5 = %
6 = ^
7 = &
8 = *
9 = (
0 = )

[shift]
1 = 1
2 = 2
3 = 3
4 = 4
5 = 5
6 = 6
7 = 7
8 = 8
9 = 9
0 = 0
```

### Navigation Layer

```ini
[main]
capslock = layer(nav)

[nav]
# Vim-style navigation
h = left
j = down
k = up
l = right

# Extended navigation
u = pageup
d = pagedown
0 = home
$ = end

# Editing
i = insert
a = end
o = enter
```

### Symbol Layer

```ini
[main]
space = overloadt(symbols, space, 200)

[symbols]
# Number row becomes F-keys
1 = f1
2 = f2
3 = f3
# ... etc

# Letters become symbols
a = !
s = @
d = #
f = $
g = %

# Navigation
h = left
j = down
k = up
l = right
```

### Mouse Integration (Experimental)

```ini
[ids]
*
m:046d:c52b  # Explicitly list mouse

[main]
# Mouse buttons can trigger layer changes
# Clears oneshot modifiers on click
```

### Multi-Keyboard Setup

**Scenario**: Laptop + external keyboard with different layouts

```ini
# /etc/keyd/laptop.conf
[ids]
0001:0001  # Laptop keyboard ID

[main]
rightalt = layer(control)  # No right control on laptop

include common

# /etc/keyd/external.conf
[ids]
0002:0002  # External keyboard ID

[main]
include common

# /etc/keyd/common
capslock = overload(control, esc)
shift = oneshot(shift)
# ... shared bindings
```

### Dynamic Bindings (IPC)

Temporarily change bindings at runtime:

```bash
# Bind minus key to Control+c
sudo keyd bind '- = C-c'

# Reset all bindings
sudo keyd bind reset

# Apply multiple bindings
sudo keyd bind '- = C-c' '= = C-v' '[ = esc'

# Bind in specific layer
sudo keyd bind 'nav.h = home'
```

**Use Cases:**
- Temporary test configurations
- Application-triggered bindings
- Scripts that modify keyboard based on context

### Layout Switching

```ini
[global]
default_layout = qwerty

[qwerty]
# Standard QWERTY (implicit)

[dvorak:layout]
q = '
w = ,
e = .
p = p
# ... full dvorak mapping

[colemak:layout]
d = s
e = f
f = t
# ... full colemak mapping

[main]
# Switch layouts
f1 = setlayout(qwerty)
f2 = setlayout(dvorak)
f3 = setlayout(colemak)
```

### Unicode Input

**Setup:**
1. Link compose file:
```bash
ln -s /usr/share/keyd/keyd.compose ~/.XCompose
```

2. Set display server to US layout

3. Restart applications

**Usage:**
```ini
[main]
# Direct unicode
a = á
e = €
s = ß

# Or via compose
rightalt = compose
[dia]
o = macro(compose o ")  # ö
e = macro(compose c =)   # €
```

### Sticky Modifiers

```ini
[main]
# Tap Control twice to lock it
control = oneshot(control)

[control]
control = toggle(control)
```

Now:
- Tap Control once: next key is Control+key
- Tap Control twice: Control stays on until tapped again

---

## Extensive Examples

### Example 1: Complete Beginner Setup

```ini
[ids]
*

[main]
# Caps Lock becomes Control when held, Esc when tapped
capslock = overload(control, esc)

# Real Esc becomes Caps Lock
esc = capslock

# Oneshot modifiers (tap, then key)
shift = oneshot(shift)
control = oneshot(control)
meta = oneshot(meta)
leftalt = oneshot(alt)
```

### Example 2: Advanced Navigation

```ini
[ids]
*

[main]
capslock = layer(nav)
space = overloadt(symbols, space, 200)

[nav:C]
# Vim navigation with Control modifier
h = left
j = down
k = up
l = right

# Word movement
b = C-left
w = C-right

# Line movement
0 = home
$ = end

# Page movement
u = pageup
d = pagedown

# Delete
x = delete
backspace = C-backspace  # Delete word

[symbols]
# Numbers on home row
a = 1
s = 2
d = 3
f = 4
g = 5
h = 6
j = 7
k = 8
l = 9
; = 0

# F-keys on number row
1 = f1
2 = f2
# ... etc
```

### Example 3: Programmer's Layout

```ini
[ids]
*

[global]
default_layout = main

[main]
# Quick access to symbols
capslock = layer(symbols)
tab = overloadt(nav, tab, 180)

# Homerow mods
a = lettermod(meta, a, 150, 200)
s = lettermod(alt, s, 150, 200)
d = lettermod(control, d, 150, 200)
f = lettermod(shift, f, 150, 200)

j = lettermod(shift, j, 150, 200)
k = lettermod(control, k, 150, 200)
l = lettermod(alt, l, 150, 200)
; = lettermod(meta, ;, 150, 200)

[symbols]
# Programming symbols on home row
h = -
j = =
k = _
l = +

# Brackets
u = [
i = ]
o = {
p = }

# Common pairs
s = (
d = )
f = <
g = >

# Special chars
a = !
; = :
' = "
/ = ?

[nav]
h = left
j = down
k = up
l = right
u = pageup
d = pagedown
0 = home
$ = end
```

### Example 4: Emacs-Style

```ini
[ids]
*

[main]
# Make Control easier to reach
capslock = layer(control)

[control]
# Cursor movement
f = right
b = left
n = down
p = up
a = home
e = end

# Delete
d = delete
h = backspace
k = macro(S-end delete)  # Kill line

# Search
s = C-f  # Find
r = C-h  # Replace

# Copy/paste
w = C-x
y = C-v
space = C-c  # Set mark

# Undo
/ = C-z
```

### Example 5: Gaming Config

```ini
[ids]
*

[main]
# WASD stays normal, everything else customized
capslock = space  # Jump/crouch
tab = esc
f = e  # Interact
r = r  # Reload
q = q  # Ability 1
e = f  # Ability 2

# Number row quick access
` = ~
1 = 1
2 = 2
3 = 3
4 = 4
5 = 5

# Toggle gaming mode
f10 = toggle(normal)

[normal]
# Reset everything to normal
capslock = capslock
tab = tab
f = f
r = r
q = q
e = e
```

### Example 6: TextBlade Emulation

```ini
[ids]
*

[global]
chord_timeout = 50
default_layout = colemak

[colemak:layout]
# Colemak layout
q = q
w = w
e = f
r = p
t = b
# ... etc

[main]
# Oneshot modifiers
shift = oneshot(shift)
control = oneshot(control)
leftalt = oneshot(alt)

# Bottom row modifier chords
z+x = layer(leftcontrol)
x+c = layer(leftalt)  
c+v = layer(leftmeta)
z+x+c = layer(leftcontrolalt)

m+, = layer(rightmeta)
,+. = layer(rightalt)
.+/ = layer(rightcontrol)

# Space bar for symbols
space = overload(green, space)

[green]
# Numbers and symbols
h = 1
j = 2
k = 3
l = 4
u = 5
i = 6
o = 7
p = 8

# Navigation
w = up
a = left
s = down
d = right
```

### Example 7: MacOS Muscle Memory

```ini
[ids]
*

[aliases]
# Swap Alt and Meta positions
leftalt = meta
leftmeta = alt

[main]
meta = oneshot(meta)
alt = oneshot(alt)

[meta]
# MacOS-style shortcuts
q = A-f4  # Quit
w = C-w   # Close window
t = C-t   # New tab
n = C-n   # New window
s = C-s   # Save
f = C-f   # Find
c = C-c   # Copy
v = C-v   # Paste
x = C-x   # Cut
z = C-z   # Undo
a = C-a   # Select all
```

### Example 8: Minimal Keyboard (60%)

```ini
[ids]
*

[main]
# Missing function keys
capslock = layer(fn)

# Missing navigation cluster
rightmeta = layer(nav)

[fn]
# Function keys on number row
1 = f1
2 = f2
3 = f3
4 = f4
5 = f5
6 = f6
7 = f7
8 = f8
9 = f9
0 = f10
- = f11
= = f12

# Media keys
q = mute
w = volumedown
e = volumeup
r = previoussong
t = playpause
y = nextsong

[nav]
# Navigation cluster
h = home
j = pagedown
k = pageup
l = end
i = insert
u = delete
o = printscreen
p = scrolllock
[ = pause
```

---

## Troubleshooting

### Common Issues

#### 1. Config Not Loading

**Check logs:**
```bash
sudo journalctl -eu keyd
```

**Validate config:**
```bash
sudo keyd check /etc/keyd/default.conf
```

**Common errors:**
- Missing `[ids]` section
- Invalid key names (use `keyd list-keys`)
- Invalid layer names
- Composite layer defined before component layers

#### 2. Keyboard Unresponsive

**Emergency exit:**
Press: `Backspace + Escape + Enter` simultaneously

**Prevention:**
- Always test configs incrementally
- Keep a backup working config
- Test in virtual machine first

#### 3. Some Keys Not Working

**Check device matching:**
```bash
sudo keyd monitor  # Shows device IDs
```

**Verify:**
- Device ID in `[ids]` section is correct
- Wildcard `*` is not excluded
- No conflicting config files

#### 4. Trackpad Disabled While Typing

**Solution:** Add to `/etc/libinput/local-overrides.quirks`
```ini
[Serial Keyboards]
MatchUdevType=keyboard
MatchName=keyd*keyboard
AttrKeyboardIntegration=internal
```

Then restart:
```bash
sudo systemctl restart keyd
```

#### 5. Modifiers "Stuck"

**Causes:**
- Oneshot without timeout
- Layer toggled accidentally

**Solutions:**
```ini
[global]
oneshot_timeout = 2000  # Auto-clear after 2s

[main]
esc = clear()  # Add clear binding
```

#### 6. Overload Not Working

**Check:**
- Timing values appropriate for typing speed
- No conflicting bindings
- Layer exists

**Debug:**
```bash
sudo keyd monitor -t  # Shows timing between keypresses
```

Adjust timeouts based on your typing:
- Fast: 100-150ms
- Normal: 150-200ms
- Slow: 200-300ms

#### 7. Unicode Not Displaying

**Requirements:**
1. Link compose file:
```bash
ln -s /usr/share/keyd/keyd.compose ~/.XCompose
```

2. Set display server to US layout

3. Restart applications

**Note:** GTK4 apps may crash with large compose files

#### 8. Application Mapper Not Working

**Check:**
```bash
# User in keyd group?
groups $USER | grep keyd

# Mapper running?
ps aux | grep keyd-application-mapper

# Window detected?
keyd-application-mapper  # Run in foreground
```

**Common causes:**
- Not in keyd group (requires logout)
- Mapper not started
- Application name mismatch

#### 9. Repeat Rate Too Fast/Slow

```ini
[global]
macro_timeout = 600         # Increase for slower initial
macro_repeat_timeout = 50   # Increase for slower repeat
```

#### 10. Keys Still Remapped After Disabling

**Solution:**
```bash
# Stop keyd
sudo systemctl stop keyd

# Kill any lingering processes
sudo pkill -9 keyd

# Restart if needed
sudo systemctl start keyd
```

### Debugging Techniques

#### 1. Monitor Mode
```bash
sudo keyd monitor -t
# Shows every keypress with timing
```

#### 2. Listen Mode
```bash
sudo keyd listen
# Shows layer state changes
```

#### 3. Verbose Logging
```bash
KEYD_DEBUG=2 sudo keyd
# Shows detailed internal state
```

#### 4. Incremental Testing
```ini
# Start minimal
[ids]
*

[main]
capslock = esc  # Test one binding

# Add gradually
# capslock = overload(control, esc)
# ...
```

---

## Best Practices

### Configuration Organization

#### 1. Use Include Files

```bash
# /etc/keyd/common.conf
# Shared bindings for all keyboards

# /etc/keyd/laptop.conf
[ids]
0001:0001
include common
# Laptop-specific additions

# /etc/keyd/external.conf
[ids]
0002:0002
include common
# External keyboard specific
```

#### 2. Comment Extensively

```ini
[main]
# Caps Lock: Tap for Esc, Hold for Control
capslock = overload(control, esc)

# Space: Hold for navigation layer (200ms threshold)
# Reduces accidental activation while typing
space = overloadt(nav, space, 200)
```

#### 3. Version Control

```bash
cd /etc/keyd
sudo git init
sudo git add .
sudo git commit -m "Working config"

# After changes
sudo git diff  # See what changed
sudo git commit -am "Added navigation layer"
```

#### 4. Layer Naming Conventions

- `nav` - Navigation
- `sym`/`symbols` - Symbols
- `num` - Number pad
- `fn` - Function keys
- `edit` - Editing commands
- `media` - Media controls

### Performance Tips

#### 1. Minimize Layers
- Don't create layer for every binding
- Group related bindings
- Use composite layers sparingly

#### 2. Optimize Chords
- Keep chord_timeout low (30-80ms)
- Only use chords for intentional combinations
- Avoid chords with commonly typed sequences

#### 3. Efficient Macros
- Keep macros short
- Use delays sparingly
- Prefer simple bindings over complex macros

### Safety Practices

#### 1. Always Have Escape Hatch

```ini
[main]
esc = clear()  # Clear all layers

# Or bind to unlikely combination
scrolllock = macro(backspace+escape+enter)  # Emergency exit
```

#### 2. Test Before Committing

```bash
# Test in foreground first
sudo systemctl stop keyd
sudo keyd

# If works, enable service
sudo systemctl start keyd
```

#### 3. Version Control with Git (Recommended)

```bash
# Store configs in Git-tracked dotfiles
mkdir -p ~/dotfiles/keyd/
cp /etc/keyd/default.conf ~/dotfiles/keyd/default.conf

# Initialize Git if not already done
cd ~/dotfiles/keyd/
git init
git add default.conf
git commit -m "Initial keyd configuration"

# Now edit here, deploy to /etc/keyd/
vim ~/dotfiles/keyd/default.conf
sudo cp ~/dotfiles/keyd/default.conf /etc/keyd/default.conf
sudo keyd reload

# Commit changes
git add default.conf
git commit -m "feat: add navigation layer"

# Rollback if needed
git revert HEAD
sudo cp default.conf /etc/keyd/default.conf
sudo keyd reload
```

**Alternative (Manual Backup - Not Recommended)**:
```bash
sudo cp /etc/keyd/default.conf /etc/keyd/default.conf.backup.$(date +%Y%m%d)
```

### Typing Comfort

#### 1. Start Simple, Iterate Continuously
Begin with basic remapping, add features as you identify pain points:
```ini
# Starting point: Essential ergonomics
capslock = overload(control, esc)

# When comfortable, add oneshot modifiers
shift = oneshot(shift)

# As needed, add navigation layer
space = layer(nav)

# Optional: Homerow mods (test carefully)
# a = lettermod(meta, a, 150, 200)
```

**Git Workflow** (iterate safely):
```bash
# Edit in dotfiles
vim ~/dotfiles/keyd/default.conf

# Deploy and test
sudo keyd check ~/dotfiles/keyd/default.conf
sudo cp ~/dotfiles/keyd/default.conf /etc/keyd/default.conf
sudo keyd reload

# Commit when stable
cd ~/dotfiles/keyd/
git add default.conf
git commit -m "feat: add feature description"

# Rollback if problematic
git revert HEAD
sudo cp default.conf /etc/keyd/default.conf
sudo keyd reload
```

#### 2. Match Your Speed
- Fast typers: Lower timeouts (100-150ms)
- Accuracy-focused: Higher timeouts (200-300ms)
- Adjust based on real usage

#### 3. Avoid Fighting Muscle Memory
- Don't remap too many letter keys
- Keep common shortcuts (C-c, C-v) working
- Add new shortcuts, don't replace existing

### Documentation

Keep a README with your config:

```markdown
# My keyd Configuration

## Philosophy
- Vim-style navigation
- Homerow mods for ergonomics
- Minimal finger movement

## Key Bindings

### Main Layer
- Capslock: Hold=Control, Tap=Esc
- Space: Hold=Navigation layer

### Navigation Layer (Space+)
- hjkl: Arrows
- u/d: Page up/down

## Changelog
- 2024-01-15: Added homerow mods
- 2024-01-20: Tweaked timing values
```

---

## Additional Resources

### Official

- **GitHub**: https://github.com/rvaiya/keyd
- **Man Page**: `man keyd`
- **IRC**: #keyd on OFTC

### Community

- **Reddit**: r/MechanicalKeyboards, r/linux
- **Discord**: Various keyboard communities
- **Issues**: GitHub issue tracker

### Related Tools

- **QMK**: Custom keyboard firmware (inspiration for keyd)
- **kmonad**: Alternative key remapper (Haskell-based)
- **xremap**: Rust-based alternative
- **Karabiner-Elements**: macOS equivalent

### Learning Path

1. **Start**: Basic remapping (capslock, esc)
2. **Beginner**: Layers, oneshot modifiers
3. **Intermediate**: Overload, navigation layers
4. **Advanced**: Homerow mods, chords, macros
5. **Expert**: Composite layers, IPC, application-specific

---

## Quick Reference Card

### Most Common Patterns

```ini
# Tap/Hold
key = overload(layer, action)

# Oneshot
key = oneshot(layer)

# Toggle
key = toggle(layer)

# Layer
key = layer(name)

# Macro
key = macro(expression)

# Disable
key = noop

# Shortcut
key = C-a  # Control+a

# Homerow mod
key = lettermod(layer, key, 150, 200)
```

### Useful Commands

```bash
# Monitor keys
sudo keyd monitor

# Monitor with timing
sudo keyd monitor -t

# Check config
sudo keyd check

# Reload config
sudo keyd reload

# View logs
sudo journalctl -eu keyd

# List key names
keyd list-keys

# Bind temporarily
sudo keyd bind 'key = action'

# Listen to layers
sudo keyd listen
```

### File Locations

```
/etc/keyd/              # Config directory
/etc/keyd/*.conf        # Config files
/usr/share/keyd/layouts/  # Included layouts
~/.config/keyd/app.conf   # Application mappings
/var/run/keyd.socket    # IPC socket
```

---

## Conclusion

This comprehensive guide covers all aspects of keyd configuration. Start simple, experiment gradually, and build up your perfect keyboard layout. Remember:

1. **Start small** - Don't change everything at once
2. **Test incrementally** - Validate each addition
3. **Backup configs** - Save working configurations
4. **Use version control** - Track changes over time
5. **Read the logs** - Errors are informative
6. **Join the community** - Ask questions, share configs

Happy keyboarding! 🎹

---

**Document Version**: 2.0  
**Last Updated**: February 2026  
**Maintained by**: Community  
**License**: MIT (same as keyd)
