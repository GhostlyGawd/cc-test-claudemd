# What a Python API workflow changes

Date: 2026-10-19. Follows `2026-10-19-crush-and-api-gaps.md`. Question type: research. Assumptions (unstated by the user): the Python workflow calls Amazon's Selling Partner API (SP-API) for client accounts and sends listing text to the Claude API. If either is wrong, parts of this change.
Labels: verified = I opened the source and it states this; inferred = follows from verified facts (step shown); unverified = snippet only or memory.

## Answer

Decide the app-registration model before writing more Python, because an Acadia-owned private app tops out at 10 self-authorizations and only each account's Primary User can self-authorize, so it cannot be your route to many client accounts. Pick between a public app (OAuth by clients) and one client-owned private app per client with isolated deployments; I recommend the second to start, because it avoids the cap and keeps client data separate by design.

## Pushback

1. **Keep credentials and client data out of this public repo.** Amazon's self-authorization page says refresh tokens must be stored in an encrypted database and never in client-side code, logs or URLs, and its security guidance says never store SP-API credentials in plain text. This repo is public. A refresh token or `credentials.yml` committed here is exposed the moment it is pushed, and removing it from history later does not make it safe, so rotate-and-revoke would be the only fix. Put the Python code in a private repo and the secrets in a secrets manager or KMS.

## What Amazon's pages say (verified)

- **Authorization limits** ([Amazon, updated 2026-09-09](https://developer-docs.amazon/sp-api/docs/application-authorization-limits)): private apps allow 10 self-authorizations and no OAuth; public seller apps unlisted allow 10 self-authorizations (internal testing) plus 25 OAuth; public seller apps listed on the Selling Partner Appstore allow unlimited OAuth. At the limit you cannot add more; for a private app the page says to make it public or remove existing self-authorizations. Usage shows in the "Authorizations remaining" column.
- **Self-authorization** ([Amazon](https://developer-docs.amazon/sp-api/docs/self-authorization)): you must be the Primary User of a Seller Central account to self-authorize it; each "Authorize app" click generates a refresh token; new tokens do not invalidate old ones. The page frames this as granting your own app access to your own account data and says public apps require a selling partner to authorize them.
- **Agency-built private apps** ([Amazon, private vendor page](https://developer-docs.amazon/sp-api/docs/register-as-a-private-vendor)): private apps are "available only to your organization", with the example "a third-party IT company or agency creating an app for you". That page is for vendors; I did not open a seller equivalent, so this is verified for vendors and only inferred for sellers.
- **Security controls** ([Amazon key security guidance](https://developer-docs.amazon/sp-api/docs/guidance-to-address-key-security-controls-in-sp-api-integration)): encrypt credentials (AES-128 minimum, AES-256 recommended) with a key management system and annual rotation; MFA; TLS 1.2 or higher including at third-party boundaries; security logs kept 12 months; scans every 30 days and before releases; annual penetration testing; critical fixes within 7 days; delete PII within 30 days of delivery and all information within 30 days of a trigger; notify security@amazon.com within 24 hours of an incident; annual risk assessment of every vendor or subcontractor before it gets access to Amazon data, with quarterly access reviews. The page does not say whether all of this applies to private apps; I treat it as the standard to build to.
- **Python library** ([saleweaver/python-amazon-sp-api](https://github.com/saleweaver/python-amazon-sp-api)): MIT licensed, not affiliated with Amazon; the README confirms Orders, Reports, Data Kiosk and Feeds clients and Restricted Data Token support, and says clients can be generated from a model JSON. The [docs page](https://python-amazon-sp-api.readthedocs.io/en/latest/endpoints/listings_items.html) shows a ListingsItems client in versions V2020_09_01 and V2021_08_01 but no method names or preview-mode parameter, so I could not confirm put, patch or `VALIDATION_PREVIEW` support. Multi-account use by passing a refresh token per client appears only in a search snippet of the config docs (unverified). Release dates were not shown.
- **Claude API data handling** ([Anthropic docs](https://platform.claude.com/docs/en/build-with-claude/api-and-data-retention)): conversation content is not retained by default; the exception is Covered Models (Claude Fable 5.1, Mythos 5.1, Fable 5 and Mythos 5), which require 30-day retention and are not eligible for zero data retention unless Anthropic expressly authorizes it. Retained data is never used for training without permission. Batch, Files API, code execution and the MCP connector are not eligible for zero data retention; prompt caching is. On Amazon Bedrock the cloud provider is the processor.

## What this means for the Python design (inferred)

1. **Registration model.**
   - **A. Client-owned private apps, Acadia-built.** Each client registers a developer profile and private app (professional account required), their Primary User self-authorizes, and you deploy the same Python code per client with that client's credentials in a separate secret store. Cost: per-client setup and a security questionnaire each time. Benefit: no 10-account cap, no cross-client data in one app, and AUP responsibility sits with each client as the developer (verify with counsel).
   - **B. One Acadia public app.** Clients authorize through OAuth (25 clients unlisted; unlimited if listed on the Appstore). Cost: Appstore listing and review, full Solution Provider Portal Agreement, AUP and Data Protection Policy duties for Acadia, with sections 4.4 and 4.6 on combining or disclosing data across users squarely in play. Benefit: one codebase and one authorization flow.
   - **C. One Acadia private app self-authorizing clients.** Not recommended: 10-account cap, Primary User must authorize, and the page frames self-authorization as your own account data.
2. **LLM step as a subcontractor.** Amazon's guidance asks for an annual risk assessment of any vendor before it gets access to Amazon data, so the Claude API (or any LLM provider) belongs in that assessment. To keep content from being retained, avoid Covered Models for client data, avoid Batch and Files API, and ask Anthropic about a zero data retention arrangement. If you use Bedrock instead, the processor is Amazon's cloud, which changes the assessment.
3. **Python mechanics already supported by Amazon's docs.** Use `patchListingsItem` for edits (put can drop attributes); sample-only `VALIDATION_PREVIEW` at 1 request/second; monitor issues through notifications or `getListingsItem` after each write; request Search Query Performance reports on your own schedule because Amazon does not schedule them; handle review insight as topics from the Customer Feedback API. Confirm the library's Listings methods before relying on it, or call the REST endpoints directly.
4. **Human gate stays.** Nothing in these pages argues for removing it.

## Options

1. **Client-owned private apps (A), draft-then-gated-write.** Cost: setup per client; risk: lowest of the API routes.
2. **Public app (B).** Cost: Appstore listing, compliance program, counsel; risk: highest because of cross-client data clauses.
3. **Stay draft-only (no SP-API writes), Python only for drafting and validation.** Cost: staff time per change; risk: lowest.

**Recommendation: option 1 for clients you want write access on, option 3 for everything else, and no public app until counsel clears the data clauses.** Because option 1 isolates each client by construction and avoids the cap, and option 3 needs no write scope. Tradeoff: more setup per client than one shared app. What would change it: counsel says option 2's clauses do not bind you, you serve well over a handful of write-enabled clients, or Amazon documents a seller-side agency pattern that fits better.

## Gaps

- Assumptions not confirmed: SP-API and the Claude API are what the Python workflow uses.
- Not opened: a seller equivalent of the private-vendor page; the Solution Provider Portal Agreement; Amazon's Appstore listing requirements; the library's Listings method pages and release dates; Anthropic's commercial terms and its Covered Models support article.
- Snippet only: library multi-account configuration.
- Not found: any Amazon statement that explicitly allows or forbids an agency to operate a client-owned private app for sellers.
- Stopped on effort, not saturation. Next searches: "Register as a Private SP-API Seller"; "Selling Partner Appstore listing requirements"; python-amazon-sp-api Listings method pages; Anthropic zero data retention request process.

Not checked: legal effect of any Amazon agreement on this setup; that the Python library supports the Listings write calls you need; anything about your current registration or LLM provider; this design has not been run.
