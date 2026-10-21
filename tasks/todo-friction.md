# Todo: harness friction plan (2026-10-21)

Plan: `tasks/plan-friction.md`. Evidence: `claude-log/answers/2026-10-21-friction-verdicts.md`. One-off task; Acadia stays parked and the STATE.md goal is unchanged.

- [x] T1. Judging set run with the user (8 situations, 3 rounds), verdicts saved, plan and todo written, pushed to `claude/harness-friction-plan-2026-10-21`.
- [x] T2. GATE: the user said "Implement" (2026-10-21), read as approval of edits 1-12, the hook and test edits and no settings.json edit; later the user asked for three git allow rules in settings.json, added at their request.
- [x] T3. Add the failing tests to `tests/hooks/run.sh` (H2 tests 1-9, H4 silent-when-healthy and no-goal-line) and delete the old H2 and H4 tests the plan lists. Done when the suite shows the new tests failing and the output is quoted.
- [x] T4. Rewrite the H2 part of `stop-check.sh`. Done when the H2 tests pass and H1 tests still pass.
- [x] T5. Make `session-start.sh` silent when healthy. Done when the H4 tests pass.
- [x] T6. Apply the approved CLAUDE.md edits. Done when `wc -l CLAUDE.md` prints 431 or less.
- [x] T7. Replay of the eight situations in a fresh session: the user judged it by eye ("Everything looked good", 2026-10-21); word and label counts were not recorded.
- [x] T8. GATE: the user said "merge it to main" (2026-10-21); merged with a conflict in log.md resolved by keeping both sides.
