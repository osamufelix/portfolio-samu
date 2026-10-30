---
title: This site
description: Bilingual, static portfolio published on Cloudflare Pages.
order: 2
metrics:
  - { value: "US$ 0", label: monthly cost }
  - { value: "~30 s", label: full CI }
tags: [Astro, Cloudflare Pages, Terraform, GitHub Actions]
---

## TL;DR

- Static, bilingual site (Astro, text in Markdown), on Cloudflare Pages at zero cost.
- Infrastructure as code (Terraform) and a GitHub Actions pipeline that only deploys with a PR and a green `ok` check.
- Every decision recorded in an ADR, with alternatives and an exit plan.

A project like the others, with stated limits. Parts, pipeline and roadmap are in [how it's built](/en/como-foi-feito).

| | |
|---|---|
| Home page weight | 7.3 KB (2.9 KB compressed), with inlined CSS and no framework JavaScript |
| CI checks | about 30 s (check, build, links and Terraform) |
| Cost | US$ 0 |

## Why it exists

- **Portfolio:** gather what I've built, with verifiable evidence.
- **Learning:** practice observability, CI/CD and IaC continuously on a real project, and be the starting point for running and evaluating an LLM service (the chatbot on the [roadmap](/en/como-foi-feito#roadmap)).
- **Visibility:** show in public the path I'm on in DevOps/SRE with AI.

## Decisions

Each decision has an ADR (architecture decision record, in Portuguese) with context, alternatives and consequences:

- [ADR 001: Astro and Markdown as the single source](https://github.com/osamufelix/portfolio-samu/blob/main/docs/adr/001-astro-e-markdown.md). The text lives in Markdown, separate from the code, and serves the site and, later, the chatbot.
- [ADR 002: Cloudflare and the exit plan](https://github.com/osamufelix/portfolio-samu/blob/main/docs/adr/002-cloudflare-e-plano-de-saida.md). Zero cost and simplicity, traded for depending on one vendor. The ADR spells out what to replace if I need to leave.
- [ADR 003: Terraform with remote state](https://github.com/osamufelix/portfolio-samu/blob/main/docs/adr/003-terraform.md). Apply runs locally; CI only validates.
- [ADR 004: deploying from GitHub Actions](https://github.com/osamufelix/portfolio-samu/blob/main/docs/adr/004-deploy-pelo-actions.md). The pipeline stays visible and versioned instead of hidden in the Pages Git integration.

## Limits

- Depends on Cloudflare and on free tiers that can change. The exit plan is written down.
- Content in Portuguese and English only.
- Still on `*.pages.dev`, with no custom domain.

## Links

Interested in the code? See it on [GitHub](https://github.com/osamufelix/portfolio-samu).
