# Track H: rules a script can check (24 rules, run 2026-10-22)

Hook tests: `bash tests/hooks/run.sh` -> "passed 47, failed 0".
Miss log (claude-log/misses.md): H1 5 blocks (4 still open), H2 1, H3 1. H4 logs nothing.

## Covered by a hook today (7)
| Rule | Hook | What the hook does not cover |
|---|---|---|
| R060 commit after each change | H1 | only checks at turn end, not "before any risky change" |
| R061 push after every commit | H1 | does not check the main vs wip/ branch choice |
| R063 never commit .env, keys, node_modules, build output | H3 | covers .env and node_modules only, not keys, credentials or build output |
| R086 commit and push after a log write | H1 | same as R061 |
| R088 git status and git log empty after push | H1 | checks the result, not that the commands were run |
| R089 never force-push | H3 | covers `git push -f/--force` only |
| R104 no closing status line | H2 | replies under 100 words only; longer replies are not checked |

## No hook and no test (17)
R032 log line format, R033 never edit old log lines, R034 150-line merge, R038 banned words, R054 STATE.md under 40 lines, R062 commit message one line under 70 characters starting with a verb, R064 push failure: pull, merge, retry once, R070 never overwrite a log file, R076 status values, R080 log lives in the repo, R085 no file only in ~ or /tmp, R094 fetch then pull --rebase before commit-and-push, R097 one copy of each log file, R105 chat answers under about 250 words, R124 and R127 STATE.md top line format, R134 AskUserQuestion with 2-4 options.

## Cheap candidates for a new hook (proposal only, none built)
- Regex checks on files at turn end: R032, R076, R054, R124/R127, R034 (line counts and formats).
- Regex on the last reply: R038 (banned words), R105 (word count against the phrase "full report").
- Check on the commit message at commit time: R062.
Each needs your approval before being built (rule 13 covers CLAUDE.md; hooks change behavior the same way).

## Note
R064 (pull and merge) and R095 (rebase) disagree; see the flags column in rules.tsv.
