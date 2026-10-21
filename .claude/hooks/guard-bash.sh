#!/bin/bash
# H3 PreToolUse(Bash) hook: deny force-push and staging .env or node_modules (matches only where a git command starts), and log the miss.
cmd=$(jq -r '.tool_input.command // ""')
start='(^|[;&|(] *)'
if echo "$cmd" | grep -Eq "${start}git +push( [^;&|]*)? (-f|--force)|${start}git +add( [^;&|]*)? [^ ;&|]*(\.env|node_modules)"; then
  cd "${CLAUDE_PROJECT_DIR:-.}" 2>/dev/null && mkdir -p claude-log && echo "$(date +%F) | miss | H3 | denied: $(echo "$cmd" | tr '\n|' ' /' | cut -c1-80) | $(git branch --show-current) | open" >> claude-log/misses.md
  jq -n '{hookSpecificOutput:{hookEventName:"PreToolUse",permissionDecision:"deny",permissionDecisionReason:"CLAUDE.md: never force-push or commit .env/node_modules"}}'
fi
