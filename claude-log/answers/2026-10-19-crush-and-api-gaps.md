# Crush identified, API gaps closed, design corrected

Date: 2026-10-19. Follows `2026-10-19-agentic-listing-workflow-design.md`. Question type: research. Assumption tested: that the design's SP-API steps and the AUP concern held up against Amazon's own pages.
Labels: verified = I opened the source and it states this; inferred = follows from verified facts (step shown); unverified = snippet only or memory.

## Answer

Start your agentic workflow as draft-only with staff entering changes, and defer a write-capable SP-API app until counsel has read Amazon's agreements, because the API route for serving many clients appears to require a public app, which brings the Acceptable Use Policy (AUP) clauses I flagged fully into play. Also correct two things in my earlier design: Amazon says validation preview is not for production use, and Search Query Performance reports cannot be scheduled.

## What "Crush Amazon accelerator" is

- **Verified (MediaPost, 2025-04-08, trade press):** Crush is a marketing agency specializing in Amazon, founded in 2022 by Matthew Rosenfeld, acquired by Acadia; it stays a separate brand with Rosenfeld leading it; compensation is tied to the sales growth it achieves; named clients David Protein, Malk, Black Rifle Coffee and True Botanicals; after the deal its clients can use Acadia's analytics, social, paid media and SEO.
- **Verified (headlines only):** Acadia's own release page, MediaPost and LBB titled it "Acadia Acquires Amazon Accelerator CRUSH". Acadia's page body came back as navigation only (retried once), so I could not read Acadia's own description. This resolves my earlier "not identified": the accelerator is Crush itself.
- **Unverified (snippets only):** an eight-figure price (techleap), a 50% retail-practice growth claim (Adweek), a small-retainer-plus-capped-percentage model (search summary), and an LBB date of September 2025 that conflicts with MediaPost's April 2025 (LBB returned 403).
- **Not found:** what Crush's accelerator includes (data stack, tools, SP-API access, any AI tooling) and whether Acadia already has its own AI listing tools. Acadia's listing-optimization and AI pages returned navigation only.
- **Inferred implication:** pay tied to client sales growth means the workflow must show sales-based results. That favors the A/B-tested measurement step and an honest report of null results, because a revenue-share client will judge you on sales, not on drafts shipped.

## Corrections to the earlier design (all from Amazon pages I opened)

1. **Validation preview is not for production.** `mode=VALIDATION_PREVIEW` works on put and patch, does not persist data, and is throttled to one request per second ([changelog](https://developer-docs.amazon/sp-api/changelog/update-listings-items-api-v2021-08-01-now-supports-previewing-errors)). Amazon's [Manage Listings Issues](https://developer-docs.amazon/sp-api/docs/manage-listings-issues) says it has lower rate limits, is for testing a small number of listings, and is "not designed for production workflows". My earlier step "preview, then patch" on every write was wrong. Use preview on a pre-launch test set and spot checks. In production, read synchronous errors from the response, subscribe to `LISTINGS_ITEM_ISSUES_CHANGE` and `LISTINGS_ITEM_STATUS_CHANGE`, then call `getListingsItem` or `searchListingsItems` with issues included. For bulk feeds, download the processing report. ERROR severity blocks an update; WARNING does not. The 5 requests/second default for put stays snippet-only.
2. **Search Query Performance (SQP):** the report type `GET_BRAND_ANALYTICS_SEARCH_QUERY_PERFORMANCE_REPORT` exists. It needs the Brand Analytics role and Brand Registry, requires an `asin` option, supports WEEK, MONTH and QUARTER (MONTH up to 17 months), and can only be requested, not scheduled ([Analytics Reports](https://developer-docs.amazon/sp-api/docs/report-type-values-analytics)). Build your own job to request it. The agency blog's 1,000 and 100 query limits and its 2025-02-26 start date remain secondary.
3. **Review data is topic-level.** The [Customer Feedback API](https://developer-docs.amazon/sp-api/docs/customer-feedback-api) (v2024-06-01) returns review topics at ASIN and browse-node level and return topics at browse-node level only, weekly refresh, English, seven marketplaces (US, UK, FR, IT, DE, ES, JP), roles Brand Analytics or Selling Partner Insights, and says it mirrors Product Opportunity Explorer. The page does not describe raw review text, so plan on topics. This replaces my earlier "reviews via API: not checked".

## Access path and the AUP question (narrowed, not settled)

- **Verified ([Amazon: register as a developer](https://developer-docs.amazon/sp-api/docs/registering-as-a-developer)):** private seller apps are for your own organization and self-authorized (professional account required). Public apps are authorized by sellers through OAuth and listed in the Selling Partner Appstore under the Solution Provider Portal Agreement. Registration tells you to review the AUP, Data Protection Policy and that agreement first. The page does not address agencies directly.
- **Inferred:** a workflow that calls SP-API against many clients' accounts needs a public app, because a private app reaches only your own organization. Then the AUP's §4.4 and §4.6 on combining or disclosing data across authorized users likely apply to you. Confidence: medium-low, because the page does not mention agencies and I can't give a legal reading.
- **Verified ([Amazon: role approval](https://developer-docs.amazon/sp-api/docs/service-provider-registration-and-role-approval-process)):** for a human service provider using Seller Central, sellers can't grant permissions until Amazon approves the provider's roles in the Solution Provider Portal, which can take up to 10 business days. The page lists no specific roles.
- **Verified ([Amazon changelog](https://developer-docs.amazon/sp-api/changelog/sp-api-updates-simplified-authorization-for-service-providers-external-fulfillment-sandbox-changes-and-multi-invoice-support-changes-for-brazil)):** from 2026-08-19 sellers authorize providers through a simplified three-step flow scoped to the provider's qualified categories, via an authorization link or the provider's listing.
- **Secondary only ([beBOLD](https://www.bebolddigital.com/news/amazon-seller-central-service-provider-authorization), [EcomCrew](https://www.ecomcrew.com/amazon-is-resetting-every-agencys-access-to-your-seller-central-account/), both citing EcomRanker):** existing agency access is being reauthorized role by role, with a September 16, 2026 provider deadline, seller-specific deadlines, access lapsing if missed, and 365-day authorizations. beBOLD gives August 10 as the start; Amazon's changelog says August 19, so I used Amazon's. Amazon's page for the September process was not found.
- **Inferred, and time-sensitive:** today is 2026-10-19, after the secondary-reported September deadline. If those reports are right, some clients' agency access may have lapsed or been narrowed to approved roles. Check each client's status in Seller Central under User Permissions, then Manage Services.

## Updated options

1. **Draft-only, staff apply changes.** Cost: lowest build; staff time per change. Risk: lowest, because it needs no SP-API write app and, inferred, keeps you out of the "Application" regime. You still need service-provider role approval for the human access you use.
2. **Gated-write on a public SP-API app.** Cost: Appstore listing and developer review, security questionnaire, per-client OAuth, review UI, notification handling. Risk: moderate; AUP §4.4 and §4.6 likely bind, and every client's data must stay isolated.
3. **Amazon's Selling Partner connector for Claude.** Cost: least build. Risk: beta, US-only per secondary sources, limited control (from the earlier research).

**Recommendation: option 1 now, option 2 only after counsel.** Because option 1 delivers the measured value (drafts, validation, tests) without the registration and data-pooling exposure, and the Fang et al. effect is small enough that build cost should wait on proof of value. Main tradeoff: staff keep doing the apply step, so throughput is lower. What would change it: counsel clears multi-client SP-API use, a pilot shows approval-without-edit above 90% (vendor-suggested threshold), or Amazon documents write scopes for its connector.

## Next actions only you can take

1. Check each client's service-provider authorization status (see above).
2. Give counsel the AUP (§2.4, §2.10, §4.4, §4.6), the Data Protection Policy and the Solution Provider Portal Agreement.
3. Tell me what Crush's accelerator already includes, because that decides whether to build or reuse.

## Gaps

- Snippet-only or secondary: eight-figure price, 50% growth, Crush pay model details, the September 16 deadline and 365-day lapse, SQP's 1,000/100 limits, the 5 requests/second put limit.
- Not read: Acadia's own description of Crush, Acadia AI pages, LBB, the "Learn How Sellers Authorize Service Providers" page, the authorization limits page, the Solution Provider Portal Agreement and which Seller Central roles exist for listing content.
- Not found: any statement of what Crush's accelerator includes.
- Stopped on effort, not saturation: the last searches still returned new Amazon primary pages. Next searches: "Learn How Sellers Authorize Service Providers"; SP-API authorization limits; Solution Provider Portal Agreement text; Seller Central roles for service providers (listing and content); Crush's own site; LBB's article date.

Not checked: legal effect of the AUP, DPP and Solution Provider Portal Agreement on agencies; whether clients' access is still active; whether the 5 requests/second default applies; this design has not been run.
