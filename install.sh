#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# install.sh — Installer for PowerShell Cleaner (Linux / macOS)
#
# Downloads and sets up the tool in ~/ps-cleaner.
# Re-running this script updates an existing installation.
#
# One-liner install:
#   curl -fsSL https://raw.githubusercontent.com/jminiel89/ps-cleaner/main/install.sh | bash
# -----------------------------------------------------------------------------
set -e

REPO="https://github.com/jminiel89/ps-cleaner"
INSTALL_DIR="$HOME/ps-cleaner"

echo "PowerShell Cleaner — Installer"
echo "--------------------------------"

# ── Step 1: Verify Python 3 is available ─────────────────────────────────────
# The tool uses Python's built-in HTTP server to serve the files locally.
# No pip packages or virtual environments are needed — just Python 3.
if ! command -v python3 &>/dev/null; then
  echo "Error: python3 not found."
  echo "Install it with your package manager:"
  echo "  Ubuntu/Debian: sudo apt install python3"
  echo "  macOS:         brew install python3"
  exit 1
fi

PYTHON_VERSION=$(python3 --version 2>&1)
echo "Found: $PYTHON_VERSION"

# ── Step 2: Download or update the tool ──────────────────────────────────────
# Prefer git clone for a full repo checkout (enables git pull for updates).
# Fall back to direct curl download if git is not installed.
if [ -d "$INSTALL_DIR/.git" ]; then
  echo "Existing install found — updating..."
  git -C "$INSTALL_DIR" pull --ff-only

elif command -v git &>/dev/null; then
  echo "Cloning repo..."
  git clone "$REPO.git" "$INSTALL_DIR"

else
  echo "git not found — downloading files directly..."
  mkdir -p "$INSTALL_DIR"
  for FILE in index.html start.sh; do
    echo "  Downloading $FILE..."
    curl -fsSL "$REPO/raw/main/$FILE" -o "$INSTALL_DIR/$FILE"
  done
fi

# ── Step 3: Ensure the start script is executable ────────────────────────────
chmod +x "$INSTALL_DIR/start.sh"

# ── Done ─────────────────────────────────────────────────────────────────────
echo ""
echo "Done. Installed to: $INSTALL_DIR"
echo ""
echo "To run:"
echo "  bash $INSTALL_DIR/start.sh"
echo ""
echo "Then open: http://localhost:8081"
