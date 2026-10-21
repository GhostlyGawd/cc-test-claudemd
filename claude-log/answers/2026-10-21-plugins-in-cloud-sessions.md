# How to install plugins in a setup like ours (Claude Code cloud session, GitHub repo)

Date: 2026-10-21. Label: research. Assumption tested: a plugin enabled in the repo's `.claude/settings.json` loads in new cloud sessions. Result: FALSE per official docs.

## Answer
Our setup is a cloud session on a fresh clone of the repo. Anthropic's docs say a cloud session does not install plugins or marketplaces declared in the repo's `.claude/settings.json`, and does not load user-scope plugins from `~/.claude`. So my earlier fix (committed `.claude/settings.json`, 2026-10-21) does nothing in cloud sessions. It still works for local terminal sessions.

## Verified (pages opened this session, all Anthropic docs = one origin, primary)
- cloud-environments, "What carries over": table row "Plugins and marketplaces declared in your repo's .claude/settings.json: No"; row "Plugins enabled only in your user settings: No"; rows for repo `.claude/skills/`, `agents/`, `commands/`: Yes (part of the clone).
- discover-plugins, "Cloud session" tab: a cloud session "doesn't load the plugins you installed on your own machine or the ones your repository's .claude/settings.json turns on"; org plugins arrive only via managed settings.
- settings, "Settings in cloud sessions": same statement for enabledPlugins and extraKnownMarketplaces; project-scope marketplaces also wait for folder trust.
- cloud-environments, setup scripts: a Bash script in the environment dialog runs as root before Claude Code launches; filesystem snapshot is cached (about 5 min runtime limit, about 7 day expiry); installed packages and files carry over.
- discover-plugins: `claude plugin install` from a shell is for "a setup script"; plugins installed that way load the next time Claude Code starts or after `/reload-plugins`.
- Confidence: medium-high that settings.json does not work in cloud (three pages agree, but one origin).

## Options (cost, risk)
1. Environment setup script (user pastes into the environment dialog at claude.ai/code): `claude plugin marketplace add addyosmani/agent-skills && claude plugin install agent-skills@addy-agent-skills || true`. Cost: about 2 minutes, outside the repo, applies to every repo using that environment. Risk: docs do not confirm the `claude` CLI is on PATH at setup time (it was on PATH in a session here) or that the cached snapshot keeps the plugin. Inferred, not tested.
2. Copy the skills into the repo's `.claude/skills/` (documented to load). Cost: a vendored copy of about 25 skills in a public repo (MIT, keep the license), no auto-updates. Risk: slightly different from the plugin (no plugin hooks or namespacing).
3. Do nothing; rerun the two commands each session (works now, lost on container reclaim).

## Contradicting evidence
- A search-result summary (snippet only, source page not identified) said the docs allow declaring plugins under enabledPlugins in `.claude/settings.json` "for cloud sessions". Three opened pages say the opposite, so I treat the snippet as wrong or from an older doc version. Unresolved, unverified.
- GitHub issues #13096/#13097 (snippet only): in headless mode, project marketplaces are skipped because the trust dialog never runs. Consistent with the docs.
- No source found saying a setup script can run `claude plugin install`; not found, scope: 1 search + docs pages.

## Stopped on effort, not saturation
Next searches: "claude plugin install setup script cloud environment" issues on github.com/anthropics/claude-code; the plugins/loading page ("synced" plugins in cloud); the plugins/org page.

## Queries run
1. Claude Code on the web plugins marketplace enabledPlugins project settings.json cloud session
2. claude code plugin not loading in cloud session extraKnownMarketplaces trust prompt headless (disconfirming)
3. claude code web cloud environment setup script install plugin marketplace skills "claude plugin install"

## Pages opened
- https://code.claude.com/docs/en/discover-plugins
- https://code.claude.com/docs/en/claude-code-on-the-web (no plugin statement found)
- https://code.claude.com/docs/en/cloud-environments (saved to file, read the carry-over table and setup-script sections)
- https://code.claude.com/docs/en/settings

## Unopened (snippet only)
- Duplicate origin: code.claude.com plugins/org (several languages), plugins/security
- Off target: composio.dev, glama.ai, jsdelivr ccpi, skills.joseconti.com, dev-utils-marketplace
- Only source for a claim: claudeissues.com #13096, #13097 and github #16870 (trust-dialog claim, snippet only)

## Gaps
All verified claims come from Anthropic's own docs. Setup-script plugin install is untested. The "synced" claude.ai plugins route for cloud sessions is unopened.
