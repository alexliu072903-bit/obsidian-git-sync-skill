# Obsidian vault → GitHub sync (Windows)
# Supports two modes:
#   -IncludeFolders ""          sync the entire vault (default)
#   -IncludeFolders "F1,F2"     sync only specified folders (allowlist)
param(
    [Parameter(Mandatory)][string]$VaultPath,
    [Parameter(Mandatory)][string]$RemoteUrl,
    [string]$IncludeFolders = "",
    [string]$Branch = "main",
    [string]$CommitMessage = "sync: update Obsidian notes",
    [switch]$DryRun
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$SyncAll = [string]::IsNullOrWhiteSpace($IncludeFolders)

# ── Validate ─────────────────────────────────────────────────────────────────
if (-not (Test-Path $VaultPath)) {
    Write-Error "Vault path not found: $VaultPath"
    exit 1
}

Set-Location $VaultPath
Write-Host "Working in: $VaultPath"

if ($SyncAll) {
    Write-Host "Mode: full vault"
} else {
    Write-Host "Mode: selected folders → $IncludeFolders"
}

# ── Validate selected folders ────────────────────────────────────────────────
if (-not $SyncAll) {
    $folders = $IncludeFolders -split "," | ForEach-Object { $_.Trim() }
    foreach ($folder in $folders) {
        if (-not (Test-Path $folder)) {
            Write-Error "Folder not found in vault: $folder"
            exit 1
        }
    }
}

# ── Build .gitignore content ─────────────────────────────────────────────────
function Get-GitignoreContent {
    if ($SyncAll) {
        return @"
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
"@
    }
    else {
        $lines = @("*", "!.gitignore")
        $folders = $IncludeFolders -split "," | ForEach-Object { $_.Trim() }
        foreach ($folder in $folders) {
            $lines += "!${folder}/"
            $lines += "!${folder}/**"
        }
        return ($lines -join "`n")
    }
}

$newGitignore = Get-GitignoreContent

# ── Dry run ──────────────────────────────────────────────────────────────────
if ($DryRun) {
    Write-Host ""
    Write-Host "[dry-run] .gitignore would be written as:"
    Write-Host "---"
    Write-Host $newGitignore
    Write-Host "---"
    Write-Host "[dry-run] No changes made."
    exit 0
}

# ── Backup existing .gitignore ───────────────────────────────────────────────
if (Test-Path ".gitignore") {
    $backup = ".gitignore.bak.$(Get-Date -Format 'yyyyMMddHHmmss')"
    Copy-Item ".gitignore" $backup
    Write-Host "Backed up .gitignore → $backup"
}

$newGitignore | Out-File -FilePath ".gitignore" -Encoding utf8
Write-Host ".gitignore written."

# ── Git init ─────────────────────────────────────────────────────────────────
if (-not (Test-Path ".git")) {
    git init
    Write-Host "Git repository initialized."
} else {
    Write-Host "Git repository already exists."
}

# ── Configure remote ─────────────────────────────────────────────────────────
$remotes = git remote 2>$null
if ($remotes -contains "origin") {
    git remote set-url origin $RemoteUrl
    Write-Host "Remote 'origin' updated."
} else {
    git remote add origin $RemoteUrl
    Write-Host "Remote 'origin' set."
}

# ── Stage files ──────────────────────────────────────────────────────────────
git add .gitignore

if ($SyncAll) {
    git add -A
} else {
    $folders = $IncludeFolders -split "," | ForEach-Object { $_.Trim() }
    foreach ($folder in $folders) {
        git add "$folder/"
    }
}

# ── Commit ───────────────────────────────────────────────────────────────────
$status = git status --porcelain
if ($status) {
    git commit -m $CommitMessage
    Write-Host "Commit created."
} else {
    Write-Host "Nothing new to commit."
}

# ── Push ─────────────────────────────────────────────────────────────────────
$currentBranch = git symbolic-ref --short HEAD 2>$null
if (-not $currentBranch) { $currentBranch = $Branch }

Write-Host "Pushing branch '$currentBranch' to origin..."
git push -u origin $currentBranch

Write-Host ""
Write-Host "Done! Your vault is now synced to GitHub."
if ($SyncAll) {
    Write-Host "Mode: full vault"
} else {
    Write-Host "Mode: selected folders → $IncludeFolders"
}
Write-Host "Next: open Obsidian → Settings → Git → Automatic, set auto-sync interval to 30 min."
