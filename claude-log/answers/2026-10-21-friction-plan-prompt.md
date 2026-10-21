# Prompt for a fresh session: plan to reduce harness friction (written 2026-10-21)

Paste everything below the line into a new session on the `main` branch of this repo.

---

This is a one-off. Do not change the STATE.md goal and do not ask me "replace, add or one-off": it is a one-off. The Acadia work stays parked.

**Task: write a plan, and only a plan, to fix the friction in our harness (the CLAUDE.md rules and the hooks in `.claude/hooks`). Do not implement anything.**

**What happened.** I typed "Test" in a fresh session. The reply, verbatim:

> You haven't asked for anything yet.
> **Answer:** "Test" isn't a task, so I've done no research, writing or code. The repo is in sync with GitHub: the working tree is clean and the remote is reachable.
> **Why:** My project instructions say only your messages set the goal, so I wait for one instead of continuing earlier work.
> The project is designing an agentic listing optimization workflow (an AI-driven process that audits Amazon listings and recommends fixes) for Acadia's clients. Crush is the Amazon agency Acadia bought. The last goal work, on 2026-10-19, was the research on how Amazon's APIs and data rules affect a Python Claude audit tool. Since then, on 2026-10-21, I updated the working rules and hooks (small scripts that run automatically on certain actions).
> **What I need from you:** What do you want to work on? My suggested next step is to confirm how your tool gets each client's Amazon data (client-granted access or your own credentials), because the open legal question about pooling client data depends on it.
> **Not verified:** STATE.md (the project status file) is still marked unverified, and I haven't re-checked the files it names this session.
> Saved and pushed: yes. Problems: none.

**My diagnosis. Treat it as the problem statement:**
1. It answered the rules, not me. I wanted to know the chat was alive and got a project briefing.
2. Ceremony without information: a template first line, four headers for two sentences of content, and "Saved and pushed: yes" when nothing was saved. The answer-format hook (H2) accepts it, so the check passes while the reply says nothing.
3. A rule fires on the wrong trigger: "no task given, so recap the project" turns one word into a status report.
4. It steered me back to Acadia right after hours on the harness, which reads as nagging.
5. Noise: "Not verified: STATE.md is unverified" changes nothing I would do.
6. Nothing is proportional. The rules say "every message" and "every task", with no exception for a ping, a thanks or a "yes".

**Your steps**
1. Load the `using-agent-skills` skill and say in one line which skills you will use and which you skip. I expect spec-driven-development and planning-and-task-breakdown.
2. Read, without summarizing back to me: `CLAUDE.md`, `.claude/hooks/*.sh`, `tests/hooks/run.sh`, `claude-log/misses.md`, and the three files in `claude-log/answers/` named `2026-10-21-harness-spec.md`, `2026-10-21-rules-to-drop.md`, `2026-10-21-retro-review.md`.
3. **Build a judging set where I am the judge.** Eight situations, using real content from this repo, not invented content: (a) "Test", with the reply above as one candidate; (b) a bare "Yes" after you asked a question; (c) "thanks"; (d) a small real task, such as "summarize the miss log"; (e) a research question; (f) a blocked or failed step; (g) "what's next?"; (h) a message that conflicts with the goal line. For each, write 2 or 3 candidate replies labeled A, B, C in random order. One candidate must follow the current rules exactly, and you must not mark which. Show them with AskUserQuestion using the preview field so I can compare side by side. Two calls of four situations each. I choose which feels right and add one line of why.
4. **Derive the plan from my verdicts, not from your own taste.** The plan has: exact rule text to change or delete in CLAUDE.md (proposed, not applied); hook changes, each with its failing test first in `tests/hooks/run.sh`; a measurable check that friction dropped (for example: a reply to a ping is at most two sentences with no section headers); and a rollback.
5. Save the plan as `tasks/plan-friction.md` and `tasks/todo-friction.md`. Do not overwrite `tasks/plan.md`. Save my verdicts in `claude-log/answers/<date>-friction-verdicts.md`. Log it, commit, and push to a new branch `claude/harness-friction-plan-<date>`.

**Pre-approved:** reading files, writing the plan, verdict and log files, commits and pushes to that new branch.
**Gates. Stop and ask me in one AskUserQuestion call:** editing CLAUDE.md, any hook, or `.claude/settings.json`; merging to main.

**Constraints**
- CLAUDE.md must get shorter or stay the same length. Every rule you propose adding has to delete or replace one.
- Your own replies in this session must be proportionate: short, no project recap, no section headers unless I ask for a report. The format hook still requires an opening "You asked:" line and a closing "Saved and pushed:" line on replies of 40 words or more, so keep each to one line and keep replies under 40 words where you can. I will flag any reply that feels ceremonial, and you count them.
- End with a summary of the plan in 150 words or fewer.
