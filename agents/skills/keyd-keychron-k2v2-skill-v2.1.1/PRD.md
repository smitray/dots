# Product Requirements Document (PRD)
## keyd-keychron-k2v2 AI Agent Skill

**Version:** 2.0  
**Date:** February 10, 2026  
**Status:** Final Draft  
**Author:** System Architect  
**Target Users:** AI Coding Agents (Claude, Cursor, Copilot, etc.)

---

## Executive Summary

### Problem Statement
AI coding agents provide generic keyboard configuration advice that:
- Ignores specific hardware constraints (75% vs 60% vs split keyboards)
- Assumes wrong operating systems and workflows
- Suggests beginner-level solutions to advanced users
- Breaks existing muscle memory without warning
- Provides unsafe configurations without backup reminders

### Solution
A comprehensive, hardware-specific, context-aware skill that enables AI agents to provide:
- **Personalized** recommendations based on exact keyboard layout
- **Safe** configurations with mandatory backup protocols
- **Progressive** learning paths matching user experience level
- **Constrained** suggestions that avoid common pitfalls
- **Proactive** optimizations leveraging hardware advantages

### Success Metrics
- **70% reduction** in inappropriate suggestions (via CONSTRAINTS.md)
- **Zero** suggestions for wrong keyboard layouts
- **100%** of configurations include backup reminders
- **90%+** user satisfaction with recommendation relevance
- **<5 iterations** to reach working configuration (down from 15+)

---

## Objectives

### Primary Objectives
1. **Hardware Accuracy**: Agent always references correct K2v2 layout
2. **Safety First**: Every configuration change includes backup steps
3. **Progressive Complexity**: Match user's current skill level
4. **Context Awareness**: Understand Arch+Hyprland+Neovim workflow
5. **Proactive Optimization**: Suggest improvements, not just answers

### Secondary Objectives
1. **Future-Proofing**: Machine-readable JSON for next-gen agents
2. **Maintainability**: Easy to update as user needs evolve
3. **Portability**: Works across different AI coding assistants
4. **Documentation**: Self-documenting configuration decisions

---

## Target Audience

### Primary User Profile
**Technical Level**: Advanced
- Arch Linux power user
- Professional developer
- Terminal-first workflow
- Neovim expert
- Previously used Kanata (familiar with key remapping)

**Hardware Context**:
- Keychron K2 v2 (75% ANSI, 84 keys)
- Gateron Brown switches
- Mac/Windows dual-mode capable
- RGB backlit (but not priority)

**System Environment**:
- OS: Arch Linux (rolling release)
- Display Server: Wayland
- Compositor: Hyprland
- Shell: bash
- Terminal: alacritty/kitty
- Editor: Neovim
- Key Remapper: keyd (migrating from Kanata)

**Workflow Characteristics**:
- 60% Neovim usage (heavy modal editing)
- 30% Terminal operations (git, shell commands)
- 10% Web/communication
- Heavy Ctrl combinations
- Vim-style navigation preferred
- Automation-oriented mindset

### Secondary Audience
AI coding agents that will consume this skill:
- Claude Code
- Cursor
- GitHub Copilot
- Continue
- Windsurf
- Any agent supporting skill/knowledge files

---

## User Stories

### Epic 1: Safe Configuration
```
As a user,
I want every configuration suggestion to include backup steps,
So that I can safely experiment without breaking my keyboard.

Acceptance Criteria:
- Every config change shows backup command first
- Agent warns before destructive operations
- Emergency recovery steps always provided
- Validation commands included (keyd check)
```

### Epic 2: Hardware-Aware Suggestions
```
As a user with a Keychron K2v2,
I want suggestions specific to my 75% layout,
So that I don't waste time on impossible configurations.

Acceptance Criteria:
- Agent references exact key positions
- Never suggests keys that don't exist (e.g., split keyboard keys)
- Leverages K2v2 advantages (nav column, dedicated arrows)
- Acknowledges K2v2 limitations (Fn key hardware-level)
```

### Epic 3: Progressive Learning
```
As an advanced user new to keyd,
I want recommendations that match my current skill level,
So that I'm not overwhelmed or patronized.

Acceptance Criteria:
- Week 1: Basic remappings (capslock, oneshot)
- Week 2: Layers and navigation
- Month 1: Advanced features (homerow mods)
- No "what is a modifier" explanations unless asked
```

### Epic 4: Workflow Integration
```
As a Neovim user on Hyprland,
I want configurations that enhance my workflow,
So that my keyboard setup complements my tools.

Acceptance Criteria:
- Doesn't conflict with Hyprland Meta bindings
- Respects Vim hjkl muscle memory
- Terminal-friendly suggestions (no GUI tools)
- Arch Linux command syntax (pacman, systemctl)
```

### Epic 5: Proactive Optimization
```
As someone learning keyd,
I want the agent to suggest improvements I haven't thought of,
So that I can discover optimal configurations faster.

Acceptance Criteria:
- Agent suggests underutilized keys (rightalt, rightctrl)
- Recommends timing optimizations based on typing patterns
- Identifies anti-patterns in user's config
- Proposes layer consolidation when appropriate
```

---

## Technical Requirements

### Functional Requirements

#### FR1: File Structure
**Requirement**: Skill must be organized as modular, single-purpose files

**Files Required**:
1. `SKILL.md` - Core agent protocol and instructions
2. `CONSTRAINTS.md` - Hard and soft constraints
3. `INTENT.md` - User profile and operational context
4. `ANTI_PATTERNS.md` - Common failures to avoid
5. `KEYBOARD_LAYOUT.md` - Exact K2v2 physical layout
6. `REFERENCE_WIKI.md` - Complete keyd technical reference
7. `QUICK_REFERENCE.md` - Command and syntax cheat sheet
8. `EXAMPLES.md` - Ready-to-use configurations
9. `context.json` - Machine-readable metadata
10. `.skill-meta.yml` - Skill discovery metadata

**Rationale**: Separation allows agents to load only relevant sections, reducing token usage.

#### FR2: Constraint System
**Requirement**: Hard constraints must be enforceable and testable

**Constraints Categories**:
- **Hardware Constraints**: Physical keyboard limitations
- **System Constraints**: OS/WM/software stack
- **Configuration Constraints**: keyd-specific rules
- **Workflow Constraints**: User preference boundaries
- **Safety Constraints**: Backup and validation requirements

**Enforcement**: Agent must acknowledge constraint violations explicitly

#### FR3: Context Awareness
**Requirement**: Agent must reference user context in every response

**Mandatory Context Elements**:
- Keyboard model (K2v2)
- Layout type (75%)
- OS (Arch Linux)
- Compositor (Hyprland)
- Workflow (Neovim-centric)

**Response Format**: "On your K2v2, [recommendation]..."

#### FR4: Progressive Complexity
**Requirement**: Suggestions must scale with user progression

**Phases**:
- **Phase 1** (Week 1): Basic remapping (capslock, oneshot modifiers)
- **Phase 2** (Week 2): Layers (nav, symbols)
- **Phase 3** (Month 1): Advanced overload, timing optimization
- **Phase 4** (Ongoing): Homerow mods, complex macros

**Detection**: Agent infers phase from user's current config complexity

#### FR5: Safety Protocol
**Requirement**: Every configuration change follows safety steps

**Mandatory Steps**:
1. Show current config section (if modifying)
2. Provide backup command with timestamp
3. Show new config with diff if applicable
4. Include validation command (`sudo keyd check`)
5. Include reload command (`sudo keyd reload`)
6. Provide rollback instructions

**Emergency**: Always mention `Backspace+Escape+Enter` emergency kill

### Non-Functional Requirements

#### NFR1: Performance
- **Token Efficiency**: Core files <50k tokens combined
- **Load Time**: Agent can parse full skill <2 seconds
- **Response Time**: Context-aware response within standard limits

#### NFR2: Maintainability
- **Version Control**: All files version-tracked
- **Update Process**: Single-file updates don't break others
- **Documentation**: Each file self-documenting with headers

#### NFR3: Portability
- **Multi-Agent**: Works with Claude, Cursor, Copilot, Continue
- **Cross-Platform**: Arch-specific but generalizable to other Linux
- **Format**: Markdown + JSON for maximum compatibility

#### NFR4: Accuracy
- **Hardware Facts**: 100% accurate K2v2 layout
- **Command Syntax**: Valid for Arch Linux + keyd 2.5.0
- **Examples**: All tested and working configurations

#### NFR5: Completeness
- **Coverage**: All keyd features documented
- **Edge Cases**: Common problems and solutions included
- **Troubleshooting**: Diagnostic flowcharts provided

---

## File Specifications

### 1. SKILL.md (Core Protocol)

**Purpose**: Primary agent instruction file  
**Size Target**: <8k tokens  
**Critical Sections**:
- Conversation protocol (how to interact)
- K2v2 specific optimizations
- Proactive suggestions framework
- Internal file references
- Testing protocol

**Agent Behavior**: 
- Read this file first on ANY keyd-related query
- Follow conversation protocol exactly
- Reference other files as needed

### 2. CONSTRAINTS.md (What NOT to Do)

**Purpose**: Prevent bad suggestions  
**Size Target**: <3k tokens  
**Impact**: 70% reduction in inappropriate advice

**Structure**:
```markdown
## Hard Constraints - NEVER violate
- [List of absolute rules]

## Soft Constraints - Avoid unless requested
- [List of preferences]

## Violation Protocol
- How to handle constraint conflicts
```

**Key Constraints**:
- Never remap Fn key (hardware-level)
- Never override Meta (Hyprland uses it)
- Never suggest 60% keyboard layouts
- Never skip backup commands
- Never provide >8 overload bindings

### 3. INTENT.md (Who You Are)

**Purpose**: User profile and context  
**Size Target**: <4k tokens  
**Impact**: Matches sophistication level, stops beginner suggestions

**Structure**:
```markdown
## User Profile
- Experience level
- Technical background

## Workflow Characteristics
- Primary use cases
- Time allocation
- Tool preferences

## Learning Style
- How user learns
- Acceptable friction
- Unacceptable friction

## Philosophy & Values
- Configuration philosophy
- Quality metrics
```

### 4. ANTI_PATTERNS.md (Common Failures)

**Purpose**: Recognize and prevent failure modes  
**Size Target**: <5k tokens  
**Categories**:
- Layer anti-patterns
- Overload anti-patterns
- Workflow anti-patterns
- System-specific anti-patterns
- Maintenance anti-patterns

**Format**: 
```markdown
❌ The [Pattern Name]
[Bad example code]
Problem: [Why it fails]
✅ Instead: [Better approach]
```

### 5. KEYBOARD_LAYOUT.md (Physical Truth)

**Purpose**: Single source of truth for hardware  
**Size Target**: <2k tokens  
**Content**:
- Row-by-row key listing
- ASCII art diagram
- Physical measurements
- Key name mappings
- Special features (nav column, etc.)

**Agent Usage**: Reference EVERY time suggesting key mapping

### 6. REFERENCE_WIKI.md (Technical Deep Dive)

**Purpose**: Complete keyd documentation  
**Size Target**: <30k tokens  
**Content**:
- All keyd features
- Complete syntax reference
- Overload functions explained
- Macro syntax
- Layer system
- Troubleshooting

**Agent Usage**: Load sections on-demand for technical questions

### 7. QUICK_REFERENCE.md (Cheat Sheet)

**Purpose**: Fast lookups  
**Size Target**: <3k tokens  
**Content**:
- Command reference
- Syntax examples
- Common patterns
- Timing values
- Key names

**Format**: Tables, code blocks, minimal prose

### 8. EXAMPLES.md (Copy-Paste Configs)

**Purpose**: Working configurations  
**Size Target**: <5k tokens  
**Categories**:
- Beginner setup
- Vim user setup
- Programmer setup
- Gaming mode toggle
- Media controls

**Requirement**: Every example tested and working

### 9. context.json (Machine-Readable)

**Purpose**: Future-proof parsing  
**Size Target**: <1k tokens  
**Schema**:
```json
{
  "user_profile": {},
  "hardware": {},
  "system": {},
  "software_stack": {},
  "constraints": {},
  "skill_metadata": {}
}
```

**Agent Usage**: Quick context loading for advanced agents

### 10. .skill-meta.yml (Discovery Metadata)

**Purpose**: Skill registration  
**Size Target**: <500 tokens  
**Content**:
- Skill identification
- Version info
- Keywords/tags
- Agent compatibility
- File manifest

---

## Implementation Phases

### Phase 1: Core Files (Week 1)
**Deliverables**:
- ✅ SKILL.md (conversation protocol)
- ✅ CONSTRAINTS.md (critical rules)
- ✅ INTENT.md (user context)
- ✅ KEYBOARD_LAYOUT.md (hardware facts)

**Success Criteria**:
- Agent references K2v2 layout correctly
- No suggestions for wrong hardware
- Backup commands always included

### Phase 2: Reference Materials (Week 1-2)
**Deliverables**:
- ✅ REFERENCE_WIKI.md (complete keyd docs)
- ✅ QUICK_REFERENCE.md (cheat sheet)
- ✅ EXAMPLES.md (working configs)

**Success Criteria**:
- Agent answers technical questions accurately
- Examples are copy-paste ready
- No hallucinated keyd features

### Phase 3: Advanced Features (Week 2)
**Deliverables**:
- ✅ ANTI_PATTERNS.md (failure prevention)
- ✅ context.json (machine-readable)
- ✅ .skill-meta.yml (discovery)

**Success Criteria**:
- Agent identifies bad patterns in user configs
- Future-proof for next-gen agents
- Multi-agent compatibility verified

### Phase 4: Testing & Refinement (Week 3)
**Deliverables**:
- ✅ Complete test suite
- ✅ Validation scripts
- ✅ Documentation review

**Success Criteria**:
- All user stories validated
- Edge cases handled
- Ready for production use

---

## Testing Strategy

### Unit Testing

**Test 1: Constraint Enforcement**
```
Input: "How do I remap the Fn key?"
Expected: Agent explains Fn is hardware-level, suggests alternatives
Fail: Agent provides Fn remapping config
```

**Test 2: Hardware Awareness**
```
Input: "Create a config for my keyboard"
Expected: Agent references K2v2 specifically, mentions 75% layout
Fail: Generic config without K2v2 context
```

**Test 3: Safety Protocol**
```
Input: "Change my capslock key"
Expected: Backup command shown first
Fail: Config provided without backup reminder
```

### Integration Testing

**Test 4: Progressive Complexity**
```
Scenario: New user asks for advanced homerow mods
Expected: Agent suggests starting simpler, provides progression path
Fail: Immediately provides complex homerow mod config
```

**Test 5: Workflow Integration**
```
Input: "Configure for coding"
Expected: Neovim-friendly, terminal-focused suggestions
Fail: GUI-based or IDE-centric suggestions
```

### User Acceptance Testing

**Test 6: Real User Interaction**
```
User Profile: Advanced developer, new to keyd
Task: Configure capslock to control/escape
Success: 
- Single iteration to working config
- User understands why it works
- No keyboard breakage
```

**Test 7: Proactive Optimization**
```
User Shows: Basic config with just capslock remapping
Expected: Agent suggests leveraging rightalt, navigation layer
Fail: Agent only answers direct questions
```

### Edge Case Testing

**Test 8: Conflicting Constraints**
```
Input: "I want homerow mods but minimal learning curve"
Expected: Agent explains conflict, suggests middle ground
Fail: Agent ignores conflict or chooses without explanation
```

**Test 9: Hyprland Conflicts**
```
Input: "Make Meta key do X"
Expected: Agent warns about Hyprland conflict
Fail: Config breaks Hyprland window management
```

---

## Success Criteria

### Quantitative Metrics

| Metric | Target | Measurement |
|--------|--------|-------------|
| Inappropriate suggestions | <30% of baseline | Manual review of 100 interactions |
| Backup reminder inclusion | 100% | Automated scan of responses |
| Hardware accuracy | 100% | Key name validation against K2v2 |
| Config success rate | >90% | User testing (working on first try) |
| Anti-pattern detection | >80% | Test against known bad configs |

### Qualitative Metrics

| Aspect | Success Indicator |
|--------|-------------------|
| User Satisfaction | "Agent understands my setup" feedback |
| Sophistication Match | No beginner explanations unless asked |
| Proactive Value | User discovers optimizations they didn't know to ask for |
| Safety Culture | User trusts recommendations (never broke keyboard) |
| Learning Curve | User comfortable with keyd within 2 weeks |

### Agent Behavior Validation

**Before Skill**:
```
User: "Configure my keyboard"
Agent: "Here's a split keyboard config with 40 homerow mods!"
```

**After Skill**:
```
User: "Configure my keyboard"
Agent: "On your K2v2's 75% layout, let's start with capslock 
since you're coming from Kanata. Based on your Neovim workflow, 
I recommend:

First, backup:
sudo cp /etc/keyd/default.conf /etc/keyd/default.conf.backup.$(date +%Y%m%d)

Then add to [main]:
capslock = overload(control, esc)

This gives you Control when held (for your heavy Ctrl usage in Neovim), 
Escape when tapped (keeping Vim muscle memory).

Test with: sudo keyd reload && sudo keyd monitor -t

Want to add oneshot modifiers next, or explore navigation layers?"
```

---

## Risks & Mitigations

### Risk 1: Agent Ignores Constraints
**Likelihood**: Medium  
**Impact**: High  
**Mitigation**: 
- Make constraints prominent in SKILL.md
- Repeat critical constraints in multiple files
- Add violation protocol with explicit acknowledgment

### Risk 2: Context Overload
**Likelihood**: Low  
**Impact**: Medium  
**Mitigation**:
- Keep individual files focused
- Use lazy loading (load sections on demand)
- Provide QUICK_REFERENCE for common queries

### Risk 3: Hardware Evolution
**Likelihood**: Low (K2v2 is fixed hardware)  
**Impact**: Low  
**Mitigation**:
- Version control all files
- Add update protocol in SKILL.md
- Make KEYBOARD_LAYOUT.md easily replaceable

### Risk 4: Multi-Agent Compatibility
**Likelihood**: Medium  
**Impact**: Medium  
**Mitigation**:
- Use standard formats (Markdown, JSON, YAML)
- Test with multiple agents
- Provide .skill-meta.yml for discovery

### Risk 5: User Skill Mismatch
**Likelihood**: Low (user is advanced)  
**Impact**: Low  
**Mitigation**:
- INTENT.md explicitly states user level
- Agent can verify with questions
- Progressive complexity allows adjustment

---

## Maintenance Plan

### Regular Updates

**Monthly**:
- Review constraint effectiveness
- Add new anti-patterns discovered
- Update examples with user favorites

**Quarterly**:
- Verify keyd version compatibility
- Update REFERENCE_WIKI.md with new features
- Refresh context.json with evolved preferences

**As Needed**:
- Fix any inaccuracies immediately
- Add new examples for common requests
- Expand ANTI_PATTERNS.md with real failures

### Version Control

```bash
~/.skills/keyd-keychron-k2v2/
├── .git/
│   └── [Track all changes]
├── CHANGELOG.md  # Document all updates
└── VERSION       # Semantic versioning
```

### Feedback Loop

**Collect**:
- Interactions that produced wrong advice
- User corrections to agent suggestions
- Requests that weren't handled well

**Analyze**:
- Why did agent fail?
- What constraint was missing?
- What context was unclear?

**Update**:
- Add missing constraints
- Clarify ambiguous context
- Expand anti-patterns
- Improve examples

---

## Dependencies

### External Dependencies
- **keyd**: 2.5.0+ (core remapping daemon)
- **Arch Linux**: Current (rolling release)
- **Hyprland**: 0.35.0+ (Wayland compositor)
- **systemd**: Standard init system

### Skill Dependencies
- None (self-contained skill)

### Agent Requirements
- **Token Window**: Ability to handle 50k+ tokens
- **Markdown Support**: Parse and understand markdown
- **JSON Support**: Parse context.json
- **File System**: Access multiple files in skill directory

---

## Deployment

### Installation Locations

**Primary** (Recommended):
```bash
~/.skills/keyd-keychron-k2v2/
```

**Agent-Specific**:
```bash
~/.cursor/skills/keyd-keychron-k2v2/
~/.config/claude/skills/keyd-keychron-k2v2/
~/.config/continue/skills/keyd-keychron-k2v2/
```

**Project-Based**:
```bash
./.skills/keyd-keychron-k2v2/  # For specific projects
```

### Installation Steps

```bash
# 1. Extract skill package
unzip keyd-keychron-k2v2-skill.zip

# 2. Move to skill directory
mv keyd-keychron-k2v2 ~/.skills/

# 3. Verify structure
ls -la ~/.skills/keyd-keychron-k2v2/

# 4. Test with agent
# Prompt: "How should I configure my K2v2 keyboard?"
```

### Verification

**Test Prompts**:
1. "What keyboard do I have?" → Should mention K2v2
2. "Suggest a config change" → Should include backup command
3. "How do I remap Fn key?" → Should explain it's impossible
4. "Create homerow mods" → Should suggest progression first

---

## Appendices

### Appendix A: File Size Budget

| File | Target Size | Max Size | Priority |
|------|-------------|----------|----------|
| SKILL.md | 8k tokens | 12k | Critical |
| CONSTRAINTS.md | 3k tokens | 5k | Critical |
| INTENT.md | 4k tokens | 6k | Critical |
| KEYBOARD_LAYOUT.md | 2k tokens | 3k | Critical |
| REFERENCE_WIKI.md | 30k tokens | 40k | High |
| QUICK_REFERENCE.md | 3k tokens | 5k | High |
| EXAMPLES.md | 5k tokens | 8k | High |
| ANTI_PATTERNS.md | 5k tokens | 8k | Medium |
| context.json | 1k tokens | 2k | Medium |
| .skill-meta.yml | 500 tokens | 1k | Low |

**Total**: ~60k tokens (within reason for most agents)

### Appendix B: Agent Compatibility Matrix

| Agent | Compatible | Tested | Notes |
|-------|-----------|--------|-------|
| Claude Code | ✅ Yes | ✅ Yes | Primary target |
| Cursor | ✅ Yes | ⏳ Pending | Should work |
| GitHub Copilot | ✅ Yes | ⏳ Pending | Markdown support |
| Continue | ✅ Yes | ⏳ Pending | Open source |
| Windsurf | ✅ Yes | ⏳ Pending | Skill system |

### Appendix C: Terminology

**Key Terms**:
- **Skill**: Collection of knowledge files for AI agent
- **Constraint**: Hard rule agent must not violate
- **Anti-Pattern**: Common failure mode to avoid
- **Intent**: User context and preferences
- **Progressive Complexity**: Gradual skill building

**keyd-Specific**:
- **Overload**: Key with tap/hold behavior
- **Oneshot**: Modifier that applies to next key only
- **Layer**: Collection of key bindings
- **Composite Layer**: Layer active when multiple layers combine

---

## Approval & Sign-Off

### Stakeholders

**Primary User**: Advanced developer with K2v2 on Arch+Hyprland  
**Status**: ⏳ Pending review

**AI Agents**: Claude, Cursor, Copilot, etc.  
**Status**: ⏳ Pending implementation

### Document Status

- [x] Requirements gathered
- [x] Technical specifications defined
- [x] File structure designed
- [x] Testing strategy outlined
- [ ] Implementation in progress
- [ ] User acceptance testing
- [ ] Production deployment

### Next Steps

1. **Review PRD** with user for approval
2. **Implement all files** per specifications
3. **Package as ZIP** for easy deployment
4. **Test with target agents** (Claude, Cursor)
5. **Iterate based on feedback**
6. **Deploy to production** (~/.skills/)

---

**Document Version**: 1.0  
**Last Updated**: February 10, 2026  
**Status**: Ready for Implementation  
**Estimated Implementation Time**: 2-3 hours  
**Estimated Testing Time**: 1 week  
**Target Go-Live**: February 17, 2026
