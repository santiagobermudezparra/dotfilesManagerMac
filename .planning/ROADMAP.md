# Roadmap: DotfilesManagerMac

**Milestone:** v1 — Corporate Mac Neovim Setup
**Goal:** A working chezmoi-managed Neovim config for Salesforce + Node.js development, deployable on a restricted corporate Mac.

---

## Phase 1: Neovim Setup (v1)

**Goal:** A fully working Neovim config managed by chezmoi — ported from personal setup, improved with modern plugins, and extended with Salesforce CLI + Node.js development support.

**Delivers:**
- chezmoi structure with bootstrap script
- Full LazyVim-based Neovim config (gruvbox-material, keymaps, options)
- LSP: TypeScript (ts_ls), Apex (apex_ls), bash, marksman, JSON, YAML
- Salesforce: sf.nvim + apex treesitter parsers + toggleterm
- Node.js: conform.nvim (prettier), ESLint, SchemaStore JSON schemas
- Treesitter: apex, soql, sosl, javascript, typescript, tsx, html, css, xml + existing parsers
- Generic-safe GitHub repo (chezmoi templates for machine-specific values)

**Requirements covered:** DFM-01–05, NVIM-01–08, LSP-01–06, TS-01–05, SF-01–05, NODE-01–05, FMT-01–02, DIAG-01

**Plans:** 5/5 plans complete

Plans:
- [x] 01-01-PLAN.md — chezmoi structure + LazyVim bootstrap + core config (options, keymaps, colorscheme, UI, completion)
- [x] 01-02-PLAN.md — Treesitter parsers + Mason + shared LSP infrastructure (jsonls, yamlls, SchemaStore)
- [x] 01-03-PLAN.md — Salesforce config (sf.nvim, apex_ls template, toggleterm, Apex filetypes)
- [x] 01-04-PLAN.md — TypeScript/Node.js config (ts_ls, eslint-lsp, conform.nvim + prettier)
- [x] 01-05-PLAN.md — Bootstrap script + chezmoi config template + final verification

**Canonical refs:**
- `.planning/PROJECT.md` — constraints and key decisions
- `.planning/REQUIREMENTS.md` — full requirement list

**Success criteria:**
- `:checkhealth` passes for LSP, treesitter, and sf.nvim
- Apex `.cls` files get syntax highlighting and LSP diagnostics
- TypeScript files get completions, go-to-definition, and prettier format-on-save
- sf.nvim commands work (`:SF org list`, deploy/retrieve)
- `chezmoi apply` on a clean machine sets up the full config
- No company names, internal hostnames, or credentials in git history

---

## Phase 2: Shell & Terminal Config (future)

**Goal:** Extend chezmoi to manage zsh, tmux, mise, and git config.

**Delivers:**
- dot_zshrc managed via chezmoi (aliases, PATH, pure prompt, mise)
- dot_tmux.conf managed via chezmoi
- .gitconfig with user template (name/email via chezmoi variables)
- mise config for Node/Python version pinning

**Requirements covered:** SH-01–03, TOOL-01–02

---

## Phase 3: Additional Development Tools (future)

**Goal:** Add more language/tool support to Neovim as needed.

**Potential additions:**
- Go LSP (gopls) — already has treesitter parser
- Python LSP (pyright or pylsp) — already has treesitter parser
- Docker/Compose tooling improvements
- GitHub Copilot or AI completion integration

---

## Backlog

- neotest + Apex test adapter (SF-V2-01)
- universal-ctags for Apex jump-to-definition (SF-V2-02)
- Neovim AI assistant (copilot.lua, codecompanion.nvim)
- Git config template management

---

*Roadmap created: 2026-03-27*
*Updated: 2026-03-27 after Phase 1 planning*
