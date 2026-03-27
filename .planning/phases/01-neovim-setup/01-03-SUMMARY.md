---
phase: 01-neovim-setup
plan: 03
subsystem: editor
tags: [neovim, salesforce, apex, sf.nvim, toggleterm, chezmoi, nvim-lspconfig, lazyvim]

# Dependency graph
requires:
  - phase: 01-neovim-setup plan 01
    provides: options.lua with base Neovim options
  - phase: 01-neovim-setup plan 02
    provides: lsp.lua with nvim-lspconfig opts.servers pattern, mason ensure_installed

provides:
  - salesforce.lua with sf.nvim (6 Salesforce CLI keymaps) and toggleterm (floating terminal)
  - apex_ls.lua.tmpl with chezmoi-templated apex_ls LSP config (semantic errors enabled)
  - Apex filetype detection in options.lua (.cls, .trigger, .apex -> apexcode)

affects:
  - 01-neovim-setup plan 04 (typescript.lua may extend nvim-lspconfig similarly)
  - future plans using Salesforce-specific filetypes or keymaps

# Tech tracking
tech-stack:
  added:
    - xixiaofinland/sf.nvim (Salesforce CLI integration, Neovim v0.11+)
    - akinsho/toggleterm.nvim (floating terminal)
    - apex_ls (Apex Language Server, JAR-based, not Mason-managed)
  patterns:
    - chezmoi .tmpl files for machine-specific values (apexJarPath variable)
    - nvim-lspconfig opts.servers extension pattern for non-Mason LSPs
    - enable_hotkeys=false with explicit keymap definitions for sf.nvim

key-files:
  created:
    - dot_config/nvim/lua/plugins/salesforce.lua
    - dot_config/nvim/lua/plugins/apex_ls.lua.tmpl
  modified:
    - dot_config/nvim/lua/config/options.lua (appended filetype detection)

key-decisions:
  - "apex_ls.lua.tmpl uses .tmpl extension so chezmoi renders {{ .apexJarPath }} at apply time"
  - "enable_hotkeys=false in sf.nvim to define explicit keymaps without leader conflicts"
  - "No formatter for Apex per D-22/FMT-02 — no viable Apex formatter exists"
  - "No trouble.nvim per D-10 — inline LSP diagnostics sufficient"

patterns-established:
  - "Pattern: Use .lua.tmpl for any Neovim config requiring machine-specific paths"
  - "Pattern: apex_ls follows same nvim-lspconfig opts.servers pattern as lsp.lua servers"

requirements-completed: [LSP-03, SF-01, SF-02, SF-03, SF-04, SF-05, FMT-02, DIAG-01]

# Metrics
duration: 2min
completed: 2026-03-27
---

# Phase 01 Plan 03: Salesforce Development Support Summary

**sf.nvim with 6 CLI keymaps + apex_ls via chezmoi-templated JAR path + toggleterm floating terminal + Apex filetype detection for .cls/.trigger/.apex**

## Performance

- **Duration:** 2 min
- **Started:** 2026-03-27T02:41:38Z
- **Completed:** 2026-03-27T02:43:40Z
- **Tasks:** 2
- **Files modified:** 3

## Accomplishments

- sf.nvim installed with `enable_hotkeys=false` and 6 custom Salesforce CLI keymaps (`<leader>sp/sr/sta/stt/so/sl`)
- apex_ls configured via `apex_ls.lua.tmpl` with chezmoi `{{ .apexJarPath }}` template variable, semantic errors enabled (`-Ddebug.semantic.errors=true`), attaches to Salesforce projects via `root_pattern("sfdx-project.json")`
- toggleterm.nvim configured for floating terminal with curved border (`<C-\>` mapping)
- Apex filetype detection appended to options.lua: `.cls`, `.trigger`, `.apex` all map to `apexcode` filetype

## Task Commits

Each task was committed atomically:

1. **Task 1: sf.nvim + toggleterm config + Apex filetype detection** - `8c47b6e` (feat)
2. **Task 2: apex_ls LSP config with chezmoi template** - `ba50d0b` (feat)

**Plan metadata:** (docs commit — see below)

## Files Created/Modified

- `dot_config/nvim/lua/plugins/salesforce.lua` - sf.nvim (6 keymaps, enable_hotkeys=false) and toggleterm (float, curved border)
- `dot_config/nvim/lua/plugins/apex_ls.lua.tmpl` - apex_ls LSP spec with chezmoi template for JAR path, semantic errors, sfdx-project.json root detection
- `dot_config/nvim/lua/config/options.lua` - Appended `vim.filetype.add` for Apex file extensions

## Decisions Made

- `apex_ls.lua.tmpl` uses `.tmpl` extension so chezmoi processes the `{{ .apexJarPath }}` Go template variable at `chezmoi apply` time. The JAR path is machine-specific and must never be hardcoded in the committed config.
- `enable_hotkeys = false` in sf.nvim setup to prevent potential `<leader>s` conflicts; all bindings defined explicitly.
- No Apex formatter added (D-22/FMT-02): no viable Apex formatter exists, conform.nvim intentionally omits it.
- No trouble.nvim anywhere (D-10/DIAG-01): inline LSP diagnostics are sufficient.

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered

None.

## User Setup Required

The `apexJarPath` value must be set in `~/.config/chezmoi/chezmoi.toml` under `[data]`:

```toml
[data]
  apexJarPath = "/path/to/apex-jorje-lsp.jar"
```

After adding this, run `chezmoi apply` to render `apex_ls.lua.tmpl` to `~/.config/nvim/lua/plugins/apex_ls.lua`.

Java 11+ must be installed on the target machine for apex_ls to start.

## Known Stubs

None — all configuration is complete and functional once `apexJarPath` is set in chezmoi.toml.

## Next Phase Readiness

- Plan 04 (typescript.lua) can proceed independently; it extends `nvim-lspconfig` with `ts_ls` and `eslint`, following the same `opts.servers` pattern established in lsp.lua and apex_ls.lua.tmpl
- Salesforce workflow is fully configured; sf.nvim keymaps and apex_ls diagnostics will be active in any Salesforce project directory containing `sfdx-project.json`

---
*Phase: 01-neovim-setup*
*Completed: 2026-03-27*
