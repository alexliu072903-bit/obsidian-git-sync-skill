---
name: obsidian-git-sync
description: Automates syncing an Obsidian vault to GitHub on Windows or macOS. Supports two sync modes on both platforms — full vault or selected folders only. Initializes git, creates an Obsidian-specific .gitignore, connects to a GitHub remote, and pushes notes. Use when user wants to sync, backup, or push their Obsidian vault to GitHub, or mentions "obsidian git", "obsidian github", "sync obsidian", "备份obsidian", "同步obsidian到github", "only sync some folders", "sync specific folders".
---

# Obsidian Git Sync

Both Windows and macOS support the same two sync modes:

| Mode | When to use |
|---|---|
| **Full vault** | Sync all notes (`.obsidian` internals excluded) |
| **Selected folders** | Sync only specified folders (allowlist — everything else is ignored) |

---

## Step 1 — Collect info

If the user hasn't provided all required info, ask:

> 请告诉我：
> 1. 你的 Obsidian vault 路径
>    - macOS 示例：`/Users/yourname/Documents/MyVault`
>    - Windows 示例：`D:\ob\Obsidian Vault`
> 2. 你在 GitHub 上创建的空仓库地址（例如 `https://github.com/yourname/obsidian.git`）
> 3. 同步模式：**全部文件夹** 还是 **指定文件夹**？
>    - 如果选指定文件夹，请告诉我文件夹名称（逗号分隔，例如 `SKILL,daily`）
>
> 如果还没有 GitHub 仓库，请先去 [github.com/new](https://github.com/new) 创建一个（选 Private，**不要**勾选 Add README）。

---

## Step 2 — Run setup script

### macOS — Full vault

```bash
~/.claude/skills/obsidian-git-sync/scripts/setup.sh \
  --vault "/Users/yourname/Documents/MyVault" \
  --remote "https://github.com/user/obsidian.git" \
  --all
```

### macOS — Selected folders

```bash
~/.claude/skills/obsidian-git-sync/scripts/setup.sh \
  --vault "/Users/yourname/Documents/MyVault" \
  --remote "https://github.com/user/obsidian.git" \
  --include "SKILL,daily"
```

Use `--dry-run` to preview before committing:

```bash
~/.claude/skills/obsidian-git-sync/scripts/setup.sh \
  --vault "/Users/yourname/Documents/MyVault" \
  --remote "https://github.com/user/obsidian.git" \
  --include "SKILL,daily" \
  --dry-run
```

### Windows — Full vault

```powershell
& "$env:USERPROFILE\.claude\skills\obsidian-git-sync\scripts\setup.ps1" `
  -VaultPath "D:\ob\Obsidian Vault" `
  -RemoteUrl "https://github.com/user/obsidian.git"
```

### Windows — Selected folders

```powershell
& "$env:USERPROFILE\.claude\skills\obsidian-git-sync\scripts\setup.ps1" `
  -VaultPath "D:\ob\Obsidian Vault" `
  -RemoteUrl "https://github.com/user/obsidian.git" `
  -IncludeFolders "SKILL,daily"
```

Dry run:

```powershell
& "$env:USERPROFILE\.claude\skills\obsidian-git-sync\scripts\setup.ps1" `
  -VaultPath "D:\ob\Obsidian Vault" `
  -RemoteUrl "https://github.com/user/obsidian.git" `
  -IncludeFolders "SKILL,daily" `
  -DryRun
```

---

## Step 3 — Verify success

**macOS:**
```bash
git -C "<VaultPath>" log --oneline -3
git -C "<VaultPath>" remote -v
```

**Windows:**
```powershell
cd "<VaultPath>"; git log --oneline -3; git remote -v
```

---

## Step 4 — Guide plugin settings

Open Obsidian → Settings → Git → Automatic:

| Setting | Recommended value |
|---|---|
| Auto commit-and-sync interval (minutes) | `30` |
| Auto pull interval (minutes) | `30` |

---

## .gitignore shape

**Full vault mode** — excludes only Obsidian internals and OS files:
```gitignore
.obsidian/workspace
.obsidian/workspace.json
.obsidian/workspace-mobile.json
.obsidian/cache
.trash/
.DS_Store
Thumbs.db
```

**Selected folders mode** — allowlist (e.g. `--include "SKILL,daily"`):
```gitignore
*
!.gitignore
!SKILL/
!SKILL/**
!daily/
!daily/**
```

---

## Safety rules

- Never run `git add .` in selected-folder mode (use explicit folder paths).
- Never overwrite an existing `.gitignore` without creating a timestamped backup.
- Do not include `.obsidian` by default in either mode.
- If the vault is already a git repo, preserve existing history.
- Confirm the sync mode with the user before running (full vault vs. selected folders).

---

## Error handling

| Error | Fix |
|---|---|
| `not a git repository` | Script wasn't run yet, or wrong vault path |
| `remote: Repository not found` | Wrong URL or no GitHub access |
| Authentication prompt | Use GitHub username + Personal Access Token (not password) |
| Folder not found | Check folder name or remove it from `--include` |
| Existing `.gitignore` | Script backs it up automatically |
| Repo already has commits | Use an empty repo, or explicitly merge histories |
