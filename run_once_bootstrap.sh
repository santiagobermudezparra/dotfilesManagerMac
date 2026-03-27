#!/bin/bash
# Bootstrap script for DotfilesManagerMac
# Runs once on initial chezmoi apply (per D-29, DFM-05)
# Downloads apex-jorje-lsp.jar for Apex LSP support and checks prerequisites
set -euo pipefail

JAR_DIR="$HOME/.local/share/nvim/apex-ls"
JAR_PATH="$JAR_DIR/apex-jorje-lsp.jar"
JAR_URL="https://raw.githubusercontent.com/forcedotcom/salesforcedx-vscode/develop/packages/salesforcedx-vscode-apex/out/apex-jorje-lsp.jar"

echo "[bootstrap] DotfilesManagerMac bootstrap starting..."

# --- Apex LSP JAR Download (per D-13) ---
if [ -f "$JAR_PATH" ]; then
  echo "[bootstrap] apex-jorje-lsp.jar already exists at $JAR_PATH, skipping download."
else
  mkdir -p "$JAR_DIR"
  echo "[bootstrap] Downloading apex-jorje-lsp.jar from Salesforce VS Code extension repo..."
  echo "[bootstrap] URL: $JAR_URL"
  echo "[bootstrap] Destination: $JAR_PATH"
  if curl -fSL --retry 3 --retry-delay 2 -o "$JAR_PATH" "$JAR_URL"; then
    echo "[bootstrap] JAR downloaded successfully ($(du -h "$JAR_PATH" | cut -f1))."
  else
    echo ""
    echo "[bootstrap] WARNING: Failed to download apex-jorje-lsp.jar automatically."
    echo "[bootstrap] This may be due to network restrictions (proxy, firewall, etc.)."
    echo ""
    echo "[bootstrap] Manual download instructions:"
    echo "  1. Visit: https://github.com/forcedotcom/salesforcedx-vscode/blob/develop/packages/salesforcedx-vscode-apex/out/apex-jorje-lsp.jar"
    echo "  2. Click 'Download raw file' button"
    echo "  3. Save the file to: $JAR_PATH"
    echo "  4. Then re-run: chezmoi apply"
    echo ""
    echo "[bootstrap] Apex LSP will not work until the JAR is available."
  fi
fi

# --- Verify Prerequisites ---
echo ""
echo "[bootstrap] Checking prerequisites..."

if command -v nvim &>/dev/null; then
  NVIM_VERSION=$(nvim --version | head -1)
  echo "[bootstrap] Neovim: $NVIM_VERSION"
else
  echo "[bootstrap] WARNING: Neovim not found. Install Neovim v0.11+ before using this config."
fi

if command -v sf &>/dev/null; then
  SF_VERSION=$(sf --version 2>/dev/null | head -1)
  echo "[bootstrap] Salesforce CLI: $SF_VERSION"
else
  echo "[bootstrap] WARNING: Salesforce CLI (sf) not found. sf.nvim commands will not work."
fi

if command -v java &>/dev/null; then
  JAVA_VERSION=$(java -version 2>&1 | head -1)
  echo "[bootstrap] Java: $JAVA_VERSION"
else
  echo "[bootstrap] WARNING: Java not found. apex_ls requires Java 11+."
fi

if command -v node &>/dev/null; then
  echo "[bootstrap] Node.js: $(node --version)"
else
  echo "[bootstrap] WARNING: Node.js not found. TypeScript LSP and prettier require Node.js."
fi

echo ""
echo "[bootstrap] Bootstrap complete."
echo "[bootstrap] Open Neovim and run :Lazy sync to install plugins."
