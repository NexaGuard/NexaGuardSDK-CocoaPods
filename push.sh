#!/usr/bin/env bash
# push.sh  —  Add, commit, and push in one go
# Usage:
#   ./push.sh "your commit message"
#   ./push.sh                        # → opens $EDITOR for message

set -euo pipefail

msg="${1:-}"

# 1. stage everything
git add .

# 2. commit (with dynamic message)
if [[ -n "$msg" ]]; then
  git commit -m "$msg"
else
  # no message passed – open editor for interactive commit
  git commit
fi

# 3. push to current branch / set upstream if first time
branch=$(git rev-parse --abbrev-ref HEAD)
git push -u origin "$branch"

