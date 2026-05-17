param(
    [Parameter(Mandatory)][string]$VaultPath,
    [Parameter(Mandatory)][string]$RemoteUrl
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# ── Validate ────────────────────────────────────────────────────────────────
if (-not (Test-Path $VaultPath)) {
    Write-Error "Vault path not found: $VaultPath"
    exit 1
}

Set-Location $VaultPath
Write-Host "Working in: $VaultPath"

# ── Git init ────────────────────────────────────────────────────────────────
if (-not (Test-Path ".git")) {
    git init
    Write-Host "Git repository initialized."
} else {
    Write-Host "Git repository already exists, skipping init."
}

# ── .gitignore ───────────────────────────────────────────────────────────────
if (-not (Test-Path ".gitignore")) {
    @"
# Obsidian workspace state (machine-specific)
.obsidian/workspace
.obsidian/workspace.json
.obsidian/workspace-mobile.json
.obsidian/cache

# Obsidian trash
.trash/

# OS files
.DS_Store
Thumbs.db
"@ | Out-File -FilePath ".gitignore" -Encoding utf8
    Write-Host ".gitignore created."
} else {
    Write-Host ".gitignore already exists, skipping."
}

# ── Remote ───────────────────────────────────────────────────────────────────
$remotes = git remote 2>$null
if ($remotes -contains "origin") {
    git remote set-url origin $RemoteUrl
    Write-Host "Remote 'origin' updated to: $RemoteUrl"
} else {
    git remote add origin $RemoteUrl
    Write-Host "Remote 'origin' set to: $RemoteUrl"
}

# ── Commit ───────────────────────────────────────────────────────────────────
git add -A
$status = git status --porcelain
if ($status) {
    git commit -m "Initial commit: sync Obsidian vault"
    Write-Host "Initial commit created."
} else {
    Write-Host "Nothing new to commit."
}

# ── Push ─────────────────────────────────────────────────────────────────────
$branch = git symbolic-ref --short HEAD 2>$null
if (-not $branch) { $branch = "main" }

Write-Host "Pushing branch '$branch' to origin..."
git push -u origin $branch

Write-Host ""
Write-Host "Done! Your vault is now synced to GitHub."
Write-Host "Next: open Obsidian → Settings → Git → Automatic, set auto-sync interval."
