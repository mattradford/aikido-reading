#!/usr/bin/env bash
set -euo pipefail

# Usage: ./deploy.sh "commit message"
MSG="${1:-Update $(date -u +"%Y-%m-%dT%H:%M:%SZ")}"

# operate from current working directory
REPO_DIR="$(pwd)"

# branch is always main
BRANCH="main"

echo "Fetching and pulling latest changes for branch: $BRANCH"
git -C "$REPO_DIR" fetch --all --prune
git -C "$REPO_DIR" pull --rebase origin "$BRANCH"

git -C "$REPO_DIR" add -A

# exit if nothing to commit
if git -C "$REPO_DIR" diff --cached --quiet; then
    echo "No changes to commit."
    exit 0
fi

git -C "$REPO_DIR" commit -m "$MSG"
echo "Committed changes with message: $MSG"

echo "Pushing to origin/$BRANCH"
git -C "$REPO_DIR" push origin "$BRANCH"
