#!/bin/bash
# Bootstrap script for DotfilesManagerMac
# Runs once on initial chezmoi apply (per D-29, DFM-05)
# Downloads apex-jorje-lsp.jar for Apex LSP support and checks prerequisites
set -euo pipefail

# Configuration
JAR_DIR="$HOME/.local/share/nvim/apex-ls"
JAR_PATH="$JAR_DIR/apex-jorje-lsp.jar"
JAR_URL="https://raw.githubusercontent.com/forcedotcom/salesforcedx-vscode/develop/packages/salesforcedx-vscode-apex/out/apex-jorje-lsp.jar"
LOG_FILE="$HOME/.local/share/dotfiles-bootstrap.log"
MAX_RETRIES=5
RETRY_DELAY=2
EXPONENTIAL_BACKOFF=true
NON_INTERACTIVE="${1:-}"

# Initialize log file
mkdir -p "$(dirname "$LOG_FILE")"
{
  echo "=== DotfilesManagerMac Bootstrap ==="
  echo "Started: $(date)"
  echo "User: $(whoami)"
  echo "Home: $HOME"
  echo "============================================"
} >> "$LOG_FILE"

log() {
  local level=$1
  shift
  local msg="$@"
  local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
  echo "[$timestamp] [$level] $msg" | tee -a "$LOG_FILE"
}

log_error() {
  log "ERROR" "$@"
}

log_warn() {
  log "WARN" "$@"
}

log_info() {
  log "INFO" "$@"
}

log_info "DotfilesManagerMac bootstrap starting..."

# --- Ensure Homebrew + Core Tools ---
ensure_brew() {
  if command -v brew >/dev/null 2>&1; then
    return 0
  fi

  log_warn "Homebrew not found. Installing Homebrew..."
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || {
    log_error "Failed to install Homebrew. Install it manually and re-run: chezmoi apply"
    return 1
  }

  if [ -x "/opt/homebrew/bin/brew" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [ -x "/usr/local/bin/brew" ]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
}

install_formula_if_missing() {
  local formula="$1"
  if brew list --formula "$formula" >/dev/null 2>&1; then
    log_info "✓ $formula already installed"
  else
    log_info "Installing $formula via Homebrew..."
    brew install "$formula" >> "$LOG_FILE" 2>&1 || log_warn "Could not install $formula automatically"
  fi
}

if ensure_brew; then
  install_formula_if_missing "neovim"
  install_formula_if_missing "tmux"
  install_formula_if_missing "pure"
  install_formula_if_missing "bat"
  install_formula_if_missing "lsd"
  install_formula_if_missing "fd"
  install_formula_if_missing "fzf"
  install_formula_if_missing "ripgrep"
  install_formula_if_missing "node"
  install_formula_if_missing "openjdk@11"
  install_formula_if_missing "jq"
fi

# --- Apex LSP JAR Download (with exponential backoff & retries) ---
if [ -f "$JAR_PATH" ]; then
  log_info "apex-jorje-lsp.jar already exists at $JAR_PATH, skipping download."
else
  mkdir -p "$JAR_DIR"
  log_info "Downloading apex-jorje-lsp.jar from Salesforce VS Code extension repo..."
  log_info "URL: $JAR_URL"
  log_info "Destination: $JAR_PATH"

  download_success=false
  retry_count=0
  retry_delay=$RETRY_DELAY

  while [ $retry_count -lt $MAX_RETRIES ] && [ "$download_success" = false ]; do
    log_info "Attempt $((retry_count + 1))/$MAX_RETRIES..."

    if curl -fSL --connect-timeout 10 --max-time 60 -o "$JAR_PATH" "$JAR_URL" 2>> "$LOG_FILE"; then
      jar_size=$(du -h "$JAR_PATH" | cut -f1)
      log_info "JAR downloaded successfully ($jar_size)."
      download_success=true
    else
      retry_count=$((retry_count + 1))
      if [ $retry_count -lt $MAX_RETRIES ]; then
        if [ "$EXPONENTIAL_BACKOFF" = true ]; then
          retry_delay=$((retry_delay * 2))
        fi
        log_warn "Download attempt $retry_count failed. Retrying in ${retry_delay}s..."
        rm -f "$JAR_PATH"
        sleep "$retry_delay"
      else
        log_error "Failed to download apex-jorje-lsp.jar after $MAX_RETRIES attempts."
      fi
    fi
  done

  if [ "$download_success" = false ]; then
    log_error ""
    log_error "Download failed due to:"
    if ! curl -I "$JAR_URL" 2>/dev/null | head -1 | grep -q "200\|301\|302"; then
      log_error "  • Network error or invalid URL"
    fi
    if ! command -v curl &>/dev/null; then
      log_error "  • curl is not installed"
    fi
    if grep -q "certificate\|SSL" "$LOG_FILE" 2>/dev/null; then
      log_error "  • SSL/Certificate error (possibly Zscaler/corporate proxy)"
    fi

    log_error ""
    log_error "Manual download instructions:"
    log_error "  1. Visit: https://github.com/forcedotcom/salesforcedx-vscode/blob/develop/packages/salesforcedx-vscode-apex/out/apex-jorje-lsp.jar"
    log_error "  2. Click 'Download raw file' button"
    log_error "  3. Save the file to: $JAR_PATH"
    log_error "  4. Then re-run: chezmoi apply"
    log_error ""
    log_error "Or use offline download:"
    log_error "  export APEX_JAR_PATH=/path/to/apex-jorje-lsp.jar"
    log_error "  chezmoi apply"
    log_error ""
    log_error "Apex LSP will not work until the JAR is available."

    if [ -z "$NON_INTERACTIVE" ]; then
      log_error "See $LOG_FILE for detailed error logs."
    fi
  fi
fi

# --- Verify Prerequisites ---
log_info "Checking prerequisites..."
log_info ""

check_tool() {
  local tool=$1
  local display_name=$2
  local required=${3:-true}
  local severity="WARN"

  if [ "$required" = true ]; then
    severity="ERROR"
  fi

  if command -v "$tool" &>/dev/null; then
    local version=""
    if [ "$tool" = "nvim" ]; then
      version=$(nvim --version | head -1)
    elif [ "$tool" = "sf" ]; then
      version=$(sf --version 2>/dev/null || echo "unknown")
    elif [ "$tool" = "java" ]; then
      version=$(java -version 2>&1 | head -1)
    elif [ "$tool" = "node" ]; then
      version=$(node --version)
    fi
    log_info "✓ $display_name: $version"
  else
    local msg="$display_name not found."
    if [ "$required" = true ]; then
      msg="$msg Install $display_name before continuing."
      log_error "$msg"
    else
      msg="$msg Install it for full functionality."
      log_warn "$msg"
    fi
  fi
}

check_tool "nvim" "Neovim v0.11+" true
check_tool "sf" "Salesforce CLI (sf)" false
check_tool "java" "Java 11+" true
check_tool "node" "Node.js" false

log_info ""
log_info "Bootstrap complete."
log_info "Open Neovim and run :Lazy sync to install plugins."
log_info "Bootstrap log: $LOG_FILE"
