#!/bin/bash
# Run one scenario with one CLAUDE.md variant in a throwaway repo and print the result as JSON.
# Usage: run.sh <scenario_file> <sid> <variant: full|Rxxx> <run#> <outdir>
set -u
HERE=$(cd "$(dirname "$0")" && pwd); ROOT=$(cd "$HERE/../.." && pwd)
SC=$1; SID=$2; VAR=$3; RUN=$4; OUT=$5
MODEL=${MODEL:-claude-sonnet-5-5}
mkdir -p "$OUT"
row=$(awk -F'\t' -v s="$SID" '$1==s' "$SC"); setup=$(echo "$row" | cut -f2); prompt=$(echo "$row" | cut -f3)
W=$(mktemp -d); trap 'rm -rf "$W"' EXIT
git init -q --bare "$W/remote.git"; git clone -q "$W/remote.git" "$W/work" 2>/dev/null; cd "$W/work" || exit 1
git config user.email t@t; git config user.name t
python3 -I "$HERE/variant.py" "$VAR" "$ROOT/CLAUDE.md" "$HERE/rules.tsv" > CLAUDE.md 2>/dev/null
mkdir -p claude-log
printf '# STATE (fixture)\n\nGoal (user'"'"'s words, 2026-10-19): design an agentic listing optimization workflow for Acadia clients.\n\nNow: waiting on the user to confirm how the tool gets each client'"'"'s Amazon data.\n' > STATE.md
printf '# decision log\n' > claude-log/log.md
git add -A; git commit -qm init; git push -q -u origin HEAD 2>/dev/null
f="$OUT/${SID}_${VAR}_${RUN}"
timeout 300 claude -p "$prompt" --model "$MODEL" --output-format stream-json --verbose \
  --setting-sources project --permission-mode acceptEdits --allowedTools "Read" "Glob" "Grep" "Bash(git *)" "Bash(ls*)" "Bash(cat*)" > "$f.jsonl" 2> "$f.err"
echo "$f.jsonl"
