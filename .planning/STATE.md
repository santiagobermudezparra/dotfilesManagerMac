---
gsd_state_version: 1.0
milestone: v1.0
milestone_name: milestone
status: unknown
last_updated: "2026-03-27T02:36:35.442Z"
progress:
  total_phases: 3
  completed_phases: 0
  total_plans: 5
  completed_plans: 2
---

# Project State

## Project Reference

See: .planning/PROJECT.md (updated 2026-03-27)

**Core value:** A single Neovim config that works on a restricted corporate Mac, handling Salesforce CLI + Node.js development with the same look and feel as the personal setup — without leaking work context to the public GitHub repo.

**Current focus:** Phase 01 — neovim-setup (Plan 01 complete, starting Plan 02)

## Milestone

**v1 — Corporate Mac Neovim Setup**

- Phase 1: Neovim Setup ● In Progress (1/? plans complete)

## Phase Status

| Phase | Name | Status | Plans |
|-------|------|--------|-------|
| 1 | Neovim Setup | ● In Progress | 1/5 |

## Progress

[██░░░░░░░░] 20% (1/5 plans)

## Last Action

Completed Phase 01 Plan 01: LazyVim foundation with gruvbox-material, custom keymaps/options, nvim-tree, telescope, and blink.cmp v1.

## Decisions

- **01-neovim-setup Plan 01:** blink.cmp pinned to v1.* to avoid v2 breaking API changes
- **01-neovim-setup Plan 01:** No lang.typescript LazyVim extra enabled; ts_ls configured directly in Plan 02
- **01-neovim-setup Plan 01:** trouble.nvim omitted per D-10; inline LSP diagnostics sufficient
- [Phase 01-neovim-setup]: Plan 02: apex_ls excluded from Mason ensure_installed — JAR requires curl bootstrap install
- [Phase 01-neovim-setup]: Plan 02: ts_ls and eslint server configs deferred to typescript.lua in plan 04 for clear ownership
- [Phase 01-neovim-setup]: Plan 02: sflog treesitter parser excluded due to LOW confidence in nvim-treesitter availability

## Performance Metrics

| Phase | Plan | Duration | Tasks | Files |
|-------|------|----------|-------|-------|
| 01-neovim-setup | 01 | 2min | 2 | 7 |
| Phase 01-neovim-setup P02 | 1min | 2 tasks | 2 files |

## Key Context for Next Session

- Existing dotfiles repo: `github.com/santiagobermudezparra/dotfiles` (LazyVim, chezmoi, gruvbox-material)
- Corporate constraints: Zscaler TLS, BNZ Nexus npm, no brew for chezmoi install
- chezmoi install: `sh -c "$(curl -fsLS get.chezmoi.io)" -- -b $HOME/.local/bin`
- sf.nvim requires Neovim v0.11+ and Salesforce CLI v2 (`sf` command)
- apex_ls needs JAR from `forcedotcom/apex-jorje-lsp` GitHub releases + Java 11+
- JAR path must use chezmoi template (machine-specific, not committed)
- Use `ts_ls` not `tsserver` in nvim-lspconfig
- blink.cmp v1.* is the completion engine (do NOT upgrade to v2)
- neo-tree is disabled; nvim-tree is the file explorer

---
*Updated: 2026-03-27 after completing Phase 01 Plan 01*
