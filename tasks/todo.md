# Task list: self-checking harness (see tasks/plan.md)

## T1: Install H1 and H3
**Description:** Add the two pipe-tested scripts and wire them in settings.json, merged with the existing plugin keys.
**Acceptance criteria:**
- [x] `.claude/hooks/stop-check.sh` and `.claude/hooks/guard-bash.sh` exist and are executable
- [x] `.claude/settings.json` keeps `extraKnownMarketplaces` and `enabledPlugins` and adds the Stop and PreToolUse(Bash) hooks plus deny rules for force-push and `.env` reads
**Verification:**
- [x] `bash -n` passes on both scripts; `jq -e '.hooks.Stop[0].hooks[0].command' .claude/settings.json` prints the command
- [x] Pipe-tests: clean tree exits 0 with no output; dirty tree blocks; `stop_hook_active:true` exits 0; force-push denied; normal push allowed (real output quoted)
**Dependencies:** None
**Files likely touched:** `.claude/settings.json`, `.claude/hooks/stop-check.sh`, `.claude/hooks/guard-bash.sh`
**Estimated scope:** Small (3 files)

## T2: Miss log
**Description:** Each block or deny appends one line to `claude-log/misses.md`; H1 ignores that file when checking for a dirty tree.
**Acceptance criteria:**
- [x] A triggered block writes exactly one line in the format `YYYY-MM-DD | miss | <hook id> | <what> | <branch> | open`
- [x] Old lines are never rewritten; the log write does not cause a second block
**Verification:**
- [x] Pipe-test twice: line count goes up by one per block, earlier lines unchanged (`wc -l` and `diff` quoted)
- [x] Dirty tree containing only `misses.md` does not block
**Dependencies:** T1
**Files likely touched:** `.claude/hooks/stop-check.sh`, `.claude/hooks/guard-bash.sh`, `claude-log/misses.md`
**Estimated scope:** Small (3 files)

## Checkpoint A (after T1-T2)
- [ ] All pipe-tests pass with quoted output; you review before T3

## T3: H4 session-start context
**Description:** A SessionStart hook prints the STATE.md goal line, branch, remote and push-ability, and warns on detached HEAD.
**Acceptance criteria:**
- [x] Output includes the goal line, branch name, and a detached-HEAD warning when applicable
- [x] The hook never blocks (no `onFailure: block`)
**Verification:**
- [x] Pipe-test `{"source":"startup"}` on a branch and on a detached HEAD; output quoted
**Dependencies:** T1
**Files likely touched:** `.claude/hooks/session-start.sh`, `.claude/settings.json`
**Estimated scope:** Small (2 files)

## T4: H2 answer-format check (gated)
**Description:** After the exemption decision, a Stop check that blocks once when `last_assistant_message` does not start with "You asked:" or end with "Saved and pushed:".
**Acceptance criteria:**
- [x] Compliant message passes; missing first line blocks; missing last line blocks; exempt short replies pass
- [x] One miss-log line per block
**Verification:**
- [x] Four pipe-tests with real output quoted
**Dependencies:** T2, your answer to open question 1
**Files likely touched:** `.claude/hooks/stop-check.sh`
**Estimated scope:** XS (1 file)

## Checkpoint B (after T3-T4)
- [ ] Scripts pass `bash -n`; settings.json valid; ready for the live test

## T5: Live test in a real session
**Description:** Start a fresh session on the branch and confirm each hook fires, including whether committed hooks need folder trust.
**Acceptance criteria:**
- [x] A turn ended with a dirty tree is blocked once, then allowed
- [x] `git push --force` on a throwaway ref is denied; a normal push is allowed
- [x] Session start shows the H4 context
**Verification:**
- [x] Transcript excerpts quoted; `claude-log/misses.md` shows one line per block
**Dependencies:** T1-T4
**Files likely touched:** none (observation); log entries only
**Estimated scope:** Small

## T6: Proposal for dropping rules
**Description:** A saved answer listing each CLAUDE.md rule the hooks now enforce, with line counts from `wc -l`.
**Acceptance criteria:**
- [x] Every proposed deletion names the hook that covers it and the test that proved it
**Verification:**
- [x] `wc -l` before/after of the proposed file quoted
**Dependencies:** T5
**Files likely touched:** `claude-log/answers/<date>-rules-to-drop.md`
**Estimated scope:** XS

## T7: Apply approved CLAUDE.md edit (gated by your approval)
**Description:** Delete only the rules you approve from T6.
**Acceptance criteria:**
- [x] Only approved rules removed; no other line changed (`git diff` shown)
**Verification:**
- [x] `wc -l CLAUDE.md` matches T6; no dangling references (`grep` for removed rule names)
**Dependencies:** T6, your approval
**Files likely touched:** `CLAUDE.md`
**Estimated scope:** XS

## Checkpoint C
- [ ] Miss log holds only real blocks; CLAUDE.md shorter by the counted amount; log and STATE.md updated

## T8: Fix the required findings from the retro review (done 2026-10-21)
**Description:** F1 (H1 missed unpushed commits without an upstream), F2 (H3 logged the raw command), F3 (tests lived only in /tmp).
**Acceptance criteria:**
- [x] `bash tests/hooks/run.sh` runs 41 checks from inside the repo and exits 0
- [x] Each fix had a failing test first: F1 two cases (no upstream, detached HEAD) failed 2 of 40, F2 three cases failed 3 of 41, then all passed
**Verification:**
- [x] Suite output quoted in the session: `passed 41, failed 0`
**Dependencies:** T1-T4
**Files touched:** `.claude/hooks/stop-check.sh`, `.claude/hooks/guard-bash.sh`, `tests/hooks/run.sh`
**Estimated scope:** Small
Not done (your call, in answers/2026-10-21-retro-review.md): F4 to F7.
