#!/bin/bash
# H4 SessionStart hook: print the STATE.md goal, branch and remote status as context; never blocks (always exits 0).
cat > /dev/null
cd "${CLAUDE_PROJECT_DIR:-.}" 2>/dev/null || exit 0
goal=$(grep -m1 -i '^goal' STATE.md 2>/dev/null)
branch=$(git branch --show-current 2>/dev/null)
remote=$(git remote get-url origin 2>/dev/null | sed 's#//[^@/]*@#//#')
echo "Harness check (SessionStart hook):"
echo "- STATE.md goal line: ${goal:-STATE.md missing or has no Goal line}"
if [ -z "$branch" ]; then
  echo "- WARNING: detached HEAD. Create a claude/<topic>-<date> branch before the first commit; the Stop hook cannot see unpushed commits here."
else
  echo "- Branch: $branch"
fi
if [ -z "$remote" ]; then
  echo "- WARNING: no origin remote, so nothing can be pushed."
elif timeout 10 git ls-remote --exit-code origin HEAD > /dev/null 2>&1; then
  echo "- Remote origin reachable: $remote"
else
  echo "- WARNING: origin not reachable (or has no HEAD): $remote"
fi
exit 0
