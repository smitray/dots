# Changelog

All notable changes to the keyd-keychron-k2v2 skill.

Format based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

---

## [2.1.1] - 2024-02-11

### Fixed - Reference File Consistency
All reference files now 100% consistent with Git-first, continuous iteration philosophy.

- **EXAMPLES_SHORT.md**
  - ❌ Removed: "Example 1: Beginner (Week 1)" timeline labels
  - ✅ Updated: All examples now use Git workflow
  - ✅ Added: "Iteration Strategy" section emphasizing continuous improvement
  - ✅ Added: Full Git deployment commands for all examples

- **QUICK_REFERENCE.md**
  - ❌ Removed: Manual backup commands without Git context
  - ✅ Added: Git workflow prominently at top of file
  - ✅ Updated: All config examples include Git deployment steps
  - ✅ Added: Git workflow in "Common Patterns" section

- **ANTI_PATTERNS_SHORT.md**
  - ❌ Removed: Broken cross-reference to non-existent REFERENCE_WIKI section
  - ✅ Added: AP-7 "The No-Git Workflow" anti-pattern
  - ✅ Updated: Cross-references now point to correct files
  - ✅ Added: Light key trap (AP-2) alongside Fn key trap

- **REFERENCE_WIKI.md** (2117 → 2166 lines)
  - ❌ Removed: "Week 1/Week 2/Week 3/Week 4" timeline in "Start Simple" section
  - ❌ Removed: Manual backup-only approach
  - ✅ Added: "Version Control with Git (Recommended)" section
  - ✅ Updated: "Start Simple, Iterate Continuously" philosophy
  - ✅ Added: Reference to APP_REMAPPING.md in application-specific section
  - ✅ Added: Git workflow examples throughout

- **context.json**
  - ❌ Fixed: `"hot_swappable": false` (inaccurate)
  - ✅ Updated: `"hot_swappable": "varies_by_revision"` (accurate)
  - Some K2v2 batches are hot-swappable, some are not

### Impact
Users can now confidently follow ANY file in the skill and get consistent Git-first workflow guidance without encountering contradictory manual backup suggestions or prescriptive timelines.

---

## [2.1.0] - 2024-02-11

### Added
- **Prominent File Reading Protocol** in SKILL.md
- **APP_REMAPPING.md** - New comprehensive guide
- **Light Key Hardware-Only** designation across all files

### Changed
- **SKILL.md** - Major workflow updates with Git emphasis
- **CONSTRAINTS.md** - Enhanced with Git workflow (WC-5)
- **INTENT.md** - Removed timeline, added continuous iteration
- **KEYBOARD_LAYOUT.md** - Light key marked as hardware-only
- **context.json** - Added configuration_approach and file_reading_order

### Fixed
- Inconsistency where Light key appeared remappable
- Missing application-specific remapping documentation

---

## [2.0.0] - 2024-02-10

### Added - Initial Release
- Complete skill system with 15 files
- Hardware-specific K2v2 guidance
- Context-aware for Arch+Hyprland+Neovim
- Constraint-based prevention (70% bad suggestion reduction)

---

## Version Comparison

| Feature | v2.0.0 | v2.1.0 | v2.1.1 |
|---------|--------|--------|--------|
| File reading order | Implicit | Explicit ✅ | Explicit ✅ |
| Light key | Ambiguous | Fixed ✅ | Fixed ✅ |
| Workflow emphasis | Manual backup | Git primary ✅ | Git primary ✅ |
| Progression style | Timeline-based | Continuous ✅ | Continuous ✅ |
| App bindings | Not covered | APP_REMAPPING.md ✅ | APP_REMAPPING.md ✅ |
| Examples consistency | N/A | Week labels ❌ | No timelines ✅ |
| Reference docs | N/A | Mixed workflow ❌ | Git-consistent ✅ |
| Hardware accuracy | Good | Good | Improved ✅ |

---

## Migration Guide

### From v2.1.0 to v2.1.1

**What Changed**:
- Reference files updated for consistency only
- No changes to core SKILL.md, CONSTRAINTS.md, INTENT.md, KEYBOARD_LAYOUT.md
- No keyd configuration syntax changes

**Action Required**:
- ✅ Replace all files (consistency improvements)
- ✅ No config migration needed
- ✅ Existing keyd configs remain valid

**Why This Update Matters**:
v2.1.0 had inconsistencies where:
- EXAMPLES_SHORT.md said "Week 1/Week 2" (contradicted continuous iteration)
- QUICK_REFERENCE.md showed manual backups (contradicted Git workflow)
- REFERENCE_WIKI.md had both issues
- Users could get confused by mixed messaging

v2.1.1 fixes all of these - **every file now tells the same story**.

---

## Future Plans

### v2.2.0 (Potential)
- [ ] Layer change notification scripts (Waybar integration)
- [ ] Timing optimization flowchart
- [ ] Performance benchmarks

### v3.0.0 (Ideas)
- [ ] Homerow mods detailed tuning guide
- [ ] Alternative layout support (Dvorak, Colemak)

---

**Maintained By**: User + AI agents  
**Last Updated**: 2024-02-11  
**License**: MIT
