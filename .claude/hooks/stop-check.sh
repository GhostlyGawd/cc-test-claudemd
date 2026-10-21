#!/bin/bash
# H1+H2 Stop hook: block while work is unsaved (H1, blind to unpushed commits on a detached HEAD) or a reply of MIN_WORDS+ lacks its "You asked:" first line or "Saved and pushed:" last line (H2); log each miss.
MIN_WORDS=40
in=$(cat)
[ "$(echo "$in" | jq -r '.stop_hook_active // false')" = "true" ] && exit 0
cd "${CLAUDE_PROJECT_DIR:-.}" || exit 0
branch=$(git branch --show-current)
reasons=""
miss() { mkdir -p claude-log && echo "$(date +%F) | miss | $1 | $2 | $branch | open" >> claude-log/misses.md; }

dirty=$(git status --short | grep -v ' claude-log/misses.md$')
unpushed=$(git log '@{u}..HEAD' --oneline 2>/dev/null)
if [ -n "$dirty$unpushed" ]; then
  what="${dirty:+uncommitted changes}${dirty:+${unpushed:+ and }}${unpushed:+unpushed commits}"
  miss H1 "turn ended with $what"
  reasons="Unsaved work. git status: [$dirty] unpushed: [$unpushed]. Commit and push per CLAUDE.md Durable storage, or tell the user why not."
fi

msg=$(echo "$in" | jq -r '.last_assistant_message // ""')
if [ "$(echo "$msg" | wc -w)" -ge "$MIN_WORDS" ]; then
  first=$(echo "$msg" | grep -m1 '[^[:space:]]' | sed 's/^[[:space:]*#>_-]*//')
  last=$(echo "$msg" | grep '[^[:space:]]' | tail -1 | sed 's/^[[:space:]*#>_-]*//')
  case "$first" in "You asked:"*|"You haven't asked"*) ;; *)
    miss H2 "reply of $MIN_WORDS+ words did not open with a 'You asked:' line"
    reasons="$reasons Reply must open with one line starting 'You asked:' (or 'You haven't asked for anything yet.') per CLAUDE.md Who sets the goal 3." ;;
  esac
  case "$last" in "Saved and pushed:"*) ;; *)
    miss H2 "reply of $MIN_WORDS+ words did not end with a 'Saved and pushed:' line"
    reasons="$reasons Reply must end with 'Saved and pushed: yes/no. Problems: ...' per CLAUDE.md Chat answers 7." ;;
  esac
fi

[ -z "$reasons" ] && exit 0
jq -n --arg r "$reasons" '{decision:"block",reason:$r}'
