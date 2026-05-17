**[English](README.md) | [中文](README.zh.md)**

A Claude Code skill that syncs your Obsidian vault to GitHub in one sentence — no manual git commands needed.

## Features

1. Initializes a git repository inside your vault
2. Auto-generates an Obsidian-specific `.gitignore`
3. Connects to your GitHub remote repository
4. Pushes all notes on first run
5. Guides you to enable auto-sync via the Obsidian Git plugin

## Prerequisites

- [Claude Code](https://claude.ai/code) installed
- [Obsidian Git plugin](https://github.com/Vinzent03/obsidian-git) installed in Obsidian
- A GitHub account with an empty repository already created

## Installation

Clone directly into Claude Code's skills directory:

```bash
# macOS / Linux
git clone https://github.com/alexliu072903-bit/obsidian-git-sync-skill \
  ~/.claude/skills/obsidian-git-sync

# Windows (PowerShell)
git clone https://github.com/alexliu072903-bit/obsidian-git-sync-skill `
  "$env:USERPROFILE\.claude\skills\obsidian-git-sync"
```

Or copy manually:

```
~/.claude/skills/obsidian-git-sync/
├── SKILL.md
└── scripts/
    └── setup.ps1
```

## Usage

Open Claude Code in any directory and say:

> "Help me sync my Obsidian vault to GitHub"

Claude will ask for two things:
1. Your vault path (e.g. `D:\ob\Obsidian Vault`)
2. Your GitHub repo URL (e.g. `https://github.com/yourname/obsidian.git`)

Everything else is automated.

### Enable auto-sync

After the first push, open Obsidian:

**Settings → Community plugins → Git → Automatic**

| Setting | Recommended value |
|---|---|
| Auto commit-and-sync interval (minutes) | `30` |
| Auto pull interval (minutes) | `30` |

Settings save immediately — no extra step needed.

## Platform support

| Platform | Status |
|---|---|
| Windows | Supported (`setup.ps1`) |
| macOS / Linux | Planned (bash script coming soon) |

## License

MIT
