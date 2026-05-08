#!/bin/bash
# -----------------------------------------------------------------------------
# start.sh — Local server for PowerShell Cleaner (Linux / macOS)
#
# Starts Python's built-in HTTP server from the directory this script lives in.
# Binds to 127.0.0.1 (localhost only) — the tool is intended for local use only.
#
# Usage:
#   bash start.sh
#
# Then open: http://localhost:8081
# Press Ctrl+C to stop the server.
# -----------------------------------------------------------------------------

# Change to the script directory so the server can find index.html
# regardless of where this script is called from.
cd "$(dirname "$0")"

python3 -m http.server 8081 --bind 127.0.0.1
