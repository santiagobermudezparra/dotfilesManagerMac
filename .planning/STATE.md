# Project State

## Project Reference

See: .planning/PROJECT.md (updated 2026-03-27)

**Core value:** A single Neovim config that works on a restricted corporate Mac, handling Salesforce CLI + Node.js development with the same look and feel as the personal setup — without leaking work context to the public GitHub repo.

**Current focus:** Phase 1 — Neovim Setup (not yet started)

## Milestone

**v1 — Corporate Mac Neovim Setup**
- Phase 1: Neovim Setup ○ Pending

## Phase Status

| Phase | Name | Status | Plans |
|-------|------|--------|-------|
| 1 | Neovim Setup | ○ Pending | 0/0 |

## Last Action

Project initialized. Research complete. Ready to plan Phase 1.

## Key Context for Next Session

- Existing dotfiles repo: `github.com/santiagobermudezparra/dotfiles` (LazyVim, chezmoi, gruvbox-material)
- Corporate constraints: Zscaler TLS, BNZ Nexus npm, no brew for chezmoi install
- chezmoi install: `sh -c "$(curl -fsLS get.chezmoi.io)" -- -b $HOME/.local/bin`
- sf.nvim requires Neovim v0.11+ and Salesforce CLI v2 (`sf` command)
- apex_ls needs JAR from `forcedotcom/apex-jorje-lsp` GitHub releases + Java 11+
- JAR path must use chezmoi template (machine-specific, not committed)
- Use `ts_ls` not `tsserver` in nvim-lspconfig

---
*Updated: 2026-03-27 after project initialization*
