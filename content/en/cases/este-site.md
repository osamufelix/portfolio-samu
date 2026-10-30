---
title: This site
description: Bilingual, static, zero-cost portfolio with infrastructure as code and automated deploys.
order: 2
metric: IaC + CI/CD · US$ 0 cost
tags: [Astro, Cloudflare Pages, Terraform, GitHub Actions]
---

## Summary

This site is a project like the others: it has recorded decisions, a pipeline, infrastructure as code and stated limits. It's all in the [repository](https://github.com/PENDENTE/portfolio) for you to check.

<!-- PENDENTE: numbers measured after the first deploy (pipeline time, home page weight in KB) -->

## Why it exists

- **Portfolio:** gather what I've built, with verifiable evidence.
- **Learning:** be the starting point for running and evaluating an LLM service (the chatbot on the roadmap).
- **Visibility:** show in public the path I'm on in DevOps/SRE with AI.

## Architecture

- **Astro** generates static HTML. There is no server, no database and no framework JavaScript in the browser; the only script switches the theme.
- **Cloudflare Pages** serves the site from its CDN, on the free plan.
- **Cloudflare Web Analytics** counts visits without cookies.
- **Terraform** creates the Pages project and Web Analytics. State lives in HCP Terraform.
- **GitHub Actions** validates every PR and deploys every push to `main`.

All page text lives in Markdown, in a `content/` folder separate from the site code. That folder will be the chatbot's knowledge base, with no copied text.

## Decisions

Each decision has an ADR (architecture decision record, in Portuguese) with context, alternatives and consequences:

- [ADR 001: Astro and Markdown as the single source](https://github.com/PENDENTE/portfolio/blob/main/docs/adr/001-astro-e-markdown.md). The same text serves the site and, later, the chatbot.
- [ADR 002: Cloudflare and the exit plan](https://github.com/PENDENTE/portfolio/blob/main/docs/adr/002-cloudflare-e-plano-de-saida.md). Zero cost and simplicity, traded for depending on one vendor. The ADR spells out what to replace if I need to leave.
- [ADR 003: Terraform with remote state](https://github.com/PENDENTE/portfolio/blob/main/docs/adr/003-terraform.md). Apply runs locally; CI only validates.
- [ADR 004: deploying from GitHub Actions](https://github.com/PENDENTE/portfolio/blob/main/docs/adr/004-deploy-pelo-actions.md). The pipeline stays visible and versioned instead of hidden in the Pages Git integration.

## Pipeline

```text
every PR and push
  npm ci                      dependencies locked by the lockfile
  astro check                 types and content (Markdown follows a schema)
  astro build                 generates the HTML
  lychee                      no broken links
  terraform fmt + validate    infra is still valid

push to main, all green
  pending-content gate        content marked as pending never reaches production
  wrangler pages deploy       publishes the build that passed to production
```

There are no preview URLs: staging runs on my machine with `docker compose up`, on the same Node version as CI and reachable only from `localhost`. PRs are for review and merge.

The pending-content gate exists because some numbers in the cases depend on material I haven't received yet. Until then, they stay marked in the text and the production deploy refuses them.

## Limits

- Depends on Cloudflare and on free tiers that can change. The [exit plan](https://github.com/PENDENTE/portfolio/blob/main/docs/adr/002-cloudflare-e-plano-de-saida.md) is written down.
- Content in Portuguese and English only.
- Still on `*.pages.dev`, with no custom domain.

## Roadmap

**Found along the way**

- Mutation testing report in the Guardião Impacta case.
- Publish the Guardião Impacta security reports (ZAP, Semgrep, Trivy, Gitleaks).
- Final version of the Guardião Impacta thesis.
- Higher-resolution screenshots of Guardião Impacta.
- A custom domain instead of `*.pages.dev`.

**Next: chatbot**

A chat about the cases, answering from these same texts. The focus is on how it's run and evaluated: evals in CI that grow with every real failure, abuse protection (invisible captcha, rate limiting, a daily usage cap), a kill switch and zero cost.

**Further ahead**

New cases.
