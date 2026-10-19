# Harness audit (CLAUDE.md-only scope), 2026-10-19

Scope agreed with the user: this repo has no code, tests, CI or `.claude/` directory, so only `CLAUDE.md`, `STATE.md` and `claude-log/` were audited. Phases 2C (benchmark tasks), D3-D7 and D11 are N/A: nothing exists to run.
Differs from request: no before/after benchmarks and no rewrite of CLAUDE.md applied, because there is no code to benchmark and CLAUDE.md rule 13 forbids editing it unprompted. Proposed edits are below as text.

## Inventory
| File | Size | Notes |
|---|---|---|
| CLAUDE.md | 480 lines, 31,863 chars (~8,000 tokens) | loads every session; 124 "Why:" lines |
| STATE.md | 23 lines | goal + state |
| claude-log/log.md, sources.md, answers/ (5 files) | 63 / 222 lines | research notes, not loaded at start |
Absent: .claude/, settings, hooks, skills, agents, MCP, CI, .gitignore, README. `gh` is installed; `~/claude-log` does not exist.

## Scores
D1 CLAUDE.md: 2/5. D2 settings: 0/5 (absent). D8 verification loop: N/A (no code). D9 legibility: 3/5 (clear layout, no README). D10 security: 3/5 (no secrets found by reading; no .gitignore). D12 context cost: 2/5.

## Findings
**H-001 (P1, D1) Whole section duplicated.** Evidence: `diff <(sed -n 85,110p CLAUDE.md) <(sed -n 126,150p CLAUDE.md)` differs only by blank line / divider. Effect: ~1,500 chars loaded twice, zero new rules. Fix: delete lines 126-150. Verify: `grep -c 'Research: coverage of claims' CLAUDE.md` returns 1.

**H-002 (P1, D1/D12) Log paths contradict.** Evidence: lines 112, 231-234 say `~/claude-log/...`; "Durable storage" (line 277+) says the repo's `claude-log/`. `~/claude-log` does not exist (`ls` error). Effect: the start-of-task rule "read INDEX.md" cannot be followed; the agent either fails or creates files outside the repo that the container then loses. Fix: delete the "Work log" paths and the `~/claude-log` Files list in "Log rules"; state once that logs are `claude-log/log.md`, `sources.md`, `answers/` in the repo.

**H-003 (P1, D1) Dangling reference.** Line 402 cites an "Ask vs. proceed rule" that does not exist (`grep -i 'ask vs'` hits only that line). Effect: the tie-break it promises is undefined. Fix: replace with "ask via AskUserQuestion per 'Staying aligned' rules 8-12".

**H-004 (P1, D1) Closing-line rules conflict.** Evidence: "Not checked:" (184), "Log check:" (265), "Saved:" (313), "Synced with origin" (334), then chat rule 7 (359) replaces three of them but not "Not checked:", and "Chat answers" rule 5 sets the section order (Answer, Why, What I need, Not verified) while Research rules 24 and the "Gaps" bullets demand other endings, and "Writing style" and "Who sets the goal" 3 each define a different first line. Effect: every answer violates at least one rule, so none can be checked. Fix: one "Answer format" section: first line "You asked: ..." (goal-setting rule wins over "first sentence is the answer" because it is more specific), then Answer, Why, What I need, Not verified, then one "Saved and pushed" line; the audit trail lives in the repo file.

**H-005 (P1, D1) Commit rules conflict with cloud sessions.** "Commit and push" says push to main if code runs; cloud sessions are assigned a branch and the harness forbids other pushes. Rule 7 of "Durable storage" uses `gh repo view`; here `gh` works but GitHub tools are MCP-based. Fix: add "if the session names a branch, use it instead of main".

**H-006 (P2, D1) Overlapping research rules.** Rules 16, 18, 19 (contradicting evidence) and Research-coverage bullets vs. rules 4, 6, 20, 23 (open full pages, label snippet-only) say the same thing in different words. Fix: merge to one rule each. Estimated saving ~25% of the Research section.

**H-007 (P2, D9) No .gitignore.** A public repo (user accepted that) with no `.gitignore`; `.env`/keys rule exists only as prose. Fix: add `.env*`, `node_modules/`, `.claude/settings.local.json`. Verify: `git check-ignore .env`.

**H-008 (P3, D1) Rule 18 vs 17.** Both say state/check the premise; keep 17.

Not found: secrets (read-only check of CLAUDE.md, STATE.md and log names; no scanner run).

## Proposed edit sizes (not applied)
Delete H-001 duplicate (-25 lines), H-002 paths (-8), H-006 merges (-30): about 480 -> 415 lines (~-14%). Getting under 200 lines would need dropping all 124 "Why:" lines, which the user wrote deliberately; that is a human decision.

## Gaps
- No code, so no benchmarks, timing or hook tests were possible (N/A, not failed).
- CLAUDE.md audited by reading and grep; no fresh-session behavior test was run.
- Secret scan not run (no scanner installed; not attempted).
- Docs for current `.claude/` formats not fetched, since no config was written.
- Stopped on scope, as agreed with the user.
