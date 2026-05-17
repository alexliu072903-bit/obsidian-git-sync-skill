---
name: obsidian-git-sync
description: Automates syncing an Obsidian vault to GitHub. Initializes git, creates Obsidian-specific .gitignore, connects to a GitHub remote, and pushes all files. Use when user wants to sync, backup, or push their Obsidian vault to GitHub, or mentions "obsidian git", "obsidian github", "sync obsidian", "备份obsidian", "同步obsidian到github".
---

# Obsidian Git Sync

## Quick start

Ask the user for two things, then run the setup script:
1. **Vault path** — absolute path to the Obsidian vault directory
2. **GitHub repo URL** — the `.git` URL of an empty GitHub repo they've already created

Then execute the setup script (Windows):
```powershell
& "$env:USERPROFILE\.claude\skills\obsidian-git-sync\scripts\setup.ps1" `
  -VaultPath "<VaultPath>" `
  -RemoteUrl "<RemoteUrl>"
```

## Workflow

### Step 1 — Collect info

If the user hasn't provided both pieces of info, ask:

> 请告诉我：
> 1. 你的 Obsidian vault 路径（例如 `D:\ob\Obsidian Vault`）
> 2. 你在 GitHub 上创建的空仓库地址（例如 `https://github.com/yourname/obsidian.git`）
>
> 如果还没有 GitHub 仓库，请先去 [github.com/new](https://github.com/new) 创建一个（选 Private，**不要**勾选 Add README）。

### Step 2 — Run setup script

```powershell
& "$env:USERPROFILE\.claude\skills\obsidian-git-sync\scripts\setup.ps1" `
  -VaultPath "D:\ob\Obsidian Vault" `
  -RemoteUrl "https://github.com/user/obsidian.git"
```

### Step 3 — Verify success

```powershell
cd "<VaultPath>"; git log --oneline -3; git remote -v
```

### Step 4 — Guide plugin settings

Tell the user to open Obsidian → Settings → Git plugin → find the **Automatic** section and set:

| Setting | Recommended value |
|---|---|
| Auto commit-and-sync interval (minutes) | `30` |
| Auto pull interval (minutes) | `30` |

Settings save automatically — no extra step needed.

## Error handling

| Error | Fix |
|---|---|
| `not a git repository` | Script wasn't run yet, or wrong path |
| `remote: Repository not found` | Wrong URL or no access — check GitHub URL |
| Authentication popup | Enter GitHub username + Personal Access Token (not password) |
| `already exists` remote error | Run: `cd "<path>"; git remote set-url origin <new-url>` |
| Repo already has commits (not empty) | Ask user to use an empty repo, or add `--allow-unrelated-histories` |
