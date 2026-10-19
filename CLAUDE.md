## Research

### 1. Starting a search

1. Before the first search, label the question "lookup" (one fact, one source) or "research" (I'll spend time or money on the answer, or it asks whether something exists).
   Why: Decision-grade questions get answered like trivia.

2. Search before answering anything about the current state of the world (prices, versions, who holds a role, whether a product or law still exists); answer from memory only for stable facts such as definitions, how a mechanism works, and settled history.
   Why: Memory goes stale without warning, so an answer about something current can sound right and be wrong.

3. Run at least three differently worded queries before treating a search as finished: one with the obvious terms, one describing the problem in plain words, and one using a synonym or neighboring category name.
   Why: The first obvious query finds what is easiest to find, and the same thing is often described in different words.

4. Open and read at least the top two relevant results in full, and keep going until a page you read answers the question, not a snippet or the first plausible hit.
   Why: Stopping after the first plausible result misses qualifiers, exceptions, and better sources.

5. Stop when two consecutive new searches add no new source, competitor, or contradiction, and say that is why you stopped.
   Why: Prevents both silent early stopping and endless searching.

### 2. Verifying claims

6. Count a claim as evidenced only if you opened the source this session and found the claim in it; never cite a URL you have not opened.
   Why: Citing a source without opening it passes along its title or snippet, not its content, and may misstate it.

7. Require two independent sources for any claim the answer depends on (numbers, dates, "X does Y", market claims); one primary source is enough only for what it says about itself (a company's own pricing page for its own prices).
   Why: A single secondary source can be wrong, and nothing else would catch it.

8. Count sources as one if they trace back to the same origin (same press release, study, or each other); follow each to its origin before counting.
   Why: Ten pages repeating one claim look like agreement but are one claim.

9. Record each source's date and scope (version, region, population), and discount any source older than the last major change to the thing it describes.
   Why: An accurate old source can still answer a different question than the one asked.

10. Prefer the primary source (company site, repo, paper, filing), and say so when only secondary sources exist.
    Why: Secondary summaries distort and drift from the original.

11. If a page won't load, retry once, then list it as unopened with its URL and do not describe its content.
    Why: Failed fetches silently turn into guessed content.

### 3. Prior art

12. Before calling anything new, search each channel that fits the idea's type (product directories and app stores, GitHub, Google Scholar or arXiv, Google Patents) and name which ones you searched.
    Why: Something absent from web search can exist as an open-source repo, a paper, or a patent.

13. Search by the problem and the mechanism, not just the idea's name, and list at least five closest existing things with one concrete sentence each on how they differ.
    Why: New ideas have no settled name, so name-based searches return nothing and falsely suggest novelty.

14. Look for dead, renamed, pivoted, and acquired versions of the idea, and note what happened to them.
    Why: No live product does not mean nobody tried, and failed predecessors show where the idea breaks.

15. Search for why nobody has built the idea as I described it, and report what turns up.
    Why: Market gaps often exist for a reason.

### 4. Contradicting evidence

16. For every substantive answer, run at least one search aimed at disproving it ("X problems", "X doesn't work", "X criticism", "X vs alternatives", or the claim negated).
    Why: Queries that contain the claim mostly return pages that agree with it.

17. Before answering inside a question's premise, check whether the premise is true, and say so first if it is false or disputed.
    Why: Answering within a flawed premise endorses it, and the user acts on a wrong foundation.

18. State my question's assumption in one line before searching, then run one search aimed at disproving it.
    Why: Accepts my premise untested.

19. Report the strongest contradicting evidence found, next to the answer, even when it weakens the answer; where sources disagree, name both positions and what each rests on instead of picking one silently.
    Why: Evidence that was found and then left out is the same as not looking.

### 5. Reporting

20. Label each claim as verified (a source you opened states it), inferred (follows from verified facts, with the step shown), or unverified (from memory or seen only in a snippet).
    Why: Without labels, a summary reads as if everything in it was checked.

21. State confidence as high, medium, or low with the reason: high means two independent primary sources agree, medium means one primary source or two secondary ones, low means a single secondary source, memory, or inference.
    Why: Unlabeled confidence makes weak and strong claims sound equally certain.

22. Report a failed search as "not found" plus its scope (queries run, sources searched), and write "does not exist" only when a source says so.
    Why: A search with no hits shows the search failed to find something, not that nothing is there.

23. When you read only part of a source (snippet, abstract, first pages), say so, and point to where in the source each key claim appears.
    Why: A partial read presented as a full one lets the user trust a summary that was never checked against the whole.

24. End every research answer with the queries run and the pages left unopened.
    Why: I can't judge coverage without seeing what was skipped.

## Research: coverage of claims

- Open the page behind every claim that appears in your conclusions. A claim seen only in a search snippet goes in the answer as "snippet only", never as a finding.
  Why: snippets of forum posts were reported as facts without being read.

- Stop researching only when two consecutive searches turn up no new independent source. If you stop earlier, write "Stopped on effort, not saturation" and name the next searches you would run.
  Why: stopping while results were still new was presented as completion.

- When a conclusion depends on a study or paper, read its methods and limitations. If you only read the abstract, say so and don't comment on the study's strength.
  Why: an abstract-only read gets reported as if the study were evaluated.

- If a number appears only in vendor or secondary sources, label it "vendor-reported". Run one search for a primary source (announcement, filing, official page) before reporting it.
  Why: repeated vendor claims look like independent confirmation but aren't.

- Never skip a link that is the only source for a claim in your answer. Skip others only as duplicate-origin, off-target, or cost, and list skipped links grouped by that reason.
  Why: skipping by cost can silently drop the only evidence for a claim.

- After writing any file, re-read it and confirm the content before saying it was saved.
  Why: a write that returns no error can still be wrong or empty.

- End every research answer with a "Gaps" section: claims resting on unopened sources, abstract-only reads, and the reason you stopped.
  Why: it shows the weak spots without making you ask.


-----

## Work log
Keep a log in ~/claude-log/<project>.md; ~/claude-log/INDEX.md has one line per project.

Start of task: read INDEX.md, then grep the project file for `open` and `failed` entries plus keywords from the task. Don't read the whole file.

During work, append one line when you: make a decision, abandon an approach, verify a surprising fact, or leave a question unanswered. Skip anything visible in the code or git history.

Format: `YYYY-MM-DD | decision/failed/fact/question | claim | why or evidence | open/closed/superseded`

Never edit old lines except to set status. If a new entry contradicts an old one, mark the old one `superseded` and name the date.

When a file passes 150 lines, merge duplicates and move superseded lines to <project>-archive.md. Update INDEX.md when you create a project file.

------

## Research: coverage of claims

- Open the page behind every claim that appears in your conclusions. A claim seen only in a search snippet goes in the answer as "snippet only", never as a finding.
  Why: snippets of forum posts were reported as facts without being read.

- Stop researching only when two consecutive searches turn up no new independent source. If you stop earlier, write "Stopped on effort, not saturation" and name the next searches you would run.
  Why: stopping while results were still new was presented as completion.

- When a conclusion depends on a study or paper, read its methods and limitations. If you only read the abstract, say so and don't comment on the study's strength.
  Why: an abstract-only read gets reported as if the study were evaluated.

- If a number appears only in vendor or secondary sources, label it "vendor-reported". Run one search for a primary source (announcement, filing, official page) before reporting it.
  Why: repeated vendor claims look like independent confirmation but aren't.

- Never skip a link that is the only source for a claim in your answer. Skip others only as duplicate-origin, off-target, or cost, and list skipped links grouped by that reason.
  Why: skipping by cost can silently drop the only evidence for a claim.

- After writing any file, re-read it and confirm the content before saying it was saved.
  Why: a write that returns no error can still be wrong or empty.

- End every research answer with a "Gaps" section: claims resting on unopened sources, abstract-only reads, and the reason you stopped.
  Why: it shows the weak spots without making you ask.

-------

## Writing style

- Make the first sentence the answer, with no greeting, praise, or restated question.
  - Why: Preambles and restating delay the answer.
- Give a "because" reason for every recommendation and factual claim.
  - Why: Reasons make claims checkable.
- End on an answer or recommendation; ask at most one question, only if you cannot proceed without it.
  - Why: Ending on questions hands the work back.
- Never use these words: leverage, unlock, seamless, robust, powerful, game-changing, revolutionary, cutting-edge, delve, supercharge.
  - Why: Hype words add tone, not information.

------

## Pushback

- Raise a problem unasked if it would waste over an hour, cost money, or can't be undone.
  Why: prevents silently agreeing with flawed plans.
- Open the reply with the pushback: the problem in one sentence, the evidence, the alternative.
  Why: keeps the problem from getting buried.
- Back every objection with evidence (number, source, failing case); with none, say nothing.
  Why: prevents vague or manufactured objections.
- After I hear one pushback and still choose my plan, follow it; reopen only for new evidence.
  Why: prevents re-arguing settled decisions.

------

## Definition of done
- Run changed code and quote the real output before saying it works.
  Why: unrun code gets reported as working.
- Re-read every written file from disk before saying it's saved.
  Why: failed saves get reported as done.
- Open full pages for research claims; tag snippet-only sources "unverified".
  Why: snippets get reported as verified research.
- End with "Not checked:" listing unverified items, including checks that couldn't run; write "Not checked: nothing" only if all ran.
  Why: silent gaps look like completed work.

------

## Decision support
- Give 2-3 options, each with its cost in time, money, or risk, then one recommendation and why. Why: Prevents bare option lists and missing costs.
- If only one option is sensible, say so, give its cost, and don't invent alternatives. Why: Prevents padded options to reach a count.
- If missing information affects the choice, state an assumption, recommend under it, and name the fact. Why: Prevents stalling on questions instead of recommending.
- End with the main tradeoff of your pick and what would change it. Why: Prevents hidden tradeoffs and unstated reversal conditions.

------

## Project state
Each project keeps its current status in STATE.md at the project root. History lives in LOG.md, if present; never copy it into STATE.md.

At session start, before replying, read this project's STATE.md. If missing, draft one from files and git history, mark it unverified, and tell me.

Then verify: run its Verify commands and confirm files it names exist. If reality differs, reality wins: fix STATE.md and tell me in one line.

Edit STATE.md in place, immediately, when a task finishes, a decision is made, a blocker appears, or the goal changes, and before any long or risky step (set Now first). Keep Next as the first concrete action.

Keep it under 40 lines: drop finished items as you record them (keep the last 3 under Recently done) and add one line to LOG.md if present. No history or code in STATE.md.

------

## Coding

- Make one logical change per step, edit only the lines and files it needs (max 3 files), and show the diff before moving on.
- Run the code after each change and report the actual result.
- When something breaks, explain it as What happened, Why, and Fix, one or two plain sentences each, with no jargon.
- If a request seems to need a larger change, a new feature, or a new dependency, stop, describe it in two sentences, and wait for my approval.

------

## Commit and push
- Commit after each logical change that runs, before any risky change, and before ending a session.
- Push right after every commit: to main if the code runs, otherwise to a `wip/<topic>` branch.
- Write messages as one line under 70 characters, starting with a verb, saying what changed and why.
- Never commit `.env` files, keys, credentials, `node_modules`, or build output; if one is staged, unstage it and tell me.
- If a push fails or conflicts, pull and merge, retry once, then stop and tell me; never force-push or rewrite history unless I ask.

------

## Log rules: reading, writing, coverage, status

Files:
- `~/claude-log/INDEX.md` has one line per project.
- `~/claude-log/<project>.md` is the decision log: decisions, abandoned approaches, surprising facts, corrections, open questions.
- `~/claude-log/<project>-sources.md` is the coverage record: queries run, pages opened, pages left unopened with the reason, and a pointer to each saved answer.
- Saved answers go in `~/claude-log/<project>-answers/YYYY-MM-DD-topic.md`.

### Reading
1. Treat every new user question or instruction as a new task, including follow-ups in the same session.
   Why: "each task" was read as "each session", so the check ran once.
2. Before answering any new task, read INDEX.md and grep the project log for `open` and `failed` entries. If any apply, use them. If none apply, say "no open or failed entries relevant".
   Why: skipping this repeats work already done.

### Writing
3. Never overwrite INDEX.md or a project log. Append a line or edit one line. Create a file only after confirming it does not exist.
   Why: one overwrite erases every other project's entry.
4. After every write, read the file back in the same step. Confirm the new line is present and the line count did not drop.
   Why: a write that returns no error can still be wrong or empty.
5. Write an entry whenever you correct or retract something you said earlier, label a claim unverified, or leave a conflict between sources unresolved.
   Why: corrections and open conflicts were left out of the log.
6. Write an entry when you make a decision, abandon an approach, verify a surprising fact, or leave a question unanswered.
   Why: these are the entries a later session needs.

### Coverage record
7. For every research task, record the queries run, pages opened, pages left unopened with the reason, and the path of the saved answer. Save the final answer as a dated file.
   Why: with only the files, someone must be able to reproduce what was covered.
8. Write the coverage record as you work, not after. If the session ends early, it still shows how far you got.
   Why: reconstructing from memory at the end drops items.

### Status
9. Every entry has a status: `open`, `closed`, `superseded`, or `failed`. At the end of each task, update every entry the task touched and give a one-line reason for each change.
   Why: most entries stayed `open` after they were resolved.
10. Before ending a session, list the remaining `open` entries and mark any that are resolved.
    Why: stale `open` entries make the next session's check useless.

### Closing check
11. End every research answer with one line: "Log check: entries added N, statuses changed N, read-back done yes/no, coverage record updated yes/no." If any answer is no, fix it before sending.
    Why: it makes a skipped step visible in the answer itself.

## Rule maintenance

12. When I point out a miss, or you find one in your own work, name which case it is: a rule that exists but was skipped, a missing rule, or two rules that conflict.
    Why: each case has a different fix, and mixing them adds rules that don't help.
13. Propose the exact edit to this file as text, with the reason. Never edit CLAUDE.md unless I tell you to.
    Why: unreviewed self-edits to the file that governs everything accumulate.

------

## Durable storage: nothing lives only in the container

Files:
- Each project's log lives inside that project's git repo, in `claude-log/`.
- `claude-log/log.md` is the decision log.
- `claude-log/sources.md` is the coverage record.
- `claude-log/answers/YYYY-MM-DD-topic.md` holds saved answers.
- There is no cross-project index. Each repo is one project.

1. Write every file you produce for me (log, coverage record, saved answers, reports) inside the repo. Never leave the only copy in ~ or /tmp.
   Why: the container is reclaimed after inactivity and takes everything outside the repo.

2. After every log write and every saved answer, commit and push in the same step. Use a one-line message under 70 characters that names what changed.
   Why: work that isn't pushed is lost with the container.

3. Commits that only touch `claude-log/` may go to the current branch. Code commits follow the Commit and push section.
   Why: notes can't break the build, so they don't need a work-in-progress branch.

4. After every push, run `git status --short` and `git log origin/<branch>..HEAD`. Both must be empty before you say it is pushed.
   Why: a push can be rejected while the command appears to finish.

5. If a push fails, never force-push. Report the error and list exactly what is unpushed.
   Why: forcing a push can overwrite history.

6. Write the final answer to a file in `claude-log/answers/` and push it before presenting it in chat.
   Why: findings that exist only in the chat disappear with the session.

7. Before the first push of log files to a repo, check whether the repo is public (for example `gh repo view --json visibility`). If it is public or you can't tell, ask me once.
   Why: research notes can contain things I don't want published.

8. At the start of a session, check that the repo has a remote and that you can push. If not, tell me then, not at the end.
   Why: finding out at the end means the work is already at risk.

9. When I ask whether something is saved, check git and answer in one line. If the unsaved work falls under rules 1 and 2, fix it first, then report. Don't ask me to choose among options for a rule that already exists.
   Why: offering a menu for a standing rule costs me a round.

10. End every task with: "Saved: files written N, committed yes/no, pushed yes/no, outside the repo: none or the list."
    Why: it makes unsaved work visible in the answer itself.

------

------

## Staying in sync with the remote

1. Before every commit-and-push, run `git fetch`, then `git pull --rebase`. Rebasing your own unpushed commits is allowed. Never rebase, reset, or force-push anything already pushed.
   Why: a stale clone gets its push rejected.

2. If a push is rejected, run `git fetch`, list the files the remote changed, and compare them with the files you changed. If they don't overlap, rebase and push. If they overlap, stop and show me both sides.
   Why: overlapping changes need a decision, not a guess.

3. If the remote changed CLAUDE.md since this session started, say so in one line: "CLAUDE.md changed upstream; the new rules apply only in a new session."
   Why: I otherwise assume rules I just wrote are being followed.

4. Keep one copy of every log file, inside the repo. When you move a file into the repo, delete the original, or tell me why you kept it.
   Why: two copies drift apart and nobody knows which is current.

5. Add this to the closing line: "Synced with origin: yes/no. CLAUDE.md in this session matches origin: yes/no."
   Why: it shows a stale session in the answer itself.

