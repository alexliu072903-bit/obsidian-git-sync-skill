**[English](README.md) | [中文](README.zh.md)**

A Claude Code skill that syncs your Obsidian vault to GitHub in one sentence — no manual git commands needed.

Supports **Windows** (full-vault sync) and **macOS** (selected-folder allowlist sync).

## Platform support

| Platform | Script | Strategy |
|---|---|---|
| Windows | `scripts/setup.ps1` | Full-vault sync |
| macOS | `scripts/setup.sh` | Selected-folder sync (allowlist) |

---

## Windows — Full-vault sync

### Features

1. Initializes a git repository inside your vault
2. Auto-generates an Obsidian-specific `.gitignore`
3. Connects to your GitHub remote
4. Pushes all notes on first run
5. Guides you to enable auto-sync via the Obsidian Git plugin

### Prerequisites

- [Claude Code](https://claude.ai/code) installed
- [Obsidian Git plugin](https://github.com/Vinzent03/obsidian-git) installed in Obsidian
- A GitHub account with an empty repository already created

### Installation

```powershell
# Windows (PowerShell)
git clone https://github.com/alexliu072903-bit/obsidian-git-sync-skill `
  "$env:USERPROFILE\.claude\skills\obsidian-git-sync"
```

### Usage

Open Claude Code and say:

> "Help me sync my Obsidian vault to GitHub"

Claude will ask for:
1. Your vault path (e.g. `D:\ob\Obsidian Vault`)
2. Your GitHub repo URL (e.g. `https://github.com/yourname/obsidian.git`)

Everything else is automated.

---

## macOS — Selected-folder sync

### Features

1. Initializes a git repository inside your vault (if not already initialized)
2. Generates an **allowlist-based `.gitignore`** — ignores the entire vault by default, includes only your chosen folders
3. Does **not** include `.obsidian` by default — no app settings leaked
4. Supports `--dry-run` to preview without making any changes
5. Backs up any existing `.gitignore` before overwriting
6. Connects to your GitHub remote and pushes

### Prerequisites

- macOS with `git` installed (comes with Xcode command-line tools)
- [Claude Code](https://claude.ai/code) installed
- A GitHub account with an empty repository already created

### Installation

```bash
git clone https://github.com/alexliu072903-bit/obsidian-git-sync-skill \
  ~/.claude/skills/obsidian-git-sync
```

### Usage

Open Claude Code and say:

> "Sync my Obsidian SKILL and daily folders to GitHub"

Claude will ask for:
1. Your vault path (e.g. `/Users/yourname/Documents/obsidian`)
2. Your GitHub repo URL
3. Which folders to include

#### Manual usage

```bash
~/.claude/skills/obsidian-git-sync/scripts/setup.sh \
  --vault "/Users/yourname/Documents/obsidian" \
  --remote "https://github.com/yourname/obsidian-notes.git" \
  --include "SKILL,daily"
```

Options:

| Flag | Required | Default | Description |
|---|---|---|---|
| `--vault` | ✅ | — | Absolute path to your Obsidian vault |
| `--remote` | ✅ | — | GitHub remote URL (`.git`) |
| `--include` | ✅ | — | Comma-separated folders to sync |
| `--branch` | — | `main` | Git branch name |
| `--message` | — | `sync selected Obsidian folders` | Commit message |
| `--dry-run` | — | off | Preview mode — no files changed |

#### Selected-folder `.gitignore` shape

```gitignore
*
!.gitignore
!SKILL/
!SKILL/**
!daily/
!daily/**
```

Only the folders you name are tracked. Everything else (including `.obsidian`) stays local.

---

## Auto-sync via Obsidian Git plugin

After the first push, open Obsidian on either platform:

**Settings → Community plugins → Git → Automatic**

| Setting | Recommended value |
|---|---|
| Auto commit-and-sync interval (minutes) | `30` |
| Auto pull interval (minutes) | `30` |

---

## License

MIT
