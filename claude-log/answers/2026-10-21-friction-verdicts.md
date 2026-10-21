# Friction judging set: verdicts (2026-10-21)

One-off task. The STATE.md goal is unchanged and the Acadia work stays parked. Nothing was implemented.

## How it was run
- Eight situations, each with 2-4 candidate replies written by me from real repo content. In every situation one candidate followed the current CLAUDE.md rules exactly; none was marked.
- Call 1 used the preview field. The user could not see previews ("I cant see the side by sides"), and declined it. After that, the full candidate text went in chat and the question box carried a one-line description of each option.
- Round 1 covered (a)-(d). Round 2 re-asked (d) and covered (e)-(g). Round 3 re-asked (d) and covered (g) and (h).

## Verdicts
| Situation | Rule-exact candidate | Chosen | User's words |
|---|---|---|---|
| (a) "Test" in a fresh session | the 199-word briefing (counted with `wc -w`) | "Here. What do you want to work on?" | none |
| (b) "Yes" after a question | You asked + Goal + log check + Answer/Why + Matches goal + closing line | "Done. Both entries closed and pushed." | none |
| (c) "thanks" | You haven't asked + Goal + Answer + next step + closing line | "You're welcome. Nothing is pending; the repo is clean and pushed." | none |
| (d) "summarize the miss log" | full format with Goal, Answer, Why, What I need, Not verified, closing | plain-prose reply naming both entries, then "I'd mark both closed; say so and I will." (chosen in rounds 1 and 3) | round 1: "Need more options for (d). C felt the best overall". Round 2: "Something about the actual structure / formatting feels still somewhat off. C is still good and so is d" |
| (e) research: does Amazon have an API for Manage Your Experiments | full format with labels, confidence, Not verified, closing line | B: one sentence with the confidence level and what was read, without the file pointer | "I like b with the confidence and the sources it read. But I'm never gonna read a whole pointer when I'm trying to have a convo in chat. Feels too technical. I hated A's caveat" |
| (f) a step failed with a 403 | Differs-from-request + four labeled parts + closing line | A: plain paragraph with the error text, what the user does, push held | none |
| (g) "what's next?" | Goal line + three options with costs + tradeoff + closing line | round 2: "None of those". Round 3: "We're on the harness friction plan. Acadia stays parked until you move it back." | "None of those" |
| (h) message conflicts with the goal line | asks "replace the goal, add to it, or one-off?" | the same ask | none |

## What the verdicts show
1. The rule-exact candidate lost in 7 of 8 situations. It won only in (h).
2. All 7 losing candidates had template lines (You asked, Goal, Matches goal, Saved and pushed) or labeled sections. Seven of seven sectioned candidates were rejected.
3. The chosen replies share one shape: answer first, 42 words or fewer, plain prose, no opener line, no Goal or Matches goal line, no closing status line, no section labels.
4. Status survives as a clause when it matters ("closed and pushed", "clean and pushed"), not as a coded line.
5. In (e) the user wants the confidence and what was read, and does not want a file path or a "check elsewhere" caveat.
6. In (h) the user wants the question asked, so Staying aligned 5 stays.

## Limits of this evidence
- One judge, eight situations, and candidates I wrote, so my taste is built into the menu.
- Reasons were given only for (d), (e) and (g). For (a), (b), (c), (f) and (h) there is a choice and no reason.
- (d): the box described C as "two bullets plus an offer", but the chat text was one paragraph. I cannot tell which the user judged. The plan assumes plain prose. The user's note that the structure "feels still somewhat off" is unresolved.
- (g): F was written after "None of those", so it is the user's rejection plus my guess. It assumes there is a current task to name.
- The chat text for round 1 was condensed from the full candidates, and the user judged the condensed versions.
- Ceremonial replies the user flagged during this session: 0. Two display problems were reported (previews not visible, new variants not visible).
