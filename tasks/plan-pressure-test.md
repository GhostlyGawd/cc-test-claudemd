# Plan: pressure test every line of CLAUDE.md (2026-10-21)

Status: plan only. Nothing in CLAUDE.md, `.claude/`, or `tests/` has been changed.
Scope: one-off. The STATE.md goal is unchanged and the Acadia work stays parked.
Skills: planning-and-task-breakdown. Skipped: the code skills, because nothing is implemented here.
Files: this plan and `tasks/todo-pressure-test.md`. The older `tasks/plan.md` and `tasks/todo.md` still have unchecked tasks, so they are left alone.

Assumed, not told by you: (a) a headless `claude -p` run works in this container, (b) you want verdicts for the model this session runs on, (c) a few hundred short test sessions is an acceptable cost. (a) was checked in Task 1 and holds. The Open questions section covers (b) and (c).

## Goal of the test
For every rule in CLAUDE.md, answer one question with evidence: does the model behave differently because this line exists? Each rule ends in one verdict:

| Verdict | Meaning | Action to propose |
|---|---|---|
| keep | followed with the line, skipped without it | none |
| redundant | followed with and without the line | drop it |
| ignored | skipped even with the line | rewrite it, or turn it into a hook (a script that checks on an event) |
| harmful | behavior is worse with the line | drop or reword it |
| untested | the scenario never triggered the rule | write a better scenario, no verdict yet |
| conflict | two rules demand opposite things in one scenario | report both rules (Rule maintenance case 3) |

## Method
1. **Inventory.** Split CLAUDE.md into one row per rule: id, section, text, its Why line, and a one-sentence observable ("the reply opens with the answer").
2. **Sort each rule into a track.**
   - Track H (hook-checkable): a script can decide pass or fail (pushed before done, no force-push, file re-read after write). Test with `tests/hooks/run.sh` plus count how often each hook blocked in `claude-log/misses.md`.
   - Track G (graded): needs a reader to decide (answer-first, labels, pushback with evidence). Test by ablation.
   - Track N (not testable): facts and definitions with no behavior (file locations, what STATE.md holds). Check only that they match reality.
3. **Ablation for Track G.** For each scenario prompt, run the full CLAUDE.md 3 times. A separate grader session, which sees only the rule, its Why, and the transcript, scores each run followed, skipped, or not triggered. Then, only for rules that were followed, run 3 more times with that one line removed and score again. Rules skipped with the line present are already "ignored", so they need no second run, which roughly halves the cost.
4. **Hooks off during ablation.** The Stop and guard hooks block bad behavior and would hide whether the written line mattered. Run ablation with hooks disabled, and test the hooks separately in Track H.
5. **Grader check.** Before trusting the grader, hand-label 10 transcripts and compare. Agreement below 9 of 10 means the grader prompt gets rewritten first.
6. **Report.** One table (rule, track, verdict, evidence, confidence) and a list of proposed CLAUDE.md edits as text, because rule 13 says edits to that file need your say-so.

## Risks
| Risk | Impact | Mitigation |
|---|---|---|
| 3 runs per cell is a small sample; model output varies | A one-off pass or fail gets read as a verdict | Mark any 2-of-3 cell low confidence; rerun with 6 for rules the report would drop |
| Removing one line at a time misses interactions between rules | A rule looks redundant only because another covers it | Re-test dropped rules together in one final run with all drops applied |
| A rule never triggered by my scenario looks dead | Wrong deletion | The "untested" verdict exists for this; never propose a drop on it |
| The grader is a model and can be wrong | Wrong verdicts | The 10-transcript hand check; spot-check 10% of verdicts |
| Verdicts hold for one model version | Stale after a model change | Record the model in every result; rerun after a switch |
| Test sessions write to the repo (logs, commits) | Pollutes history | Run each in a throwaway copy of the repo, delete after |

## Open questions
- Scope: all sections (user, 2026-10-21). Budget: estimate shown at checkpoint A, awaiting approval.
- Model: test the model this session runs on, or the one you use day to day?

## Tasks
Task details and checkpoints are in `tasks/todo-pressure-test.md`.
