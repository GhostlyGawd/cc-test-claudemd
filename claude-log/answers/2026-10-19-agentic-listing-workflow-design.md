# Designing an agentic listing optimization workflow for Acadia clients

Date: 2026-10-19. Builds on `2026-10-19-ai-listing-optimization-research.md` in this folder.
Labels: verified = I opened the source and it states this; inferred = follows from verified facts (step shown); unverified = snippet only or memory.

## Answer

Build a gated-write workflow (agent drafts, a strategist approves, the API patches, results are A/B tested), and start every client in draft-only mode, because every credible design I found stops short of autonomous publishing and the one measured effect is small and uneven. Two things need a decision before any code: whether Amazon's data rules allow one shared workflow across clients, and whether your value claim is time and compliance rather than a promised conversion lift.

## Pushback (problems that cost money or can't be undone)

1. **Pooling client data may breach Amazon's Acceptable Use Policy.** The AUP (opened; no effective date shown on the page) says: "Do not disclose Information, individually labelled or aggregated, to other Application users" (§4.6), and, paraphrased by the fetch tool, you may not combine data from Authorized Users' businesses obtained through the API to provide or sell to any party (§4.4). A shared prompt library, vector store or fine-tune built from Brand Analytics, listings or reviews across clients is exactly that pattern. Whether these clauses bind an agency using delegated account access, as opposed to a developer's registered "Application", is unresolved and is a legal question I can't answer. The cost of being wrong is API access and possibly client accounts. Alternative: isolate each client (separate stores, prompts and credentials) and share only things that are not Amazon Information, such as your own rubrics, validators and process metrics. Confidence: medium on the clause text (primary page, one read, §4.4 and §4.8 paraphrased by the tool), low on applicability.
2. **Do not promise a conversion lift.** The only randomized evidence for AI-written descriptions (Fang et al., arXiv 2510.12049, html read to 200,000 of 202,640 characters) found +2.05% sales on average, +6.5% on products with 50 words or fewer, and no significant change above 50 words, on one cross-border platform. I found no independent test on Amazon listings. Sell speed, consistency and compliance, and report tested lift per client.
3. **Never use `putListingsItem` for routine edits.** Amazon's use-case guide (opened) says a put replaces the listing and can remove attributes left out, with bullet points as the example. Use `patchListingsItem` (top-level attributes only) after a preview.

## What the building blocks allow (verified unless marked)

- **Read listings:** `getListingsItem`, `searchListingsItems`; roles Product Listing or Inventory and Order Tracking ([Listings Items guide](https://developer-docs.amazon/sp-api/docs/listings-items-api-v2021-08-01-use-case-guide)).
- **Write listings:** put, patch, delete one listing at a time; bulk via the `JSON_LISTINGS_FEED` feed. The put/patch/delete response shows only acceptance and blocking issues; problems found after processing appear on a later `getListingsItem`. So the workflow must re-read after every write.
- **Preview and limits:** a validation-preview mode and rates of 5 requests/second (burst 10) and 1/second for preview appear only in a search snippet of the v2021-08-01 reference (unverified; the guide I opened gave no rate limits).
- **A+ content:** ten operations including create, update, ASIN relations and approval submission; roles Brand Analytics or Product Listing ([A+ guide](https://developer-docs.amazon/sp-api/docs/a-content-api-use-case-guide)). The approval flow, status values and "no more than once an hour" limit for status checks are snippet-only (unverified).
- **Search demand data:** Search Query Performance reports through SP-API since 2025-02-26, needing Brand Registry and the Brand Analytics role, 1,000 queries at brand level and 100 per ASIN ([Clear Ads Agency](https://clearadsagency.com/api-access-to-search-query-performance-sqp-reports/), agency blog; the official SQP page was not found, so these details are secondary).
- **Experiments:** Amazon's seller page lets brands A/B test product information but says nothing about an API ([page](https://sell.amazon.com/blog/amazon-split-test)); one search for programmatic access found only other vendors' tools. Treat Manage Your Experiments as manual until shown otherwise (not found, not "does not exist").
- **Amazon's own connector:** the Amazon Selling Partner connector for Claude is in beta, made by Amazon, with a read tool and a write tool, and says you "review and approve every action" ([listing](https://claude.com/marketplace/connectors/amazon-selling-partner)). A US-only beta and the free Quick Plus year come from secondary sources (see the earlier report).
- **Data rules for the LLM step:** the Data Protection Policy (opened) has no AI clause but requires annual third-party risk assessments of subcontractors (§2.8), PII retention of no more than 30 days after delivery (§2.1), and deletion within 30 days of a trigger (§1.7). The AUP asks you to be explicit about AI use, its accuracy and data freshness (§2.4) and to run data-integrity checks on analytical processing (§2.10). The AUP has no clause on training models on Amazon Information (not found in the version I read). An LLM provider that receives listing or Brand Analytics data is a subprocessor to assess.

## How others structure it

- **IPG via Width.ai (2026-06-22):** about 14 agent nodes (compliance, keyword analysis, content generation) producing optimization briefs; deterministic checks (character limits, prohibited terms, keyword coverage) plus an LLM review and a hallucination screen; strategists review every brief; it does not write to live listings; no measured outcomes published ([article](https://www.width.ai/post/agentic-ai-for-e-commerce-at-enterprise-scale)). Vendor-authored.
- **Seller Labs agent guide (updated 2026-08-03):** start read-only or draft-only, review queue, human approval before any write, log rejection reasons; suggests loosening review above 90% edit-free approval and refining below 70% (vendor-reported thresholds); its 82% approval figure for one small seller is vendor-reported ([article](https://www.sellerlabs.com/knowledge-base/building-an-ai-agent-for-amazon-tasks-whats-possible-today/)). It excludes browser automation of Seller Central as a terms violation.
- No independent, quantified results (lift, error rate, hours saved) for any agency running this across clients were found.

## Options

1. **Draft-only briefs (IPG pattern).** Agent produces a brief per ASIN; staff paste into Seller Central. Cost: lowest engineering and no write scope, so lowest policy risk; staff copy-paste time stays. Risk: you never get the post-write verification loop.
2. **Gated-write agent on your own SP-API integration.** Draft, validate, human approve, preview, patch, re-read for issues, snapshot for rollback, test in Manage Your Experiments. Cost: per-client authorization and credentials, a review UI, logging, QA; moderate risk, bounded by the approval gate.
3. **Build on Amazon's Selling Partner connector.** Your prompts and rules run in Claude with Amazon's approve-every-action write tool. Cost: least build; but it is a beta with US-only scope per secondary sources, you don't control the tool surface, and client data flows under Amazon's and Anthropic's terms.

**Recommendation: option 2, rolled out through option 1 first.** Run draft-only for the first batch per client, record approval-without-edit rate and rejection reasons, then enable gated writes. Because the preview, patch and post-write re-read steps are what catch Amazon-side rejections that the put/patch response does not show.

## Workflow (inferred from the verified blocks above)

1. **Tenancy:** one credential set, store and log per client; no cross-client retrieval of Amazon-sourced data.
2. **Triage:** rank listings by thin text (the 50-word split), missing attributes and demand gaps from SQP; start with new, thin and long-tail ASINs where the measured effect was largest.
3. **Draft:** generate title, bullets, description, backend terms (and A+ text) from a per-client claim library (approved claims, forbidden terms, spec sheets). Keep the model's inputs to documents the client supplied plus that client's own Amazon data.
4. **Validate:** deterministic checks (length limits, prohibited terms, keyword coverage), a grounding check against the spec sheet, and an LLM critic. The critic never replaces the human gate.
5. **Human gate:** strategist approves or rejects with a reason; log both.
6. **Preview and write:** preview, then `patchListingsItem`; snapshot the prior `getListingsItem` for rollback; re-read after processing and alert on issues.
7. **Measure:** run a Manage Your Experiments test on a sample of changed ASINs; record result and significance per client; report honestly, including nulls.
8. **Disclose:** keep the AI-use and accuracy statements the AUP asks for, and a retention and deletion schedule for any stored Amazon data.

## What would change this

- Counsel says the AUP data clauses don't reach delegated agency access: shared retrieval across clients becomes an option (benefit: faster improvement of prompts).
- Approval-without-edit above 90% for 60 days on a client, with no policy flags: allow auto-publish for low-risk fields only (vendor-suggested threshold, not independently validated).
- Amazon documents write scopes and data handling for its connector and opens it beyond the US: option 3 becomes the cheapest path.
- An API for experiments appears: automate the measure step.

## Assumptions and open facts

- "Crush Amazon accelerator" was not identified. A search found only unrelated Alexa/Techstars and Louisiana programs; the eMarketer article on Acadia's acquisition of Crush returned HTTP 403. A search snippet describes Acadia as a growth agency that acquired Crush, an Amazon-focused consultancy (unverified). I assumed it refers to Acadia's Crush Amazon practice. Fact that would change the design: what the accelerator already includes (data stack, SP-API access, client mix).
- Which clients are brand-registered (needed for Search Query Performance and Manage Your Experiments) is unknown.

## Gaps

- AUP/DPP: single read of each page, no effective date shown; §4.4, §4.8 and §3.13 are tool paraphrases; I did not read the Solution Provider Portal Agreement.
- Snippet-only: preview mode and rate limits, A+ approval flow and status limit, the official SQP report page.
- Secondary or vendor-reported: SQP details, Seller Labs and Width.ai figures, free Quick Plus year, US-only connector scope.
- Not found: any manage-experiments API, any independent multi-client agency results, whether Amazon's reviews data is reachable via SP-API for your use (not checked).
- Stopped on effort, not saturation. Next searches: the SP-API Search Query Performance official docs; Customer Feedback API; Amazon's Solution Provider Portal Agreement; "Acadia Crush Amazon" on acadia.io; Brand Registry delegated-access rules for agencies.

Not checked: legal reading of the AUP/DPP for agencies; the approval flow in the A+ guide; whether preview mode exists as described; what the Crush accelerator is; this design has not been run.
