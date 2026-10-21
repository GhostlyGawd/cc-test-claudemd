# Plan: bring the harness in line with the 4-tier memory model (2026-10-21)

You asked: a plan to update the harness to do what the pasted essay says. Plan only; nothing below is built. One-off; the Acadia goal stays parked.

## Where the harness stands against the essay

| Tier | Essay says | Harness today | Gap |
|---|---|---|---|
| L1 scratchpad | per-process, evicted on /clear | native | none |
| L2 handoff | overwritten HANDOFF.md, pushed at SessionStart/PostCompact, deleted on merge | STATE.md (project-wide, edited by hand, 40-line cap); no per-branch file; no PostCompact hook | missing |
| L3 provenance | inline WHY comments, directory CLAUDE.md | repo has no code, so nothing to attach to | skip until code exists |
| L4 rules | small root CLAUDE.md, modular .claude/rules/, inbox for learned rules | one 431-line, 29,585-byte CLAUDE.md; Rule maintenance 13 forbids self-edits (good) but there is no inbox | too big; no inbox |
| Worktree safety | hooks read `.cwd` from stdin, not $CLAUDE_PROJECT_DIR | all 3 hooks `cd "$CLAUDE_PROJECT_DIR"` | would break in a worktree (if the essay's claim is true) |
| Append-only logs | unique filename per branch | claude-log/log.md and misses.md are single shared appended files | the same merge-conflict trap the essay describes (a log.md conflict already happened on 2026-10-21) |

## Pushback (evidence)

1. The essay's push budget is under ~2,000 tokens; CLAUDE.md is 29,585 bytes, roughly 7,000 tokens, loaded every session. Trimming or splitting it matters more than any new hook.
2. Several essay claims are unverified and the plan depends on them: that $CLAUDE_PROJECT_DIR points at the main checkout inside a worktree, that "v2.1.218" enforces worktree boundaries, that CLAUDE_CODE_DISABLE_AUTO_MEMORY exists, that .claude/rules/*.md auto-loads, that a PostCompact hook exists. Step 0 checks them against the official docs before anything is built.
3. This repo runs one cloud session at a time. The parallel-worktree parts only pay off if you actually run 3 agents here; otherwise build only the single-session parts (steps 2, 3, 6).

## Steps (each is one logical change, max 3 files, run and show output before moving on)

0. Verify the five claims above in code.claude.com docs (hooks, settings, memory). Output: a log line per claim, verified or not. Cost: ~30 min. Gate for steps 1-5.
1. Worktree-safe hooks: change stop-check.sh, session-start.sh, guard-bash.sh to take the directory from stdin `.cwd` (fallback $CLAUDE_PROJECT_DIR); add a test in tests/hooks/run.sh that runs each hook from a second `git worktree`. Files: 3 hooks + test (needs your OK for 4th file). Run: `bash tests/hooks/run.sh`.
2. L2 handoff: define `.claude/HANDOFF.md` (goal in your words, verified steps, dead ends, next step; overwritten, max 30 lines); session-start.sh prints it when present. Files: session-start.sh, .gitignore or commit rule, one example file.
3. L2 write nudge: Stop hook blocks once if commits were made this session and HANDOFF.md is unchanged (reuses the stop_hook_active guard). Files: stop-check.sh, test.
4. Per-branch logs: move appends to `claude-log/log.d/<branch>.md` and `misses.d/<branch>.md`, consolidated on main. This edits CLAUDE.md Log rules, so it needs your explicit go. Files: CLAUDE.md, 2 hooks.
5. Rules inbox: agents on branches write candidate rules to `claude-log/inbox/<branch>.md`; you fold them into CLAUDE.md on main. Files: CLAUDE.md (one rule), no hook.
6. Shrink the push load: split CLAUDE.md by topic into `.claude/rules/*.md` only if step 0 confirms they auto-load and cost fewer tokens; measure bytes before and after. Gate: your approval, since this is the file that governs everything.
7. Settings: add the auto-memory switch to .claude/settings.json only if step 0 confirms the name.

## Gates
CLAUDE.md edits (4, 5, 6) and settings.json (7) need your explicit instruction. Merge to main is yours. Work happens on a `claude/` branch.

## Recommendation
Do step 0, then 1-3 now (single-session value, low risk, testable). Hold 4-7 until you say you run parallel worktrees here. Main tradeoff: 4-7 add rules and files to maintain; if you stay single-session, they are cost without benefit.
