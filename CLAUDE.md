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

