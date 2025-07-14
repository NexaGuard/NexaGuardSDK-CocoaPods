#!/usr/bin/env bash
# File: /Users/cybexo/Desktop/NexaGuardSDK-CocoaPods/push.sh
# Add‑commit‑rebase‑push in one go ─ robust against CI‑generated commits & tags
set -euo pipefail

msg=${1:-}

# ----------------------------------------------------------------------
# 0.   Make sure we see everything that exists on GitHub first
# ----------------------------------------------------------------------
git fetch --tags --prune origin            # grabs commits *and* tags

# ----------------------------------------------------------------------
# 1.   Stage *all* changes (feel free to refine if you only want subsets)
# ----------------------------------------------------------------------
git add -A

# ----------------------------------------------------------------------
# 2.   Commit with the user‑supplied message or drop into $EDITOR
# ----------------------------------------------------------------------
if [[ -n "$msg" ]]; then
  git commit -m "$msg"
else
  git commit
fi

# ----------------------------------------------------------------------
# 3.   Replay our new commit(s) on top of the latest remote copy
#      ▶︎ This is the step your earlier script missed.
# ----------------------------------------------------------------------
git rebase --autostash origin/main

# ----------------------------------------------------------------------
# 4.   Push *branch + tags* in one atomic request, but only if remote
#      hasn’t progressed in the meantime (“with‑lease” safety net)
# ----------------------------------------------------------------------
git push --follow-tags --atomic --force-with-lease origin HEAD:main
