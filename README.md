# DotfilesManagerMac

A corporate Mac Neovim setup using **chezmoi**, designed for restricted network environments with Salesforce CLI + Node.js development support.

## Quick Start

### Prerequisites (Install First)

Before setting up, install these tools on a fresh Mac:

```bash
# Install Homebrew (if not already installed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install required tools
brew install neovim         # Neovim v0.11+
brew install openjdk@11    # Java for Apex LSP
# Optional but recommended:
brew install node          # Node.js for TypeScript/JavaScript
```

### Fresh Machine Setup (Step-by-Step)

The setup process has three steps because the one-liner requires TTY input:

#### Step 1: Install chezmoi

```bash
sh -c "$(curl -fsLS get.chezmoi.io)"
```

This installs chezmoi to `./bin/chezmoi` in your current directory.

#### Step 2: Clone and initialize your dotfiles

```bash
./bin/chezmoi init santiagobermudezparra/DotfilesManagerMac
```

This clones the repo to `~/.local/share/chezmoi` but **does not yet apply** the configs.

#### Step 3: Create chezmoi config with JAR path

Create the chezmoi config file (this is where the TTY issue is solved):

```bash
mkdir -p ~/.config/chezmoi
cat > ~/.config/chezmoi/chezmoi.toml << 'EOF'
[data]
apexJarPath = "/Users/$(whoami)/.local/share/nvim/apex-ls/apex-jorje-lsp.jar"
EOF
```

Or if you already have the Apex JAR downloaded elsewhere, point to that path:

```bash
cat > ~/.config/chezmoi/chezmoi.toml << 'EOF'
[data]
apexJarPath = "/path/to/your/apex-jorje-lsp.jar"
EOF
```

#### Step 4: Apply the configuration

```bash
./bin/chezmoi apply
```

This will:
- Deploy Neovim config to `~/.config/nvim/`
- Run the bootstrap script (downloads Apex JAR if needed)
- Verify all prerequisites

#### Step 5: Open Neovim

```bash
nvim
```

On first launch, lazy.nvim will download and install all plugins (~30–60 seconds).
You should see the **gruvbox-material** colorscheme (warm brown/orange tones) once complete.

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

### The one-liner doesn't work ("chezmoi: command not found" or nothing happens)

**Why:** The original one-liner doesn't work because:
1. The chezmoi install script requires TTY input to run `chezmoi init`, but the subshell can't access it
2. The `.chezmoi.toml.tmpl` file requires the `apexJarPath` variable before chezmoi can apply configs

**Solution:** Use the **step-by-step setup** above instead (Steps 1–5).

### "command not found: nvim"

Neovim is not installed. Install it first:

```bash
brew install neovim
```

Or download from [neovim.io](https://neovim.io/download/).

Then try again:

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

## How I Fixed The Setup (Technical Details)

When the one-liner failed, here's exactly what I did to get it working:

### Problem 1: The one-liner installs chezmoi but doesn't run init/apply

```bash
# ❌ This doesn't work:
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply ...
# The script only downloads chezmoi, doesn't run it

# ✅ Fixed by splitting into steps:
sh -c "$(curl -fsLS get.chezmoi.io)"        # Step 1: Install
./bin/chezmoi init santiagobermudezparra... # Step 2: Clone
```

### Problem 2: chezmoi init clones the repo but doesn't fetch commits

```bash
# The repo was initialized but had no commits
cd ~/.local/share/chezmoi && git pull origin main

# Now the files exist
ls dot_config/nvim/
```

### Problem 3: chezmoi apply fails because apexJarPath is missing

```bash
# ❌ Error: "map has no entry for key "apexJarPath""
# The `.chezmoi.toml.tmpl` file tries to render {{ .apexJarPath }}
# but the config file doesn't exist yet

# ✅ Fixed by creating the config file manually:
mkdir -p ~/.config/chezmoi
cat > ~/.config/chezmoi/chezmoi.toml << 'EOF'
[data]
apexJarPath = "/Users/YOU/.local/share/nvim/apex-ls/apex-jorje-lsp.jar"
EOF

# Now chezmoi apply works
./bin/chezmoi apply
```

### Problem 4: The chezmoi init prompt can't open TTY in CI/headless mode

```bash
# ❌ Error: "could not open a new TTY: open /dev/tty: device not configured"
# The `.chezmoi.toml.tmpl` uses promptStringOnce which requires user input
# This fails in non-interactive shells

# ✅ Fixed by creating the config file before running init
# (See Problem 3 above)
```

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
