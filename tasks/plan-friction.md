# Plan: remove friction from the harness (2026-10-21)

Status: plan only. Nothing in CLAUDE.md, `.claude/hooks`, `tests/` or `.claude/settings.json` has been changed.
Scope: one-off. The STATE.md goal is unchanged and the Acadia work stays parked.
Skills: spec-driven-development and planning-and-task-breakdown. Skipped: the code skills, because nothing is implemented here.
Evidence: `claude-log/answers/2026-10-21-friction-verdicts.md` (the user's choices in an eight-situation judging set).

## Problem
A one-word "Test" got a 199-word reply with 6 template lines (an opener, Answer, Why, What I need from you, Not verified, a closing status line) and a pitch to resume Acadia. Seven of eight rule-exact replies in the judging set were rejected. The causes sit in both layers:
- Rules say "every message" and "every task" with no exception for a ping (Who sets the goal 2 and 3, Log rules Reading 1 and 2, Staying aligned 2 and 3, Project state, Chat answers 1, 4, 5 and 7).
- The Stop hook's answer-format check (H2) requires the opener and closer on any reply of 40 words or more. It would block the reply the user chose for (d) (42 words, no opener or closer), and it passes ceremony while saying nothing.
- The SessionStart hook (H4) prints the Acadia goal line into every new session, which feeds the pivot back to Acadia.

## Target reply shapes (from the verdicts)
| Situation | Target | Measurable limit |
|---|---|---|
| ping ("Test") | one line, ask what they want | 15 words or fewer; no template label; no project name |
| "Yes", "thanks" | one clause of result, with status if relevant | 15 words or fewer |
| small task | plain prose, answer first, an offer | 60 words or fewer; no label; no file path |
| research | answer, confidence, what was read | 60 words or fewer; a confidence word; no file path; no "check elsewhere" advice |
| blocked step | the exact error, what the user does, what is held | 60 words or fewer; error text quoted; no option menu |
| "what's next?" | the current task, parked items stay parked | 30 words or fewer |
| goal conflict | ask replace, add, or one-off | contains the three-way question |

## Changes
### A. CLAUDE.md (proposed, not applied)
Twelve edits, all replacements, none added. Length 434 lines now, 431 after (counted with `wc -l` on a copy). The deleted rule is Staying aligned 3 ("Matches goal"). Evidence for each edit is in the verdicts file. Edit 11 (Durable storage 6: save research and reports, not every chat reply) is my inference from the ceremony finding, not a verdict; the user can drop it alone.
Exact change, as a diff against the current file (line numbers are from the current file):

```diff
@@ -119 +119 @@
-- After the "You asked:" line, make the first sentence the answer, with no greeting, praise, or restated question.
+- Make the first sentence the answer, with no greeting, praise, or restated question.
@@ -164 +164 @@
-At session start, before replying, read this project's STATE.md. If missing, draft one from files and git history, mark it unverified, and tell me.
+When my first message is a task about the project, read STATE.md before replying; skip it for pings and yes/no replies. If STATE.md is missing, draft one from files and git history, mark it unverified, and tell me.
@@ -201,4 +201,4 @@
-1. Treat every new user question or instruction as a new task, including follow-ups in the same session.
-   Why: "each task" was read as "each session", so the check ran once.
-2. Before answering any new task, grep `claude-log/log.md` for `open` and `failed` entries. If any apply, use them. If none apply, say "no open or failed entries relevant".
-   Why: skipping this repeats work already done.
+1. Treat every new question or instruction that needs research, a decision or a file change as a new task, including follow-ups. Pings, thanks and yes/no replies are not tasks.
+   Why: "each task" was read as "each session", so the check ran once; a "Yes" needs no log check.
+2. Before a new task, grep `claude-log/log.md` for `open` and `failed` entries. If any apply, use them; if none apply, say nothing about it.
+   Why: skipping this repeats work already done; announcing an empty check is noise.
@@ -261,2 +261,2 @@
-6. Write the final answer to a file in `claude-log/answers/` and push it before presenting it in chat.
-   Why: findings that exist only in the chat disappear with the session.
+6. Write research answers and reports to a file in `claude-log/answers/` and push it before presenting in chat. Chat-only replies (pings, short answers, status) need no file.
+   Why: findings that exist only in the chat disappear with the session; a "thanks" has no findings.
@@ -295 +295 @@
-1. After the "You asked:" line, open with the answer in one or two plain sentences, then the reasoning. Never open by recapping what you did or which file you read.
+1. Open with the answer in one or two plain sentences, then the reasoning if it changes what I do. Never open by recapping what you did or which file you read.
@@ -304,2 +304,2 @@
-4. Put the audit trail in the repo file, not the chat: queries run, pages opened, unopened pages, statuses changed, correction notes. Chat gets one line pointing to that file.
-   Why: the audit exists to be checked later, not read while I decide.
+4. Put the audit trail in the repo file, not the chat. Don't paste file paths into chat unless I ask where something is; do say in plain words what was read and how sure you are ("one Amazon page opened, nothing contradicting; confidence low").
+   Why: I won't read a file pointer mid-conversation, but I do want the confidence and what it rests on.
@@ -307,2 +307,2 @@
-5. Use these sections in chat, in this order, and skip any that are empty: Answer, Why, What I need from you, Not verified. Give options only when I asked which way to go.
-   Why: a fixed shape stops every answer growing every section.
+5. Write plain sentences, answer first, no section labels. Use the sections Answer, Why, What I need from you, Not verified only in a report I asked for. Give options only when I asked which way to go.
+   Why: 7 of 7 sectioned candidates were rejected in the judging set (2026-10-21).
@@ -313,2 +313,2 @@
-7. Replace the Saved, Log check, and Synced lines with one line: "Saved and pushed: yes/no. Problems: none or the plain-language list." If it's anything but a plain yes, say what is wrong in a sentence.
-   Why: three coded lines are unreadable, and one clear line gets read. This line and the Not verified section replace every other closing line in this file (Not checked, Log check, Saved, Synced, Gaps, queries run); those details go in the repo answer file instead.
+7. Don't end with a status line. If you saved and pushed, say so in a clause ("Both entries closed and pushed."); if anything is unsaved, unpushed or wrong, say that plainly. The Stop hook (H1) blocks the turn while work is unsaved or unpushed.
+   Why: a coded closing line on every reply was ceremony; a clause carries the same fact and H1 checks it. Queries run, Log check, Synced and Gaps details go in the repo answer file.
@@ -366,2 +366,2 @@
-2. If I haven't given a task at the start of a session, do no research, writing or code. Say in plain words what the project is and what was done last, give one suggested next step with a reason, and ask what I want.
-   Why: I need to choose the direction, not find it already underway.
+2. If I haven't given a task at the start of a session (a ping like "Test"), do no research, writing or code. Reply in one line that you're here and ask what I want; don't recap the project or suggest a task unless I ask "what's next".
+   Why: a one-word ping got a 199-word project briefing (2026-10-21); I need to choose the direction, not find it already underway.
@@ -369,2 +369,2 @@
-3. Open every chat message with one line saying what it responds to: "You asked: ..." or "You haven't asked for anything yet."
-   Why: I can't tell why a message is arriving.
+3. Open a report (a reply I asked for in full) with one line, "You asked: ...". Answer everything else directly, with no opener line.
+   Why: on pings, yes/no replies and short answers the opener was ceremony (judging set, 2026-10-21).
@@ -395,5 +395,2 @@
-2. At the start of a new task, make the second line of the reply (after the "You asked:" line) this one line: "Goal: [goal]. This task: [what you're about to do]. How it serves the goal: [reason]." If you can't connect the task to the goal, stop and ask me.
-   Why: it makes drift visible before work happens.
-
-3. Before finishing, compare the result to the goal and write one line: "Matches goal: yes/no, because [reason]." If no, say what's missing instead of presenting it as done.
-   Why: work can be finished and still not be what I asked for.
+2. If a task doesn't serve the goal, say so in one clause in the reply (for example "one-off; Acadia stays parked"). If it conflicts with the goal line, rule 5 applies. Otherwise say nothing about the goal.
+   Why: a Goal line on every reply was ceremony; drift only needs flagging when it happens.
```

### B. Hooks (proposed, not applied). Each change has its failing test first in `tests/hooks/run.sh`
Today the suite prints `passed 41, failed 0`. `settings.json` is not touched, because the hooks are already wired. H1 and H3 are unchanged.

**H2 in `stop-check.sh`: from "require the template" to "block the template in short replies".**
- New logic: `SHORT_WORDS=100`. A reply under 100 words is blocked once if any line starts with `You asked:`, `You haven't asked`, `Goal:`, `Matches goal:`, `Saved and pushed:`, `Answer:`, `Why:`, `What I need from you:` or `Not verified:` (optional leading `*#>_-` and spaces). The reason text says to drop the template lines. A reply of 100 words or more is not format-checked, because it is a report. The `stop_hook_active` guard stays.
- The miss log line names the first label hit and never the reply text, because `misses.md` is pushed to a public repo: `H2 | ceremony in short reply: <label>`.
- Tests that fail first (each is red against today's script):
  1. A 42-word plain reply allows (today it blocks).
  2. A 90-word plain reply allows (today it blocks).
  3. A 12-word reply with a `You asked:` line blocks (today it allows).
  4. A 30-word reply ending `Saved and pushed: yes.` blocks.
  5. A 60-word reply with an `**Answer:**` label blocks.
  6. A short reply with a `Goal:` or `Matches goal:` line blocks.
  7. A 150-word report with labeled sections allows (today it blocks).
  8. A ceremony block writes exactly one line to the miss log.
  9. The miss log line contains the label and not the reply text.
- Tests that stay: empty message allows, 39 words allows, the loop guard.
- Tests deleted because they encode the old rule: the 40-words-blocks, logs-two-misses, compliant-reply-allows, "You haven't asked" opener allows, bold opener allows, missing-first-line and missing-last-line tests (lines 52-59 of `run.sh`).

**H4 in `session-start.sh`: silent when healthy.**
- New behavior: print nothing when the branch exists and origin is reachable; print only the WARNING lines (detached HEAD, no origin, origin not reachable). Never print the goal line.
- Tests that fail first: healthy session prints nothing (today it prints three lines); output never contains `Goal:`.
- Tests that stay: exits 0, warns on detached HEAD, warns when there is no origin. Tests deleted: prints the goal line, prints the branch, reports origin reachable.
- Cost: the goal line is no longer shown at session start. The Project state edit (R5) has me read STATE.md when the first message is a task about the project.

### C. Left alone on purpose
Pushback, the Research sections, Staying aligned 5 (the verdict in (h) kept it), Durable storage 2 and 4, H1 and H3, Chat answers 3 (acronyms; see open questions).

## How we will know friction dropped
- M1, automatic: `bash tests/hooks/run.sh` passes with the new tests, and after install the count of `H2 | ceremony` lines in `claude-log/misses.md` stays near zero.
- M2, replay: after the edits are merged, type the eight situations (Test, Yes, thanks, summarize the miss log, a research question, a failed step, what's next, a conflicting goal) into a fresh session. Count words with `wc -w` and labels with the H2 pattern. Pass means every reply is inside its limit in the table above. Baseline today: the "Test" reply is 199 words and 6 template lines, so (a) fails.
- M3: `wc -l CLAUDE.md` prints 431 or less. Pass means no growth.
- Every reply you flag as ceremonial in a session counts as a miss. So far in this session: 0.

## Rollback
- Nothing merges to main without the gate below. Until then, discard the apply commits on this branch.
- After a merge: `git revert` the apply commit or commits (a new commit, no history rewrite). The CLAUDE.md edits revert on their own, apart from the hooks. CLAUDE.md changes apply only to new sessions.
- To go back to the old format check alone, revert `stop-check.sh` and `tests/hooks/run.sh`. The suite returns to `passed 41, failed 0`.

## Risks
- Dropping the closing status line removes the only visible claim of "saved". H1 still blocks a turn with uncommitted or unpushed work, so the real fact is still checked; what is lost is a stated claim, not a check.
- Dropping the Goal and Matches goal lines makes drift less visible. The clause rule (R3) and the three-way question (Staying aligned 5) are the replacements.
- The evidence is thin: one judge, eight situations, and candidates I wrote. Reasons exist for only three situations.

## Gates (stop and ask in one AskUserQuestion call)
1. Approve editing CLAUDE.md (edits 1 to 12, or a subset).
2. Approve editing `stop-check.sh`, `session-start.sh` and `tests/hooks/run.sh`.
3. `.claude/settings.json`: no edit planned. If one becomes needed, ask first.
4. Merge to main.

## Open questions (not decided here)
1. (d): the user said the structure "feels still somewhat off". The plan uses plain prose; a different shape may be wanted.
2. Chat answers 3 (spell out acronyms): the chosen (d) reply used H1 and H3 unexplained. Left unchanged until the user says.
3. Edit 11 is an inference, not a verdict.
4. The platform's own stop hook (`~/.claude/stop-hook-git-check.sh`) also blocks on uncommitted changes. It is outside the repo and unchanged.

## Not verified
- The replay (M2) has not been run; the limits are set from the replies the user chose, with margin.
- The hook changes are designed, not written. No script has been run against the new tests.
