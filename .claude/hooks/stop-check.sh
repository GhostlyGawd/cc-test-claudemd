#!/bin/bash
# H1+H2 Stop hook: block while work is unsaved (H1: uncommitted changes, or commits that are on no remote branch) or a reply under SHORT_WORDS words carries a template line such as "You asked:" or "Saved and pushed:" (H2); log each miss.
SHORT_WORDS=100
in=$(cat)
[ "$(echo "$in" | jq -r '.stop_hook_active // false')" = "true" ] && exit 0
cd "${CLAUDE_PROJECT_DIR:-.}" || exit 0
branch=$(git branch --show-current)
reasons=""
miss() { mkdir -p claude-log && echo "$(date +%F) | miss | $1 | $2 | $branch | open" >> claude-log/misses.md; }

dirty=$(git status --short | grep -v ' claude-log/misses.md$')
unpushed=""; [ -n "$(git remote)" ] && unpushed=$(git log HEAD --not --remotes --oneline 2>/dev/null)
if [ -n "$dirty$unpushed" ]; then
  what="${dirty:+uncommitted changes}${dirty:+${unpushed:+ and }}${unpushed:+unpushed commits}"
  miss H1 "turn ended with $what"
  reasons="Unsaved work. git status: [$dirty] unpushed: [$unpushed]. Commit and push per CLAUDE.md Durable storage, or tell the user why not."
fi

msg=$(echo "$in" | jq -r '.last_assistant_message // ""')
if [ "$(echo "$msg" | wc -w)" -lt "$SHORT_WORDS" ]; then
  label=$(echo "$msg" | sed 's/^[[:space:]*#>_-]*//' | grep -m1 -oE "^(You asked:|You haven.t asked|Goal:|Matches goal:|Saved and pushed:|Answer:|Why:|What I need from you:|Not verified:)")
  if [ -n "$label" ]; then
    miss H2 "ceremony in short reply: $label"
    reasons="$reasons Short reply (under $SHORT_WORDS words): drop the template line '$label' and answer in plain sentences per CLAUDE.md Chat answers 5 and 7."
  fi
fi

[ -z "$reasons" ] && exit 0
jq -n --arg r "$reasons" '{decision:"block",reason:$r}'
