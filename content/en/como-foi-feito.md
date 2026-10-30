---
title: How it is built
description: Quick reference for this site's architecture, pipeline and decisions.
---

## Parts

| Part | Role |
|---|---|
| Astro | Builds the static site from the Markdown in `content/` |
| Cloudflare Pages | Hosts and serves from the CDN (free plan) |
| Cloudflare Web Analytics | Counts visits without cookies |
| Terraform | Creates the Pages project and Web Analytics |
| HCP Terraform | Stores the Terraform state |
| GitHub Actions | Validates every PR and deploys every push to `main` |
| Docker Compose | Local staging, `localhost` only |

## Pipeline

1. **PR or push:** `astro check`, `astro build`, link check and `terraform validate`.
2. **Push to `main`:** if no content is marked as pending, the build goes to production with `wrangler pages deploy`.
3. **Staging:** `docker compose up` serves the production build on `localhost`. There is no public preview URL.

The infrastructure rarely changes. So `terraform apply` runs on my machine, and CI only checks that the code is still valid.

## Decisions (ADRs, in Portuguese)

| ADR | Decision |
|---|---|
| [001](https://github.com/osamufelix/portifolio-samu/blob/main/docs/adr/001-astro-e-markdown.md) | Astro, with the text in Markdown in its own folder |
| [002](https://github.com/osamufelix/portifolio-samu/blob/main/docs/adr/002-cloudflare-e-plano-de-saida.md) | Cloudflare on the free plan, with a written exit plan |
| [003](https://github.com/osamufelix/portifolio-samu/blob/main/docs/adr/003-terraform.md) | Terraform with remote state and local apply |
| [004](https://github.com/osamufelix/portifolio-samu/blob/main/docs/adr/004-deploy-pelo-actions.md) | Deploy from GitHub Actions, not the Pages Git integration |

## Stated limits

- No server and no database: the site stores nothing about visitors.
- Depends on Cloudflare; ADR 002 describes how to leave.
- Content in Portuguese and English.

## Code

It's all at [github.com/osamufelix/portifolio-samu](https://github.com/osamufelix/portifolio-samu).
