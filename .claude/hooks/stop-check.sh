#!/bin/bash
# H1 Stop hook: block ending the turn while work is uncommitted or unpushed, and log the miss (blind to unpushed commits on a detached HEAD).
in=$(cat)
[ "$(echo "$in" | jq -r '.stop_hook_active // false')" = "true" ] && exit 0
cd "${CLAUDE_PROJECT_DIR:-.}" || exit 0
dirty=$(git status --short | grep -v ' claude-log/misses.md$')
unpushed=$(git log '@{u}..HEAD' --oneline 2>/dev/null)
[ -z "$dirty" ] && [ -z "$unpushed" ] && exit 0
what="${dirty:+uncommitted changes}${dirty:+${unpushed:+ and }}${unpushed:+unpushed commits}"
mkdir -p claude-log && echo "$(date +%F) | miss | H1 | turn ended with $what | $(git branch --show-current) | open" >> claude-log/misses.md
jq -n --arg r "Unsaved work. git status: [$dirty] unpushed: [$unpushed]. Commit and push per CLAUDE.md Durable storage, or tell the user why not." '{decision:"block",reason:$r}'
