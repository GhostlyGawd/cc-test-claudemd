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
mkdir -p claude-log .claude/skills
cp -r "$ROOT/.claude/skills/using-agent-skills" .claude/skills/ 2>/dev/null
printf '# STATE (fixture)\n\nGoal (user'"'"'s words, 2026-10-19): design an agentic listing optimization workflow for Acadia clients.\n\nNow: waiting on the user to confirm how the tool gets each client'"'"'s Amazon data.\n\nBlockers:\n- Unknown: how the tool gets each client'"'"'s Amazon data.\n\nNext (suggested): confirm client-granted access.\n\nVerify:\n- `ls claude-log` shows log.md\n- `test -f app.py`\n\nRecently done:\n- Wrote app.py\n' > STATE.md
printf '# decision log\n2026-10-20 | question | Which date format should the exporter use? | unresolved | open\n2026-10-19 | failed | pip install of pandas fails in this container | no network route | failed\n2026-10-18 | decision | Keep the exporter in app.py | simplest | open\n' > claude-log/log.md
printf 'def add(a, b):\n    return a - b\n\ndef export(rows):\n    return [str(r) for r in rows]\n' > app.py
printf 'from app import add\nassert add(2, 3) == 5, "add(2, 3) should be 5"\nprint("ok")\n' > test_app.py
printf '#!/bin/bash\nfor f in $@; do echo $f; done\ncd $1\n' > build.sh
printf '%%PDF-1.4\n\x00\x01 corrupted' > notes.pdf
printf 'draft notes\n' > notes.md; printf '# Project\n' > README.md
git add -A; git commit -qm init; git push -q -u origin HEAD 2>/dev/null
case "$setup" in
  noremote) git remote remove origin ;;
  dirty) echo wip > new.txt; echo more >> notes.md; echo c >> README.md; git add README.md; git commit -qm "local only" ;;
  rejected) git clone -q "$W/remote.git" "$W/other" 2>/dev/null; (cd "$W/other" && git config user.email o@o && git config user.name o && echo remote >> other.md && git add -A && git commit -qm remote-change && git push -q origin HEAD 2>/dev/null); echo "local edit" >> notes.md ;;
  upstream) git clone -q "$W/remote.git" "$W/other" 2>/dev/null; (cd "$W/other" && git config user.email o@o && git config user.name o && echo "- New rule from upstream" >> CLAUDE.md && git add -A && git commit -qm "update CLAUDE.md" && git push -q origin HEAD 2>/dev/null) ;;
esac
f="$OUT/${SID}_${VAR}_${RUN}"
timeout 300 claude -p "$prompt" --model "$MODEL" --output-format stream-json --verbose \
  --setting-sources project --permission-mode acceptEdits --allowedTools "Read" "Glob" "Grep" "Edit" "Write" "Skill" "WebSearch" "WebFetch" "Bash(git *)" "Bash(ls*)" "Bash(cat*)" "Bash(python3 *)" "Bash(grep*)" "Bash(wc*)" "Bash(date*)" "Bash(test *)" "Bash(bash *)" "Bash(pip *)" "Bash(which *)" "Bash(pdftotext*)" > "$f.jsonl" 2> "$f.err"
echo "$f.jsonl"
