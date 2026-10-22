# Pilot report (2026-10-22): 5 rules, 3 scenarios, 24 runs, 42 grades

Model for tests and grader: claude-sonnet-5-5 (pinned). Hooks off (scratch repo with only CLAUDE.md). 3 runs per cell. Raw results: `results-pilot.tsv`.

| Rule | With the line | Without the line | Pilot verdict | Confidence |
|---|---|---|---|---|
| R040 open the reply with the pushback | followed 2 of 3 | followed 0 of 3 | keep | low (3 runs per cell) |
| R098 open with the answer | followed 2 of 3 | followed 3 of 3 | redundant | low |
| R100 spell out acronyms | followed 1 of 3 | followed 0 of 3 | mostly ignored | low |
| R120 ping: one line, ask what I want | followed 3 of 3 | followed 3 of 3 | redundant in this fixture | low; see limit 2 |
| R051 read STATE.md on a project task | not triggered in all 9 runs | not triggered | untested | scenario was wrong; see limit 1 |

## Grader check
Grader and my hand labels agreed on 11 of 12 transcripts (target was 9 of 10). The one miss was R120 where a reply said "I haven't touched any files"; I read that as a small recap, the grader did not.

## Usage measured
24 test runs: 1,259,804 input tokens (about 52,500 each, mostly the repeated system prompt read from cache) and 12,798 output tokens. Wall time 68 seconds with 6 runs in parallel. The 42 grading calls took 85 seconds; their tokens were not captured (estimate: about 30,000 input each).

## Limits found
1. R051 can't be tested with a ping. Removing "read STATE.md" leaves nothing telling the model to read it, so a ping looks the same either way. It needs a project-task prompt where "followed" means the model opened STATE.md first.
2. A clean test repo can understate rules that exist to counter context. R120 was written after a ping got a 199-word briefing, but that briefing came from a session-start hook printing the goal line, which this fixture does not have. A "redundant" verdict on such a rule means "redundant in a clean session", not "safe to drop".
3. 3 runs per cell is thin: with the line, R040 was followed 2 of 3 and R098 2 of 3. Rules the report would drop need 6 runs.

## Full-run estimate (assumptions: about 35 scenarios, about 60% of rules followed in phase 1)
About 300 test runs and 500 grading calls: roughly 33 million input tokens (most of it cached repeated prefix) and 0.25 million output tokens, about 40 minutes of wall time. The input-token figure is the pilot's average scaled up; how much subscription usage cached input counts for is not known to me.
