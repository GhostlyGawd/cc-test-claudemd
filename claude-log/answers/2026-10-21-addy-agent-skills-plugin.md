# Where is Addy Osmani's "agent skills" plugin, and how is it installed?

Date: 2026-10-21. Label: research. Assumption (user said "addy", "agent skills"): Addy Osmani, project named agent-skills. Not confirmed by the user.

## Answer
Found. It is GitHub repo addyosmani/agent-skills, a Claude Code plugin marketplace plus plugin. It is not in this harness's plugin catalog, so it must be added by marketplace command.

## Verified (page opened this session)
- Owner is GitHub user addyosmani; MIT license; "Production-grade engineering skills for AI coding agents"; the repo page says 25 skills (https://github.com/addyosmani/agent-skills).
- Claude Code install, repo page and official site agree word for word: `/plugin marketplace add addyosmani/agent-skills` then `/plugin install agent-skills@addy-agent-skills`. Marketplace name `addy-agent-skills`, plugin name `agent-skills`. SSH error fallback: use the full HTTPS URL https://github.com/addyosmani/agent-skills.git (https://skills.addy.ie/docs/getting-started/, footer "Built by Addy Osmani & contributors").
- Confidence: medium. Two pages, but both are the author's own (one origin, primary). The repo page does not show the contents of .claude-plugin, so marketplace.json existence is unconfirmed by me.

## Contradicting / caution (search results only, snippet-level, unverified)
- Skill count differs: 25 (repo page), 24 (site and reviews), 20 core (third-party catalog).
- Release 0.6.10 notes (newreleases.io, result text only) mention a fixed Windows startup-hook failure; the plugin has hooks, so read them before enabling.
- One third-party guide points to a different repo (nicepkg/agent-skills); do not use it.
- No direct critique of the repo found.

## Stopped on effort, not saturation
Next searches: the repo's hooks/ and .claude-plugin/marketplace.json files; the release notes page itself; the repo issues list.

## Queries run
1. Addy Osmani agent skills Claude Code plugin
2. addyosmani agent-skills github production-grade engineering skills for AI coding agents
3. how to install Addy Osmani agent skills plugin marketplace add
4. addyosmani agent-skills problems issues doesn't work install error criticism (disconfirming)

## Pages opened
- https://github.com/addyosmani/agent-skills
- https://skills.addy.ie/docs/getting-started/

## Pages left unopened (snippet only)
- Duplicate origin: aiengineerguide.com, agensi.io (2 pages), jimmysong.io, dev.to review, ai-tldr.dev, claudskills.com, everydev.ai, heyclau.de
- Off target: jfrog docs, ngautopilot, microsoft/azure-sql issue
- Cost: newreleases.io 0.6.10, github.com/addyosmani/agent-skills/issues, csdn article

## Gaps
Install commands rest on two same-author pages. Release-note and issue claims are unopened. Not installed or run in this harness.
