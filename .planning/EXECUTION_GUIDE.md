# Ralph Execution Guide — DotfilesManagerMac PRD Suite

## Overview

You now have three comprehensive PRDs ready for Ralph autonomous implementation:

| PRD | File | Branch | Stories | Scope |
|-----|------|--------|---------|-------|
| 1 | `prd-1.json` | `ralph/docs-and-bootstrap-improvements` | 6 | Documentation, error handling, network resilience |
| 2 | `prd-2.json` | `ralph/fix-sf-nvim-modifiable` | 5 | Fix Neovim/sf.nvim buffer error |
| 3 | `prd-3.json` | `ralph/consolidate-dotfiles` | 7 | Audit & consolidate personal dotfiles |

---

## Prerequisites

✅ **Already Done:**
- Ralph installed and ready
- Three prd-N.json files created with right-sized user stories
- .gitignore updated to support Ralph artifacts
- PRDS.md master document created

⚠️ **Before Running:**
- Set model to **Sonnet** (for Haiku → Sonnet switch when implementing)
- Ensure git is clean (commit/stash any pending changes)
- Have enough context window for Ralph (each PRD will spawn an Amp instance)

---

## Execution Strategy

### Phase 1: Parallel Execution (PRD-1 & PRD-2)

These PRDs are **independent** and can run in parallel:

```bash
# Terminal 1: Run PRD-1 (Docs & Bootstrap)
cd /Users/santiagobermudez/Documents/Personal/Repos/DotfilesManagerMac
# Run Ralph with prd-1.json (implementation starts after switch to Sonnet)

# Terminal 2: Run PRD-2 (Fix sf.nvim)
cd /Users/santiagobermudez/Documents/Personal/Repos/DotfilesManagerMac
# Run Ralph with prd-2.json (implementation starts after switch to Sonnet)
```

**Expected Duration:** ~20-30 minutes each

**Deliverables:**
- `ralph/docs-and-bootstrap-improvements` branch with improved README & bootstrap.sh
- `ralph/fix-sf-nvim-modifiable` branch with sf.nvim buffer error fix

---

### Phase 2: Sequential Execution (PRD-3)

Run after Phase 1 completes:

```bash
cd /Users/santiagobermudez/Documents/Personal/Repos/DotfilesManagerMac
# Run Ralph with prd-3.json (after Sonnet switch)
```

**Expected Duration:** ~30-45 minutes (audit is thorough)

**Deliverables:**
- `.planning/DOTFILES_AUDIT.md` — complete audit of personal dotfiles
- `.planning/CONSOLIDATION_ROADMAP.md` — phased consolidation plan
- `ralph/consolidate-dotfiles` branch with tmux, aliases, scripts, and docs integrated

---

## How to Run Ralph

### Option A: Using Ralph CLI (if configured)

```bash
cd /Users/santiagobermudez/Documents/Personal/Repos/DotfilesManagerMac

# PRD-1: Docs & Bootstrap
ralph run .planning/prd-1.json

# PRD-2: Fix sf.nvim
ralph run .planning/prd-2.json

# PRD-3: Consolidate Dotfiles (after Phase 1)
ralph run .planning/prd-3.json
```

### Option B: Using Claude Code Commands (recommended)

```bash
# PRD-1 (Docs & Bootstrap)
# → When prompted, switch model to Sonnet before implementation

# PRD-2 (Fix sf.nvim)
# → When prompted, switch model to Sonnet before implementation

# PRD-3 (Consolidate Dotfiles)
# → When prompted, switch model to Sonnet before implementation
```

---

## Key Configuration

### Model Switching

**During Research Phase:** Haiku (fast, efficient)
**During Implementation Phase:** Sonnet (code quality, context handling)

When Ralph asks, respond with `/model sonnet` or equivalent.

### Permissions

**Pre-approved actions:**
- Create/edit files in `.planning/`, `dot_config/`, `bin/`, `dot_*` files
- Create branches and commits (non-destructive)
- Run tests/linting if applicable
- Update README.md

**Bypass Permissions:** Already configured per your request

### Branch Strategy

- Each PRD creates one feature branch (`ralph/*`)
- Commits are atomic, descriptive, and linked to user stories
- No force-pushes; branches are clean for PRs

---

## After Ralph Completes Each PRD

### Review Checklist

For each completed PRD branch:

1. **Review branch changes:**
   ```bash
   git diff main..<branch-name>
   ```

2. **Check user story completion** (in branch commit messages):
   ```bash
   git log main..<branch-name> --oneline
   ```

3. **Verify no conflicts** (rebase on main if needed):
   ```bash
   git rebase main <branch-name>
   ```

4. **Test locally** (especially PRD-2 and PRD-3):
   ```bash
   # PRD-1: Review README and bootstrap in an editor
   nvim README.md
   bash run_once_bootstrap.sh --help  # if --non-interactive was added

   # PRD-2: Test sf.nvim commands
   nvim
   :SF org list  # via <leader>sl

   # PRD-3: Test new aliases, tmux, and scripts
   source ~/.zshrc
   tmux new-session -s test
   alias  # should show new aliases
   ```

---

## Creating PRs After Completion

### One PR Per PRD (Recommended)

```bash
# PRD-1
git checkout ralph/docs-and-bootstrap-improvements
git push -u origin ralph/docs-and-bootstrap-improvements
# Open PR: "docs: review and enhance README + bootstrap script"

# PRD-2
git checkout ralph/fix-sf-nvim-modifiable
git push -u origin ralph/fix-sf-nvim-modifiable
# Open PR: "fix: resolve sf.nvim modifiable buffer error"

# PRD-3
git checkout ralph/consolidate-dotfiles
git push -u origin ralph/consolidate-dotfiles
# Open PR: "feat: audit and consolidate personal dotfiles"
```

### Merge Order

1. **PRD-1 first** (docs-only, no conflicts)
2. **PRD-2 next** (bug fix, improves usability)
3. **PRD-3 last** (largest, benefits from PRD-1 & PRD-2 merged)

---

## Troubleshooting

### Ralph stuck or out of context?

- **Symptom:** PRD execution halts, mentions "context limit"
- **Solution:** Check user story sizes — if any are >500 lines of code, Ralph may have split it. Review `.planning/progress.txt` for which story failed.
- **Next:** Manually complete the remaining stories, or rerun Ralph with modified prd.json.

### Branch conflicts after merge?

- **Symptom:** PRD-2 or PRD-3 has merge conflicts with main
- **Solution:** Rebase onto main before PR:
  ```bash
  git rebase main <branch-name>
  ```

### sf.nvim fix doesn't work?

- Check `.planning/DEBUG_SF_NVIM.md` (created by PRD-2)
- Test with a Salesforce project directory (needs `sfdx-project.json`)
- If still broken, create a GitHub issue with stack trace

### New aliases not available?

- Ensure bootstrap runs (`chezmoi apply`) after PRD-3 merge
- Or manually source: `source ~/.zshrc`

---

## Next Steps After All PRDs Complete

### 1. Update Memory & CLAUDE.md

Document learnings from this Ralph run:

```bash
cd /Users/santiagobermudez/Documents/Personal/Repos/DotfilesManagerMac
# Use /claude-md-management:revise-claude-md to update CLAUDE.md
```

### 2. Archive This PRD Suite (Optional)

Once all three PRDs are merged to main:

```bash
mkdir -p .planning/archive/2026-03-29-initial-prds/
mv .planning/PRDS.md .planning/archive/2026-03-29-initial-prds/
mv .planning/prd-*.json .planning/archive/2026-03-29-initial-prds/
```

### 3. Plan Next Phase (e.g., Additional Features)

If you want to extend DotfilesManagerMac further:

- Create new `prd-4.json` following the template
- Reference `.planning/CONSOLIDATION_ROADMAP.md` for next priorities
- Run Ralph again with new PRD

---

## Questions?

Refer to:
- **PRDS.md** — High-level PRD content and rationale
- **prd-N.json** — Ralph-specific user story format
- **README.md** — Project setup and usage (being improved by PRD-1)

Good luck with Ralph! 🚀

---
