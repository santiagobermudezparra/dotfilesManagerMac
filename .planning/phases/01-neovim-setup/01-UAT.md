---
status: testing
phase: 01-neovim-setup
source: [01-01-SUMMARY.md, 01-02-SUMMARY.md, 01-03-SUMMARY.md, 01-04-SUMMARY.md, 01-05-SUMMARY.md]
started: 2026-03-27T03:00:00Z
updated: 2026-03-27T03:00:00Z
---

## Current Test

[testing complete]

## Tests

### 1. chezmoi apply deploys Neovim config
expected: Run `chezmoi apply` (or `chezmoi apply --dry-run` to preview). The config files should be rendered to ~/.config/nvim/. Specifically, ~/.config/nvim/init.lua and ~/.config/nvim/lua/ directory should exist and be populated.
result: blocked
blocked_by: prior-phase
reason: "chezmoi not initialized on this machine yet (no ~/.local/share/chezmoi). This is expected — chezmoi needs to be set up first via chezmoi init."

### 2. Neovim launches with LazyVim and gruvbox-material
expected: Open Neovim (`nvim`). LazyVim should bootstrap — lazy.nvim auto-installs on first launch. The colorscheme should be gruvbox-material (warm brown/orange tones). No errors on startup. After plugins install, `:colorscheme` should show `gruvbox-material`.
result: blocked
blocked_by: prior-phase
reason: "Neovim not installed on this machine (command not found). Cannot test runtime behavior without Neovim. This is expected — Neovim is installed by chezmoi on the target machine."

### 3. nvim-tree file explorer works
expected: Press `<leader>e` to toggle nvim-tree file explorer sidebar. The tree should open/close on the left. Files and directories should be visible and navigable.
result: blocked
blocked_by: prior-phase
reason: "Blocked by Neovim not being installed."

### 4. Telescope fuzzy finder works
expected: Press `<leader>ff` (or your configured telescope keymap) to open telescope file finder. A fuzzy search prompt appears. Typing filters the file list. `<Enter>` opens the selected file.
result: blocked
blocked_by: prior-phase
reason: "Blocked by Neovim not being installed."

### 5. Scroll-center keymaps work
expected: In a file longer than the screen, press `<C-d>` and `<C-u>` to scroll. The cursor should stay centered on screen after each scroll (not jump to top/bottom). This is the scroll-centering behavior from the personal config.
result: blocked
blocked_by: prior-phase
reason: "Blocked by Neovim not being installed."

### 6. Treesitter parsers install for Apex/Salesforce
expected: Run `:TSInstall apex soql sosl` in Neovim (or they install automatically). Then open a `.cls` file — Apex syntax highlighting should be active. Run `:TSInstallInfo` to confirm apex, soql, sosl parsers are installed.
result: blocked
blocked_by: prior-phase
reason: "Blocked by Neovim not being installed."

### 7. Mason installs LSP servers
expected: Run `:Mason` in Neovim. The Mason UI should show the following tools as installed (or installable): `typescript-language-server`, `yaml-language-server`, `json-lsp`, `bash-language-server`, `marksman`, `eslint-lsp`, `prettier`. They should auto-install on first launch.
result: blocked
blocked_by: prior-phase
reason: "Blocked by Neovim not being installed."

### 8. JSON files get SchemaStore validation
expected: Open a `package.json` or any `.json` file. The LSP (jsonls) should provide hover documentation for known JSON keys (e.g., hover over `"version"` in package.json should show schema info). No error about missing schema.
result: blocked
blocked_by: prior-phase
reason: "Blocked by Neovim not being installed."

### 9. Apex filetype detection
expected: Open a `.cls` file (e.g., `MyClass.cls`). Run `:set ft?` — it should show `filetype=apexcode`. Same for `.trigger` and `.apex` files. This confirms the `vim.filetype.add` configuration is working.
result: blocked
blocked_by: prior-phase
reason: "Blocked by Neovim not being installed."

### 10. sf.nvim Salesforce commands work
expected: In a Salesforce project directory (containing `sfdx-project.json`), the sf.nvim keymaps should be active. Press `<leader>sl` to run `sf org list`. A terminal/output window should appear showing the Salesforce org list. (Requires Salesforce CLI `sf` installed and authenticated org.)
result: blocked
blocked_by: prior-phase
reason: "Blocked by Neovim not being installed."

### 11. Floating terminal (toggleterm) works
expected: Press `<C-\>` to open the floating terminal. A terminal window with curved borders should appear centered on screen. Press `<C-\>` again (or `<Esc>`) to close it.
result: blocked
blocked_by: prior-phase
reason: "Blocked by Neovim not being installed."

### 12. apex_ls template renders JAR path
expected: After setting `apexJarPath` in `~/.config/chezmoi/chezmoi.toml` and running `chezmoi apply`, the file `~/.config/nvim/lua/plugins/apex_ls.lua` should exist (rendered from `.tmpl`). Opening a `.cls` file in a Salesforce project should start the Apex LSP (check with `:LspInfo`).
result: blocked
blocked_by: prior-phase
reason: "Blocked by Neovim not being installed and chezmoi not initialized."

### 13. TypeScript LSP (ts_ls) provides completions
expected: Open a `.ts` or `.js` file in a project with `package.json` or `tsconfig.json`. Typing should trigger autocompletions from ts_ls (variable names, method names, imports). `gd` (go-to-definition) should navigate to symbol definitions. `:LspInfo` should show `ts_ls` attached.
result: blocked
blocked_by: prior-phase
reason: "Blocked by Neovim not being installed."

### 14. ESLint auto-fix on save
expected: Open a `.ts` or `.js` file with an ESLint-fixable issue (e.g., missing semicolon if enforced by your config, or unused import). Saving the file (`<leader>w` or `:w`) should automatically fix the issue. `:LspInfo` should show `eslint` attached.
result: blocked
blocked_by: prior-phase
reason: "Blocked by Neovim not being installed."

### 15. Prettier format-on-save
expected: Open a `.ts`, `.json`, `.css`, or `.html` file with inconsistent formatting (e.g., mixed indentation). Saving the file should auto-format it with prettier (normalize quotes, indentation, line endings). No manual `:Format` needed.
result: blocked
blocked_by: prior-phase
reason: "Blocked by Neovim not being installed."

### 16. Bootstrap script downloads apex JAR
expected: Run `bash run_once_bootstrap.sh` (or let chezmoi run it as a `run_once_` script on first apply). The script should attempt to download `apex-jorje-lsp.jar` from GitHub releases via curl. If download succeeds, the JAR appears at the target path. If it fails (network issue), it prints manual download instructions and continues without crashing.
result: blocked
blocked_by: prior-phase
reason: "Blocked by chezmoi not being initialized (no ~/.local/share/chezmoi)."

### 17. chezmoi init one-liner prompts for JAR path
expected: On a fresh machine, run: `sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply santiagobermudezparra/DotfilesManagerMac`. During init, chezmoi should prompt: "Enter path to apex-jorje-lsp.jar" (or similar). The value entered is stored in `~/.config/chezmoi/chezmoi.toml` and not re-asked on subsequent `chezmoi apply` runs.
result: blocked
blocked_by: prior-phase
reason: "Blocked by chezmoi not being initialized (no ~/.local/share/chezmoi)."

### 18. No sensitive data in git history
expected: Run `git log --all --oneline` and `git grep -i "company\|internal\|hostname\|credential"` in the repo. No company names, internal hostnames, Salesforce org URLs, or credentials should appear in any committed file or commit message. All machine-specific values use chezmoi templates.
result: pass

## Summary

total: 18
passed: 1
issues: 0
pending: 0
skipped: 0
blocked: 17

## Gaps

[none yet]
