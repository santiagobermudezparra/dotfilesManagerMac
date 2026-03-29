#!/usr/bin/env bash
# nvim-sync.sh — Run after pulling dotfile changes to sync Neovim plugins
# Usage: bash nvim-sync.sh

set -euo pipefail

echo "==> Applying chezmoi changes..."
chezmoi apply

echo "==> Syncing Neovim plugins (this may take 30-60s on first run)..."
nvim --headless -c "lua require('lazy').sync()" -c "qa" 2>&1 | tail -5

echo ""
echo "Done. Open nvim and run :checkhealth to verify."
