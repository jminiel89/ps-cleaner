# PowerShell Cleaner

![License](https://img.shields.io/badge/license-MIT-blue) ![UI](https://img.shields.io/badge/UI-Glassmorphism-1d4ed8) ![Python](https://img.shields.io/badge/requires-Python%203-yellow)

---

## The Problem

When you copy a PowerShell script from a terminal emulator (Tilix, Windows Terminal, etc.), the terminal's visual word-wrap gets baked into the copied text as real newlines. A single long command becomes multiple broken lines that fail when pasted into NinjaOne, Rewst, or any other editor.

| Source | What you copy | What happens |
|--------|--------------|--------------|
| Terminal at 80-col width | Long one-liner | Broken into ~5 lines |
| Mid-word wrap | `...Uninstall\*","H` + `KLM:\...` | Joined wrong → syntax error |
| Mid-flag wrap | `-ErrorAction` + `SilentlyContinue` | Split → PowerShell rejects |

Generic text editors don't know PowerShell grammar — they can't tell a terminal wrap artifact from an intentional line break.

---

## What This Tool Does

**PowerShell Cleaner** is a single-page browser tool that removes terminal word-wrap artifacts and produces clean, runnable PowerShell. It:

- **Detects continuation lines** — identifies lines that were split by terminal word-wrap, not by intent
- **Joins them correctly** — splices continuation lines back to the previous line without adding unwanted spaces
- **Preserves real structure** — keeps intentional line breaks after `;` `{` `}` `|` and backtick, and keeps new statements starting with `$`, `#`, or PS keywords on their own lines
- **Highlights the result** with PowerShell-aware syntax colors — variables, cmdlets, keywords, strings, parameters, and type literals all in distinct colors
- **Runs 100% locally** — your scripts never leave your machine

---

## Install

Requires Python 3. No other dependencies, no `pip install`, no Node.js.

**Linux / macOS** — paste into a terminal:
```bash
curl -fsSL https://raw.githubusercontent.com/jminiel89/ps-cleaner/main/install.sh | bash
```

**Windows** — paste into PowerShell:
```powershell
irm https://raw.githubusercontent.com/jminiel89/ps-cleaner/main/install.ps1 | iex
```

Both scripts will:
1. Check that Python 3 is available
2. Clone the repo via git (or download the files directly if git is not installed)
3. Print the exact command to start the tool

> Re-run the same install command at any time to update to the latest version.

---

## Running the Tool

**Linux / macOS:**
```bash
bash ~/ps-cleaner/start.sh
```

**Windows (PowerShell):**
```powershell
powershell -File "$env:USERPROFILE\ps-cleaner\start.ps1"
```

Then open **http://localhost:8081** in your browser.

The server binds to `127.0.0.1` (your machine only) by default. To make it accessible on your local network, open `start.sh` or `start.ps1` and change the bind address to `0.0.0.0`.

---

## How to Use It

1. **Paste** your broken PowerShell into the left panel
   *(Cleaning triggers automatically on paste — no button click needed)*

2. **Review** the info bar below the toolbar
   *(Example: "Joined 4 terminal wrap artifacts")*

3. **Check** the right panel for the syntax-highlighted clean output
   - Cyan = variables (`$app`, `$targetVersion`)
   - Green = cmdlets (`Get-ItemProperty`, `Where-Object`)
   - Purple = keywords (`if`, `else`, `foreach`)
   - Amber = strings
   - Blue = parameters (`-Path`, `-ErrorAction`)
   - Yellow = type literals (`[version]`, `[string]`)

4. **Click Copy Output** and paste directly into NinjaOne, Rewst, or your editor

> **Keyboard shortcut:** `Ctrl+Enter` (or `Cmd+Enter` on Mac) triggers clean from anywhere on the page.

---

## Example

Click **Load Example** in the toolbar to load a sample Acrobat Reader version check script with artificial terminal wrap artifacts. Clean it to see how the tool works.

---

## Files

```
index.html      # The entire app — HTML, CSS, and JavaScript in one file. No build step.
start.sh        # Starts the local server on Linux / macOS
start.ps1       # Starts the local server on Windows
install.sh      # One-liner installer for Linux / macOS
install.ps1     # One-liner installer for Windows
```

---

## License

MIT — free to use, modify, and share.
