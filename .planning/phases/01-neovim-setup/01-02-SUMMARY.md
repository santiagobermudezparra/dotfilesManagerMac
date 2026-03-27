---
phase: 01-neovim-setup
plan: 02
subsystem: neovim
tags: [treesitter, lsp, mason, schemastore, nvim-lspconfig, jsonls, yamlls, bash-ls, marksman, apex, salesforce]

# Dependency graph
requires:
  - phase: 01-neovim-setup-01
    provides: LazyVim foundation, lazy.nvim plugin loader, options/keymaps/ui structure

provides:
  - Treesitter parsers for apex, soql, sosl, css, go, c_sharp, bicep, terraform
  - Mason ensure_installed list for all required LSP servers and formatters
  - jsonls with SchemaStore JSON schema validation
  - yamlls with SchemaStore YAML schema validation
  - bash-ls and marksman retained with auto-config
  - b0o/SchemaStore.nvim plugin spec

affects: [01-neovim-setup-03, 01-neovim-setup-04, 01-neovim-setup-05]

# Tech tracking
tech-stack:
  added:
    - b0o/SchemaStore.nvim (lazy-loaded JSON/YAML schema provider)
  patterns:
    - LazyVim opts extension pattern for treesitter (merges with defaults, does not replace)
    - Mason ensure_installed for tool management
    - nvim-lspconfig opts.servers for LSP server settings
    - SchemaStore integration via require("schemastore") at config time

key-files:
  created:
    - dot_config/nvim/lua/plugins/treesitter.lua
    - dot_config/nvim/lua/plugins/lsp.lua
  modified: []

key-decisions:
  - "apex_ls excluded from Mason ensure_installed — JAR must be installed via curl bootstrap (Mason cannot install it, research Pitfall 5)"
  - "ts_ls and eslint server configs deferred to typescript.lua in plan 04 for clear file ownership"
  - "sflog parser excluded — LOW confidence it exists in nvim-treesitter main (would cause TSInstall error)"
  - "yamlls schemaStore.enable set to false to avoid conflict with SchemaStore.nvim"

patterns-established:
  - "LazyVim opts extension: return { { 'plugin/name', opts = { ... } } } to merge with LazyVim defaults"
  - "LSP separation: Mason (tool install), nvim-lspconfig (server settings), per-language files (language-specific configs)"

requirements-completed: [NVIM-08, LSP-01, LSP-04, LSP-05, LSP-06, TS-01, TS-02, TS-03, TS-04, TS-05, NODE-04]

# Metrics
duration: 1min
completed: 2026-03-27
---

# Phase 01 Plan 02: Treesitter Parsers and Shared LSP Infrastructure Summary

**Treesitter parsers for Salesforce/web/infra languages plus Mason-managed LSP servers with SchemaStore-backed jsonls and yamlls validation**

## Performance

- **Duration:** 1 min
- **Started:** 2026-03-27T02:34:42Z
- **Completed:** 2026-03-27T02:35:39Z
- **Tasks:** 2
- **Files modified:** 2

## Accomplishments

- Created treesitter.lua using LazyVim opts extension pattern, adding 8 parsers beyond LazyVim defaults: apex, soql, sosl, css, go, c_sharp, bicep, terraform
- Created lsp.lua with Mason ensuring 7 tools are installed (typescript-language-server, yaml-language-server, json-lsp, bash-language-server, marksman, eslint-lsp, prettier)
- jsonls configured with `require("schemastore").json.schemas()` and validation enabled
- yamlls configured with `require("schemastore").yaml.schemas()` with manual schemaStore disabled to avoid conflict
- b0o/SchemaStore.nvim added as lazy-loaded plugin dep

## Task Commits

Each task was committed atomically:

1. **Task 1: Configure treesitter parsers** - `a282fbe` (feat)
2. **Task 2: Configure Mason, jsonls, yamlls, bash-ls, marksman, SchemaStore** - `1fda27f` (feat)

**Plan metadata:** (docs commit — see final_commit below)

## Files Created/Modified

- `dot_config/nvim/lua/plugins/treesitter.lua` - nvim-treesitter opts extension adding Salesforce, web, and infra parsers
- `dot_config/nvim/lua/plugins/lsp.lua` - Mason tool install list, SchemaStore plugin, jsonls/yamlls server settings

## Decisions Made

- apex_ls excluded from Mason ensure_installed — the Apex LSP JAR must be curl-bootstrapped separately; Mason cannot install it (research Pitfall 5)
- ts_ls and eslint server configurations intentionally deferred to typescript.lua (plan 04) to maintain clear file ownership boundaries
- sflog treesitter parser excluded due to LOW confidence in nvim-treesitter availability; would cause TSInstall errors
- yamlls schemaStore.enable forced to false to prevent conflict between built-in YAML LSP schema store and SchemaStore.nvim

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered

None.

## User Setup Required

None - no external service configuration required. Mason will auto-install the configured tools on first Neovim launch.

## Next Phase Readiness

- Plan 03 (Salesforce LSP / sf.nvim) can proceed — Mason foundation is ready, apex_ls Mason exclusion is documented
- Plan 04 (TypeScript LSP) can proceed — typescript-language-server and eslint-lsp are in Mason ensure_installed, ts_ls/eslint server config slots are open in lsp.lua
- Plan 05 (formatting/conform) can proceed — prettier is in Mason ensure_installed

---
*Phase: 01-neovim-setup*
*Completed: 2026-03-27*
