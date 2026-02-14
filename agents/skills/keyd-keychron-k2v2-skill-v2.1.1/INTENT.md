# INTENT.md - User Profile & Operational Context

**Purpose**: Help AI agents understand WHO you are and HOW you work.

**Impact**: Prevents beginner-level suggestions, matches user sophistication.

---

## 👤 User Profile

### Experience Level

**System Administration**: ⭐⭐⭐⭐⭐ Expert
- Arch Linux power user (rolling release comfort)
- systemd fluency
- Comfortable with config files, bash scripts
- Understands kernel-level concepts

**Keyboard Customization**: ⭐⭐⭐⭐☆ Intermediate → Advanced
- Previously used **Kanata** (familiar with remapping concepts)
- Understands layers, modifiers, overload functions
- Currently learning keyd specifics
- Comfortable reading technical documentation

**Terminal Proficiency**: ⭐⭐⭐⭐⭐ Expert
- Terminal-first workflow
- Heavy command-line tool usage
- Bash scripting capable
- Prefers CLI over GUI for everything

**Programming**: ⭐⭐⭐⭐⭐ Professional
- Professional developer (primary occupation)
- Heavy keyboard usage (8+ hours/day)
- Precision and efficiency critical
- Code quality mindset

---

## 🎯 Workflow Characteristics

### Time Allocation (Daily Average)

**Neovim** (~60% of keyboard time)
- Primary text editor
- Modal editing (Normal, Insert, Visual modes)
- Heavy use of:
  - `hjkl` navigation (ingrained muscle memory)
  - Ctrl combinations (window management, commands)
  - Leader key workflows
  - Macros and registers
- Frequent mode switching

**Terminal Operations** (~30% of keyboard time)
- Shell commands (bash)
- Git operations (commits, merges, rebases)
- Build tools (make, cargo, npm, etc.)
- System administration
- File navigation
- SSH sessions

**Web Browsing / Communication** (~10% of keyboard time)
- Documentation research
- Code reviews
- Email/chat (secondary priority)
- Standard shortcuts expected to work

### Keyboard Usage Patterns

**High-Frequency Keys**:
1. `hjkl` (Vim navigation) - thousands of presses/day
2. `Ctrl` - heavy modifier usage
3. `Esc` - mode switching in Vim
4. `Enter` - command execution
5. `:` - Vim command mode
6. `/` - Vim search

**Medium-Frequency**:
- Brackets `[]{}()` - coding
- Symbols `!@#$%` - programming
- Space, Tab - indentation
- Shift - capitalization, selection

**Low-Frequency**:
- Function keys (F1-F12) - rare
- CapsLock - currently useless (prime for remapping)
- Nav column (PgUp/PgDn/Home/End) - occasional
- Media keys - very rare

---

## 🧠 Learning & Adaptation Style

### How User Learns New Configurations

**Documentation Reader** (Primary Learning Style)
- Reads full documentation before trying features
- Prefers understanding WHY something works
- Not a "trial-and-error" learner
- Values comprehensive guides over quick tips

**Systematic Tester**
- Tests one change at a time
- Validates each modification before adding more
- Uses version control for configs (git commits)
- Methodical, not impulsive

**Seeks Deep Understanding**
- Wants to know the mechanism, not just the result
- Asks "why" questions
- Learns principles, not just recipes
- Values conceptual models

**Self-Sufficient**
- Prefers to solve problems independently
- Consults documentation first
- Only asks for help after research
- Values teaching over hand-holding

---

## 🔄 Current Configuration Approach

### Philosophy: Continuous Iteration and Refinement

**Not bound by timelines** - Configuration is an ongoing process:
- Git-tracked dotfiles for version control
- Test-driven: validate each change before committing
- Incremental improvements, not big-bang rewrites
- Balance stability with experimentation

**Current Capability Level**: 
- Comfortable with layers and overload functions
- Actively refining timing and ergonomics
- Open to advanced features when they solve real problems
- Sophistication evolves with experience, not calendar dates

**Decision Framework**:
- Does this solve an actual pain point? → Try it
- Does this break existing muscle memory? → Needs strong justification
- Can I revert easily? → Experiment freely (Git makes this safe)
- Is this maintainable long-term? → Keep or discard

**Acceptable Friction**:
- Willing to invest time in setup and tuning
- Expects some adaptation period for new bindings
- Tolerates occasional mistakes during learning
- Fine with fine-tuning timing values iteratively

### Unacceptable Friction

**Deal Breakers** (will abandon approach):

❌ **"Here are 40 shortcuts to memorize"**
- Cognitive overload
- No logical grouping
- Rote memorization required

❌ **Breaking existing workflows without clear win**
- Muscle memory disruption without benefit
- Incompatible with Neovim/Vim keybindings
- Conflicts with Hyprland shortcuts

❌ **Configs requiring constant tweaking**
- "Set and forget" preferred after initial tuning
- Don't want to babysit timing values
- Should be stable once dialed in

❌ **Black-box solutions without explanation**
- "Just use this config" - no context
- Unclear what each line does
- No understanding of trade-offs

❌ **GUI dependency**
- Terminal solutions only
- No desktop app requirements
- Text config files preferred

❌ **Not Git-tracked**
- All configs must be version controlled
- Manual backups are insufficient
- Need history and rollback capability

---

## 🔧 Technical Environment

### Fixed Infrastructure

**Operating System**:
- Distribution: Arch Linux
- Update Model: Rolling release (latest everything)
- Kernel: Latest stable
- Init System: systemd

**Window Manager**:
- Compositor: Hyprland
- Display Server: Wayland (not X11)
- Tiling: Yes (manual tiling WM)
- Meta key: Heavily used for window management

**Shell**:
- Primary: bash
- Terminal: alacritty (or kitty)
- Multiplexer: tmux (occasional)

**Editor**:
- Primary: Neovim
- Config: Heavily customized
- Plugins: Many (LSP, treesitter, telescope, etc.)
- Muscle Memory: Deep Vim keybindings

**Development Tools**:
- Git: CLI (not GUI)
- Build Tools: make, cargo, npm, etc.
- Debuggers: gdb, lldb (CLI)
- All terminal-based

### Integration Points

**Hyprland Bindings (Meta-based)**:
```
Meta + Enter = Terminal
Meta + Q = Close window
Meta + 1-9 = Workspace switching
Meta + Shift + 1-9 = Move window to workspace
Meta + H/J/K/L = Focus window
# Many more...
```

**Critical**: Any keyd config MUST NOT override Meta key.

**Neovim Keybindings (Modal)**:
```
Normal mode: hjkl navigation, dd delete, yy yank, etc.
Insert mode: Standard typing
Visual mode: Selection with v, V, Ctrl+V
Command mode: :w :q :wq etc.
```

**Critical**: Any keyd config should complement, not conflict with Vim.

**Shell Shortcuts**:
```
Ctrl+C = Kill process
Ctrl+D = EOF / Logout
Ctrl+R = Reverse search
Ctrl+A/E = Line start/end
# Standard readline bindings
```

**Critical**: Don't break standard shell shortcuts.

---

## 🎨 Philosophy & Values

### Configuration Philosophy

> **"Enhance the keyboard, don't transform it"**

**Core Principles**:

1. **Respect Physical Layout**
   - K2v2 already has good nav column
   - Don't fight the hardware
   - Leverage existing strengths

2. **Layers as Tools, Not Replacements**
   - Augment functionality
   - Don't hide original keys completely
   - Always have escape hatch

3. **Modifiers are Helpers**
   - Reduce pinky strain
   - Speed up common operations
   - But don't become barriers

4. **Macros for Repetition Only**
   - Automate tedious tasks
   - Not for basic character entry
   - Keep configs readable

5. **Git-Tracked Everything**
   - Version control is not optional
   - History is valuable
   - Rollback must be easy

### Quality Over Quantity

**Preference Hierarchy**:

1. **10 well-tuned bindings** > 50 mediocre ones
2. **One perfect layer** > three half-baked layers
3. **Timing precision** > feature count
4. **Muscle memory preservation** > novelty
5. **Git history** > manual backups

**Decision Framework**:
- If unsure, prefer simpler solution
- If conflict, preserve Vim keybindings
- If complex, require strong justification
- If experimental, ensure easy rollback (Git)

### Success Metrics

**What "Success" Looks Like**:

✅ **Positive Indicators**:
- Can type common code patterns faster
- Less pinky strain at end of day (RSI prevention)
- Existing shortcuts still work (Neovim, Hyprland)
- Config survives system updates
- Rarely think about keyboard (it "just works")
- Git history shows thoughtful iteration
- Can rollback bad changes easily

❌ **Failure Indicators**:
- Constantly correcting mistyped keys
- Forgetting which layer is active
- Breaking muscle memory
- Frustration > productivity gain
- Needing reference sheet after weeks
- Lost changes due to no version control
- Fear of experimenting (no easy rollback)

### Ergonomics vs. Efficiency Trade-Off

**Willing to sacrifice**:
- Some initial speed (during learning)
- Aesthetic perfection
- "Cool factor"

**NOT willing to sacrifice**:
- Long-term ergonomics
- Vim muscle memory
- Terminal workflow efficiency
- System stability
- Version control (Git)

---

## 💼 Professional Context

### Development Focus

**Primary Languages** (assume one or more):
- Systems programming (Rust, C, C++)
- Web development (JavaScript, TypeScript)
- Scripting (Python, bash)
- Data analysis (Python, R)

**Common Coding Patterns**:
- Heavy bracket/brace usage `{}[]()`
- Symbols `!@#$%^&*`
- Arrows `->` `=>` `<-`
- Comparisons `==` `!=` `>=` `<=`
- String concatenation `+` `"`

**Optimal Symbol Access**: 
- Frequently used symbols should be <2 keystrokes
- Rare symbols can be 3+ keystrokes
- Logical grouping (all brackets together, etc.)

### Collaboration Style

**Primary Communication**:
- Git commits (written carefully)
- Code reviews (thoughtful feedback)
- Documentation (values quality docs)

**Secondary**:
- Chat/Email (efficient, concise)
- Video calls (occasional)

**Keyboard Impact**: 
- Long-form writing important
- Precision typing valued
- Speed secondary to accuracy

---

## 📂 Configuration Management

### Git-Tracked Dotfiles Structure

**Primary Workflow**:
```
~/dotfiles/keyd/
├── default.conf      # Main keyboard config
├── app.conf          # Application-specific bindings
├── README.md         # Personal notes and rationale
└── .git/             # Version history
```

**Deployment Flow**:
```bash
# 1. Edit in dotfiles
vim ~/dotfiles/keyd/default.conf

# 2. Validate
sudo keyd check ~/dotfiles/keyd/default.conf

# 3. Deploy
sudo cp ~/dotfiles/keyd/default.conf /etc/keyd/default.conf
sudo keyd reload

# 4. Test and commit
git add default.conf
git commit -m "feat: add navigation layer"

# 5. Rollback if needed
git revert HEAD
sudo cp default.conf /etc/keyd/default.conf
sudo keyd reload
```

**Git Commit Style**:
- Conventional commits preferred: `feat:`, `fix:`, `refactor:`
- Descriptive messages explaining WHY, not just WHAT
- Atomic commits (one logical change per commit)

---

## 📄 Migration Context

### Coming From Kanata

**Familiar Concepts**:
- Layers and layer activation
- Tap-hold (overload in keyd terms)
- Oneshot modifiers
- Chord detection
- Configuration syntax (similar to keyd)

**Muscle Memory to Preserve**:
- Whatever was working in Kanata
- Standard modifier positions
- Common shortcuts

**Open to Change**:
- keyd-specific optimizations
- Better timing algorithms
- Simplified config if possible
- Wayland-specific improvements

### Expectations from Previous Experience

**What Worked Well** (continue):
- Layer-based organization
- Incremental complexity
- Clear config file structure
- Version-controlled configs

**What Could Improve** (interested in):
- Better timing tuning
- More precise overload detection
- Easier debugging tools
- Better Wayland integration
- More robust application-specific bindings

---

## 🎯 Specific Needs & Preferences

### Keyboard Comfort

**Pain Points** (current):
- Pinky strain from Ctrl usage
- CapsLock wasted (prime real estate)
- Symbol access slower than desired
- Navigation sometimes requires hand movement

**Desired Improvements**:
- Reduced pinky workload
- CapsLock becomes useful
- Symbols within 1-2 keystrokes
- Vim navigation everywhere (hjkl)

### Productivity Gains Sought

**Top Priorities**:
1. **Faster symbol access** (programming efficiency)
2. **Less hand movement** (ergonomics)
3. **Preserved muscle memory** (Vim, shell)
4. **Reliable timing** (no misfires)
5. **Easy experimentation** (Git rollback)

**Secondary Priorities**:
- Media control convenience
- Function key access
- Quick window management
- Application-specific tweaks

**Not Important**:
- RGB customization (Fn/Light keys are hardware-level anyway)
- Gaming features
- Fancy macros for text expansion

---

## 📊 Usage Statistics (Hypothetical)

If we measured this user's keyboard usage:

**Key Presses per Day**: ~30,000-50,000
- Neovim editing: 20,000
- Terminal commands: 10,000
- Web/other: 5,000

**Most Common Shortcuts**:
1. `Ctrl+C` (copy/kill) - hundreds/day
2. `Ctrl+V` (paste) - hundreds/day
3. `Ctrl+W` (window operations) - hundreds/day
4. `Esc` (Vim mode) - thousands/day
5. `:` (Vim command) - hundreds/day

**Least Common**:
- CapsLock - <5/day (mostly accidental)
- F1-F12 - <10/day combined
- NumLock/ScrollLock - never
- Fn/Light keys - hardware-level (not tracked)

---

## 🎓 Agent Adaptation Guidelines

**Based on this profile, AI agents should:**

### DO:
✅ Assume technical competence - no basic explanations
✅ Provide detailed reasoning - user wants to understand
✅ Suggest Vim-compatible solutions - core workflow
✅ Respect terminal-first approach - no GUI recommendations
✅ Emphasize Git workflow - version control is mandatory
✅ Offer optimization suggestions - user is always iterating
✅ Link to documentation - user is a reader
✅ Explain trade-offs - user values informed decisions

### DON'T:
❌ Explain what a modifier is - user knows
❌ Suggest breaking Vim keybindings - dealbreaker
❌ Recommend GUI tools - user won't use them
❌ Provide 50 bindings at once - cognitive overload
❌ Assume gaming use case - wrong focus
❌ Ignore Hyprland Meta usage - will break workflow
❌ Skip technical details - user wants depth
❌ Suggest manual backups - Git history is the backup
❌ Prescribe fixed timelines - user iterates continuously

---

## 🔗 Cross-References

**Related Files**:
- **CONSTRAINTS.md**: See hard rules based on this user's system
- **ANTI_PATTERNS.md**: Common failures for users with this profile
- **KEYBOARD_LAYOUT.md**: Hardware this user actually has
- **SKILL.md**: How to interact with this user effectively

---

**Profile Version**: 2.1.0  
**Last Updated**: 2024-02-11  
**Profile Type**: Advanced Developer, Terminal-First, Vim-Centric, Git-Driven  
**Adaptation Priority**: High - matching sophistication is critical
