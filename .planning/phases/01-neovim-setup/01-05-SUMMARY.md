---
phase: 01-neovim-setup
plan: 05
subsystem: infra
tags: [chezmoi, bootstrap, apex-ls, curl, dotfiles]

# Dependency graph
requires:
  - phase: 01-neovim-setup
    plan: 03
    provides: "apex_ls.lua.tmpl consuming chezmoi apexJarPath template variable"
provides:
  - "run_once_bootstrap.sh: one-time machine setup script downloading apex JAR and checking prereqs"
  - ".chezmoi.toml.tmpl: prompts user for apexJarPath on first chezmoi init"
  - "One-liner install: sh -c $(curl -fsLS get.chezmoi.io) -- init --apply santiagobermudezparra/DotfilesManagerMac"
affects: [future-phases, new-machine-setup]

# Tech tracking
tech-stack:
  added: [chezmoi-config-template, bash-bootstrap-script]
  patterns: [run_once_chezmoi_bootstrap, promptStringOnce-for-machine-specific-paths]

key-files:
  created:
    - run_once_bootstrap.sh
    - .chezmoi.toml.tmpl
  modified: []

key-decisions:
  - "Bootstrap script uses curl -fSL --retry 3 (no SSL bypass -k flag) — macOS System Keychain trusts cert chain"
  - "Curl failure in bootstrap is non-fatal: prints manual download instructions and continues (does not exit)"
  - "chezmoi promptStringOnce stores apexJarPath persistently in ~/.config/chezmoi/chezmoi.toml on first run"
  - "No company names, internal hostnames, or credentials in any committed file (DFM-04 compliance)"

patterns-established:
  - "Pattern 1: run_once_ prefix ensures bootstrap runs exactly once per machine via chezmoi"
  - "Pattern 2: [bootstrap] log prefix for all output — makes progress visible in network-restricted terminals"
  - "Pattern 3: graceful curl failure — warns and prints manual steps instead of set -e exiting"

requirements-completed: [DFM-03, DFM-05]

# Metrics
duration: 3min
completed: 2026-03-27
---

# Phase 01 Plan 05: Bootstrap and chezmoi Config Template Summary

**curl-based bootstrap installs apex-jorje-lsp.jar with graceful fallback, and chezmoi.toml.tmpl prompts for machine-specific JAR path on first apply**

## Performance

- **Duration:** ~3 min
- **Started:** 2026-03-27T02:45:45Z
- **Completed:** 2026-03-27T02:48:00Z
- **Tasks:** 1 auto + 1 checkpoint (human verification pending)
- **Files modified:** 2

## Accomplishments

- run_once_bootstrap.sh created: downloads apex-jorje-lsp.jar via curl with 3 retries, fallback manual download instructions, and prereq checks for nvim/sf/java/node
- .chezmoi.toml.tmpl created: prompts user once for apexJarPath using chezmoi's promptStringOnce, stored persistently
- All DFM-04 constraints met: no company names, internal hostnames, or credentials in any committed file

## Task Commits

Each task was committed atomically:

1. **Task 1: Create chezmoi config template and bootstrap script** - `915b213` (feat)

**Plan metadata:** (pending final commit after human verification)

## Files Created/Modified

- `run_once_bootstrap.sh` - Bootstrap script: downloads apex JAR via curl, checks nvim/sf/java/node prerequisites
- `.chezmoi.toml.tmpl` - chezmoi config template: uses promptStringOnce to capture apexJarPath on first init

## Decisions Made

- curl uses `-fSL --retry 3 --retry-delay 2` (no `-k` SSL bypass) — macOS trusts Zscaler cert via System Keychain
- Bootstrap curl failure is handled by if/else (does not abort the script despite `set -euo pipefail`)
- promptStringOnce chosen over promptString so value is stored and not re-asked on each `chezmoi apply`

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered

None.

## User Setup Required

None - no external service configuration required beyond the bootstrap script itself.

## Next Phase Readiness

- Phase 01 (neovim-setup) complete: all 5 plans shipped
- Human verification of complete file structure needed (Task 2 checkpoint)
- After verification, one-liner install is ready: `sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply santiagobermudezparra/DotfilesManagerMac`

---
*Phase: 01-neovim-setup*
*Completed: 2026-03-27*
