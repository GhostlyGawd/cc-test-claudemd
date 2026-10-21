# Todo: harness friction plan (2026-10-21)

Plan: `tasks/plan-friction.md`. Evidence: `claude-log/answers/2026-10-21-friction-verdicts.md`. One-off task; Acadia stays parked and the STATE.md goal is unchanged.

- [x] T1. Judging set run with the user (8 situations, 3 rounds), verdicts saved, plan and todo written, pushed to `claude/harness-friction-plan-2026-10-21`.
- [ ] T2. GATE: ask the user, in one AskUserQuestion call, to approve CLAUDE.md edits 1-12 (or a subset), the hook and test edits, and note that `settings.json` is not edited. Done when the answers are saved in the answers file.
- [ ] T3. Add the failing tests to `tests/hooks/run.sh` (H2 tests 1-9, H4 silent-when-healthy and no-goal-line) and delete the old H2 and H4 tests the plan lists. Done when the suite shows the new tests failing and the output is quoted.
- [ ] T4. Rewrite the H2 part of `stop-check.sh`. Done when the H2 tests pass and H1 tests still pass.
- [ ] T5. Make `session-start.sh` silent when healthy. Done when the H4 tests pass.
- [ ] T6. Apply the approved CLAUDE.md edits. Done when `wc -l CLAUDE.md` prints 431 or less.
- [ ] T7. Replay the eight situations in a fresh session and record word counts and labels (M2). Done when all eight are inside their limits, or the misses are listed.
- [ ] T8. GATE: ask before merging to main.
