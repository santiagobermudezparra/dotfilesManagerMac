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
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin
```

This downloads and installs chezmoi to `~/.local/bin/chezmoi`.

Add `~/.local/bin` to your PATH if it's not already there:

```bash
export PATH="$HOME/.local/bin:$PATH"
# Add this line to your ~/.zshrc or ~/.bash_profile to make it permanent
```

#### Step 2: Clone and initialize your dotfiles

```bash
chezmoi init santiagobermudezparra/DotfilesManagerMac
```

This clones the repo to `~/.local/share/chezmoi` but **does not yet apply** the configs.

#### Step 3: Create chezmoi config with JAR path

Create the chezmoi config file (this is where the TTY issue is solved):

```bash
mkdir -p ~/.config/chezmoi
cat > ~/.config/chezmoi/chezmoi.toml << 'EOF'
[data]
# IMPORTANT: Ensure this path is wrapped in double quotes
apexJarPath = "/Users/santiagobermudez/.local/share/nvim/apex-ls/apex-jorje-lsp.jar"
EOF
```

> **Note:** The path **must** be wrapped in double quotes. If you are editing the `.chezmoi.toml.tmpl` file directly, ensure the template expression is also quoted:
> ```
> apexJarPath = "{{ .apexJarPath }}"
> ```
> Without the surrounding quotes, chezmoi renders an unquoted string which is invalid TOML and causes the error `map has no entry for key "apexJarPath"`.

Or if you already have the Apex JAR downloaded elsewhere, point to that path:

```bash
cat > ~/.config/chezmoi/chezmoi.toml << 'EOF'
[data]
# IMPORTANT: Ensure this path is wrapped in double quotes
apexJarPath = "/path/to/your/apex-jorje-lsp.jar"
EOF
```

#### Step 4: Apply the configuration

```bash
chezmoi apply
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

The Apex LSP JAR must be downloaded separately. The bootstrap script attempts to download it automatically, but **if it fails** (empty directory, network timeout, broken link), download it manually:

```bash
# Step 1: Ensure the target directory exists
mkdir -p ~/.local/share/nvim/apex-ls/

# Step 2: Navigate there
cd ~/.local/share/nvim/apex-ls/

# Step 3: Download the JAR from Salesforce's official source
curl -L -o apex-jorje-lsp.jar \
  https://github.com/forcedotcom/salesforcedx-vscode/raw/main/packages/salesforcedx-vscode-apex/out/apex-jorje-lsp.jar

# Step 4: Verify it downloaded correctly (should be several MB)
ls -lh apex-jorje-lsp.jar
```

> **Why this URL?** The `salesforcedx-vscode` repository is the canonical source for `apex-jorje-lsp.jar`. The GitHub releases URL used in earlier versions of the bootstrap script may return a 404 or an outdated version.

**Or** use the convenient bootstrap (if it works on your network):

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
# IMPORTANT: Ensure this path is wrapped in double quotes
apexJarPath = "/Users/santiagobermudez/.local/share/nvim/apex-ls/apex-jorje-lsp.jar"
```

These values are interpolated into `apex_ls.lua.tmpl` when you run `chezmoi apply`.

> **Template note:** In `.chezmoi.toml.tmpl`, the variable must be wrapped in quotes to remain valid TOML:
> ```
> apexJarPath = "{{ promptStringOnce . "apexJarPath" "Path to apex-jorje-lsp.jar" }}"
> ```
> Without the surrounding quotes, the rendered TOML is invalid and chezmoi will fail with a key-not-found error.

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

### Quick Lookup: Common Setup Failures

| Error Message | Likely Cause | Solution |
|---------------|--------------|----------|
| `chezmoi: command not found` | chezmoi not in PATH | Add `~/.local/bin` to PATH: `export PATH="$HOME/.local/bin:$PATH"` |
| `map has no entry for key "apexJarPath"` | Missing or unquoted config value | Create `~/.config/chezmoi/chezmoi.toml` with quoted path (see Step 3) |
| `curl: (60) SSL certificate problem` | Zscaler/corporate proxy blocking | Add Zscaler cert to System Keychain (see Network-Restricted Setups below) |
| `apex-jorje-lsp.jar not found` | JAR download failed silently | Download manually (see Apex Language Server JAR section) |
| `Cannot make changes, 'modifiable' is off` | sf.nvim buffer error | Use fixed sf.nvim wrapper in config (see sf.nvim error section below) |
| `Error: File not in a sf project folder` | Not in Salesforce project | Ensure project has `sfdx-project.json` or `.forceignore` in root |

---

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

**Most common cause:** The JAR file was never downloaded — the `~/.local/share/nvim/apex-ls/` directory exists but is empty. This happens when the bootstrap script creates the folder but fails to fetch the file (network timeout, broken link, etc.).

**Fix — download the JAR manually:**

```bash
mkdir -p ~/.local/share/nvim/apex-ls/
cd ~/.local/share/nvim/apex-ls/

# Download from the canonical Salesforce VS Code extension source
curl -L -o apex-jorje-lsp.jar \
  https://github.com/forcedotcom/salesforcedx-vscode/raw/main/packages/salesforcedx-vscode-apex/out/apex-jorje-lsp.jar

# Verify (should be several MB)
ls -lh apex-jorje-lsp.jar
```

Then confirm your chezmoi config points to the right path and reapply:

```bash
cat ~/.config/chezmoi/chezmoi.toml
# Should show: apexJarPath = "/Users/YOU/.local/share/nvim/apex-ls/apex-jorje-lsp.jar"

chezmoi apply
```

**Second possible cause:** The TOML value is missing quotes. Open `~/.config/chezmoi/chezmoi.toml` and confirm the path is surrounded by double quotes:

```toml
[data]
apexJarPath = "/Users/YOU/.local/share/nvim/apex-ls/apex-jorje-lsp.jar"
#             ^                                                           ^
#             Must have opening and closing double quotes
```

### Network-Restricted Setups (Zscaler, Corporate Proxy, SSL Interception)

**Symptom:** curl fails with `SSL certificate problem` or `certificate verify failed`

**Why:** Corporate networks (Zscaler, proxies, SSL inspection) intercept HTTPS traffic and require additional certificates.

**Solution:**

#### Step 1: Trust Zscaler Root Cert on macOS

1. **Download the Zscaler root cert:**
   - Contact your IT department or download from your Zscaler admin portal
   - Usually named `ZscalerRootCert.cer` or similar

2. **Add to macOS System Keychain:**
   - Open Keychain Access: `Cmd+Space` → "Keychain Access"
   - Drag the cert into Keychain Access, or go to File → Import Items
   - Select the cert in the System keychain
   - Double-click it, expand the "Trust" section
   - Set "When using this certificate" → "Always Trust"
   - Enter your Mac password to confirm

3. **Verify:** Test curl
   ```bash
   curl -I https://github.com
   # Should return HTTP/2 200 OK, not a certificate error
   ```

#### Step 2: Configure Git Proxy (if behind corporate proxy)

```bash
git config --global http.proxy http://proxy.company.com:8080
git config --global https.proxy https://proxy.company.com:8080

# If using Zscaler with auth, include credentials:
# git config --global http.proxy http://username:password@proxy.company.com:8080
```

#### Step 3: Bootstrap with Environment Variables (if still failing)

If automatic download fails, use environment variables for offline setup:

```bash
# Download JAR manually on a machine with network access, then:
export APEX_JAR_PATH="/path/to/apex-jorje-lsp.jar"
chezmoi apply
```

#### Step 4: Check Bootstrap Logs

The bootstrap script logs all details to `~/.local/share/dotfiles-bootstrap.log`:

```bash
cat ~/.local/share/dotfiles-bootstrap.log | grep ERROR
# Shows exact failure point (network timeout, certificate error, etc.)
```

The bootstrap script uses robust error detection (no `-k` bypass) and trusts the system cert chain.

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

### sf.nvim "modifiable is off" error

**Error:** `Error executing lua: vim/_editor.lua:0: Vim:E21: Cannot make changes, 'modifiable' is off`

**When:** Running sf.nvim commands (`<leader>sl`, `<leader>sp`, etc.) in a read-only or special buffer (help, preview, etc.)

**Why:** sf.nvim's error handler tries to display messages in the current buffer, which may be non-modifiable (read-only files, help buffers, preview panes, etc.).

**Fix:** Our config wraps sf.nvim commands with a buffer safety check that:
1. Saves the current buffer's modifiable state
2. Temporarily makes it modifiable for error messages
3. Restores the original state afterward

**If error persists:**
- Ensure you're in a modifiable buffer: `:set modifiable`
- Or open a new file/buffer before running sf commands
- Check that your Salesforce project has `sfdx-project.json` or `.forceignore` in the root

**Technical details:** See `.planning/DEBUG_SF_NVIM.md` for root cause analysis.

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
# The script only downloads chezmoi, doesn't run it in the subshell

# ✅ Fixed by splitting into steps:
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin  # Step 1: Install to PATH
chezmoi init santiagobermudezparra/DotfilesManagerMac   # Step 2: Clone
```

### Problem 2: chezmoi init clones the repo but doesn't fetch commits

```bash
# The repo was initialized but had no commits
cd ~/.local/share/chezmoi && git pull origin main

# Now the files exist
ls dot_config/nvim/
```

### Problem 3: chezmoi apply fails because apexJarPath is missing or unquoted

```bash
# ❌ Error: "map has no entry for key "apexJarPath""
# The `.chezmoi.toml.tmpl` file tries to render {{ .apexJarPath }}
# but the config file doesn't exist yet — OR — the value exists but
# is missing surrounding double quotes, making it invalid TOML.

# ✅ Fixed by creating the config file manually with proper quoting:
mkdir -p ~/.config/chezmoi
cat > ~/.config/chezmoi/chezmoi.toml << 'EOF'
[data]
apexJarPath = "/Users/santiagobermudez/.local/share/nvim/apex-ls/apex-jorje-lsp.jar"
EOF

# KEY LESSON: The path value MUST be wrapped in double quotes.
# apexJarPath = /some/path     ← invalid TOML, causes key-not-found errors
# apexJarPath = "/some/path"   ← valid TOML ✅

# In the .chezmoi.toml.tmpl source file, the template expression must
# also be quoted so the rendered output is valid:
# apexJarPath = "{{ .apexJarPath }}"   ← correct ✅
# apexJarPath = {{ .apexJarPath }}     ← renders unquoted, broken ❌

# Now chezmoi apply works
chezmoi apply
```

### Problem 4: The chezmoi init prompt can't open TTY in CI/headless mode

```bash
# ❌ Error: "could not open a new TTY: open /dev/tty: device not configured"
# The `.chezmoi.toml.tmpl` uses promptStringOnce which requires user input
# This fails in non-interactive shells

# ✅ Fixed by creating the config file before running init
# (See Problem 3 above)
```

### Problem 5: The Apex JAR directory exists but is empty

```bash
# ❌ Symptom: ~/.local/share/nvim/apex-ls/ exists but no .jar inside
# The bootstrap script created the folder but the download failed silently
# (broken URL, network timeout, or Zscaler blocking the request)

# ✅ Fixed by downloading from the canonical source manually:
cd ~/.local/share/nvim/apex-ls/
curl -L -o apex-jorje-lsp.jar \
  https://github.com/forcedotcom/salesforcedx-vscode/raw/main/packages/salesforcedx-vscode-apex/out/apex-jorje-lsp.jar

ls -lh apex-jorje-lsp.jar  # Verify: should be several MB
```

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
