# How people and vendors use AI to optimize Amazon and e-commerce listings

Research date: 2026-10-19. Project rules followed: /CLAUDE.md "Research" section (labels: verified = a source I opened states it; inferred = follows from verified facts; unverified = from memory or seen only in a snippet).
Companion files: `coverage.md` (all queries, pages opened, failed and unopened pages) and `cc-test-claudemd.md` (decision log).

## Bottom line

AI is mostly used to speed up listing work: drafting titles, bullets, descriptions and A+ content, mining keywords and reviews, and generating images. The best independent evidence shows a small sales lift (about 2%) from AI-written descriptions, concentrated on listings with little existing text. No independent head-to-head test of AI-written versus human-written Amazon listings was found. Most vendors appear to wrap third-party LLMs around their own Amazon data and add a scoring layer; none published evidence of fine-tuned models, though absence of documentation is not proof of absence.

## Question labels and assumptions

- Q1 "How are people optimizing Amazon and eCommerce listings using AI": research. Assumption tested: AI listing optimization works well enough to be widely adopted. Result: adoption is real (Amazon ships its own tools, many vendors), but efficacy evidence is thin.
- Q5 "How are the companies like ZonGuru doing it": research. Assumption tested: vendors are thin wrappers around third-party LLMs plus proprietary data. Result: partly supported (see vendors section).
- Q6 "What is Quick?": lookup.

## 1. How listings are being optimized with AI

1. **Amazon's built-in tools (verified).** Amazon's seller blog (https://sell.amazon.com/blog/amazon-listing-ai, 2025-11-03) describes listing creation from product images (up to three), a public URL, or a spreadsheet (bulk, new catalog products only), and gen-AI A+ Content modules. Sellers review and approve drafts and are responsible for accuracy. Amazon says its gen AI is powered by Amazon Bedrock. Amazon's stated figures (over 70% of required attributes filled, 40% listing quality increase, Basic A+ up to +8% sales, Premium A+ up to +20%) cite Amazon internal data and are unverified. The first tool launched 2023-09-13 per CNBC (verified); Digital Commerce 360 (2024-09-24) says "earlier this year", which conflicts and is unresolved.
2. **General chatbots for drafting (verified, vendor sources).** Sellers prompt ChatGPT or Claude with product facts and keywords for titles (200-character limit), bullets and A+ copy, and to group keyword lists by intent (ZonGuru guide 2026-01-22; SellerSprite; RevenueGeeks). All of these sources sell seller tools. ZonGuru's own guide offers no performance data for ChatGPT-written listings.
3. **Third-party listing tools** (see vendors section).
4. **Writing from customer language (verified, vendor source).** Seller Labs (2026-03-19) argues AI listings underperform when built from seller assumptions, and recommends mining three-star reviews, return-reason text and Brand Analytics search terms first. Its supporting figures (an $15,000 anecdote, 8% vs 14% conversion) are an unverified single story from a tool vendor.
5. **Listing for AI shopping surfaces (inferred).** Advice centers on complete structured attributes and buyer-language copy for Amazon's assistant (Rufus, now also referred to as "Alexa for Shopping" in Amazon's 2026 recap; no source I opened states a rename) and for COSMO. Sources agree Amazon has published no optimization playbook, so tactics are inference.
6. **Images and video (unverified, vendor sources).** AI background replacement, lifestyle scenes for secondary images, and Amazon's video generator. Advice: keep the main image to plain background removal. No independent AI-versus-photography test was found.
7. **Other marketplaces.** Walmart announced an AI-Powered Listing Tool (single and bulk setup) in August 2025 (verified: Walmart corporate release; no availability or numbers). No official Etsy or eBay tool was found in results (third-party tools only; native help pages not checked).
8. **AI shopping engines (low confidence, vendor guide).** BigCommerce (2026-09-30): ChatGPT leans on merchant-submitted feeds plus a crawler; Google AI Mode uses Merchant Center; Perplexity accepts Google-Shopping-formatted feeds and PayPal merchants. In-chat checkout is mostly not live; OpenAI's Instant Checkout was retired in March 2026 per that guide (not checked against OpenAI).

## 2. Does it work?

**Best evidence (verified; medium confidence):** Fang, Yuan, Zhang, Donati, Sarvary, "Generative AI and Firm Productivity: Field Experiments in Online Retail", arXiv 2510.12049v3. Randomized field experiments on one large cross-border retail platform, seven GenAI workflows, 2023 to 2024.
- Product Description workflow: consumers who clicked product pages were randomized (about 4.77 million consumers, five one-week sub-experiments, December 2023). AI-written content added on top of human descriptions raised sales about 2.05% (2.1% in the earlier read), conversion about 1.27%, orders about 1.08%; return rates fell 3.9% (p<0.01); ratings unchanged.
- Heterogeneity: products with 50 words or fewer in the original description saw +6.5% sales (p<0.05); longer descriptions showed no significant change (difference between groups p about 0.054). Low-experience buyers gained +5.6%; experienced buyers about zero.
- Google Advertising Title workflow: AI titles showed sales -4.5%, not significant; authors suggest a non-fine-tuned model and ad-system deprioritization.
- The 0% to 16.3% range in the abstract spans all seven workflows, not listing copy. Annualized value about $0.54 per consumer for the description workflow.
- Limits: one platform, self-sold products, weeks-to-months horizon, no competitor-response modeling, English-only for the length analysis.

**Not found:** a published head-to-head test of AI versus human Amazon listing copy (Manage Your Experiments or otherwise). The keywords.am figures (23.7%, 2.5% vs 2.1%, 26%) have no named sources (verified by opening the page).

**Vendor-sourced lift claims, not independent (unverified):** Shopify Magic 18% (traces to a single secondary source), 78% (a tool vendor), 23% to 31% (no methodology). Shopify Magic article (ecommerce-platforms.com) cites no conversion data.

**Shopper reaction (verified from press release only; medium-low):** WSU study (Journal of Hospitality Marketing & Management, more than 1,000 US adults): mentioning "AI" in product descriptions lowered emotional trust and purchase intent, more so for high-risk products. It tested AI as a product feature, not AI-written copy. Effect sizes not reported in the press release; full paper not opened.

**Other:** Walmart fine-tuned LLaMA 2 7B for descriptions (arXiv 2310.18357, abstract only): evaluated by NDCG, click-through and human assessment; no numbers or live conversion test in the abstract. Amazon researchers describe hallucination as a risk in LLM-enriched listings (EMNLP 2024 workshop, abstract only).

## 3. How Amazon ranks and surfaces listings

- COSMO (SIGMOD 2024, Amazon Science abstract, verified): mines user behavior into a commonsense knowledge graph, deployed in search applications, expanded to 18 categories from about 30k annotated instructions. The abstract does not mention seller listings, so advice to "write for COSMO" is inference. The full PDF returned 404.
- Rufus: only news and seller-blog coverage found; no Amazon technical source (Tom's Guide etc. not opened).
- Patents: US10937078B1 "Dynamic generation of item description content" (Amazon Technologies, filed 2018-01-31, granted 2021-03-02) generates descriptions tailored to a shopper profile; not a seller-facing tool and pre-LLM; claims not read. Two other patents surfaced without a confirmed Amazon assignee (not attributed).

## 4. Policy and risk

- Sellers are responsible for accuracy of AI-generated drafts (Amazon seller blog, verified).
- Photorealistic AI-generated people in images and A+ need metadata keyword `contains-synthetic-performer` (MyAmazonGuy, secondary, says it relays a Seller Central notice; no date or penalties stated; Amazon's notice not opened).
- Anecdotal failure case (Amazon Canada seller forum, undated): Amazon's "Generate listing content" produced a prohibited health claim and overwrote the title; relisting was blocked by a catalog error until a Brand Registry permission in another marketplace was removed. No Amazon staff reply.
- FTC final rule on fake reviews (ftc.gov press release, verified) explicitly covers AI-generated fake reviews, with civil penalties for knowing violations. It governs reviews, not seller-written listing copy. Effective date stated as 60 days after Federal Register publication (secondary sources say 2024-10-21).
- Amazon's own generative-AI content policy text was not found.

## 5. The vendors and how they build

| Company | Product | What its own pages say | Label |
|---|---|---|---|
| ZonGuru | Listing Optimizer, AI listing analysis | Scores a public ASIN against "COSMO Semantic Mapping" and "Alexa for Shopping Q&A coverage" (ZonGuru's own definitions) into a score out of 100, plus a 75/125-character check. Model not named; formula undisclosed. A search snippet said GPT-4 plus its "Keywords on Fire" data, from a page not opened. | Model unverified |
| Helium 10 | Listing Builder, Listing Analyzer, Cerebro, Magnet | Product page: "Integrated with Chat GPT" (no version). Inputs: keyword lists, competitor ASINs, tone, brand placement; syncs to Seller Central. Plans: Platinum about $99/mo yearly, Diamond about $279/mo, Enterprise from $1,499/mo. A snippet claiming "ChatGPT-5.1" is NOT supported by the pages opened. | Verified (vendor page) |
| Jungle Scout | AI Listing Builder, Review Analysis, AI Assist chat | Builds from Keyword Scout lists and ASIN reviews; recommends editing output. No model named on pages opened; a 2023 snippet said ChatGPT (release unreadable, 403). | Model unverified |
| Jarvio | Listing optimization agent | Uses Claude and Gemini; inputs Brand Analytics, SP-API listing content, your and competitors' reviews; nothing publishes without approval; updates flat text only. | Verified (vendor page) |
| Hypotenuse AI | Catalog content and enrichment | Claims a model trained on the customer's own product pages, per-value confidence scores, audit trail, SOC 2. No models named; training and scoring undescribed. | Technical claims unverified |
| AmazonSEO.ai | Optimizer (AWS Marketplace) | "Tuned for Rufus and COSMO", weekly Brand Analytics terms, $19.90 to $99.90/mo; no model named. | Unverified |
| Viral Launch | LaunchGPT | Snippet only (GPT-4 plus Amazon logic); pages returned empty. | Unverified |
| Amazon | Seller Central generator | Did not name its LLMs (TechCrunch 2023); later materials say Bedrock. | Verified |

Ownership: RevenueGeeks (2026-05-01, single secondary source) says Helium 10 is owned by Assembly (acquired 2020), with Pacvue acquired 2021 and the group unified under the Pacvue name in 2023, and notes an internal inconsistency in its own timeline. A PitchBook snippet agrees but was not opened. An ATDb snippet claiming Thrasio is unsupported. No funding data (Tracxn returned 403). Pacvue and Perpetua are advertising automation platforms, not listing writers (snippet-level).

**Inferred build pattern:** (1) a proprietary data layer (keywords and search volumes, Brand Analytics, reviews, competitor listings, SP-API listing data); (2) prompts that package that data with Amazon's formatting rules; (3) a proprietary listing "score" with undisclosed method; (4) workflow features (approval, bulk output, sync to Seller Central). **Disproof attempt:** one search for fine-tuned or proprietary models at these vendors found nothing beyond marketing claims by Hypotenuse and AmazonSEO.ai; this supports but does not prove the wrapper-plus-data picture.

## 6. 2026 shift and "Quick"

- Amazon Accelerate 2026 (Seattle, September 2026; Amazon recap, verified): sellers can connect Seller Central data to outside AI tools, starting with Claude and Amazon Quick in the US, carrying skills such as sales-trend analysis and listing optimization. Seller Assistant now monitors continuously and can act within seller-set limits; Amazon says shoppers describe problems in plain language and clear explanations should benefit sellers more than keyword reliance. My inference: this weakens vendors whose main value is access to seller data.
- **Amazon Quick** (AWS FAQ and April 2026 announcement, verified): an AWS AI assistant for work that connects to apps and data and takes actions; components include Quick Flows, Quick Automate, Quick Sight (BI, Professional/Enterprise), Quick Research (cited reports) and a desktop app (Plus and above). Plans: Free, Plus (30-day trial for new signups), Professional, Enterprise; Free and Plus announced 2026-04-28, no AWS account required. AWS states it does not use customer data to train models. The AWS page lists no prices. Origin: launched as Quick Suite on 2025-10-09 as an evolution of QuickSight (search results, not opened).
- Seller plugin and offer (novadata.io, secondary; medium-low): Selling Partner plugin announced 2026-09-23, US beta only; 12 months of Quick Plus free for primary account holders who sign up by 2026-12-31; plugin reads listings, inventory and sales (not cost of goods, freight, duties, VAT); actions require human approval and are logged. Claim that Seller Assistant runs on Claude via Bedrock appears only in this source.

## 7. Corrections made during the research

- Project Amelia, AI-written titles and the Video Generator were announced at Accelerate 2024 (Sept 2024), not 2025.
- "Up to 16.3%" from Fang et al. is the all-workflow range, not the listing-copy effect.
- Helium 10 "ChatGPT-5.1": unsupported by pages opened.
- Search count: 39 queries, not "about 45".

## 8. Confidence summary

| Claim | Confidence | Why |
|---|---|---|
| Amazon offers AI listing generation and A+ tools | High | Amazon's own pages plus press |
| AI-written descriptions give about a 2% sales lift, mainly on thin listings | Medium | One primary randomized study, one platform, abstract plus html read |
| Detailed existing listings gain little | Medium-low | Sub-group result, marginal significance |
| Vendors mainly wrap third-party LLMs with proprietary data | Low-medium | Helium 10 and Jarvio pages name models; others undisclosed |
| AI "AI" label hurts purchase intent | Medium-low | Press release only; tests the term in product features |
| Rufus/COSMO tactics, AI image gains, feed-sourcing claims | Low | Inference or vendor claims |
| Quick seller offer and plugin details | Medium-low | Single secondary source |

## 9. Suggested actions (inference)

1. Use AI mainly on thin or new listings; do not expect much on strong ones.
2. Start from real customer language and complete attributes; verify every claim before publishing.
3. Run your own Manage Your Experiments test with AI copy as the only change.
4. Do not pay a premium for "proprietary AI" without evidence; the data layer is the real asset.

## 10. Known gaps

No independent AI-versus-human Amazon listing test; no Reddit or seller-community evidence (tool blocked); no vendor funding or deal history beyond one ownership claim; no Etsy or eBay native tool documentation; no independent AI-image conversion study; Rufus mechanics unsourced; full texts of the WSU, EMNLP hallucination, Walmart and COSMO papers not read. See `coverage.md` for the exact list of failed and unopened pages.
