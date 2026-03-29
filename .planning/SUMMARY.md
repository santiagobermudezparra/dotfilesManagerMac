# Ralph PRD Suite Preparation — COMPLETE ✅

## What's Ready

You have **three comprehensive, right-sized PRDs** ready for Ralph autonomous implementation:

### PRD-1: Docs & Bootstrap (6 stories)
**File:** `.planning/prd-1.json`
**Branch:** `ralph/docs-and-bootstrap-improvements`

Improves README and bootstrap script:
- ✅ Clarity audits and decision trees
- ✅ Common failures quick-reference
- ✅ Better error messages and exponential backoff
- ✅ Non-interactive/CI mode support
- ✅ Network/Zscaler/proxy documentation

**Complexity:** Medium | **Duration:** ~20-30 min

---

### PRD-2: Fix sf.nvim (5 stories)
**File:** `.planning/prd-2.json`
**Branch:** `ralph/fix-sf-nvim-modifiable`

Resolves Neovim error when sf.nvim pastes to non-modifiable buffers:
- ✅ Root cause diagnosis
- ✅ Buffer modifiable check implementation
- ✅ Error recovery + user guidance
- ✅ Full command testing (all SF keymaps)
- ✅ Troubleshooting documentation

**Complexity:** Medium | **Duration:** ~20-30 min

---

### PRD-3: Consolidate Dotfiles (7 stories)
**File:** `.planning/prd-3.json`
**Branch:** `ralph/consolidate-dotfiles`

Audits and integrates useful components from your personal dotfiles:
- ✅ Complete audit of devpods dotfiles repo
- ✅ Categorization and prioritization
- ✅ tmux integration
- ✅ Shell aliases consolidation
- ✅ Reusable scripts in bin/
- ✅ Recursive .gitignore strategy
- ✅ Extensibility documentation

**Complexity:** High | **Duration:** ~30-45 min

---

## How to Use

### Option 1: Let Ralph Run Them (Recommended)

Ralph will handle everything autonomously:

```bash
cd /Users/santiagobermudez/Documents/Personal/Repos/DotfilesManagerMac

# Phase 1: Run PRD-1 and PRD-2 in parallel
# → When Ralph asks, respond with /model sonnet (or equivalent for your setup)

# Phase 2: After Phase 1 merges, run PRD-3
```

### Option 2: Review PRDs First

Before running Ralph, you can review:

1. **Master document:** `.planning/PRDS.md` — Complete PRD text
2. **Ralph JSON files:** `.planning/prd-1.json`, etc. — JSON format (for Ralph consumption)
3. **Execution guide:** `.planning/EXECUTION_GUIDE.md` — Step-by-step instructions

---

## Key Features of This PRD Suite

✅ **Right-sized stories** — Each completable in one Ralph iteration
✅ **Dependency-ordered** — No story blocks later ones
✅ **Verifiable criteria** — All acceptance criteria are testable
✅ **Parallel-ready** — PRD-1 & 2 can run together; PRD-3 after
✅ **Future-proof** — `.gitignore` supports recursive PRD phases
✅ **Scalable** — Template for adding more PRDs in future

---

## Implementation Strategy

### Phase 1 (Parallel)
```
PRD-1 (Docs)        →  ralph/docs-and-bootstrap-improvements
                    ↓
PRD-2 (sf.nvim fix) →  ralph/fix-sf-nvim-modifiable
```

### Phase 2 (Sequential)
```
PRD-3 (Consolidate) →  ralph/consolidate-dotfiles
```

### Merge Order
1. PRD-1 first (docs, no conflicts)
2. PRD-2 next (bug fix)
3. PRD-3 last (features, benefits from prior merges)

---

## Important Notes

### Model Switching ⚠️

Ralph will use **Haiku** for research, but asks you to switch to **Sonnet** before implementation:

**When Ralph asks during implementation phase:**
```
→ Respond: /model sonnet
(or your configured equivalent)
```

This ensures code quality and better handling of larger contexts.

### Permissions Already Set

Bypass permissions ON ✅ (per your request)
Ralph can create branches, commits, and PRs directly.

### After Each PRD Completes

1. Review the new branch: `git diff main..<branch>`
2. Check commits: `git log main..<branch> --oneline`
3. Test locally (especially PRD-2 and PRD-3)
4. Create PR when ready

---

## Next Steps

### Before Running Ralph:

- [ ] Verify model is set to Haiku initially (will switch to Sonnet during implementation)
- [ ] Ensure git is clean (`git status`)
- [ ] Have 30-45 minutes available for each PRD

### To Run Ralph:

Follow `.planning/EXECUTION_GUIDE.md` for exact commands.

### After All PRDs Complete:

1. Merge all three branches to main
2. Update CLAUDE.md with learnings: `/claude-md-management:revise-claude-md`
3. Plan next improvements (reference `.planning/CONSOLIDATION_ROADMAP.md`)

---

## Files Created This Session

```
.planning/
├── PRDS.md                    ← Master PRD document (human-readable)
├── prd-1.json                 ← Ralph JSON for Docs & Bootstrap
├── prd-2.json                 ← Ralph JSON for sf.nvim fix
├── prd-3.json                 ← Ralph JSON for Consolidate Dotfiles
├── EXECUTION_GUIDE.md         ← Step-by-step implementation guide
└── SUMMARY.md                 ← This file
```

Also updated:
- `.gitignore` — Support Ralph artifacts and future phases

---

## Q&A

**Q: Can I run all three PRDs at once?**
A: Yes, PRD-1 and PRD-2 can run in parallel (independent). PRD-3 should run after to benefit from fixes in PRD-1/2.

**Q: What if a PRD fails halfway?**
A: Check `.planning/progress.txt` (created by Ralph). Retry with `/loop`, or manually complete remaining stories. Rerun Ralph with modified prd.json.

**Q: Do I need to manually switch to Sonnet?**
A: Yes, but only when Ralph asks during implementation phase. This is automatic in most setups; just respond when prompted.

**Q: Can I customize the PRDs before running?**
A: Absolutely. Edit `.planning/prd-N.json` to add/remove/modify stories before running Ralph.

**Q: Will this break my current setup?**
A: No. All changes are on feature branches. Only merged to main when you're satisfied with reviews.

---

**Status:** ✅ Ready for Ralph execution
**Created:** 2026-03-29
**Branches to create:** 3 (docs, sf-nvim fix, consolidate)
**Expected PRs:** 3 (one per PRD, can be consolidated if preferred)

🚀 Ready to proceed with Ralph? Follow `.planning/EXECUTION_GUIDE.md`!
