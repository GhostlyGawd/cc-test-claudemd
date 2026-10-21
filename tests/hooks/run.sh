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

echo "== H2: answer format (40-word threshold)"
new_repo
OK=$(printf 'You asked: test.\n\n%s\n\nSaved and pushed: yes. Problems: none.' "$(words 45)")
t "H2 empty message allows"                allows "$(stop "$(msg '')")"
t "H2 39 words without format allows"      allows "$(stop "$(msg "$(words 39)")")"
n=$(lines); out=$(stop "$(msg "$(words 40)")")
t "H2 40 words without format blocks"      blocks "$out"
t "H2 missing both lines logs two misses"  is "$(( $(lines) - n ))" 2
t "H2 compliant reply allows"              allows "$(stop "$(msg "$OK")")"
t "H2 'You haven't asked' opener allows"   allows "$(stop "$(msg "$(printf "You haven't asked for anything yet.\n\n%s\n\nSaved and pushed: yes." "$(words 45)")")")"
t "H2 bold opener allows"                  allows "$(stop "$(msg "$(printf '**You asked:** x.\n\n%s\n\nSaved and pushed: yes.' "$(words 45)")")")"
t "H2 missing first line blocks"           blocks "$(stop "$(msg "$(printf '%s\n\nSaved and pushed: yes.' "$(words 45)")")")"
t "H2 missing last line blocks"            blocks "$(stop "$(msg "$(printf 'You asked: x.\n\n%s' "$(words 45)")")")"

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
n=$(lines); guard 'git status' > /dev/null
t "H3 allowed command logs nothing"        is "$(( $(lines) - n ))" 0

echo "== H4: session start"
new_repo
out=$(printf '{"source":"startup"}' | bash "$H/session-start.sh"); rc=$?
t "H4 exits 0"                             is "$rc" 0
t "H4 prints the goal line"                grep -q 'Goal: test goal' <<< "$out"
t "H4 prints the branch"                   grep -q 'Branch: ' <<< "$out"
t "H4 reports origin reachable"            grep -q 'Remote origin reachable' <<< "$out"
git checkout -q --detach
t "H4 warns on detached HEAD"              grep -q 'detached HEAD' <<< "$(printf '{}' | bash "$H/session-start.sh")"
git remote remove origin
t "H4 warns when there is no origin"       grep -q 'no origin remote' <<< "$(printf '{}' | bash "$H/session-start.sh")"

echo; echo "passed $pass, failed $fail"; [ "$fail" -eq 0 ]
