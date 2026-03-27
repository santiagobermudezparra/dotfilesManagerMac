# Phase 1: Neovim Setup - Research

**Researched:** 2026-03-27
**Domain:** Neovim configuration, LazyVim, LSP ecosystem, chezmoi dotfiles management, Salesforce/Apex development
**Confidence:** HIGH (core stack verified via official docs and GitHub repos)

---

<user_constraints>
## User Constraints (from CONTEXT.md)

### Locked Decisions
- **D-01:** Stay on LazyVim distribution — existing config is LazyVim-based; provides sensible defaults; easier to maintain via extras
- **D-02:** gruvbox-material colorscheme (port from existing personal config as-is)
- **D-03:** Existing keymaps ported (leader mappings, scroll centering, telescope symbol finder, etc.)
- **D-04:** Existing options ported (no line numbers, scrolloff=8, mouse enabled, smartcase, signcolumn=yes)
- **D-05:** Use blink.cmp as the completion engine (modern alternative to nvim-cmp)
- **D-06:** blink.cmp sources: LSP, snippet, buffer, path
- **D-07:** Telescope fuzzy finder configured (existing pattern)
- **D-08:** nvim-tree file explorer configured (existing pattern)
- **D-09:** Treesitter syntax highlighting working (existing pattern)
- **D-10:** No dedicated diagnostic UI (trouble.nvim omitted) — use inline LSP hover only
- **D-11:** sf.nvim plugin installed (xixiaofinland/sf.nvim, requires sf CLI v2 and Neovim v0.11+)
- **D-12:** apex_ls LSP configured pointing to apex-jorje-lsp JAR
- **D-13:** Apex LSP uses hybrid approach: bootstrap script attempts curl-based auto-download from salesforcedx-vscode repo; falls back to manual instructions if curl fails
- **D-14:** JAR path provided to nvim-lspconfig via chezmoi template (never hardcoded in repo)
- **D-15:** toggleterm.nvim configured for sf CLI terminal output
- **D-16:** Treesitter parsers: apex, soql, sosl installed
- **D-17:** ts_ls (not tsserver) LSP configured via nvim-lspconfig for JS/TS
- **D-18:** conform.nvim for format-on-save: prettier for JS, TS, JSON, CSS, HTML
- **D-19:** eslint-lsp for ESLint integration — runs automatically on file change
- **D-20:** SchemaStore JSON schemas (b0o/schemastore.nvim) for package.json, tsconfig.json
- **D-21:** Treesitter parsers: javascript, typescript, tsx, html, css installed
- **D-22:** No formatter for Apex (LSP diagnostics only)
- **D-23:** LSP servers via Mason: bash-language-server, marksman, json-lsp, yaml-language-server
- **D-24:** Treesitter parsers: bash, lua, python, json, yaml, vim, vimdoc, go, bicep, terraform, c_sharp (existing)
- **D-25:** xml parser installed (Salesforce package.xml)
- **D-26:** chezmoi structure: `dot_config/nvim/`, `dot_config/chezmoi/`, `run_bootstrap.sh` at repo root
- **D-27:** chezmoi templates for machine-specific values: apex JAR path, npm registry (if needed)
- **D-28:** No employer names, internal URLs, or credentials in committed files — repo is publicly publishable
- **D-29:** Bootstrap script installs chezmoi via curl binary (no brew dependency) and applies dotfiles in one command

### Claude's Discretion
- Exact keymap bindings for new Salesforce features (sf.nvim commands)
- conform.nvim configuration details (trim_trailing_whitespace, etc.)
- blink.cmp configuration (fuzzy matching, formatting, sorting)
- nvim-lint ESLint setup details (which linters, debounce timing)
- Exact treesitter query/highlight customizations
- Error handling in bootstrap script (retry logic, cleanup on failure)

### Deferred Ideas (OUT OF SCOPE)
- zsh config management — Phase 2
- tmux config management — Phase 2
- neotest + Apex test adapter — backlog (SF-V2-01)
- universal-ctags for Apex jump-to-definition — backlog (SF-V2-02)
- Neovim AI assistant (copilot.lua, codecompanion.nvim) — backlog
- Git config template management — Phase 2
</user_constraints>

---

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|------------------|
| DFM-01 | chezmoi installable via curl binary (no brew) | Verified: `sh -c "$(curl -fsLS get.chezmoi.io)" -- -b $HOME/.local/bin` |
| DFM-02 | All Neovim config files managed by chezmoi from single GitHub repo | Verified: dot_config/nvim/ structure in chezmoi source |
| DFM-03 | Machine-specific values via chezmoi templates — never hardcoded | Verified: `.tmpl` files + chezmoi.toml `[data]` section |
| DFM-04 | Repo safe to publish publicly | Pattern: no secrets in committed files; chezmoi templates for env-specific values |
| DFM-05 | Bootstrap script installs chezmoi + applies dotfiles in one command | Verified: `sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply $GITHUB_USERNAME` |
| NVIM-01 | LazyVim distribution as foundation | Verified: use LazyVim starter, stay within its plugin spec conventions |
| NVIM-02 | gruvbox-material colorscheme | Pattern: add as plugin spec in `lua/plugins/colorscheme.lua` |
| NVIM-03 | Existing keymaps ported | Pattern: `lua/config/keymaps.lua` in LazyVim |
| NVIM-04 | Existing options ported | Pattern: `lua/config/options.lua` in LazyVim |
| NVIM-05 | blink.cmp completion with LSP/snippet/buffer/path | Verified: LazyVim blink.cmp extra; built-in sources cover all four |
| NVIM-06 | Telescope fuzzy finder configured | Pattern: LazyVim includes telescope by default; extend in `lua/plugins/` |
| NVIM-07 | nvim-tree file explorer configured | Pattern: add nvim-tree spec in `lua/plugins/` |
| NVIM-08 | Treesitter syntax highlighting working | Verified: LazyVim default treesitter config; extend `ensure_installed` |
| LSP-01 | Mason manages LSP server installation | Verified: Mason is LazyVim default; `ensure_installed` list controls servers |
| LSP-02 | ts_ls configured via nvim-lspconfig | CRITICAL: LazyVim TypeScript extra defaults to vtsls, not ts_ls — see Architecture section |
| LSP-03 | apex_ls configured pointing to apex-jorje-lsp JAR | Verified: nvim-lspconfig has apex_ls config; JAR from salesforcedx-vscode repo |
| LSP-04 | json-lsp with SchemaStore schemas | Verified: b0o/SchemaStore.nvim + jsonls setup |
| LSP-05 | yaml-language-server configured | Pattern: nvim-lspconfig yamlls + SchemaStore for YAML schemas |
| LSP-06 | bash-language-server and marksman retained | Pattern: add to Mason ensure_installed |
| TS-01 | apex, soql, sosl treesitter parsers | Verified: all three in nvim-treesitter main (from aheber/tree-sitter-sfapex) |
| TS-02 | javascript, typescript, tsx parsers | Verified: in LazyVim default ensure_installed |
| TS-03 | html, css parsers | Verified: html in LazyVim defaults; css needs explicit addition |
| TS-04 | xml parser | Verified: in LazyVim default ensure_installed |
| TS-05 | bash, lua, python, json, yaml, vim, vimdoc, go, bicep, terraform, c_sharp | Most in LazyVim defaults; bicep, terraform, c_sharp need explicit addition |
| SF-01 | sf.nvim installed and configured | Verified: xixiaofinland/sf.nvim, Neovim v0.11+ required |
| SF-02 | sf.nvim deploy/retrieve/run tests/open org | Verified: all commands available via SF category subcommands |
| SF-03 | toggleterm.nvim for sf CLI terminal output | NOTE: sf.nvim has built-in SFTerm; toggleterm.nvim can be added separately for general use |
| SF-04 | apex_ls semantic error checking enabled | Pattern: set `apex_enable_semantic_errors = true` in apex_ls setup |
| SF-05 | Apex and SOQL filetypes recognized + highlighted | Verified: treesitter parsers handle this once apex/soql/sosl installed |
| NODE-01 | ts_ls completions/go-to-def/hover/diagnostics | Covered by LSP-02 (vtsls decision clarification needed — see Architecture) |
| NODE-02 | conform.nvim with prettier for JS/TS/JSON formatting | Verified: conform.nvim formatters_by_ft pattern |
| NODE-03 | ESLint diagnostics via eslint-lsp | Verified: nvim-lspconfig eslint server config |
| NODE-04 | SchemaStore.nvim for package.json/tsconfig.json | Verified: b0o/SchemaStore.nvim |
| NODE-05 | tsx files handled (JSX highlighting + ts_ls) | Verified: tsx in LazyVim default parsers; ts_ls/vtsls handles tsx |
| FMT-01 | conform.nvim format-on-save for JS/TS/JSON/CSS/HTML | Verified: format_on_save option + formatters_by_ft |
| FMT-02 | No formatter for Apex | Pattern: simply omit apex from conform formatters_by_ft |
| DIAG-01 | Diagnostic list UI (trouble.nvim or equivalent) | CONFLICT: REQUIREMENTS.md says trouble.nvim; D-10 says omit it — see Pitfalls |
</phase_requirements>

---

## Summary

Phase 1 is a fully configured Neovim setup managed via chezmoi on a corporate Mac with Zscaler TLS interception. The stack is well-established: LazyVim as the Neovim distribution, blink.cmp for completion, conform.nvim for formatting, nvim-lspconfig for all language servers, and chezmoi for dotfiles management.

The biggest technical nuance is the **TypeScript LSP server choice**: the user-locked decision says `ts_ls`, but LazyVim's current TypeScript extra defaults to `vtsls` and actively disables `ts_ls`. Both work; the plan must explicitly configure `ts_ls` via nvim-lspconfig directly (bypassing LazyVim's TypeScript extra), or use vtsls and relax the requirement. Research recommends using `ts_ls` directly since it is the user's explicit preference and works fine with nvim-lspconfig.

The **apex_ls JAR download** is a well-understood pattern: the JAR lives in the `forcedotcom/salesforcedx-vscode` repository under `packages/salesforcedx-vscode-apex/out/apex-jorje-lsp.jar`. It is a regular file download (not streaming/GHCR), so Zscaler curl-based downloads work. The JAR is around 6–8 MB. Java 11+ is required to run it.

The **chezmoi template pattern** for the JAR path is straightforward: define `apexJarPath` in `~/.config/chezmoi/chezmoi.toml` under `[data]`, then reference `{{ .apexJarPath }}` in a `.lua.tmpl` file in the nvim config.

**Primary recommendation:** Use LazyVim extras for everything supported (blink.cmp, treesitter, mason, lsp), then add custom `lua/plugins/` files for Salesforce-specific config (apex_ls, sf.nvim), TypeScript config (ts_ls directly), and conform.nvim. The chezmoi structure is `dot_config/nvim/` at the repo root, with a `.tmpl` suffix on the apex LSP config file.

---

## Standard Stack

### Core
| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| LazyVim | latest (uses lazy.nvim) | Neovim distribution + plugin framework | Existing base; sensible defaults; extras system for modular config |
| blink.cmp | v1.10.1 (Mar 2026) | Completion engine | LazyVim official extra; modern replacement for nvim-cmp; built-in LSP/snippet/buffer/path sources |
| nvim-lspconfig | latest | LSP server configurations | Standard glue between Neovim and LSP servers |
| mason.nvim | latest | LSP/formatter installer | LazyVim default; manages typescript-language-server, yaml-ls, json-lsp, etc. |
| nvim-treesitter | latest | Syntax highlighting + parsing | LazyVim default; includes apex/soql/sosl parsers |
| conform.nvim | latest (Neovim 0.10+) | Format-on-save | Current community standard; supports prettier per filetype |
| chezmoi | latest binary | Dotfiles management | Already in use; curl binary install; Go template system |

### Supporting
| Library | Version | Purpose | When to Use |
|---------|---------|---------|-------------|
| b0o/SchemaStore.nvim | latest | JSON/YAML schemas catalog | Wire into jsonls and yamlls for package.json/tsconfig.json validation |
| xixiaofinland/sf.nvim | latest | Salesforce CLI integration | Only actively maintained Neovim Salesforce plugin |
| telescope.nvim | LazyVim default | Fuzzy finder | Already used in existing config |
| nvim-tree.lua | latest | File explorer | Existing pattern |
| sainnhe/gruvbox-material | latest | Colorscheme | User's existing preference |
| toggleterm.nvim | latest | General terminal | For sf CLI terminal output (sf.nvim has built-in SFTerm but toggleterm provides general-purpose floating terminals) |

### Alternatives Considered
| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| ts_ls | vtsls | vtsls is LazyVim default and faster; ts_ls is user's explicit decision — use ts_ls directly via nvim-lspconfig |
| ts_ls | tsgo | tsgo is experimental/faster but less stable as of 2026 |
| eslint-lsp | nvim-lint | eslint-lsp integrates with Neovim's LSP diagnostics automatically; nvim-lint requires manual configuration and autocmds |
| conform.nvim | null-ls | null-ls is archived/unmaintained; conform.nvim is the current standard |
| blink.cmp | nvim-cmp | blink.cmp is more performant; LazyVim migrated to it; no reason to use nvim-cmp in new config |

**Installation (Mason-managed, run from within Neovim):**
Servers installed automatically via `mason.nvim` `ensure_installed`:
- `typescript-language-server` (for ts_ls)
- `yaml-language-server`
- `json-lsp`
- `bash-language-server`
- `marksman`
- `eslint-lsp`
- `prettier` (for conform.nvim)

apex_ls is NOT in Mason — see JAR Download Strategy section.

---

## Architecture Patterns

### Recommended Project Structure
```
(repo root)
├── dot_config/
│   ├── nvim/
│   │   ├── init.lua                    # LazyVim bootstrap (copied from starter)
│   │   ├── lazy-lock.json              # Plugin lockfile
│   │   └── lua/
│   │       ├── config/
│   │       │   ├── options.lua         # Editor options (scrolloff, mouse, etc.)
│   │       │   ├── keymaps.lua         # Custom keymaps
│   │       │   └── lazy.lua            # lazy.nvim bootstrap
│   │       └── plugins/
│   │           ├── colorscheme.lua     # gruvbox-material
│   │           ├── ui.lua              # nvim-tree, telescope
│   │           ├── lsp.lua             # ts_ls, eslint, json-lsp, yaml-ls, bash-ls, marksman
│   │           ├── apex_ls.lua.tmpl    # apex_ls with {{ .apexJarPath }} template
│   │           ├── salesforce.lua      # sf.nvim, toggleterm
│   │           ├── formatting.lua      # conform.nvim + prettier
│   │           └── treesitter.lua      # ensure_installed additions
│   └── chezmoi/
│       └── chezmoi.toml.tmpl           # chezmoi config (if needed)
├── dot_local/
│   └── share/
│       └── nvim/
│           └── apex-ls/                # NOT committed — downloaded by bootstrap
├── run_bootstrap.sh                    # Bootstrap entry point
└── .chezmoitemplates/                  # Shared template partials (if needed)
```

### Pattern 1: LazyVim Plugin Extension
**What:** Add custom plugins by creating files in `lua/plugins/*.lua`. Each file returns a table of plugin specs.
**When to use:** For all Salesforce and TypeScript customizations.

```lua
-- Source: https://www.lazyvim.org/configuration/plugins
-- lua/plugins/salesforce.lua
return {
  {
    "xixiaofinland/sf.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("sf").setup({
        enable_hotkeys = false,  -- define own mappings to avoid conflicts
        fetch_org_list_at_nvim_start = true,
      })
      -- Custom keymaps
      vim.keymap.set("n", "<leader>sp", "<cmd>SF metadata push<cr>", { desc = "SF Push" })
      vim.keymap.set("n", "<leader>sr", "<cmd>SF metadata retrieve<cr>", { desc = "SF Retrieve" })
      vim.keymap.set("n", "<leader>ta", "<cmd>SF apex test run_all<cr>", { desc = "Run All Apex Tests" })
      vim.keymap.set("n", "<leader>tt", "<cmd>SF apex test run_current<cr>", { desc = "Run Apex Test" })
    end,
  },
}
```

### Pattern 2: LazyVim opts Extension (extending defaults)
**What:** LazyVim uses `opts_extend` for lists — your `ensure_installed` additions merge with defaults, not replace them.
**When to use:** Adding treesitter parsers, Mason servers on top of LazyVim defaults.

```lua
-- Source: https://www.lazyvim.org/plugins/treesitter
-- lua/plugins/treesitter.lua
return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        -- Salesforce-specific (beyond LazyVim defaults)
        "apex", "soql", "sosl",
        -- LazyVim already includes: javascript, typescript, tsx, html, json, yaml, xml, bash, lua, python, vim, vimdoc
        -- Additional for this config:
        "css", "go", "c_sharp", "bicep", "terraform",
      },
    },
  },
}
```

### Pattern 3: chezmoi Template for Machine-Specific Paths
**What:** Files ending in `.tmpl` are processed as Go templates. Variables come from `~/.config/chezmoi/chezmoi.toml`.
**When to use:** The apex JAR path and any other machine-specific value.

```toml
# ~/.config/chezmoi/chezmoi.toml (on target machine, NOT committed)
[data]
  apexJarPath = "/Users/username/.local/share/nvim/apex-ls/apex-jorje-lsp.jar"
```

```lua
-- dot_config/nvim/lua/plugins/apex_ls.lua.tmpl
-- Source: chezmoi template syntax
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        apex_ls = {
          apex_jar_path = "{{ .apexJarPath }}",
          apex_enable_semantic_errors = true,
          filetypes = { "apexcode" },
          root_dir = function(fname)
            return require("lspconfig.util").root_pattern("sfdx-project.json")(fname)
          end,
        },
      },
    },
  },
}
```

### Pattern 4: ts_ls Explicit Configuration (bypassing LazyVim's TypeScript extra)
**What:** LazyVim's TypeScript extra enables vtsls and disables ts_ls. Since the requirement is ts_ls, configure it directly via nvim-lspconfig without enabling the LazyVim TypeScript extra.
**When to use:** This is the approach for this project — do NOT enable `:LazyExtras` `lang.typescript`.

```lua
-- lua/plugins/lsp.lua
-- Source: nvim-lspconfig docs
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ts_ls = {
          filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
          root_dir = require("lspconfig.util").root_pattern("tsconfig.json", "jsconfig.json", "package.json", ".git"),
        },
        eslint = {
          -- ESLint-LSP: runs on file change; provides diagnostics
          settings = {
            packageManager = "npm",
          },
          on_attach = function(_, bufnr)
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = bufnr,
              command = "EslintFixAll",  -- optional: auto-fix on save
            })
          end,
        },
        jsonls = {
          settings = {
            json = {
              schemas = require("schemastore").json.schemas(),
              validate = { enable = true },
            },
          },
        },
        yamlls = {
          settings = {
            yaml = {
              schemaStore = { enable = false, url = "" },
              schemas = require("schemastore").yaml.schemas(),
            },
          },
        },
      },
    },
  },
  {
    "b0o/SchemaStore.nvim",
    lazy = true,
  },
}
```

### Pattern 5: conform.nvim Format-on-Save
**What:** Prettier runs on save for JS/TS/JSON/CSS/HTML files only. No formatter for Apex.

```lua
-- lua/plugins/formatting.lua
-- Source: https://github.com/stevearc/conform.nvim
return {
  {
    "stevearc/conform.nvim",
    opts = {
      format_on_save = {
        timeout_ms = 500,
        lsp_format = "fallback",
      },
      formatters_by_ft = {
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        json = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        -- apex intentionally omitted (D-22)
      },
    },
  },
}
```

### Anti-Patterns to Avoid
- **Enabling LazyVim's `lang.typescript` extra:** It activates vtsls and disables ts_ls. Since ts_ls is required (D-17), configure ts_ls directly via nvim-lspconfig.
- **Hardcoding apex JAR path in lua files:** Any `.lua` file with an absolute path would be machine-specific. Use `.lua.tmpl` + chezmoi template.
- **Using Mason to install apex_ls:** Mason cannot install it. The JAR must be downloaded via curl separately.
- **Sourcing ~/.npmrc in bootstrap script:** `.npmrc` is read by npm, not a shell script. Sourcing it causes syntax errors in zsh.
- **Using `require('lspconfig').apex_ls.setup{}` pattern in Neovim 0.11+:** The note in nvim-lspconfig says this is deprecated for 0.11+. Use `vim.lsp.config('apex_ls', {...})` or the LazyVim `opts.servers` pattern instead (both work; the opts.servers pattern is cleanest for LazyVim).

---

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Completion UI | Custom floating window | blink.cmp | Handles LSP protocol, ranking, ghost text, docs |
| Format-on-save | BufWritePre autocmd with shell call | conform.nvim | Handles async, timeout, fallback, multiple formatters |
| LSP server lifecycle | Manual `vim.lsp.start_client()` | nvim-lspconfig | Root detection, capabilities, server config is complex |
| JSON schema validation | Custom JSON schema provider | b0o/SchemaStore.nvim | Maintains 500+ schemas including package.json, tsconfig.json |
| chezmoi installation | Custom curl/install script | `get.chezmoi.io` official installer | Handles platform detection, checksum verification |
| Treesitter parser installation | Manual grammar compilation | `:TSInstall` via nvim-treesitter | Handles compilation, queries, highlight injection |
| ESLint integration | nvim-lint manual autocmds | eslint-lsp | Runs as LSP server, uses standard diagnostic infrastructure |

**Key insight:** Every problem in the Neovim plugin ecosystem has a maintained solution. The complexity of LSP server lifecycle management, parser compilation, and format-on-save timing is substantial — custom solutions will break across Neovim minor versions.

---

## JAR Download Strategy

### apex-jorje-lsp.jar Source
The JAR is embedded in the `forcedotcom/salesforcedx-vscode` repository (the VS Code Salesforce extension). It is not distributed as a GitHub Release but as a committed binary in the repository.

- **GitHub blob URL:** `https://github.com/forcedotcom/salesforcedx-vscode/blob/develop/packages/salesforcedx-vscode-apex/out/apex-jorje-lsp.jar`
- **Raw download URL:** `https://raw.githubusercontent.com/forcedotcom/salesforcedx-vscode/develop/packages/salesforcedx-vscode-apex/out/apex-jorje-lsp.jar`
- **File size:** approximately 6–8 MB (simple file download, not a streaming archive)
- **Java requirement:** Java 11+ (class file version 55.0)

### Zscaler Compatibility
The raw.githubusercontent.com download is a standard HTTPS file transfer (not a streaming/chunked download like GHCR container pulls or Rust-based tools). Based on the explanation.txt notes, curl-based downloads to GitHub work through Zscaler. The macOS System Keychain trusts the Zscaler cert, so curl uses the system trust chain.

### Recommended curl Command
```bash
JAR_DIR="$HOME/.local/share/nvim/apex-ls"
JAR_PATH="$JAR_DIR/apex-jorje-lsp.jar"
JAR_URL="https://raw.githubusercontent.com/forcedotcom/salesforcedx-vscode/develop/packages/salesforcedx-vscode-apex/out/apex-jorje-lsp.jar"

mkdir -p "$JAR_DIR"
echo "[bootstrap] Downloading apex-jorje-lsp.jar from Salesforce VS Code extension repo..."
if curl -fSL --retry 3 --retry-delay 2 -o "$JAR_PATH" "$JAR_URL"; then
  echo "[bootstrap] JAR downloaded successfully to $JAR_PATH"
else
  echo "[bootstrap] FAILED to download JAR automatically."
  echo "[bootstrap] Manual download instructions:"
  echo "  1. Visit: https://github.com/forcedotcom/salesforcedx-vscode/blob/develop/packages/salesforcedx-vscode-apex/out/apex-jorje-lsp.jar"
  echo "  2. Click 'Download raw file'"
  echo "  3. Save to: $JAR_PATH"
  echo "  Then re-run: chezmoi apply"
fi
```

### chezmoi.toml Configuration (run after JAR download)
The bootstrap script must create/update `~/.config/chezmoi/chezmoi.toml` with the JAR path so that the `.lua.tmpl` template renders correctly.

---

## Treesitter Parser Availability

| Parser | Name | Source | In nvim-treesitter main? | Confidence |
|--------|------|--------|--------------------------|------------|
| Apex | `apex` | aheber/tree-sitter-sfapex | YES (maintained by @aheber, @xixiaofinland) | HIGH |
| SOQL | `soql` | aheber/tree-sitter-sfapex | YES (last updated 2025-02-12) | HIGH |
| SOSL | `sosl` | aheber/tree-sitter-sfapex | YES (last updated 2025-02-12) | HIGH |
| SFLog | `sflog` | aheber/tree-sitter-sfapex | UNCERTAIN — not confirmed in SUPPORTED_LANGUAGES.md | LOW |
| JavaScript | `javascript` | standard | YES — LazyVim default | HIGH |
| TypeScript | `typescript` | standard | YES — LazyVim default | HIGH |
| TSX | `tsx` | standard | YES — LazyVim default | HIGH |
| HTML | `html` | standard | YES — LazyVim default | HIGH |
| CSS | `css` | standard | YES — needs explicit addition | HIGH |
| XML | `xml` | tree-sitter-grammars | YES — LazyVim default | HIGH |
| Bash | `bash` | standard | YES — LazyVim default | HIGH |
| Lua | `lua` | standard | YES — LazyVim default | HIGH |
| Python | `python` | standard | YES — LazyVim default | HIGH |
| JSON | `json` | standard | YES — LazyVim default | HIGH |
| YAML | `yaml` | standard | YES — LazyVim default | HIGH |
| Go | `go` | standard | YES — needs explicit addition | HIGH |
| C# | `c_sharp` | standard | YES — needs explicit addition | HIGH |
| Bicep | `bicep` | standard | YES — needs explicit addition | MEDIUM |
| Terraform | `terraform` | standard | YES — needs explicit addition | HIGH |
| Vim | `vim` | standard | YES — LazyVim default | HIGH |
| Vimdoc | `vimdoc` | standard | YES — LazyVim default | HIGH |

**sflog note:** The sflog parser exists in aheber/tree-sitter-sfapex and sf.nvim docs mention it as a requirement, but it was not confirmed in nvim-treesitter's SUPPORTED_LANGUAGES.md. Include `"sflog"` in ensure_installed; `:TSInstall` will fail silently if unavailable. Treat as optional enhancement.

---

## Bootstrap Script Structure

The bootstrap script (`run_bootstrap.sh` in chezmoi source) handles one-command machine setup.

### Execution Order
1. **Install chezmoi binary** — `sh -c "$(curl -fsLS get.chezmoi.io)" -- -b $HOME/.local/bin`
2. **Clone repo and init chezmoi** — handled by chezmoi init from GitHub username
3. **Prompt for machine-specific values** — ask for apex JAR path (or auto-detect)
4. **Write chezmoi.toml** — create `~/.config/chezmoi/chezmoi.toml` with `[data]` section
5. **Download apex JAR** — curl from raw.githubusercontent.com with fallback instructions
6. **Run `chezmoi apply`** — applies all dotfiles from source to target

### chezmoi run_once vs run_onchange
- `run_once_` prefix: runs once per machine (use for bootstrap dependencies)
- `run_onchange_` prefix: re-runs when file content changes (use for JAR updates)

The bootstrap file should be named `run_once_bootstrap.sh` or kept as a standalone invocation script outside chezmoi.

### One-Liner for New Machine (after repo is published to GitHub)
```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply santiagobermudezparra/DotfilesManagerMac
```
This installs chezmoi and applies the dotfiles. The bootstrap script handles the JAR download separately.

---

## sf.nvim Architecture Notes

- sf.nvim has a **built-in terminal (SFTerm)** — it does NOT require toggleterm.nvim as a dependency
- toggleterm.nvim is an independent addition for general-purpose terminal windows (valid to have both)
- sf.nvim activates **only when the current path contains a Salesforce project** (`.forceignore` or `sfdx-project.json`)
- Default hotkeys are **disabled by default** — must set `enable_hotkeys = true` or define custom keymaps
- Requires sf CLI v2 (`sf` command, not `sfdx`) and Neovim v0.11+
- fzf-lua is an optional dependency for metadata listing — not required for core functionality
- The `<leader><leader>` toggle terminal shortcut conflicts with many configs — map explicitly

---

## Common Pitfalls

### Pitfall 1: DIAG-01 Requirement Conflict
**What goes wrong:** REQUIREMENTS.md DIAG-01 says "trouble.nvim (or equivalent) provides diagnostic list UI." CONTEXT.md D-10 says "No dedicated diagnostic UI (trouble.nvim omitted) — use inline LSP hover only." These conflict.
**Why it happens:** Requirements were drafted before the final decisions were locked.
**How to avoid:** The CONTEXT.md locked decision (D-10) overrides REQUIREMENTS.md. Do NOT add trouble.nvim. The planner should note this conflict and resolve it in favor of D-10.
**Warning signs:** If trouble.nvim appears in a plan task, it should be removed.

### Pitfall 2: LazyVim TypeScript Extra vs ts_ls Requirement
**What goes wrong:** If you enable `:LazyExtras lang.typescript`, it installs vtsls and disables ts_ls. The requirement is ts_ls.
**Why it happens:** LazyVim switched the TypeScript extra default to vtsls as of late 2024.
**How to avoid:** Do NOT enable `lang.typescript` extra. Configure ts_ls directly in `lua/plugins/lsp.lua` via nvim-lspconfig.
**Warning signs:** If Mason installs `vscode-langservers-extracted` and vtsls appears in `:LspInfo`, the extra was enabled.

### Pitfall 3: apex_ls Filetype Registration
**What goes wrong:** Neovim may not recognize `.cls` and `.trigger` files as `apexcode` filetype, preventing apex_ls from attaching.
**Why it happens:** Neovim has no built-in filetype detection for Apex.
**How to avoid:** Add filetype detection to `lua/config/options.lua` or a filetype plugin:
```lua
vim.filetype.add({
  extension = {
    cls = "apexcode",
    trigger = "apexcode",
    apex = "apexcode",
  },
})
```
**Warning signs:** apex_ls not attaching to `.cls` files; `:set ft?` shows `ft=` (empty).

### Pitfall 4: chezmoi Template File Not Processed
**What goes wrong:** The `apex_ls.lua.tmpl` renders with literal `{{ .apexJarPath }}` instead of the actual path.
**Why it happens:** The file wasn't added to chezmoi with template handling, or `chezmoi.toml` is missing the `[data]` section on the target machine.
**How to avoid:** Verify with `chezmoi cat ~/.config/nvim/lua/plugins/apex_ls.lua` before running Neovim. The chezmoi.toml must exist at `~/.config/chezmoi/chezmoi.toml` with `[data] apexJarPath = "..."`.
**Warning signs:** apex_ls config starts Neovim but JAR path shows as literal template syntax.

### Pitfall 5: Mason Cannot Install apex_ls
**What goes wrong:** Adding `apex_ls` to Mason's `ensure_installed` causes an error — Mason has no package named `apex_ls`.
**Why it happens:** apex_ls is a Java-based LSP server distributed as a JAR, not a typical npm/pip/cargo package.
**How to avoid:** Do NOT add `apex_ls` to Mason's `ensure_installed`. Manage it separately via the bootstrap curl download.
**Warning signs:** Mason error "Unknown package: apex_ls" on startup.

### Pitfall 6: blink.cmp V2 API Breaking Change
**What goes wrong:** blink.cmp v1.x config syntax breaks with V2.
**Why it happens:** V2 development has begun; it requires separate `blink.lib` dependency.
**How to avoid:** Pin to v1 in lazy.nvim: `version = "1.*"` or `branch = "v1"`. This is the current stable recommendation per blink.cmp docs (March 2026).
**Warning signs:** Error about missing `blink.lib` module on startup.

### Pitfall 7: Zscaler and raw.githubusercontent.com
**What goes wrong:** curl download of apex JAR fails with SSL certificate error.
**Why it happens:** Zscaler intercepts HTTPS. System Keychain must trust the Zscaler cert.
**How to avoid:** Do NOT pass `-k` (skip SSL verification) to curl. The macOS System Keychain already trusts the Zscaler cert per the explanation.txt notes. Use `curl -fSL` without SSL bypasses. If it fails, the fallback instructions guide manual download.
**Warning signs:** `curl: (60) SSL certificate problem`. If this occurs, check `security find-certificate -a -p /Library/Keychains/System.keychain` for the Zscaler cert.

### Pitfall 8: eslint-lsp vs EslintFixAll on save
**What goes wrong:** ESLint floods diagnostics on every keystroke or the `EslintFixAll` command auto-applies unsafe fixes.
**Why it happens:** eslint-lsp by default runs on file change (after save), not on every keystroke. The `EslintFixAll` command in `on_attach` applies all fixes including potentially unsafe ones.
**How to avoid:** Only bind `EslintFixAll` to `BufWritePre` if safe fixes are acceptable. Otherwise, let eslint-lsp provide diagnostics only and let the developer apply fixes manually. Per Claude's discretion, this is a configuration choice.
**Warning signs:** Unexpected code changes on save that weren't requested.

---

## Code Examples

### blink.cmp LazyVim Integration (pin to v1)
```lua
-- Source: https://www.lazyvim.org/extras/coding/blink and blink.cmp v1 docs
-- In lazy.nvim extras via :LazyExtras, or explicit spec:
{
  "saghen/blink.cmp",
  version = "1.*",  -- pin to v1 stable, not V2 (which needs blink.lib)
  opts = {
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },
  },
}
```

### chezmoi Bootstrap One-Liner
```bash
# Source: https://www.chezmoi.io/install/
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply $GITHUB_USERNAME
# Or with explicit repo:
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply git@github.com:USERNAME/REPO.git
```

### Mason ensure_installed (correct list — no apex_ls)
```lua
-- Source: mason.nvim docs
{
  "williamboman/mason.nvim",
  opts = {
    ensure_installed = {
      "typescript-language-server",  -- ts_ls
      "yaml-language-server",
      "json-lsp",
      "bash-language-server",
      "marksman",
      "eslint-lsp",
      "prettier",
      -- apex_ls is NOT here — managed by bootstrap curl download
    },
  },
},
```

### apex_ls via vim.lsp.config (Neovim 0.11+ pattern)
```lua
-- Source: Neovim 0.11 lsp/ directory pattern
-- This can go in dot_config/nvim/lsp/apex_ls.lua.tmpl
return {
  cmd = {
    "java",
    "-cp", "{{ .apexJarPath }}",
    "-Ddebug.internal.errors=true",
    "-Ddebug.semantic.errors=true",
    "-Dlwc.typegeneration.disabled=true",
    "apex.jorje.lsp.ApexLanguageServerLauncher",
  },
  filetypes = { "apexcode" },
  root_dir = function(fname)
    return vim.fs.dirname(vim.fs.find("sfdx-project.json", { path = fname, upward = true })[1])
  end,
}
```

---

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| tsserver (nvim-lspconfig) | ts_ls (same binary, renamed) | 2023 | Config key must be `ts_ls`, not `tsserver` |
| LazyVim TypeScript extra → ts_ls | LazyVim TypeScript extra → vtsls | 2024 | Must bypass LazyVim's TypeScript extra to use ts_ls |
| nvim-cmp | blink.cmp | 2024-2025 | LazyVim migrated; blink has built-in sources |
| null-ls | conform.nvim | 2023 | null-ls archived; conform.nvim is the standard |
| LazyVim Neovim extras via config | `:LazyExtras` interactive UI | 2024 | Easier to enable/disable extras |
| nvim-lspconfig `setup{}` | Neovim 0.11 `vim.lsp.config()` | 2025 | Native LSP config without nvim-lspconfig |

**Deprecated/outdated:**
- `tsserver` key in nvim-lspconfig: renamed to `ts_ls` — using `tsserver` silently fails
- `null-ls`: archived, unmaintained — use conform.nvim for formatting, nvim-lint or eslint-lsp for linting
- `nvim-cmp`: not broken but superseded by blink.cmp in modern configs

---

## Open Questions

1. **sflog parser availability in nvim-treesitter**
   - What we know: sflog exists in aheber/tree-sitter-sfapex; sf.nvim mentions it; apex parser is confirmed in nvim-treesitter
   - What's unclear: Whether `:TSInstall sflog` works without custom parser registration
   - Recommendation: Include `"sflog"` in ensure_installed; if it fails, sf.nvim will still function. Validate during implementation with `:TSInstallInfo`.

2. **toggleterm.nvim requirement (D-15 vs sf.nvim built-in SFTerm)**
   - What we know: sf.nvim has its own SFTerm terminal (read-only, for sf CLI output); toggleterm.nvim provides general-purpose floating terminals
   - What's unclear: Whether the user wants toggleterm.nvim for non-Salesforce use cases or purely for sf CLI
   - Recommendation: Install toggleterm.nvim as specified in D-15 and wire sf.nvim to use its terminal mode, keeping toggleterm.nvim available for general `<leader>t` style terminal splits.

3. **DIAG-01 conflict resolution**
   - What we know: REQUIREMENTS.md says add trouble.nvim; CONTEXT.md D-10 says omit it
   - What's unclear: Was the requirement intended to be satisfied by basic `vim.diagnostic` hover, or was it a mistake?
   - Recommendation: D-10 wins (locked decision). Plan should include a note to the user that DIAG-01 is marked as resolved by inline LSP hover (not trouble.nvim) per D-10.

---

## Validation Architecture

### Test Framework
| Property | Value |
|----------|-------|
| Framework | Manual / scripted validation (no automated Neovim test framework in scope) |
| Config file | None — manual `:checkhealth` and startup validation |
| Quick run command | `nvim --headless -c "checkhealth" -c "qa"` |
| Full suite command | Launch Neovim and inspect `:LspInfo`, `:TSModuleInfo`, `:ConformInfo`, `:Mason` |

### Phase Requirements → Test Map
| Req ID | Behavior | Test Type | Automated Command | File Exists? |
|--------|----------|-----------|-------------------|-------------|
| DFM-01 | chezmoi installable via curl | smoke | `chezmoi --version` after bootstrap | Wave 0 |
| DFM-05 | Bootstrap applies dotfiles | smoke | `ls ~/.config/nvim/init.lua` | Wave 0 |
| NVIM-01 | LazyVim loads | smoke | `nvim --headless -c "lua require('lazy').sync()" -c "qa"` | Wave 0 |
| NVIM-02 | gruvbox-material applies | manual | Open nvim, check colorscheme | manual-only |
| LSP-01 | Mason installs servers | manual | `:Mason` → all servers green | manual-only |
| LSP-02 | ts_ls attaches to TS files | manual | Open `.ts` file → `:LspInfo` shows ts_ls | manual-only |
| LSP-03 | apex_ls attaches to .cls files | manual | Open `.cls` file → `:LspInfo` shows apex_ls | manual-only |
| TS-01 | apex/soql/sosl parsers | manual | `:TSInstall apex soql sosl` then `:TSModuleInfo` | manual-only |
| SF-01 | sf.nvim loads in SF project | manual | `cd sfdx-project && nvim` → `:SF` commands available | manual-only |
| FMT-01 | Prettier formats on save | manual | Open `.ts` file, add trailing space, `:w` | manual-only |
| DIAG-01 | Inline diagnostics visible | manual | Open broken TS file → hover diagnostic | manual-only |

### Sampling Rate
- **Per task commit:** `nvim --headless -c "lua require('lazy').health()" -c "qa" 2>&1 | head -20` to confirm no startup errors
- **Per wave merge:** Full manual validation — open Neovim, check `:checkhealth`, `:LspInfo`, `:TSModuleInfo`
- **Phase gate:** All LSP servers green in `:LspInfo`, all required parsers in `:TSModuleInfo`, format-on-save working on a `.ts` file

### Wave 0 Gaps
- [ ] `run_bootstrap.sh` — does not exist yet; needed before chezmoi apply works
- [ ] `~/.config/chezmoi/chezmoi.toml` — must be created on target machine with `apexJarPath`
- [ ] `dot_config/nvim/init.lua` — LazyVim bootstrap; start from LazyVim starter template

*(No automated test framework gaps — validation is manual for Neovim UI behaviors)*

---

## Sources

### Primary (HIGH confidence)
- [LazyVim plugin configuration docs](https://www.lazyvim.org/configuration/plugins) — plugin spec format, opts merging, list extension
- [LazyVim treesitter plugin docs](https://www.lazyvim.org/plugins/treesitter) — default ensure_installed, opts_extend pattern
- [LazyVim blink.cmp extra](http://www.lazyvim.org/extras/coding/blink) — default sources, configuration
- [LazyVim TypeScript extra](http://www.lazyvim.org/extras/lang/typescript) — vtsls default, ts_ls conflict
- [blink.cmp GitHub](https://github.com/Saghen/blink.cmp) — v1.10.1, V2 branch status, source configuration
- [sf.nvim GitHub](https://github.com/xixiaofinland/sf.nvim) — Neovim 0.11 requirement, built-in SFTerm, commands
- [conform.nvim GitHub](https://github.com/stevearc/conform.nvim) — format_on_save, formatters_by_ft, Neovim 0.10+ requirement
- [b0o/SchemaStore.nvim GitHub](https://github.com/b0o/SchemaStore.nvim) — jsonls and yamlls setup patterns
- [nvim-lspconfig apex_ls config](https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/configs/apex_ls.lua) — cmd, filetypes, settings
- [chezmoi install docs](https://www.chezmoi.io/install/) — curl one-liner, init --apply pattern
- [chezmoi machine differences docs](https://www.chezmoi.io/user-guide/manage-machine-to-machine-differences/) — .tmpl syntax, chezmoi.toml [data] section
- [aheber/tree-sitter-sfapex GitHub](https://github.com/aheber/tree-sitter-sfapex) — apex/soql/sosl parser names, nvim-treesitter integration
- [nvim-treesitter SUPPORTED_LANGUAGES.md](https://github.com/nvim-treesitter/nvim-treesitter/blob/main/SUPPORTED_LANGUAGES.md) — confirmed apex/xml in main; soql/sosl per community reports

### Secondary (MEDIUM confidence)
- [salesforcedx-vscode repo — apex-jorje-lsp.jar location](https://github.com/forcedotcom/salesforcedx-vscode/blob/develop/packages/salesforcedx-vscode-apex/out/apex-jorje-lsp.jar) — verified path; raw download URL inferred from standard GitHub pattern
- [Java 11 requirement for apex_ls](https://github.com/forcedotcom/salesforcedx-vscode/issues/5046) — confirmed from issue discussion

### Tertiary (LOW confidence)
- sflog parser in nvim-treesitter main — reported by community but not confirmed in SUPPORTED_LANGUAGES.md

---

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH — all verified via official GitHub repos and docs
- Architecture patterns: HIGH — LazyVim conventions verified, chezmoi template syntax verified
- apex_ls JAR download: MEDIUM — URL structure inferred from GitHub raw content convention; file size estimated from historical data
- Treesitter Salesforce parsers: HIGH for apex; HIGH for soql/sosl (community-confirmed in nvim-treesitter main); LOW for sflog
- Bootstrap strategy: HIGH — chezmoi one-liner verified from official docs

**Research date:** 2026-03-27
**Valid until:** 2026-04-27 (stable ecosystem; blink.cmp V2 could introduce breaking changes)
