# Todo: pressure test every line of CLAUDE.md (plan: tasks/plan-pressure-test.md)

Order follows risk: the cheapest check of the riskiest assumption comes first.

## Task 1: Can a headless test session run here?
**Description:** Run one `claude -p` session in a throwaway copy of the repo and capture its transcript.
- [ ] A transcript file exists with the reply text and the model name
- [ ] Hooks can be switched off for the run
**Verification:** quote the command and the first 20 lines of output.
**Dependencies:** none. **Scope:** XS (scratchpad only, no repo files).

## Task 2: Rule inventory
**Description:** One row per rule in CLAUDE.md with id, section, text, Why, observable.
- [ ] Row count matches a hand count of numbered and bulleted rules per section
- [ ] No row is missing its Why
**Verification:** re-read the file from disk; compare row count with the `grep` count per section.
**Dependencies:** none. **Files:** `tasks/pressure-test/rules.md`. **Scope:** S.

## Task 3: Sort rules into tracks H, G, N
**Description:** Add a track column and, for track G, a one-line scenario idea.
- [ ] Every row has a track
- [ ] Rules that look duplicated or opposed are flagged with the other rule's id
**Verification:** re-read; count rows per track and quote the totals.
**Dependencies:** 2. **Files:** `tasks/pressure-test/rules.md`. **Scope:** S.

### Checkpoint A: after tasks 1-3
- [ ] Show you the track counts and the cost estimate (sessions x runs) before any test is run
- [ ] You approve scope: all sections, or the three highest-risk first

## Task 4: Track H check
**Description:** For each hook-checkable rule, confirm a hook test exists; list rules with no test; count hook blocks per rule in the miss log.
- [ ] `bash tests/hooks/run.sh` output quoted, all pass
- [ ] A list of track H rules with no hook or no test
**Verification:** quote the real run output.
**Dependencies:** 3. **Files:** `tasks/pressure-test/track-h.md`. **Scope:** S.

## Task 5: Scenario prompts for track G
**Description:** One prompt per rule cluster, with the rule ids it should trigger and the observable pass or fail.
- [ ] Every track G rule appears in at least one scenario
- [ ] Each scenario states what a "followed" and a "skipped" reply look like
**Verification:** re-read; coverage check that no track G id is missing.
**Dependencies:** 3. **Files:** `tasks/pressure-test/scenarios.md`. **Scope:** M.

## Task 6: Runner and grader, pilot on 5 rules
**Description:** A script that runs a scenario with a chosen CLAUDE.md variant N times, and a grader prompt. Pilot on 5 rules.
- [ ] Grader matches 9 of 10 hand-labeled transcripts
- [ ] Script run quoted end to end, with the cost of the pilot
**Verification:** quote the script output and the agreement count.
**Dependencies:** 1, 5. **Files:** `tasks/pressure-test/run.sh`, `tasks/pressure-test/grader.md`. **Scope:** M.

### Checkpoint B: after tasks 4-6
- [ ] Pilot cost and variance shown; you decide whether to run the full pass
- [ ] If 3 runs give inconsistent scores on the pilot, raise runs per cell before continuing

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
