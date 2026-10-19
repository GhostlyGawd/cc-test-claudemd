# STATE (drafted 2026-10-19 from files and git history: UNVERIFIED)

Goal: design an agentic listing optimization workflow for Acadia clients (Crush, the Amazon agency Acadia bought in 2025, is the "Amazon accelerator").

Now: Python-workflow answer saved and pushed; waiting on the user for four inputs.

Next: user confirms which SP-API registration and LLM provider the Python workflow uses, checks client authorizations, gets counsel on the AUP/DPP/SPPA, and says what Crush includes.

Blockers:
- Open legal question: do AUP s4.4/s4.6 limit pooling client data across clients (likely yes for a public SP-API app; inferred)?
- Unknown: what the Crush accelerator includes (tools, data stack, AI).
- Repo is public; the user said that is fine (2026-10-19).

Verify:
- `ls claude-log claude-log/answers` shows log.md, sources.md and four dated answers
- `git status --short` is empty after the push

Recently done:
- Python API workflow answer: registration model, 10-authorization private cap, security controls, Claude retention (answers/2026-10-19-python-api-workflow.md)
- Agentic workflow design and corrections (answers/2026-10-19-agentic-listing-workflow-design.md, ...-crush-and-api-gaps.md)
- Crush identified; SQP, Customer Feedback API, preview mode and service-provider access checked against Amazon pages

Files: claude-log/log.md (decision log), claude-log/sources.md (coverage record), claude-log/answers/ (saved answers).
