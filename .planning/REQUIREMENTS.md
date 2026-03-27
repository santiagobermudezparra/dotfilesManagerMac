# Requirements: DotfilesManagerMac

**Defined:** 2026-03-27
**Core Value:** A single Neovim config that works on a restricted corporate Mac, handling Salesforce CLI + Node.js development with the same look and feel as the personal setup — without leaking work context to the public GitHub repo.

## v1 Requirements

### Dotfiles Manager

- [x] **DFM-01**: chezmoi is the dotfiles manager, installable via curl binary (no brew dependency)
- [x] **DFM-02**: All Neovim config files are managed by chezmoi from a single GitHub repo
- [ ] **DFM-03**: Machine-specific values (apex JAR path, npm registry) handled via chezmoi templates — never hardcoded
- [x] **DFM-04**: Repo is safe to publish publicly — no employer names, internal URLs, or credentials committed
- [ ] **DFM-05**: A bootstrap script installs chezmoi and applies dotfiles on a new machine in one command

### Neovim Core

- [x] **NVIM-01**: LazyVim distribution used as the foundation (stays on existing LazyVim setup)
- [x] **NVIM-02**: gruvbox-material colorscheme applied (matches existing personal config)
- [x] **NVIM-03**: Existing keymaps ported from personal config (leader mappings, scroll centering, telescope symbol finder, etc.)
- [x] **NVIM-04**: Existing options ported (no line numbers, scrolloff=8, mouse enabled, smartcase, signcolumn=yes)
- [x] **NVIM-05**: nvim-cmp completion with LSP, snippet, buffer, and path sources (or blink.cmp as modern alternative)
- [x] **NVIM-06**: Telescope fuzzy finder configured
- [x] **NVIM-07**: nvim-tree file explorer configured
- [x] **NVIM-08**: Treesitter syntax highlighting working

### LSP & Language Support

- [x] **LSP-01**: Mason.nvim manages LSP server installation (bash-language-server, marksman, typescript-language-server, yaml-language-server, json-lsp)
- [x] **LSP-02**: ts_ls (TypeScript/JavaScript) configured via nvim-lspconfig
- [ ] **LSP-03**: apex_ls configured pointing to apex-jorje-lsp JAR (path via chezmoi template)
- [x] **LSP-04**: json-lsp configured with SchemaStore schemas (package.json, tsconfig.json validation)
- [x] **LSP-05**: yaml-language-server configured (covers Salesforce metadata YAML)
- [x] **LSP-06**: bash-language-server and marksman retained from existing config

### Treesitter Parsers

- [x] **TS-01**: apex, soql, sosl parsers installed (Salesforce)
- [x] **TS-02**: javascript, typescript, tsx parsers installed (Node.js / LWC)
- [x] **TS-03**: html, css parsers installed (LWC templates)
- [x] **TS-04**: xml parser installed (Salesforce package.xml, metadata)
- [x] **TS-05**: Existing parsers retained: bash, lua, python, json, yaml, vim, vimdoc, go, bicep, terraform, c_sharp

### Salesforce Development

- [ ] **SF-01**: sf.nvim plugin installed and configured (requires sf CLI v2 and Neovim v0.11+)
- [ ] **SF-02**: sf.nvim provides: deploy metadata, retrieve metadata, run Apex tests, open org in browser
- [ ] **SF-03**: toggleterm.nvim (or equivalent) configured for sf CLI terminal output
- [ ] **SF-04**: apex_ls semantic error checking enabled
- [ ] **SF-05**: Apex and SOQL filetypes recognized and highlighted via treesitter

### Node.js / JavaScript / TypeScript Development

- [x] **NODE-01**: ts_ls LSP provides completions, go-to-definition, hover, diagnostics for JS/TS files
- [x] **NODE-02**: conform.nvim configured with prettier for JS/TS/JSON formatting
- [x] **NODE-03**: ESLint diagnostics integrated (via eslint-lsp or nvim-lint)
- [x] **NODE-04**: b0o/schemastore.nvim provides JSON schemas for package.json and tsconfig.json
- [x] **NODE-05**: tsx files handled correctly (JSX syntax highlighting + ts_ls)

### Formatting & Diagnostics

- [x] **FMT-01**: conform.nvim configured for format-on-save (JS, TS, JSON, CSS, HTML via prettier)
- [ ] **FMT-02**: No formatter configured for Apex (none exists; LSP diagnostics only)
- [ ] **DIAG-01**: trouble.nvim (or equivalent) provides diagnostic list UI

## v2 Requirements

### Shell & Terminal

- **SH-01**: zsh config managed by chezmoi (aliases, PATH, mise integration)
- **SH-02**: tmux config managed by chezmoi
- **SH-03**: pure prompt theme configured

### Additional Tools

- **TOOL-01**: mise config managed by chezmoi (Node, Python version management)
- **TOOL-02**: Git config (gitconfig) managed by chezmoi with user-specific template

### Enhanced Salesforce

- **SF-V2-01**: neotest + Apex test adapter for running tests inline
- **SF-V2-02**: universal-ctags for enhanced Apex jump-to-definition

## Out of Scope

| Feature | Reason |
|---------|--------|
| DevPods / container provisioning | Not possible in this corporate environment |
| Windows / Linux support | macOS-only target |
| GUI Neovim (Neovide) | Terminal Neovim only |
| Secrets management (1Password, etc.) | Not needed for v1 — no secrets in dotfiles |
| Auto-updating apex JAR | Manual download acceptable for v1 |
| Neovim plugin for Apex debugging | No mature solution exists as of 2025/2026 |

## Traceability

| Requirement | Phase | Status |
|-------------|-------|--------|
| DFM-01 | Phase 1 | Complete |
| DFM-02 | Phase 1 | Complete |
| DFM-03 | Phase 1 | Pending |
| DFM-04 | Phase 1 | Complete |
| DFM-05 | Phase 1 | Pending |
| NVIM-01 | Phase 1 | Complete |
| NVIM-02 | Phase 1 | Complete |
| NVIM-03 | Phase 1 | Complete |
| NVIM-04 | Phase 1 | Complete |
| NVIM-05 | Phase 1 | Complete |
| NVIM-06 | Phase 1 | Complete |
| NVIM-07 | Phase 1 | Complete |
| NVIM-08 | Phase 1 | Complete |
| LSP-01 | Phase 1 | Complete |
| LSP-02 | Phase 1 | Complete |
| LSP-03 | Phase 1 | Pending |
| LSP-04 | Phase 1 | Complete |
| LSP-05 | Phase 1 | Complete |
| LSP-06 | Phase 1 | Complete |
| TS-01 | Phase 1 | Complete |
| TS-02 | Phase 1 | Complete |
| TS-03 | Phase 1 | Complete |
| TS-04 | Phase 1 | Complete |
| TS-05 | Phase 1 | Complete |
| SF-01 | Phase 1 | Pending |
| SF-02 | Phase 1 | Pending |
| SF-03 | Phase 1 | Pending |
| SF-04 | Phase 1 | Pending |
| SF-05 | Phase 1 | Pending |
| NODE-01 | Phase 1 | Complete |
| NODE-02 | Phase 1 | Complete |
| NODE-03 | Phase 1 | Complete |
| NODE-04 | Phase 1 | Complete |
| NODE-05 | Phase 1 | Complete |
| FMT-01 | Phase 1 | Complete |
| FMT-02 | Phase 1 | Pending |
| DIAG-01 | Phase 1 | Pending |

**Coverage:**
- v1 requirements: 37 total
- Mapped to phases: 37
- Unmapped: 0 ✓

---
*Requirements defined: 2026-03-27*
*Last updated: 2026-03-27 after initial definition*
