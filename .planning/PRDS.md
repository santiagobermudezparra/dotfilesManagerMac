# DotfilesManagerMac — Ralph PRD Suite

This document contains three interconnected PRDs for comprehensive dotfiles management improvements. These PRDs feed Ralph autonomous implementation phases and are designed to be scalable and recursive for future feature additions.

---

## PRD 1: Review & Enhance README + Bootstrap Script

**Feature:** Comprehensive audit of setup documentation and initialization scripts, with improvements for clarity, error handling, and network resilience.

### User Stories

#### US-001: Audit README.md for clarity and completeness
- **Description:** Review README.md section-by-section for accuracy, completeness, and clarity targeting both first-time users and experienced developers.
- **Acceptance Criteria:**
  - Document all prerequisites (macOS version, tools, network requirements)
  - Verify each step in setup flow matches actual behavior
  - Identify any gaps in error messaging or troubleshooting
  - Check compliance with DFM-04 (no credentials/internal info in docs)
  - Typecheck passes

#### US-002: Enhance README with visual decision trees
- **Description:** Add ASCII diagrams or flowcharts showing setup decision paths (e.g., "Do you have JAR? Yes → point to path. No → download.").
- **Acceptance Criteria:**
  - Add decision tree for "Fresh Machine Setup"
  - Add decision tree for "JAR already exists vs needs download"
  - Add quick-reference table for prerequisite tools
  - Maintain markdown readability
  - Typecheck passes

#### US-003: Add "Common Setup Failures" quick-reference section
- **Description:** Create a quick matrix of failures → symptoms → fixes, complementing detailed Troubleshooting section.
- **Acceptance Criteria:**
  - Add 2-column quick-ref table (Error → Solution)
  - Link to detailed Troubleshooting sections for each
  - Include network/proxy scenarios
  - Typecheck passes

#### US-004: Enhance bootstrap script with better error messages and retries
- **Description:** Improve `run_once_bootstrap.sh` to provide clearer error context, suggest fixes inline, and retry failed downloads with exponential backoff.
- **Acceptance Criteria:**
  - Add contextual error messages (network vs. permission vs. missing tools)
  - Implement exponential backoff for JAR download (current: 3 retries fixed)
  - Output suggests next steps when failures occur
  - Log bootstrap execution to ~/.local/share/dotfiles-bootstrap.log
  - Typecheck passes

#### US-005: Add script mode for non-interactive/CI environments
- **Description:** Support `--non-interactive` flag for bootstrap to work in automated deployments.
- **Acceptance Criteria:**
  - Add `--non-interactive` flag to bootstrap
  - Use sensible defaults when TTY not available
  - Skip prompts for JAR path (use environment variable fallback)
  - Document CI/automation setup in README
  - Typecheck passes

#### US-006: Document network-restricted setup (Zscaler/proxy)
- **Description:** Add comprehensive guide for corporate Mac setups with proxy/firewall/SSL interception.
- **Acceptance Criteria:**
  - Document Zscaler cert installation (existing in README, expand with screenshots/steps)
  - Add git proxy configuration examples
  - Add troubleshooting for curl certificate errors
  - Suggest offline JAR installation workaround
  - Typecheck passes

---

## PRD 2: Fix sf.nvim Modifiable Buffer Error

**Feature:** Resolve Neovim error when sf.nvim attempts to paste output in a non-modifiable buffer.

### Error Context
```
Error executing lua: vim/_editor.lua:0: Vim:E21: Cannot make changes, 'modifiable' is off
  at ...obermudez/.local/share/nvim/lazy/sf.nvim/lua/sf/util.lua:25: Sf: Empty table
```

### User Stories

#### US-001: Diagnose sf.nvim buffer handling
- **Description:** Investigate when/why sf.nvim tries to write to non-modifiable buffers, identify root cause.
- **Acceptance Criteria:**
  - Identify which sf.nvim command triggers the error (SF metadata push? retrieve? test run?)
  - Check if specific buffer types trigger it (e.g., help buffers, read-only files)
  - Review sf.nvim source to understand buffer management strategy
  - Document root cause in `.planning/DEBUG_SF_NVIM.md`
  - Typecheck passes

#### US-002: Implement buffer modifiable check in sf.nvim wrapper
- **Description:** Add guard in sf.nvim setup to ensure output buffers are modifiable before writing.
- **Acceptance Criteria:**
  - Check `vim.bo.modifiable` before sf.nvim operations
  - If non-modifiable, create new scratch buffer or toggle modifiable
  - Preserve existing buffer content/state
  - No breaking changes to existing sf.nvim workflows
  - Typecheck passes

#### US-003: Add error recovery and user guidance
- **Description:** When error occurs, display helpful message suggesting user actions (create new buffer, check file permissions, etc.).
- **Acceptance Criteria:**
  - Catch "modifiable is off" error specifically
  - Display actionable message to user
  - Suggest creating new buffer or opening in split
  - Log error details for debugging
  - Typecheck passes

#### US-004: Test with all SF commands
- **Description:** Verify fix works with all sf.nvim keymaps (push, retrieve, test run, org open, org list).
- **Acceptance Criteria:**
  - Test `<leader>sp` (push) — no error
  - Test `<leader>sr` (retrieve) — no error
  - Test `<leader>sta` (test all) — no error
  - Test `<leader>stt` (test current) — no error
  - Test `<leader>so` (open org) — no error
  - Test `<leader>sl` (list orgs) — no error
  - Typecheck passes

#### US-005: Document workaround and root cause in Troubleshooting
- **Description:** Add sf.nvim buffer error to README Troubleshooting section with explanation and preventive steps.
- **Acceptance Criteria:**
  - Document error message and when it appears
  - Explain why it happens (buffer modifiable state)
  - Provide manual workaround (e.g., toggle modifiable, create new buffer)
  - Link to preventive code change above
  - Typecheck passes

---

## PRD 3: Audit & Consolidate Personal Dotfiles

**Feature:** Review https://github.com/santiagobermudezparra/dotfiles (devpods version) and strategically consolidate useful components into DotfilesManagerMac.

### Context
- **Source repo:** Your personal dotfiles with devpods/node/tmux/scripts setup
- **Target repo:** DotfilesManagerMac (corporate Mac Neovim-focused)
- **Goal:** Identify useful patterns, configs, and scripts that align with DotfilesManagerMac's scope, add them recursively, keep it maintainable.

### User Stories

#### US-001: Audit personal dotfiles repo structure and contents
- **Description:** Review the devpods dotfiles repo to understand its structure, features, and philosophy.
- **Acceptance Criteria:**
  - Document directory structure (`dot_config/`, `scripts/`, `.chezmoiscripts/`, etc.)
  - List key features not in DotfilesManagerMac (tmux, shell aliases, additional tools)
  - Identify reusable patterns (chezmoi templates, script layout, etc.)
  - Create `.planning/DOTFILES_AUDIT.md` with findings
  - Typecheck passes

#### US-002: Map components to DotfilesManagerMac categories
- **Description:** Classify audit findings into: (1) Directly applicable, (2) Requires adaptation, (3) Out of scope.
- **Acceptance Criteria:**
  - Document each candidate component with category
  - Include rationale for "out of scope" decisions
  - Prioritize by value (core dev tools first, nice-to-haves last)
  - Create `.planning/CONSOLIDATION_ROADMAP.md` with phased approach
  - Typecheck passes

#### US-003: Add tmux configuration (if applicable)
- **Description:** If your personal dotfiles have tmux config that improves dev workflow, integrate into DotfilesManagerMac.
- **Acceptance Criteria:**
  - Adapt tmux config for Mac/Neovim context
  - Add to `dot_config/tmux/` or similar
  - Update README with tmux setup instructions
  - Test tmux + Neovim integration (e.g., window navigation)
  - Typecheck passes

#### US-004: Add shell configuration (aliases, functions, profile tweaks)
- **Description:** Consolidate useful zsh aliases, functions, and profile improvements into DotfilesManagerMac.
- **Acceptance Criteria:**
  - Review `dot_zshrc` from personal dotfiles
  - Identify dev-workflow-friendly aliases (e.g., `sf` helpers, git shortcuts)
  - Adapt for corporate Mac context (no internal tool references)
  - Add to `dot_zshrc` in DotfilesManagerMac
  - Document new aliases in README "Usage" section
  - Typecheck passes

#### US-005: Consolidate scripts directory
- **Description:** Review personal dotfiles `scripts/` folder and add useful, reusable scripts to DotfilesManagerMac.
- **Acceptance Criteria:**
  - List scripts in personal dotfiles
  - Identify which support Neovim/Apex/Salesforce dev workflows
  - Adapt for Mac and add to `bin/` in DotfilesManagerMac
  - Update bootstrap to add scripts to PATH
  - Document scripts in README
  - Typecheck passes

#### US-006: Add recursive implementation support to .gitignore
- **Description:** Update `.gitignore` to exclude Ralph-generated artifacts and future phase directories, allowing recursive feature implementation.
- **Acceptance Criteria:**
  - Add `.planning/prd.json` (Ralph PRD artifact)
  - Add `.planning/progress.txt` (Ralph progress tracking)
  - Add `.planning/archive/` (archived PRDs)
  - Add `.planning/DEBUG_*.md` (debug logs from this phase)
  - Add `.planning/AUDIT_*.md` and `ROADMAP_*.md` (audit outputs)
  - Keep structure flexible for future phases
  - Typecheck passes

#### US-007: Document consolidation strategy and future extensibility
- **Description:** Add section to README explaining the consolidation approach and how to add features recursively.
- **Acceptance Criteria:**
  - Explain .planning/ directory purpose and structure
  - Document how to add new features using Ralph
  - Provide template for future PRDs
  - Link to DOTFILES_AUDIT and CONSOLIDATION_ROADMAP
  - Typecheck passes

---

## Ralph Execution Metadata

```json
{
  "projectName": "DotfilesManagerMac",
  "prdSuite": [
    {
      "prdId": "PRD-1",
      "title": "Review & Enhance README + Bootstrap Script",
      "branchName": "ralph/docs-and-bootstrap-improvements",
      "userStoryCount": 6,
      "estimatedComplexity": "Medium",
      "dependencies": "None — can run independently"
    },
    {
      "prdId": "PRD-2",
      "title": "Fix sf.nvim Modifiable Buffer Error",
      "branchName": "ralph/fix-sf-nvim-modifiable",
      "userStoryCount": 5,
      "estimatedComplexity": "Medium",
      "dependencies": "None — can run independently"
    },
    {
      "prdId": "PRD-3",
      "title": "Audit & Consolidate Personal Dotfiles",
      "branchName": "ralph/consolidate-dotfiles",
      "userStoryCount": 7,
      "estimatedComplexity": "High",
      "dependencies": "PRD-2 (nice to have — improves overall config quality before consolidation)"
    }
  ],
  "executionStrategy": "Run PRD-1 and PRD-2 in parallel (independent), then PRD-3 (audit + consolidation)",
  "gitignoreStrategy": "Recursive — supports future phases without re-configuration",
  "scalability": "Each PRD self-contained; future PRDs can reference this suite's outputs"
}
```

---

## Next Steps

1. **Convert PRDs to Ralph JSON format** — Use `ralph:prd` skill to convert each PRD above to `prd.json`
2. **Archive old `.planning/` state** (if any) — Ralph will manage progress tracking
3. **Run PRD-1 and PRD-2 in parallel** via Ralph
4. **Run PRD-3 after parallel execution** — consolidation benefits from completed fixes
5. **Review, test, and merge** — One PR per PRD, or consolidated if fast
6. **Update memory and CLAUDE.md** — Document learnings for future Ralph runs

---
