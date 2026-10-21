#!/bin/bash
# H4 SessionStart hook: print a WARNING only when the branch or origin remote is unusable; silent when healthy; never blocks (always exits 0).
cat > /dev/null
cd "${CLAUDE_PROJECT_DIR:-.}" 2>/dev/null || exit 0
branch=$(git branch --show-current 2>/dev/null)
remote=$(git remote get-url origin 2>/dev/null | sed 's#//[^@/]*@#//#')
if [ -z "$branch" ]; then
  echo "WARNING: detached HEAD. Create a claude/<topic>-<date> branch before the first commit; the Stop hook cannot see unpushed commits here."
fi
if [ -z "$remote" ]; then
  echo "WARNING: no origin remote, so nothing can be pushed."
elif ! timeout 10 git ls-remote --exit-code origin HEAD > /dev/null 2>&1; then
  echo "WARNING: origin not reachable (or has no HEAD): $remote"
fi
exit 0
