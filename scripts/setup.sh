#!/usr/bin/env bash
# Obsidian vault → GitHub sync (macOS / Linux)
# Supports two modes:
#   --all              sync the entire vault
#   --include F1,F2    sync only specified folders (allowlist)
set -euo pipefail

VAULT_PATH=""
REMOTE_URL=""
INCLUDE_FOLDERS=""
BRANCH="main"
COMMIT_MSG="sync: update Obsidian notes"
DRY_RUN=false
SYNC_ALL=false

# ── Parse arguments ──────────────────────────────────────────────────────────
while [[ $# -gt 0 ]]; do
  case "$1" in
    --vault)    VAULT_PATH="$2";      shift 2 ;;
    --remote)   REMOTE_URL="$2";      shift 2 ;;
    --include)  INCLUDE_FOLDERS="$2"; shift 2 ;;
    --all)      SYNC_ALL=true;        shift   ;;
    --branch)   BRANCH="$2";          shift 2 ;;
    --message)  COMMIT_MSG="$2";      shift 2 ;;
    --dry-run)  DRY_RUN=true;         shift   ;;
    *) echo "Unknown option: $1"; exit 1 ;;
  esac
done

# ── Validate required args ───────────────────────────────────────────────────
if [[ -z "$VAULT_PATH" || -z "$REMOTE_URL" ]]; then
  echo "Error: --vault and --remote are required"
  exit 1
fi

if [[ "$SYNC_ALL" == false && -z "$INCLUDE_FOLDERS" ]]; then
  echo "Error: specify --all to sync the entire vault, or --include FOLDER1,FOLDER2"
  exit 1
fi

if [[ "$SYNC_ALL" == true && -n "$INCLUDE_FOLDERS" ]]; then
  echo "Error: --all and --include are mutually exclusive"
  exit 1
fi

# ── Validate environment ─────────────────────────────────────────────────────
if ! command -v git &>/dev/null; then
  echo "Error: git is not installed. Install via: xcode-select --install"
  exit 1
fi

if [[ ! -d "$VAULT_PATH" ]]; then
  echo "Error: Vault directory not found: $VAULT_PATH"
  exit 1
fi

cd "$VAULT_PATH"

# ── Validate selected folders ────────────────────────────────────────────────
if [[ "$SYNC_ALL" == false ]]; then
  IFS=',' read -ra FOLDERS <<< "$INCLUDE_FOLDERS"
  for folder in "${FOLDERS[@]}"; do
    folder="${folder// /}"
    if [[ ! -d "$folder" ]]; then
      echo "Error: Folder not found in vault: $folder"
      exit 1
    fi
  done
fi

# ── Build .gitignore content ─────────────────────────────────────────────────
build_gitignore() {
  if [[ "$SYNC_ALL" == true ]]; then
    cat <<'EOF'
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
EOF
  else
    echo "*"
    echo "!.gitignore"
    IFS=',' read -ra FOLDERS <<< "$INCLUDE_FOLDERS"
    for folder in "${FOLDERS[@]}"; do
      folder="${folder// /}"
      echo "!${folder}/"
      echo "!${folder}/**"
    done
  fi
}

NEW_GITIGNORE="$(build_gitignore)"

# ── Dry run ──────────────────────────────────────────────────────────────────
if [[ "$DRY_RUN" == true ]]; then
  echo ""
  if [[ "$SYNC_ALL" == true ]]; then
    echo "[dry-run] Mode: full vault"
  else
    echo "[dry-run] Mode: selected folders → ${INCLUDE_FOLDERS}"
  fi
  echo "[dry-run] .gitignore would be:"
  echo "---"
  echo "$NEW_GITIGNORE"
  echo "---"
  echo "[dry-run] No changes made."
  exit 0
fi

# ── Backup existing .gitignore ───────────────────────────────────────────────
if [[ -f ".gitignore" ]]; then
  BACKUP=".gitignore.bak.$(date +%Y%m%d%H%M%S)"
  cp ".gitignore" "$BACKUP"
  echo "Backed up .gitignore → $BACKUP"
fi

echo "$NEW_GITIGNORE" > ".gitignore"
echo ".gitignore written."

# ── Git init ─────────────────────────────────────────────────────────────────
if [[ ! -d ".git" ]]; then
  git init
  echo "Git repository initialized."
else
  echo "Git repository already exists."
fi

# ── Configure remote ─────────────────────────────────────────────────────────
if git remote | grep -q "^origin$"; then
  git remote set-url origin "$REMOTE_URL"
  echo "Remote 'origin' updated."
else
  git remote add origin "$REMOTE_URL"
  echo "Remote 'origin' set."
fi

# ── Stage files ──────────────────────────────────────────────────────────────
git add .gitignore

if [[ "$SYNC_ALL" == true ]]; then
  git add -A
else
  IFS=',' read -ra FOLDERS <<< "$INCLUDE_FOLDERS"
  for folder in "${FOLDERS[@]}"; do
    folder="${folder// /}"
    git add "$folder/"
  done
fi

# ── Commit ───────────────────────────────────────────────────────────────────
STATUS="$(git status --porcelain)"
if [[ -n "$STATUS" ]]; then
  git commit -m "$COMMIT_MSG"
  echo "Commit created."
else
  echo "Nothing new to commit."
fi

# ── Push ─────────────────────────────────────────────────────────────────────
CURRENT_BRANCH="$(git symbolic-ref --short HEAD 2>/dev/null || echo "$BRANCH")"
echo "Pushing '$CURRENT_BRANCH' to origin..."
git push -u origin "$CURRENT_BRANCH"

echo ""
echo "Done! Vault synced to GitHub."
if [[ "$SYNC_ALL" == true ]]; then
  echo "Mode: full vault"
else
  echo "Mode: selected folders → ${INCLUDE_FOLDERS}"
fi
echo "Next: Obsidian → Settings → Git → Automatic → set auto-sync interval to 30 min"
