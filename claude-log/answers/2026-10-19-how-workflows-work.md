# How workflows work

Date: 2026-10-19. Question type: research (the answer shapes how you build). Assumption: "workflows" means agentic LLM workflows like your listing pipeline, plus Claude Code's own Workflow feature, which appeared in this session.
Labels: verified = I opened the source and it states this; inferred = follows from verified facts (step shown); unverified = snippet only or memory.

## Answer

A workflow is code that runs a fixed path of LLM and tool calls, while an agent lets the model choose the next step; for listing optimization, use a workflow with checks between steps and a human gate, because the path is known in advance, so you get predictable cost, repeatable results and an audit trail.

## The core definitions (verified)

[Anthropic, "Building effective agents" (2024-12-19)](https://www.anthropic.com/research/building-effective-agents): workflows orchestrate LLMs and tools through predefined code paths; agents let the LLM direct its own process and tool use. Anthropic advises the simplest solution that works, because agentic systems trade latency and cost for performance. The page notes that much of the tooling it describes has since changed.

## The five workflow patterns (verified, mapped to listings by me)

| Pattern | What it is | Listing use (inferred) |
|---|---|---|
| Prompt chaining | Each call processes the previous output, with programmatic checks between steps | Facts, then draft, then validate length and banned terms, then format for the API |
| Routing | Classify the input, send it to a specialized handler | Thin listing, detailed listing and new product each get a different prompt; hard cases go to a stronger model |
| Parallelization | Run independent subtasks at once (sectioning) or the same task several times (voting) | Draft title, bullets and backend terms in parallel; vote on a risky claim |
| Orchestrator-workers | A central model splits the task at runtime and delegates | Mostly unneeded for listings; steps are known in advance |
| Evaluator-optimizer | One model generates, another critiques, in a loop | Compliance critic against a claim library, bounded to a few rounds |

## How the loop works underneath (verified, [Claude tool-use docs](https://platform.claude.com/docs/en/agents-and-tools/tool-use/how-tool-use-works))

- The model never executes anything. It emits a structured request, your code runs it, and the result goes back in the conversation.
- With client tools, your app drives a loop: send the request, and while `stop_reason` is `"tool_use"`, run the tools, return `tool_result` blocks, and call again. Any other stop reason (`end_turn`, `max_tokens`, `stop_sequence`, `refusal`) ends the loop and must be handled.
- Server tools (web search, code execution) run their own loop on Anthropic's side and may return `pause_turn` at an iteration cap.
- In a Python workflow, your script is the orchestrator: it decides the order, runs the checks and holds the intermediate results. That is why a workflow is easier to test and audit than an agent.

## Tested skeleton (stubs instead of real API calls)

I ran a small prompt chain with a bounded retry and a human gate (`python3 -I chain_demo.py`). Output:

```
{'status': 'approved', 'listing': {'title': 'Acme Bottle - insulated', 'bullets': ['insulated']}, 'attempts': 2}
{'status': 'rejected', 'listing': {'title': 'Acme Bottle - insulated', 'bullets': ['insulated']}}
```

First run: the draft contained the banned word "best", failed the check, was regenerated and passed on attempt 2, then the approver said yes. Second run: the approver said no, so nothing would be written. The demo shows the control flow only; the LLM and Amazon calls are stubs, so it says nothing about real quality or API behavior.

## Claude Code's own "dynamic workflows" (verified, [official docs](https://code.claude.com/docs/en/workflows))

- A JavaScript script that orchestrates many subagents; Claude writes it, a runtime executes it in the background. With subagents or skills Claude decides turn by turn what runs next; with a workflow the script holds the plan, the loops and the intermediate results, so Claude's context holds only the final answer.
- Script calls: `agent()` runs one subagent (optionally with a JSON schema), `pipeline()` runs one per list item, `parallel()` runs a set at once, `phase()` groups for the progress view.
- Limits: up to 16 concurrent agents by default, 4,096 items per `parallel()` or `pipeline()` call, 1,000 agents per run, no mid-run user input, no module loading.
- Control: you approve the plan before it runs (depending on permission mode); `/workflows` shows progress and lets you pause or stop; runs resume within the same session, and completed agents return saved results.
- Cost: a run can use meaningfully more tokens than the same task in conversation; a "Large workflow" warning shows above 25 agents or about 1.5 million projected tokens. It starts only when you opt in with the keyword `ultracode`, a direct request, or `/effort ultracode`.
- Subagents ([SDK docs](https://code.claude.com/docs/en/agent-sdk/subagents)): each has its own context and returns only its final message, can be limited to specific tools, and by default nesting is capped at 3 layers and 20 concurrent, with a spend cap option.
- Relevance (inferred): this is a tool for coding and research tasks inside Claude Code, not the production runtime for your listing pipeline. It could help you audit or migrate the Python code. I did not run one.

## Where workflows fail (secondary; arithmetic is mine)

- **Compounding errors.** If each step is right 95% of the time, 20 steps give 0.95^20, about 36%. At 90% per step it is 59% over 5 steps, 35% over 10 and 12% over 20. This is arithmetic, not a benchmark. [Mirantis/Lens](https://www.mirantis.com/blog/why-ai-agents-fail-in-production/) (2026-05-12, a vendor post) makes the same point and also recommends short workflows, validation checkpoints, and human approval for destructive operations. Several of its other statistics have no named source.
- **Cost and loops.** Anthropic says autonomy raises cost and compounding-error risk and should be tested in sandboxes with guardrails.
- **Frameworks.** Anthropic warns that framework abstractions can hide prompts and responses; start with direct API calls.

## Options for your listing pipeline

1. **Fixed prompt chain with deterministic checks and a human gate.** Cost: lowest tokens and engineering; repeatable. Risk: less flexible on odd listings.
2. **Chain plus evaluator loop and voting on risky claims.** Cost: 2 to 5 times the model calls for those steps (my estimate, not measured). Benefit: fewer compliance misses.
3. **Open-ended agent with tools.** Cost: highest and least predictable; error risk compounds. Benefit: handles unforeseen cases.

**Recommendation: option 1, then add option 2 only for the checks that fail often in review logs.** Because your steps are known (facts, draft, validate, approve, write, re-read), and Anthropic's own guidance is to add complexity only when it clearly helps. Tradeoff: odd cases go to a human instead of being handled automatically. What would change it: review logs showing many edge cases that a fixed path mishandles.

## Gaps

- Anthropic's agents post is from December 2024; its tooling advice has partly changed.
- The Mirantis post is a vendor article; its percentages other than the arithmetic have no named sources.
- Not read: the Workflow tool's SDK reference, the `workflow-authoring` skill, Claude Agent SDK Python reference, Anthropic's tool-use tutorial.
- Stopped on effort, not saturation. Next searches: "Claude Agent SDK Python agent loop budget"; independent evaluations of multi-step agent reliability; LangGraph versus plain Python for fixed pipelines.

Not checked: the demo against real Claude or SP-API calls; any Workflow run; the listing-specific cost multiplier in option 2.
