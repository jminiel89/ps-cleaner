# -----------------------------------------------------------------------------
# start.ps1 — Local server for PowerShell Cleaner (Windows)
#
# Starts Python's built-in HTTP server from the directory this script lives in.
# Binds to 127.0.0.1 (localhost only) — the tool is intended for local use only.
#
# Usage:
#   powershell -File start.ps1
#
# Then open: http://localhost:8081
# Press Ctrl+C to stop the server.
# -----------------------------------------------------------------------------
#Requires -Version 5.1
$ErrorActionPreference = "Stop"

# Try both 'python' and 'python3' since Windows installs vary.
$python = Get-Command python -ErrorAction SilentlyContinue
if (-not $python) { $python = Get-Command python3 -ErrorAction SilentlyContinue }

if (-not $python) {
  Write-Host "Error: Python not found. Install from https://python.org" -ForegroundColor Red
  exit 1
}

# Change to the script directory so the server can find index.html
# regardless of where this script is called from.
Set-Location $PSScriptRoot

Write-Host "Starting PowerShell Cleaner on http://localhost:8081" -ForegroundColor Cyan
Write-Host "Press Ctrl+C to stop."
Write-Host ""

& $python.Source -m http.server 8081 --bind 127.0.0.1
