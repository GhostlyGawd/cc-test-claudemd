#!/bin/bash
# Tests for the hooks in .claude/hooks. Run: bash tests/hooks/run.sh   (exit 0 = all pass, 1 = any failure)
ROOT=$(cd "$(dirname "$0")/../.." && pwd); H=$ROOT/.claude/hooks
T=$(mktemp -d); trap 'rm -rf "$T"' EXIT
pass=0; fail=0
t() { # name, then a command whose exit status is the verdict
  local name=$1; shift
  if "$@"; then pass=$((pass+1)); printf 'PASS  %s\n' "$name"; else fail=$((fail+1)); printf 'FAIL  %s\n' "$name"; fi
}
new_repo() { # work repo with one pushed commit, STATE.md and a misses.md header; sets CLAUDE_PROJECT_DIR
  rm -rf "$T/remote.git" "$T/work"
  git init -q --bare "$T/remote.git"; git clone -q "$T/remote.git" "$T/work" 2>/dev/null; cd "$T/work" || exit 1
  git config user.email t@t; git config user.name t
  mkdir claude-log; printf '# header\n' > claude-log/misses.md; printf '# STATE\nGoal: test goal\n' > STATE.md
  git add -A; git commit -qm init; git push -q -u origin HEAD 2>/dev/null
  export CLAUDE_PROJECT_DIR=$PWD
}
stop()      { printf '%s' "$1" | bash "$H/stop-check.sh"; }
msg()       { jq -n --arg m "$1" '{last_assistant_message:$m}'; }
words()     { yes word | head -n "$1" | tr '\n' ' '; }
blocks()    { [ "$(echo "$1" | jq -r .decision 2>/dev/null)" = block ]; }
allows()    { [ -z "$1" ]; }
lines()     { wc -l < claude-log/misses.md; }
guard()     { local d; d=$(printf '{"tool_input":{"command":%s}}' "$(jq -Rn --arg c "$1" '$c')" | bash "$H/guard-bash.sh" | jq -r '.hookSpecificOutput.permissionDecision // empty'); echo "${d:-allow}"; }
is()        { [ "$1" = "$2" ]; }
commit_f()  { echo "$RANDOM" >> f; git add f; git commit -qm c; }

echo "== H1: unsaved work"
new_repo
t "H1 clean pushed tree allows"            allows "$(stop '{}')"
touch x; n=$(lines); out=$(stop '{}')
t "H1 untracked file blocks"               blocks "$out"
t "H1 block logs exactly one line"         is "$(( $(lines) - n ))" 1
t "H1 loop guard allows when already continuing" allows "$(stop '{"stop_hook_active":true}')"
rm x; echo extra >> claude-log/misses.md
t "H1 tree dirty only by misses.md allows" allows "$(stop '{}')"
git checkout -q claude-log/misses.md
commit_f
t "H1 unpushed commit (has upstream) blocks" blocks "$(stop '{}')"
new_repo; git checkout -q -b feature; commit_f
t "H1 unpushed commit on branch with no upstream blocks" blocks "$(stop '{}')"
new_repo; git checkout -q --detach; commit_f
t "H1 unpushed commit on detached HEAD blocks" blocks "$(stop '{}')"
new_repo; git remote remove origin
t "H1 repo with no remote and clean tree allows" allows "$(stop '{}')"

echo "== H2: no template lines in short replies (under 100 words)"
new_repo
t "H2 empty message allows"                allows "$(stop "$(msg '')")"
t "H2 39 words plain allows"               allows "$(stop "$(msg "$(words 39)")")"
t "H2 42-word plain reply allows"          allows "$(stop "$(msg "$(words 42)")")"
t "H2 90-word plain reply allows"          allows "$(stop "$(msg "$(words 90)")")"
t "H2 150-word report with sections allows" allows "$(stop "$(msg "$(printf 'You asked: x.\n\nAnswer: x.\n\n%s\n\nSaved and pushed: yes.' "$(words 150)")")")"
n=$(lines); out=$(stop "$(msg "$(printf 'You asked: SECRETWORD please.\n\n%s' "$(words 10)")")")
t "H2 opener line in a short reply blocks" blocks "$out"
t "H2 ceremony block logs exactly one line" is "$(( $(lines) - n ))" 1
t "H2 log names the label"                 grep -q 'H2 | ceremony in short reply: You asked:' claude-log/misses.md
t "H2 log never stores reply text"         bash -c '! grep -q SECRETWORD claude-log/misses.md'
t "H2 'You haven't asked' opener blocks"   blocks "$(stop "$(msg "$(printf "You haven't asked for anything yet.\n\n%s" "$(words 10)")")")"
t "H2 closing status line in a short reply blocks" blocks "$(stop "$(msg "$(printf '%s\n\nSaved and pushed: yes.' "$(words 30)")")")"
t "H2 bold Answer label in a short reply blocks"   blocks "$(stop "$(msg "$(printf '**Answer:** %s' "$(words 60)")")")"
t "H2 Goal line in a short reply blocks"           blocks "$(stop "$(msg "$(printf 'Goal: x.\n\n%s' "$(words 20)")")")"
t "H2 Matches goal line in a short reply blocks"   blocks "$(stop "$(msg "$(printf '%s\n\nMatches goal: yes.' "$(words 20)")")")"
t "H2 loop guard allows a flagged reply"           allows "$(stop "$(jq -n --arg m "You asked: x. $(words 10)" '{stop_hook_active:true,last_assistant_message:$m}')")"

echo "== H3: command guard"
new_repo
for c in 'git push --force origin main' 'git push -f' 'git push origin main --force' 'git add .env' 'git add src node_modules' 'cd x && git push --force'; do
  t "H3 denies: $c" is "$(guard "$c")" deny
done
for c in 'git push -u origin main' 'git add README.md' 'git commit -m "never git push --force"' 'echo git push --force' 'grep -c "git add .env" CLAUDE.md' 'git status'; do
  t "H3 allows: $c" is "$(guard "$c")" allow
done
n=$(lines); guard 'git push -f' > /dev/null
t "H3 deny logs exactly one line"          is "$(( $(lines) - n ))" 1
guard 'git push --force https://user:SECRET123@example.com/x/y.git' > /dev/null
t "H3 log never stores the denied command text" bash -c '! grep -q SECRET123 claude-log/misses.md'
t "H3 log names what was blocked"          grep -q 'H3 | blocked: force-push' claude-log/misses.md
guard 'git add .env' > /dev/null
t "H3 log names a blocked secret staging"  grep -q 'H3 | blocked: staging .env or node_modules' claude-log/misses.md
n=$(lines); guard 'git status' > /dev/null
t "H3 allowed command logs nothing"        is "$(( $(lines) - n ))" 0

echo "== H4: session start (silent when healthy)"
new_repo
out=$(printf '{"source":"startup"}' | bash "$H/session-start.sh"); rc=$?
t "H4 exits 0"                             is "$rc" 0
t "H4 prints nothing when healthy"         is "$out" ""
t "H4 healthy output has no goal line"     bash -c '! grep -q Goal <<< "$1"' _ "$out"
git checkout -q --detach
out=$(printf '{}' | bash "$H/session-start.sh")
t "H4 warns on detached HEAD"              grep -q 'detached HEAD' <<< "$out"
t "H4 warning output has no goal line"     bash -c '! grep -q Goal <<< "$1"' _ "$out"
git remote remove origin
t "H4 warns when there is no origin"       grep -q 'no origin remote' <<< "$(printf '{}' | bash "$H/session-start.sh")"

echo; echo "passed $pass, failed $fail"; [ "$fail" -eq 0 ]
