# Phase 1: Neovim Setup - Context

**Gathered:** 2026-03-27
**Status:** Ready for planning

<domain>
## Phase Boundary

A fully working chezmoi-managed Neovim config — ported from existing LazyVim setup, improved with modern plugins, and extended for Salesforce CLI + Node.js development on a restricted corporate Mac (Zscaler TLS interception). Includes LSP servers, Treesitter parsers, sf.nvim integration, and format-on-save. Bootstrap script makes it installable in one command on a new machine.

</domain>

<decisions>
## Implementation Decisions

### LazyVim Foundation
- **D-01:** Stay on LazyVim distribution (not bare lazy.nvim) — existing config is LazyVim-based; provides sensible defaults; easier to maintain and extend via extras
- **D-02:** gruvbox-material colorscheme applied (port from existing personal config as-is)
- **D-03:** Existing keymaps ported (leader mappings, scroll centering, telescope symbol finder, etc.)
- **D-04:** Existing options ported (no line numbers, scrolloff=8, mouse enabled, smartcase, signcolumn=yes)

### Completion & Editor Experience
- **D-05:** Use blink.cmp as the completion engine (modern TypeScript support, modern alternative to nvim-cmp)
- **D-06:** nvim-cmp sources: LSP, snippet, buffer, path (migrate to blink.cmp equivalent structure)
- **D-07:** Telescope fuzzy finder configured (existing pattern)
- **D-08:** nvim-tree file explorer configured (existing pattern)
- **D-09:** Treesitter syntax highlighting working (existing pattern)
- **D-10:** No dedicated diagnostic UI (trouble.nvim omitted) — use inline LSP hover only for minimal visual footprint

### Salesforce Development
- **D-11:** sf.nvim plugin installed (xixiaofinland/sf.nvim, requires sf CLI v2 and Neovim v0.11+)
- **D-12:** apex_ls LSP configured pointing to apex-jorje-lsp JAR
- **D-13:** Apex LSP installation uses hybrid approach: bootstrap script attempts curl-based auto-download from apex-jorje-lsp GitHub releases; falls back to manual download instructions if curl fails (respects Zscaler curl-allowed downloads)
- **D-14:** JAR path provided to nvim-lspconfig via chezmoi template (never hardcoded in repo)
- **D-15:** toggleterm.nvim configured for sf CLI terminal output
- **D-16:** Treesitter parsers: apex, soql, sosl installed (Salesforce filetypes)

### Node.js / JavaScript / TypeScript
- **D-17:** ts_ls (not tsserver) LSP configured via nvim-lspconfig for completions, go-to-definition, hover, diagnostics
- **D-18:** conform.nvim for format-on-save: prettier configured for JS, TS, JSON, CSS, HTML
- **D-19:** eslint-lsp for ESLint integration — runs automatically on file change, integrates with LSP diagnostics for immediate feedback
- **D-20:** SchemaStore JSON schemas (b0o/schemastore.nvim) for package.json, tsconfig.json validation
- **D-21:** Treesitter parsers: javascript, typescript, tsx, html, css installed

### Apex & General Languages
- **D-22:** No formatter for Apex (none exists; LSP diagnostics only)
- **D-23:** LSP servers via Mason: bash-language-server, marksman, json-lsp, yaml-language-server (retained from existing config)
- **D-24:** Treesitter parsers: bash, lua, python, json, yaml, vim, vimdoc, go, bicep, terraform, c_sharp (existing parsers retained)
- **D-25:** xml parser installed (Salesforce package.xml, metadata files)

### Dotfiles Management & Repo Safety
- **D-26:** chezmoi structure at repo root: `dot_config/nvim/`, `dot_config/chezmoi/`, `run_bootstrap.sh`
- **D-27:** chezmoi templates used for machine-specific values: apex JAR path, npm registry (if needed)
- **D-28:** No employer names, internal URLs, or credentials may appear in committed files — repo is publishable to GitHub
- **D-29:** Bootstrap script installs chezmoi via curl binary (no brew dependency) and applies dotfiles in one command

### Claude's Discretion
- Exact keymap bindings for new Salesforce features (sf.nvim commands)
- conform.nvim configuration details (trim_trailing_whitespace, etc.)
- blink.cmp configuration (fuzzy matching, formatting, sorting)
- nvim-lint ESLint setup details (which linters, debounce timing)
- Exact treesitter query/highlight customizations
- Error handling in bootstrap script (retry logic, cleanup on failure)

</decisions>

<specifics>
## Specific Ideas

- Port the personal config look & feel exactly — existing keymaps, colorscheme, editor feel should transfer without friction
- sf.nvim should be accessible via leader key (e.g., `:SF` command or leader shortcut for deploy/retrieve)
- ESLint integration should check on save, not on every keystroke (avoid noise during editing)
- JAR download logic: clearly log what it's doing and why (transparency for network-restricted environment)

</specifics>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Project Constraints & Architecture
- `.planning/PROJECT.md` — Corporate environment constraints (Zscaler, npm Nexus, curl-based installs), key tech decisions, existing dotfiles baseline
- `.planning/REQUIREMENTS.md` — Full v1 requirement list (37 requirements), all mapped to Phase 1

### Neovim & Plugin Ecosystem
- [LazyVim docs](https://www.lazyvim.org/) — Distribution patterns, extras system, conventions
- [blink.cmp repository](https://github.com/Saghen/blink.cmp) — Modern completion engine, configuration
- [sf.nvim repository](https://github.com/xixiaofinland/sf.nvim) — Salesforce CLI integration, commands, requirements (sf CLI v2, Neovim v0.11+)
- [conform.nvim docs](https://github.com/stevearc/conform.nvim) — Format-on-save, prettier integration
- [eslint-lsp docs](https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/server_configurations/eslint.lua) — ESLint as language server, automatic checking

### Language Servers & Treesitter
- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) — ts_ls, apex_ls, json-lsp, yaml-language-server setup
- [Mason.nvim docs](https://github.com/williamboman/mason.nvim) — LSP server management (bash-language-server, marksman, json-lsp, yaml-language-server)
- [Treesitter docs](https://github.com/nvim-treesitter/nvim-treesitter) — Syntax highlighting, parser installation (apex, soql, sosl, javascript, typescript, tsx, html, css, xml, etc.)

### apex-jorje-lsp & JAR Installation
- [apex-jorje-lsp releases](https://github.com/forcedotcom/apex-language-server/releases) — JAR download source for curl-based auto-install
- `.planning/PROJECT.md` Section "Apex LSP" — JAR path must be templated via chezmoi, never hardcoded

### Corporate Network & Tooling
- `~/.npmrc` — BNZ Nexus registry config (mentioned in explanation.txt; ensure chezmoi templates handle npm registry overrides if needed)
- `.planning/phases/01-neovim-setup/explanation.txt` OR PROJECT.md notes — Zscaler curl-allowed downloads, 403 policy blocks, macOS Keychain trust chain

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets
- Personal dotfiles repo (`github.com/santiagobermudezparra/dotfiles`) — Existing LazyVim config, gruvbox-material setup, keymaps, nvim-cmp structure can be ported as baseline
- Existing Neovim config patterns — keymaps, options, color scheme are proven in personal use

### Established Patterns
- LazyVim spec → extras, plugin directory structure, lazy.nvim patterns are well-known; stay within conventions
- chezmoi template patterns → Machine-specific overrides via templates, not env vars

### Integration Points
- Bootstrap script will: (1) install chezmoi via curl, (2) clone this repo, (3) download apex JAR (with fallback), (4) run `chezmoi apply`
- nvim-lspconfig → Connects ts_ls, apex_ls, json-lsp, yaml-language-server, bash-language-server, marksman to Neovim
- conform.nvim → Prettier integration for format-on-save
- eslint-lsp → ESLint runs as language server, automatically on file change

</code_context>

<deferred>
## Deferred Ideas

- zsh config management — Phase 2
- tmux config management — Phase 2
- neotest + Apex test adapter — backlog (SF-V2-01)
- universal-ctags for Apex jump-to-definition — backlog (SF-V2-02)
- Neovim AI assistant (copilot.lua, codecompanion.nvim) — backlog
- Git config template management — Phase 2

</deferred>

---

*Phase: 01-neovim-setup*
*Context gathered: 2026-03-27*
