#!/bin/bash
# H1 Stop hook: block ending the turn while work is uncommitted or unpushed (blind to unpushed commits on a detached HEAD).
in=$(cat)
[ "$(echo "$in" | jq -r '.stop_hook_active // false')" = "true" ] && exit 0
cd "${CLAUDE_PROJECT_DIR:-.}" || exit 0
dirty=$(git status --short)
unpushed=$(git log '@{u}..HEAD' --oneline 2>/dev/null)
[ -z "$dirty" ] && [ -z "$unpushed" ] && exit 0
jq -n --arg r "Unsaved work. git status: [$dirty] unpushed: [$unpushed]. Commit and push per CLAUDE.md Durable storage, or tell the user why not." '{decision:"block",reason:$r}'
