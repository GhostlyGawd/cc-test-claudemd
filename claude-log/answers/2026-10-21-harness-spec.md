# Spec: self-checking harness (draft for review, 2026-10-21)

Source of intent: the confirmed Statement of Intent from the 2026-10-21 interview (fewer rules + hooks; hook-verified result per task; miss log updates automatically; CLAUDE.md and hook edits are proposed as text and wait for approval per rule 13; only the Acadia work is out of scope).
Phase 0 (capability map): skipped. The work is one capability (enforcement plus a miss log), small enough for one spec. If you want the rule pruning split into its own spec, say so.

## Assumptions I'm making (correct me now or I proceed with these)
1. VERIFIED in docs, NOT tested live: a repo's committed `.claude/settings.json` is read in a cloud session that has one repository and is not inside a Claude project (settings page, "Settings in cloud sessions"). In a project thread or a multi-repo session its hooks do not apply. Whether its hooks also wait for the folder-trust step is not stated.
2. VERIFIED in docs (hooks page, "Stop input"): a Stop hook receives `stop_hook_active` and `last_assistant_message` (the text of Claude's final reply). The docs say to prefer `last_assistant_message` over reading `transcript_path`, because the transcript may lag. H2 therefore uses `last_assistant_message`, not the transcript.
3. Hooks stay shell scripts using `bash` and `jq`; both exist in this container (jq ran in this session's pipe-tests).
4. The miss log lives at `claude-log/misses.md` inside the repo (Durable storage rule 1).
5. A block from a Stop hook makes me continue the turn once; `stop_hook_active` stops an endless loop.

## Objective
Make the checkable rules in CLAUDE.md run as hooks, so a skipped step is blocked or logged instead of relying on my memory, and use the logged misses as evidence for proposed rule edits.
User: you, reading on a phone. Success: every task ends with a hook-verified result, and each miss lands in a log that feeds proposed edits (see Success Criteria).

## Tech Stack
bash, jq, git. No new dependencies. Files: `.claude/settings.json` (existing, merge don't replace), `.claude/hooks/*.sh`, `claude-log/misses.md`.

## Commands
```
Test a hook:   echo '<json>' | CLAUDE_PROJECT_DIR=$PWD bash .claude/hooks/<name>.sh; echo "exit $?"
Validate JSON: jq -e '.hooks' .claude/settings.json
Syntax check:  bash -n .claude/hooks/<name>.sh
Repo state:    git status --short; git log origin/<branch>..HEAD --oneline
```

## Project Structure
```
.claude/settings.json        hook wiring + deny rules (merged with existing plugin keys)
.claude/hooks/stop-check.sh  H1: unsaved work, H2: required answer lines
.claude/hooks/guard-bash.sh  H3: block force-push and staging secrets
.claude/hooks/session-start.sh  H4: print goal, branch, remote, detached-HEAD warning
claude-log/misses.md         append-only miss log written by the hooks
claude-log/answers/          saved proposals (this file lives here)
```

## Hooks (what each checks and which prose it replaces)
| Id | Event | Check | Result | CLAUDE.md prose it could replace (after you approve) |
|---|---|---|---|---|
| H1 | Stop | dirty tree or unpushed commits | block once, log a miss | Durable storage 4, 10; Commit and push "before ending a session" |
| H2 | Stop | last reply starts with "You asked:" and ends with "Saved and pushed:" (reads `last_assistant_message`) | block once, log a miss; the harness stops honoring blocks after 8 in a row (hooks page, Stop) | Goal rule 3, Chat answers 7 |
| H3 | PreToolUse(Bash) | force-push, `git add` of `.env`/`node_modules` | deny | Commit and push: force-push and secrets bullets |
| H4 | SessionStart | none; prints STATE.md goal line, branch, remote, push-ability, warns on detached HEAD | context only | Project state "at session start", Durable storage 8 |
Pipe-tested already (2026-10-21, real output in `2026-10-21-harness-update.md`): H1 and H3 only. H2 and H4 are not written yet.

## Miss log
Format, one line per miss, append-only: `YYYY-MM-DD | miss | <hook id> | <what was skipped> | <session branch> | open`.
Written by the hook with `>>`, never rewritten. Rule review: when 3 or more `open` misses share a hook id or rule, I propose an edit as text in a saved answer and mark those lines `superseded` only after you decide. I never edit CLAUDE.md or the hooks myself.
Known risk: the hook's own write dirties the tree, which H1 would block on. Mitigation: H1 ignores `claude-log/misses.md` in its dirty check, and the log is committed with the next normal commit.

## Code Style
Each script: `#!/bin/bash`, one comment line stating its job, reads stdin once into `in`, exits 0 for allow, prints one JSON object for block/deny. Example (H1 as pipe-tested):
```bash
in=$(cat)
[ "$(echo "$in" | jq -r '.stop_hook_active // false')" = "true" ] && exit 0
```

## Testing Strategy
1. `bash -n` on every script and `jq -e` on settings.json.
2. Pipe-tests per hook with a clean case, a violating case, and `stop_hook_active:true` where relevant; quote real output.
3. One live session test per hook after install: end a turn with a dirty tree (expect block), attempt `git push --force` on a throwaway ref (expect deny), start a session (expect H4 output). If the settings watcher misses the new file you open `/hooks` or restart.
No coverage target; there is no application code.

## Boundaries
- Always: pipe-test before wiring; merge into the existing settings.json (keep `extraKnownMarketplaces` and `enabledPlugins`); show each diff before moving on; max 3 files per step (Coding rule).
- Ask first: installing any hook; editing CLAUDE.md; marking miss-log lines `superseded`; any hook that blocks rather than only logs.
- Never: edit CLAUDE.md unprompted (rule 13); let a hook rewrite or delete old log lines; use `onFailure: block` on H4 (a broken session-start must not lock the session); force-push.

## Success Criteria
1. All four scripts pass `bash -n` and their pipe-tests (clean, violating, loop-guard cases) with output quoted.
2. Live: a turn ended with a dirty tree is blocked once and then allowed (no loop).
3. Live: `git push --force` and `git add .env` are denied; `git push -u origin <branch>` is allowed.
4. Live: a new session prints the goal line, branch, and remote check, and warns on detached HEAD.
5. Each block writes exactly one line to `claude-log/misses.md` in the format above.
6. After install, I deliver one saved proposal listing which CLAUDE.md rules can be deleted, with line counts counted by `wc -l`, not estimated.

## Open Questions
1. Do you want H2 (answer-format check)? The field it needs now exists, but it will block any reply that lacks the two lines, including short replies like "Yes". Should short replies be exempt?
2. Should H1 also block when the tree is clean but the branch is detached?
3. Is `claude-log/misses.md` the right place, or should misses go into `log.md` with `miss` as a type?
4. Which comes first if you want to ship in pieces: H1 + H3 (already tested) or H4?

## Not checked
Docs check done 2026-10-21 (official pages only, so the sources share one origin: confidence medium, not high). Verified: Stop input fields and block format, PreToolUse deny format, SessionStart stdout/additionalContext, and that single-repo cloud sessions read the repo's settings.json.
Still not checked: hooks running live in this cloud session (needs an install and a test); whether committed hooks wait for folder trust; the last ~70,000 characters of the hooks page (offset 200000) and the cloud-environments page were not opened; the SessionStart timeout in cloud sessions; how many of the 451 lines the hooks would let us remove.
