# Obsidian Git Sync

**English | [中文](README.zh-CN.md)**

A skill that syncs your Obsidian vault to GitHub from one sentence to your agent. You decide first which folders may leave your machine.

It works with Claude Code, Codex, and any agent that loads a `SKILL.md`, on Windows and macOS.

## What you say

> Sync my Obsidian vault to GitHub.

or, to share only some folders:

> Sync only my SKILL and daily folders to GitHub.

The agent asks for three things: the vault path, the URL of an empty GitHub repository, and the mode (the whole vault, or selected folders). Then it runs the script for your platform.

## Two modes, on both platforms

| Mode | What it does | Use it when |
| --- | --- | --- |
| Full vault | Syncs every note. Obsidian internals and OS files are ignored | You want a complete private backup |
| Selected folders | Ignores the whole vault, then opens only the folders you name (an allowlist) | You want to control exactly what leaves your machine |

In both modes `.obsidian` settings are not included by default.

## Install

Clone the repository into your agent's skills directory.

Claude Code on macOS:

```bash
git clone https://github.com/alexliu072903-bit/obsidian-git-sync-skill ~/.claude/skills/obsidian-git-sync
```

Codex on macOS:

```bash
git clone https://github.com/alexliu072903-bit/obsidian-git-sync-skill ~/.codex/skills/obsidian-git-sync
```

On Windows, clone into `%USERPROFILE%\.claude\skills\obsidian-git-sync` or `%USERPROFILE%\.codex\skills\obsidian-git-sync` in the same way.

## Requirements

- `git`. On macOS it comes with the Xcode command line tools.
- A GitHub account and an **empty** repository. Choose Private and do not add a README.
- For automatic syncing after the first push, the [Obsidian Git plugin](https://github.com/Vinzent03/obsidian-git).

## Run it yourself

You do not need an agent. Both scripts take the same information.

macOS, selected folders, previewing first:

```bash
~/.claude/skills/obsidian-git-sync/scripts/setup.sh \
  --vault "/Users/you/Documents/MyVault" \
  --remote "https://github.com/you/obsidian-notes.git" \
  --include "SKILL,daily" \
  --dry-run
```

Windows, full vault:

```powershell
& "$env:USERPROFILE\.claude\skills\obsidian-git-sync\scripts\setup.ps1" `
  -VaultPath "D:\ob\Obsidian Vault" `
  -RemoteUrl "https://github.com/you/obsidian-notes.git"
```

| Option (macOS) | Option (Windows) | Meaning |
| --- | --- | --- |
| `--vault` | `-VaultPath` | Path to the vault (required) |
| `--remote` | `-RemoteUrl` | GitHub remote URL (required) |
| `--all` | leave `-IncludeFolders` empty | Sync the whole vault |
| `--include A,B` | `-IncludeFolders "A,B"` | Sync only these folders. Cannot be combined with `--all` |
| `--branch` | `-Branch` | Branch name, default `main` |
| `--message` | `-CommitMessage` | Commit message |
| `--dry-run` | `-DryRun` | Show what would change without changing anything |

## Safety defaults

- Before it replaces a `.gitignore`, the script saves a timestamped backup.
- In selected-folder mode it never runs `git add .`; it adds the folders you named.
- If the vault is already a git repository, its history is kept.
- Use an empty remote. A remote that already has commits needs you to merge histories yourself.

## Automatic sync after the first push

In Obsidian open Settings, then Git, then Automatic:

| Setting | Recommended |
| --- | --- |
| Auto commit-and-sync interval (minutes) | `30` |
| Auto pull interval (minutes) | `30` |

## Not tested

`scripts/setup.sh` is a bash script and may run on Linux, but it has only been used on macOS.

## License

MIT
