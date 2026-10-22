# Todo: pressure test every line of CLAUDE.md (plan: tasks/plan-pressure-test.md)

Order follows risk: the cheapest check of the riskiest assumption comes first.

## Task 1: Can a headless test session run here?
**Description:** Run one `claude -p` session in a throwaway copy of the repo and capture its transcript.
- [x] A transcript file exists with the reply text and the model name (done 2026-10-21: `claude -p ... --output-format json` returned the reply, `modelUsage` and cost; about $0.025 per tiny run)
- [x] Hooks can be switched off for the run (a scratch copy with only a CLAUDE.md loads no hooks; `--bare` also skips them)
- Finding: one run listed claude-haiku-5-5 as the first model, so the runner must pin `--model claude-sonnet-5-5`.
**Verification:** quote the command and the first 20 lines of output.
**Dependencies:** none. **Scope:** XS (scratchpad only, no repo files).

## Task 2: Rule inventory
**Description:** One row per rule in CLAUDE.md with id, section, text, Why, observable.
- [x] Row count matches a hand count: 138 rows = 127 list items + 11 paragraph rules (Work log 6, Project state 5)
- [x] 29 rows have no Why because CLAUDE.md has none for them (Work log, Project state, Coding, Commit and push, file definitions); marked MISSING, not invented
**Verification:** re-read the file from disk; compare row count with the `grep` count per section.
**Dependencies:** none. **Files:** `tasks/pressure-test/rules.tsv`. **Scope:** S.

## Task 3: Sort rules into tracks H, G, N
**Description:** Add a track column and, for track G, a one-line scenario idea.
- [x] Every row has a track: G 106, H 24, N 8
- [x] 34 rows flagged as duplicate, overlapping or possibly conflicting (column `flags`)
**Verification:** re-read; count rows per track and quote the totals.
**Dependencies:** 2. **Files:** `tasks/pressure-test/rules.tsv`. **Scope:** S.

### Checkpoint A: after tasks 1-3
- [ ] Show you the track counts and the cost estimate (sessions x runs) before any test is run
- [ ] You approve scope: all sections, or the three highest-risk first

## Task 4: Track H check
**Description:** For each hook-checkable rule, confirm a hook test exists; list rules with no test; count hook blocks per rule in the miss log.
- [x] `bash tests/hooks/run.sh` output: passed 47, failed 0 (2026-10-22)
- [x] Track H rules with no hook or test: 17 of 24 (list in `tasks/pressure-test/track-h.md`)
**Verification:** quote the real run output.
**Dependencies:** 3. **Files:** `tasks/pressure-test/track-h.md`. **Scope:** S.

## Task 5: Scenario prompts for track G (pilot scenarios done; rest waits for checkpoint B)
**Description:** One prompt per rule cluster, with the rule ids it should trigger and the observable pass or fail.
- [ ] Every track G rule appears in at least one scenario
- [ ] Each scenario states what a "followed" and a "skipped" reply look like
**Verification:** re-read; coverage check that no track G id is missing.
**Dependencies:** 3. **Files:** `tasks/pressure-test/scenarios.md`. **Scope:** M.

## Task 6: Runner and grader, pilot on 5 rules
**Description:** A script that runs a scenario with a chosen CLAUDE.md variant N times, and a grader prompt. Pilot on 5 rules.
- [x] Grader matches hand labels on 11 of 12 transcripts
- [x] Pilot run end to end: 24 runs, 42 grades; usage in `tasks/pressure-test/pilot-report.md`
- Deviation: scenarios were written for the 5 pilot rules only; Task 5 for the other track G rules waits for checkpoint B, so no effort is spent if the pilot shows the method fails.
**Verification:** quote the script output and the agreement count.
**Dependencies:** 1, 5. **Files:** `tasks/pressure-test/run.sh`, `tasks/pressure-test/grader.md`. **Scope:** M.

### Checkpoint B: after tasks 4-6
- [x] Pilot cost and variance shown (pilot-report.md); you decide whether to run the full pass
- [ ] 3 runs per cell gave 2-of-3 results on the pilot: raise to 5 runs per cell for the full pass (decision needed)

## Task 7: Full ablation run (per section, one section per step)
**Description:** Run with-line then without-line for rules that were followed; record results as they finish.
- [ ] Results file updated after each section, not at the end
- [ ] Each rule has a verdict from the table in the plan
**Verification:** re-read the results file; row count equals track G rule count.
**Dependencies:** 6, checkpoint B approval. **Files:** `tasks/pressure-test/results.md`. **Scope:** L by run time, S by files; split by section.

## Task 8: Combined re-test of proposed drops
**Description:** Apply all proposed drops to one CLAUDE.md copy and rerun the scenarios.
- [ ] No rule that was "keep" regresses
**Verification:** quote before and after pass counts.
**Dependencies:** 7. **Files:** `tasks/pressure-test/results.md`. **Scope:** S.

## Task 9: Report and proposed edits
**Description:** Verdict table plus exact CLAUDE.md edits as text for your approval (rule 13); log entries; STATE.md updated.
- [ ] Report saved in `claude-log/answers/` and pushed
- [ ] Chat summary under 250 words
**Verification:** `git status --short` and `git log origin/<branch>..HEAD` both empty.
**Dependencies:** 8. **Files:** the answer file, `claude-log/log.md`, `STATE.md`. **Scope:** S.

### Checkpoint C: complete
- [ ] You have approved or rejected each proposed edit
