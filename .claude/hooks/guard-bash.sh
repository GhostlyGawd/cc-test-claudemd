#!/bin/bash
# H3 PreToolUse(Bash) hook: deny force-push and staging .env or node_modules (matches only where a git command starts).
cmd=$(jq -r '.tool_input.command // ""')
start='(^|[;&|(] *)'
if echo "$cmd" | grep -Eq "${start}git +push( [^;&|]*)? (-f|--force)|${start}git +add( [^;&|]*)? [^ ;&|]*(\.env|node_modules)"; then
  jq -n '{hookSpecificOutput:{hookEventName:"PreToolUse",permissionDecision:"deny",permissionDecisionReason:"CLAUDE.md: never force-push or commit .env/node_modules"}}'
fi
