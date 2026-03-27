# DotfilesManagerMac

## What This Is

A chezmoi-based dotfiles manager for a corporate macOS machine, designed to work within enterprise network restrictions (Zscaler TLS interception, corporate npm registry, no DevPods). Starts with a fully configured Neovim setup ported and improved from an existing personal config, adding Salesforce CLI and Node.js development support. Built to be extensible — shell, tools, and other dotfiles can be added in future phases.

## Core Value

A single Neovim config that works on a restricted corporate Mac, handling Salesforce CLI + Node.js development with the same look and feel as the personal setup — without leaking work context to the public GitHub repo.

## Requirements

### Validated

<!-- Shipped and confirmed valuable. -->

(None yet — ship to validate)

### Active

- [ ] chezmoi manages all dotfiles from a single GitHub repo
- [ ] Neovim config is ported from existing LazyVim setup (gruvbox-material, keymaps, plugins)
- [ ] Neovim config improved with modern plugin best practices (2025/2026 recommendations)
- [ ] Salesforce/Apex LSP configured (apex_ls via apex-jorje-lsp JAR)
- [ ] TypeScript/JavaScript LSP configured (ts_ls via Mason)
- [ ] sf.nvim plugin integrated for Salesforce CLI workflow
- [ ] Treesitter parsers include apex, soql, sosl, javascript, typescript, tsx, html, css, xml
- [ ] conform.nvim for formatting (prettier for JS/TS)
- [ ] Repo looks generic on GitHub — no work-specific context, company names, or internal URLs
- [ ] chezmoi installable without brew (pre-built binary via curl)
- [ ] Machine-specific overrides handled via chezmoi templates (e.g., npm registry)

### Out of Scope

- zsh config management — not in v1, own phase later
- tmux config management — not in v1, own phase later
- DevPods / container provisioning — not possible in this environment
- GUI Neovim (Neovide, etc.) — terminal Neovim only
- Windows/Linux support — macOS only

## Context

- **Corporate environment:** BNZ-managed macOS with Zscaler TLS interception. npm must use BNZ Nexus registry (`~/.npmrc`). Python should use System Keychain (no SSL_CERT_FILE overrides). GHCR/Rust streaming downloads are blocked (use curl-based installs only).
- **Existing dotfiles:** `github.com/santiagobermudezparra/dotfiles` — already uses chezmoi, LazyVim, gruvbox-material, nvim-cmp, telescope, nvim-tree, treesitter. Currently only bash + marksman LSPs. No JS/TS/Apex.
- **Tools already installed on work machine:** Salesforce CLI (`sf`), Node.js, npm (via Nexus).
- **Confidentiality:** Repo must be publishable to GitHub without revealing employer, internal URLs, or corporate specifics. chezmoi templates handle env-specific config.
- **Neovim version target:** v0.11+ (required by sf.nvim).

## Constraints

- **Network:** No public npm registry access — must use BNZ Nexus. chezmoi must be installed via curl binary, not brew.
- **Apex LSP:** `apex_ls` JAR (`apex-jorje-lsp`) must be downloaded manually (Mason cannot install it). Requires Java 11+.
- **sf.nvim:** Requires Salesforce CLI v2 (`sf` command). Confirmed actively maintained (65 stars, Neovim v0.11+ required).
- **Generic repo:** No internal hostnames, company names, or credentials may appear in committed files. chezmoi templates used for machine-specific values.
- **Tech stack:** LazyVim distribution on top of lazy.nvim — stay within LazyVim conventions where possible for maintainability.

## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| Use chezmoi | Already in use in personal dotfiles; supports templating for machine-specific overrides; binary install (no brew needed); mature and well-documented | — Pending |
| Stay on LazyVim | Existing config is LazyVim-based; provides sensible defaults; easier to extend via extras; avoids full config rewrite | — Pending |
| gruvbox-material colorscheme | User's existing preference; port as-is | — Pending |
| ts_ls (not tsserver) | nvim-lspconfig renamed tsserver → ts_ls; new configs must use ts_ls | — Pending |
| conform.nvim for formatting | Current community standard (replaces null-ls); supports format-on-save; works with prettier for JS/TS | — Pending |
| sf.nvim for Salesforce CLI integration | Only actively maintained Neovim Salesforce plugin; wraps sf CLI v2; supports deploy/retrieve/test | — Pending |
| apex_ls JAR path via chezmoi template | JAR path is machine-local; must not be hardcoded in committed config | — Pending |

---
*Last updated: 2026-03-27 after initial project setup*
