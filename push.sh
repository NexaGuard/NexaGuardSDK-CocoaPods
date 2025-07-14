#!/usr/bin/env bash
# File: /Users/cybexo/Desktop/NexaGuardSDK-CocoaPods/push.sh
# One‑command publish: add → commit → rebase → push (auto‑retry, signature‑clean)

set -euo pipefail
msg=${1:-}

# ──────────────────────────────────────────────────────────────
# 0. Sync against origin *before* we touch anything
# ──────────────────────────────────────────────────────────────
git fetch --tags --prune origin

# ──────────────────────────────────────────────────────────────
# 1. Remove all _CodeSignature folders so they never reach Git
# ──────────────────────────────────────────────────────────────
find NexaGuardSDK.xcframework -name _CodeSignature -type d -exec rm -rf {} +

# ──────────────────────────────────────────────────────────────
# 2. Stage and (optionally) commit
# ──────────────────────────────────────────────────────────────
git add -A

if ! git diff --cached --quiet; then
  if [[ -n "$msg" ]]; then
    git commit -m "$msg"
  else
    git commit       # opens $EDITOR
  fi
else
  echo "🔄 Nothing to commit; will just sync tags"
fi

# ──────────────────────────────────────────────────────────────
# 3. Rebase on top of the freshest origin/main
# ──────────────────────────────────────────────────────────────
git rebase --autostash origin/main

# ──────────────────────────────────────────────────────────────
# 4. Push branch + tags atomically.
#    If someone (or CI) beat us by a millisecond, auto‑retry once.
# ──────────────────────────────────────────────────────────────
until git push --follow-tags --atomic --force-with-lease origin HEAD:main
do
  echo "⚠️  Push race detected — rebasing and retrying"
  git fetch --tags --prune origin
  git rebase --autostash origin/main
done

echo "✅  Push complete — CI will take it from here"
