---
name: obsidian-git-sync
description: Automates syncing an Obsidian vault to GitHub on Windows (full-vault) or macOS (selected-folder allowlist). Initializes git, creates an Obsidian-specific .gitignore, connects to a GitHub remote, and pushes notes. Use when user wants to sync, backup, or push their Obsidian vault to GitHub, or mentions "obsidian git", "obsidian github", "sync obsidian", "备份obsidian", "同步obsidian到github", "only sync some folders".
---

# Obsidian Git Sync

Supports two platforms with two different sync strategies:

| Platform | Script | Default strategy |
|---|---|---|
| Windows | `scripts/setup.ps1` | Full-vault sync |
| macOS | `scripts/setup.sh` | Selected-folder allowlist sync |

---

## Windows — Full-vault sync

### Quick start

Collect two things, then run the setup script:
1. **Vault path** — absolute path to the Obsidian vault directory
2. **GitHub repo URL** — the `.git` URL of an empty GitHub repo

```powershell
& "$env:USERPROFILE\.claude\skills\obsidian-git-sync\scripts\setup.ps1" `
  -VaultPath "<VaultPath>" `
  -RemoteUrl "<RemoteUrl>"
```

### Workflow

#### Step 1 — Collect info

If the user hasn't provided both pieces of info, ask:

> 请告诉我：
> 1. 你的 Obsidian vault 路径（例如 `D:\ob\Obsidian Vault`）
> 2. 你在 GitHub 上创建的空仓库地址（例如 `https://github.com/yourname/obsidian.git`）
>
> 如果还没有 GitHub 仓库，请先去 [github.com/new](https://github.com/new) 创建一个（选 Private，**不要**勾选 Add README）。

#### Step 2 — Run setup script

```powershell
& "$env:USERPROFILE\.claude\skills\obsidian-git-sync\scripts\setup.ps1" `
  -VaultPath "D:\ob\Obsidian Vault" `
  -RemoteUrl "https://github.com/user/obsidian.git"
```

#### Step 3 — Verify success

```powershell
cd "<VaultPath>"; git log --oneline -3; git remote -v
```

#### Step 4 — Guide plugin settings

Open Obsidian → Settings → Git plugin → Automatic:

| Setting | Recommended value |
|---|---|
| Auto commit-and-sync interval (minutes) | `30` |
| Auto pull interval (minutes) | `30` |

### Error handling (Windows)

| Error | Fix |
|---|---|
| `not a git repository` | Script wasn't run yet, or wrong path |
| `remote: Repository not found` | Wrong URL or no access — check GitHub URL |
| Authentication popup | Enter GitHub username + Personal Access Token (not password) |
| `already exists` remote error | Run: `cd "<path>"; git remote set-url origin <new-url>` |
| Repo already has commits | Ask user to use an empty repo, or add `--allow-unrelated-histories` |

---

## macOS — Selected-folder sync

### Purpose

Sync only selected Obsidian folders to GitHub on macOS.

Default behavior is **allowlist-based**: ignore the whole vault first, then explicitly include only the folders you choose. Do not sync the entire vault unless explicitly asked. Do not include `.obsidian` by default.

### Quick start

Collect three things:
1. **Vault path** — absolute path to the Obsidian vault (default: `/Users/mac/Desktop/obsidian`)
2. **GitHub remote URL**
3. **Selected folders** — comma-separated, e.g. `SKILL,daily`

```bash
scripts/setup.sh \
  --vault "/Users/mac/Desktop/obsidian" \
  --remote "https://github.com/<user>/<repo>.git" \
  --include "SKILL,daily"
```

Use `--dry-run` first when the folder list is uncertain:

```bash
scripts/setup.sh \
  --vault "/Users/mac/Desktop/obsidian" \
  --remote "https://github.com/<user>/<repo>.git" \
  --include "SKILL,daily" \
  --dry-run
```

### Workflow

1. Confirm selected-folder sync, not full-vault sync.
2. Verify the vault path exists.
3. Verify all selected folders exist inside the vault.
4. Run with `--dry-run` if there is any uncertainty about folder names.
5. Run for real after folder list is confirmed.
6. Verify:

```bash
git -C "<VaultPath>" status --short --branch
git -C "<VaultPath>" remote -v
git -C "<VaultPath>" log --oneline -3
```

7. Guide plugin settings (same as Windows table above).

### Selected-folder `.gitignore` shape

```gitignore
*
!.gitignore
!SKILL/
!SKILL/**
!daily/
!daily/**
```

Git tracks only the explicitly included folders.

### Safety rules

- Never run `git add .` for this workflow.
- Never overwrite an existing `.gitignore` without creating a timestamped backup.
- Never push the whole vault unless explicitly asked.
- Do not include `.obsidian` by default.
- If the vault is already a git repo, preserve existing history.

### Error handling (macOS)

| Error | Fix |
|---|---|
| `not a git repository` | Run setup script or confirm vault path |
| `remote: Repository not found` | Check remote URL and GitHub access |
| Authentication prompt | Use GitHub username + Personal Access Token, not password |
| Folder missing | Ask whether to remove it from `--include` or create it |
| Existing `.gitignore` | Script backs it up automatically before writing allowlist rules |
| Repo already has commits | Use an empty repo, or explicitly decide whether to merge histories |
