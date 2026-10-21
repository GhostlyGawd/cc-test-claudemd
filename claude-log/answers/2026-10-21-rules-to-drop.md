# Proposal: CLAUDE.md rules to drop or edit after the hooks (T6, 2026-10-21)

Nothing here is applied. CLAUDE.md rule 13 says I never edit it unless you say so; T7 applies whatever you approve.
Basis: the hooks were tested live this session (H1 block, H2 short-reply exemption, H3 deny, H4 fresh-session output; see log.md entries of 2026-10-21). Line counts come from `wc -l` on a copy in the scratchpad, not estimates.

## Finding first
The hooks make very few prose rules deletable. The size problem is elsewhere: CLAUDE.md is 451 lines, and the Research sections (lines 1-104) plus 124 "Why:" lines are most of it. Those are your deliberate rules, so cutting them is your decision, not a hook consequence.

## A. Safe deletions (no hook needed): closing lines already replaced by Chat answers 7
Chat answers rule 7 (lines 330-331) states it replaces "Not checked, Log check, Saved, Synced, Gaps, queries run". Six older rules still demand those lines, so every reply breaks one rule or another. H2 now enforces the single replacement line, so the old ones are pure conflict.
| # | Rule (current lines) | What it demands | Lines removed |
|---|---|---|---|
| A1 | Research 23 (79-81) | queries run + unopened pages at the end of every answer | 3 |
| A2 | Research coverage, "Gaps" bullet (101-103) | a Gaps section | 3 |
| A3 | Definition of done, "Not checked:" bullet (156-157) | a Not checked line | 2 |
| A4 | Log rules 11 "Closing check" (235-238) | a Log check line | 4 |
| A5 | Durable storage 10 (284-286) | a "Saved: files written N..." line | 3 |
| A6 | Staying in sync 5 (305-307) | a "Synced with origin" line | 3 |
Result on a copy: 451 -> 433 lines (-18). Nothing else in the copy cites the removed rules (grep for "Closing check", "rule 10", "Durable storage 10" returned nothing). Log rules numbering then jumps from 10 to 12; harmless, renumber if you prefer. The detail those lines asked for already lives in the repo answer file, per Chat answers 4.
Exact command (T7 would run it after your approval): `sed -i -e '79,81d;101,103d;156,157d;235,238d;284,286d;305,307d' CLAUDE.md`, then `wc -l CLAUDE.md` should print 433.

## B. Edits that fix remaining conflicts (net 0 lines)
- B1, Chat answers 1: change "Open with the answer in one or two plain sentences" to "After the 'You asked:' line, open with the answer in one or two plain sentences". Why: H2 requires "You asked:" first, so rule 1 as written contradicts it.
- B2, Staying aligned 2: change "At the start of every task, say in one line" to "At the start of a new task, make the second line of the reply (after 'You asked:')". Why: this rule has not been followed in this session (I used "Matches goal" at the end only) because it has no place in the reply shape; this gives it one. No hook enforces it.

## C. Kept on purpose, with the reason
- Goal rule 3 and Chat answers 7: H2 only blocks after the fact; the prose is what teaches the format, so deleting it would cost a blocked turn on every long reply.
- Commit and push (never force-push): H3 catches `git push -f/--force` and `git add` of `.env`/`node_modules` only. It does not catch `git push origin +main`, `git reset`, `git rebase` of pushed work, or committed keys, so the prose stays.
- Project state / Durable storage 8: H4 prints only the goal line and whether origin is reachable. It does not read the Verify commands, compare against your latest goal, or prove push permission.
- Durable storage 2 and 4: H1 checks at turn end that nothing is unsaved or unpushed, but not "in the same step", and it is blind to unpushed commits on a detached HEAD. A built-in platform hook (`~/.claude/stop-hook-git-check.sh`, not read) also blocks on uncommitted changes. Optional: drop Durable storage 4 (3 lines) if you accept the end-of-turn check instead of a check right after each push.

## D. Other findings (not changes to propose today)
- STATE.md breaks Staying aligned 1: its first line is "# STATE ... UNVERIFIED" and the goal line reads "Goal: ..." instead of "Goal (user's words, date): ...". H4 prints the line as is.
- The Research sections (104 lines) could move to a skill that loads on research tasks only, which would cut every session's context. This is a design change, not tested.

## Decision for you
Approve A1-A6 and B1-B2 as one T7 edit (-18 lines, two rewrites), approve a subset, or none. I recommend all of them because they remove direct contradictions and no behavior you rely on.

## Not checked
- The built-in `stop-hook-git-check.sh` was not read, so how much of H1 it duplicates is unknown.
- Line numbers are from the CLAUDE.md on this branch as read at 2026-10-21; they shift if CLAUDE.md changes before T7.
- Whether a shorter CLAUDE.md improves adherence: inference, not measured.
