# Harness update proposal, 2026-10-21 (nothing applied)

Goal line: one-off task, chosen by the user on 2026-10-21; STATE.md goal (Acadia workflow) unchanged.
Scope chosen by the user: both the CLAUDE.md rules and settings/hooks.
Differs from request: nothing is applied, because CLAUDE.md rule 13 forbids editing CLAUDE.md unprompted and "Coding" says new features/larger changes wait for approval. Hook scripts below were pipe-tested only, not installed.

## Key finding
The 2026-10-19 audit fixes (H-001..H-007) were approved ("Apply") but live only on branch `origin/claude/harness-audit-4zvuyi` (commit 2679a62). `main` (3c9325c) and this session's CLAUDE.md still have every defect: duplicate section (lines 85-110 vs 126-150, only a divider differs), `~/claude-log` paths that don't exist, dangling "Ask vs. proceed rule" (line 402), conflicting closing lines. Evidence: `git diff 32cf618 origin/claude/harness-audit-4zvuyi --stat` shows CLAUDE.md, .gitignore, audit answer and log changed; `git log origin/main..HEAD` empty and main has no such commit.
Fix: merge that branch into main (expected conflict only in claude-log/log.md, both sides append).

## Still-open rule problems (after the merge)
1. Three different first lines are demanded: "You asked:" (Who sets the goal 3), "first sentence is the answer" (Writing style), "Open with the answer" (Chat answers 1). The branch resolves Writing style only; Chat answers 1 still says never recap. Proposed: change Chat answers 1 to "After the 'You asked:' line, open with the answer".
2. Goal-alignment rule 2 (one "Goal: ... This task: ..." line at the start of every task) collides with Chat answers 2 (no narration). Proposed: allow it as the single permitted line.
3. Session start requires reading STATE.md and checking push ability, but nothing forces it. See hooks.
4. CLAUDE.md is ~480 lines (~8,000 tokens) loaded every session; adherence drops as rules pile up (inferred, not measured). Rules that a script can check should move out of prose (hooks below), then the prose can shrink.
5. Detached HEAD: this session started on a detached HEAD at main, so "push the current branch" has no meaning. Proposed rule under "Commit and push": if HEAD is detached, create `claude/<topic>-<date>` before the first commit.

## Proposed hooks (project `.claude/settings.json`, merged with the existing plugin entries)
Existing file has only `extraKnownMarketplaces` and `enabledPlugins`; there are no hooks and no permission rules today.

Enforced by hook, then deletable from prose:
- Durable storage 4 and 10 (nothing unpushed): Stop hook below.
- Commit and push (never force-push, never commit .env/node_modules): PreToolUse(Bash) guard below plus a `permissions.deny`.
- Project state / Durable storage 8 (read STATE.md, check remote at start): SessionStart hook (not written yet; would print STATE.md head, `git remote -v`, branch name, and warn on detached HEAD).

```json
{
  "hooks": {
    "Stop": [{ "hooks": [{ "type": "command", "command": "bash .claude/hooks/stop-check.sh", "timeout": 20 }] }],
    "PreToolUse": [{ "matcher": "Bash", "hooks": [{ "type": "command", "command": "bash .claude/hooks/guard-bash.sh", "timeout": 10 }] }]
  },
  "permissions": { "deny": ["Bash(git push --force*)", "Bash(git push -f*)", "Read(.env*)"] }
}
```

`.claude/hooks/stop-check.sh`:
```bash
#!/bin/bash
# Stop hook: block ending the turn while work is uncommitted or unpushed.
in=$(cat)
[ "$(echo "$in" | jq -r '.stop_hook_active // false')" = "true" ] && exit 0
cd "${CLAUDE_PROJECT_DIR:-.}" || exit 0
dirty=$(git status --short)
unpushed=$(git log '@{u}..HEAD' --oneline 2>/dev/null)
[ -z "$dirty" ] && [ -z "$unpushed" ] && exit 0
jq -n --arg r "Unsaved work. git status: [$dirty] unpushed: [$unpushed]. Commit and push per CLAUDE.md Durable storage, or tell the user why not." '{decision:"block",reason:$r}'
```

`.claude/hooks/guard-bash.sh`:
```bash
#!/bin/bash
# PreToolUse(Bash): deny force-push and staging secrets.
cmd=$(jq -r '.tool_input.command // ""')
if echo "$cmd" | grep -Eq 'git +push.*( -f|--force)|git +add.*(\.env|node_modules)'; then
  jq -n '{hookSpecificOutput:{hookEventName:"PreToolUse",permissionDecision:"deny",permissionDecisionReason:"CLAUDE.md: never force-push or commit .env/node_modules"}}'
fi
```

Pipe-test results (this session, real output):
- stop-check, clean tree: no output, exit 0. Dirty tree (`?? zz-test.txt`): printed `{"decision":"block","reason":"Unsaved work. git status: [?? zz-test.txt] unpushed: [] ..."}`. With `stop_hook_active:true`: exit 0 (loop guard works).
- guard-bash: `git push --force origin main` and `git add .env` printed a `permissionDecision: deny` JSON; `git push -u origin main` printed nothing (allowed).
Known limits: on a detached HEAD `@{u}` does not exist, so unpushed commits are not detected (the dirty check still works); the regex guard misses `git push origin +main`; the Stop hook also fires on turns that only answered a question in a dirty tree, which is the intended strictness but may annoy.

## Decisions needed
1. Merge `claude/harness-audit-4zvuyi` into main (restores the approved fixes).
2. Apply the five rule edits above (CLAUDE.md edit, needs your say-so per rule 13).
3. Install the two hooks plus deny rules (3 files: settings.json and two scripts).

## Not checked
- Hook JSON format taken from the update-config skill text in this session, not from current official docs.
- Hooks not installed, so not tested inside a live session; the settings watcher may need `/hooks` or a restart.
- Whether hooks run in cloud sessions for this repo: not tested.
- Adherence effect of shortening CLAUDE.md: inference, no measurement.
- No secret scan run.
