# DotfilesManagerMac

A corporate Mac Neovim setup using **chezmoi**, designed for restricted network environments with Salesforce CLI + Node.js development support.

## Quick Start

### Fresh Machine Setup (One-liner)

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply santiagobermudezparra/DotfilesManagerMac
```

This command:
1. **Installs chezmoi** to `~/.local/bin/chezmoi`
2. **Clones this repo** to `~/.local/share/chezmoi`
3. **Prompts for `apexJarPath`** — the path to your Apex Language Server JAR (see Prerequisites)
4. **Deploys all configs** to `~/.config/nvim/`
5. **Runs bootstrap script** to download the Apex LSP JAR (if curl succeeds)

After the script completes, open Neovim:

```bash
nvim
```

Neovim will auto-install LazyVim and all plugins on first launch. This may take 30–60 seconds.

---

## Prerequisites

Before running the one-liner, ensure your machine has:

- **macOS 11+** (tested on Sonoma/Sequoia)
- **Internet access** (or manual JAR download; see below)
- **curl** (usually pre-installed; required for chezmoi install and JAR download)
- **Zscaler** (if on corporate network) — macOS System Keychain must trust Zscaler's cert

### Required Tools (Auto-installed by chezmoi bootstrap)

After initial `chezmoi apply`, the bootstrap script will check for:

- **Neovim** (v0.11+) — required; install via `brew install neovim` or [download](https://github.com/neovim/neovim/releases)
- **Java 11+** — required for Apex LSP; install via `brew install openjdk@11`
- **Salesforce CLI** (`sf` command) — optional; install via `npm install --global @salesforce/cli` or `brew install salesforce-cli`
- **Node.js + npm** — optional; required for TypeScript/JavaScript development; use `mise` or `nvm` to manage versions

### Apex Language Server JAR

The Apex LSP JAR must be downloaded separately. The bootstrap script attempts to download it automatically, but you can also download manually:

```bash
# Download apex-jorje-lsp.jar from GitHub releases
curl -L https://github.com/forcedotcom/apex-jorje-lsp/releases/download/v[VERSION]/apex-jorje-lsp.jar \
  -o ~/apex-jorje-lsp.jar
```

**Or** use the convenient bootstrap:

```bash
bash run_once_bootstrap.sh
```

The bootstrap script will:
1. Download the latest Apex LSP JAR from GitHub
2. Store it at the path specified in `chezmoi.toml` (under `apexJarPath`)
3. Print fallback instructions if the download fails
4. Verify all required tools (nvim, sf, java, node)

---

## Configuration

### Machine-Specific Values

The following values are **NOT committed** to git — they're stored in `~/.config/chezmoi/chezmoi.toml` using chezmoi's `promptStringOnce`:

```toml
[data]
apexJarPath = "/path/to/apex-jorje-lsp.jar"
```

These values are interpolated into `apex_ls.lua.tmpl` when you run `chezmoi apply`.

### Updating the Config

If you modify files in the deployed config (`~/.config/nvim/`), chezmoi will detect the changes:

```bash
chezmoi diff
chezmoi apply
```

Or push changes back to the repo:

```bash
cd ~/.local/share/chezmoi
git add dot_config/nvim/...
git commit -m "..."
git push
```

---

## What's Included

### Editor (LazyVim)

- **colorscheme:** gruvbox-material (warm, material foreground)
- **completion:** blink.cmp v1.* with LSP, path, snippet, and buffer sources
- **file explorer:** nvim-tree (toggle: `<leader>e`)
- **fuzzy finder:** telescope (search: `<leader>ff`, symbols: `<leader>fs`)
- **custom keymaps:** scroll centering (`<C-d>`, `<C-u>`), symbol search

### LSP Servers (via Mason)

Automatically installed on first Neovim launch:

| Language | Server | Treesitter Parser |
|----------|--------|-------------------|
| TypeScript/JavaScript | `ts_ls` | javascript, typescript, tsx, jsx |
| JSON | `jsonls` + SchemaStore | json |
| YAML | `yamlls` + SchemaStore | yaml |
| Bash | `bash-language-server` | bash |
| Markdown | `marksman` | markdown |
| Apex | `apex_ls` (JAR-based) | apex, soql, sosl |

### Formatting

- **JavaScript/TypeScript:** prettier (format-on-save)
- **JSON/CSS/HTML:** prettier (via conform.nvim)
- **Apex:** No formatter (none exists; inline diagnostics only)

### Salesforce Development

- **sf.nvim:** 6 keymaps for Salesforce CLI
  - `<leader>sp` — org push
  - `<leader>sr` — org retrieve
  - `<leader>sta` — org test
  - `<leader>stt` — run test
  - `<leader>so` — open org
  - `<leader>sl` — list orgs
- **Apex filetype detection:** `.cls`, `.trigger`, `.apex` → `apexcode`
- **toggleterm:** Floating terminal (`<C-\>`)

### Bootstrap & Deployment

- **`run_once_bootstrap.sh`:** Downloads Apex JAR, verifies tools
- **`.chezmoi.toml.tmpl`:** Prompts for machine-specific JAR path (stored locally, never committed)

---

## Directory Structure

```
DotfilesManagerMac/
├── README.md                              # This file
├── dot_config/                            # Deployed to ~/.config/
│   └── nvim/
│       ├── init.lua                       # Neovim entry point
│       └── lua/
│           ├── config/
│           │   ├── lazy.lua              # LazyVim bootstrap & spec
│           │   ├── options.lua           # Editor options, filetypes
│           │   └── keymaps.lua           # Custom keymaps
│           └── plugins/
│               ├── colorscheme.lua       # gruvbox-material config
│               ├── ui.lua                # nvim-tree, telescope
│               ├── completion.lua        # blink.cmp v1.*
│               ├── treesitter.lua        # Treesitter parsers
│               ├── lsp.lua               # Mason, jsonls, yamlls, etc.
│               ├── typescript.lua        # ts_ls, eslint-lsp
│               ├── formatting.lua        # conform.nvim + prettier
│               ├── salesforce.lua        # sf.nvim, toggleterm
│               └── apex_ls.lua.tmpl      # apex_ls (chezmoi template)
├── run_once_bootstrap.sh                 # Bootstrap script (chezmoi run_once_)
├── .chezmoi.toml.tmpl                    # chezmoi config template (prompts for JAR path)
└── .planning/                            # GSD project planning (not deployed)
```

---

## Troubleshooting

### "command not found: nvim"

Neovim is not installed. After `chezmoi apply`, install it:

```bash
brew install neovim
```

Or download from [neovim.io](https://neovim.io/download/).

Then reopen Neovim:

```bash
nvim
```

### "cannot find java" (Apex LSP won't start)

Java 11+ is required for the Apex Language Server:

```bash
brew install openjdk@11
```

### "apexJarPath not set" or apex_ls not starting

The bootstrap script failed to download the JAR. Download manually:

```bash
# Download from GitHub releases
curl -L https://github.com/forcedotcom/apex-jorje-lsp/releases \
  -o ~/apex-jorje-lsp.jar

# Then update chezmoi config
chezmoi edit ~/.config/chezmoi/chezmoi.toml
# Set apexJarPath = "/Users/YOU/apex-jorje-lsp.jar"

# Reapply
chezmoi apply
```

### Zscaler SSL cert errors

If curl fails with certificate errors, macOS System Keychain must trust the Zscaler root cert:

1. Download Zscaler root cert via your company's network
2. Add to System Keychain: `Keychain Access > Add Certificates`
3. Trust the cert for `SSL`
4. Retry the one-liner

The bootstrap script uses `-fSL` (no `-k` bypass) and trusts the system cert chain.

### "lazy.nvim failed to download"

If plugins fail to download on first launch, check your network:

```bash
# Test network
curl -I https://github.com

# If blocked by proxy, configure git
git config --global http.proxy http://proxy:port
git config --global https.proxy https://proxy:port
```

Then retry Neovim startup.

### "ts_ls not found" or TypeScript errors

Mason auto-installs `typescript-language-server` on first `:Mason` open. If it fails:

```bash
:Mason  # Open Mason UI
# Find typescript-language-server, press 'i' to install
```

---

## Development Workflow

### Open a Salesforce Project

```bash
cd /path/to/salesforce/project
nvim

# In Neovim:
# `:SF org list` (via <leader>sl) — list authenticated orgs
# `:SF deploy` (via <leader>sp) — push changes to org
# `:SF retrieve` (via <leader>sr) — pull metadata from org
```

### Open a TypeScript/Node.js Project

```bash
cd /path/to/node/project
nvim

# In Neovim:
# - Type to trigger ts_ls completions
# - `gd` — go to definition
# - `<leader>w` — save and auto-format with prettier
# - ESLint auto-fixes on save
```

### Check Health

```bash
nvim
:checkhealth  # Verify Neovim, LSP, Treesitter status
:Mason        # View installed LSP servers and tools
:LspInfo      # See active LSP clients for current buffer
```

---

## Customization

### Add a New Plugin

Edit `dot_config/nvim/lua/plugins/*.lua`:

```lua
return {
  "plugin/author",
  config = function()
    -- plugin config
  end,
}
```

Then:

```bash
nvim  # lazy.nvim auto-installs
chezmoi add dot_config/nvim/lua/plugins/my_plugin.lua
chezmoi push
```

### Change Colorscheme

Edit `dot_config/nvim/lua/plugins/colorscheme.lua` and set a different colorscheme.

### Add an LSP Server

Add to `dot_config/nvim/lua/plugins/lsp.lua` in the Mason `ensure_installed` list:

```lua
ensure_installed = { ..., "new-lsp-server" },
```

---

## Architecture Notes

- **chezmoi source layout:** `dot_config/` prefix maps to `~/.config/` on the target machine
- **LazyVim extensions:** Plugins in `lua/plugins/` are auto-imported and merged with LazyVim defaults
- **Machine-specific values:** `.tmpl` files (Golang text/template syntax) are rendered by chezmoi at apply time
- **Bootstrap:** `run_once_` prefix ensures bootstrap script runs exactly once per machine
- **LSP separation:** Mason (tool install), nvim-lspconfig (server settings), language-specific files (configs)

---

## Security & Compliance

✅ **DFM-04 Compliance:** No company names, internal hostnames, Salesforce org URLs, or credentials committed to git.

- Machine-specific values (JAR paths, org URLs) use chezmoi templates
- `apexJarPath` stored locally in `~/.config/chezmoi/chezmoi.toml` (not committed)
- Bootstrap script logs to stdout (no credential leakage)

---

## Support

For issues or feedback:

1. Check the **Troubleshooting** section above
2. Run `:checkhealth` in Neovim for LSP/Treesitter diagnostics
3. Check git log for recent changes: `git log --oneline -10`
4. Open an issue on GitHub: [DotfilesManagerMac Issues](https://github.com/santiagobermudezparra/DotfilesManagerMac/issues)

---

## License

MIT — See LICENSE file (if present).

---

**Last updated:** 2026-03-27
**Phase:** 01 — Neovim Setup (Complete)
