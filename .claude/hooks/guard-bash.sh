#!/bin/bash
# H3 PreToolUse(Bash) hook: deny force-push and staging .env or node_modules (matches only where a git command starts); logs what was blocked, never the command text, because misses.md is pushed to a public repo.
cmd=$(jq -r '.tool_input.command // ""')
start='(^|[;&|(] *)'
what=""
if echo "$cmd" | grep -Eq "${start}git +push( [^;&|]*)? (-f|--force)"; then
  what="force-push"
elif echo "$cmd" | grep -Eq "${start}git +add( [^;&|]*)? [^ ;&|]*(\.env|node_modules)"; then
  what="staging .env or node_modules"
fi
[ -z "$what" ] && exit 0
cd "${CLAUDE_PROJECT_DIR:-.}" 2>/dev/null && mkdir -p claude-log && echo "$(date +%F) | miss | H3 | blocked: $what | $(git branch --show-current) | open" >> claude-log/misses.md
jq -n '{hookSpecificOutput:{hookEventName:"PreToolUse",permissionDecision:"deny",permissionDecisionReason:"CLAUDE.md: never force-push or commit .env/node_modules"}}'
