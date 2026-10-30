---
title: How it is built
description: Parts, pipeline and roadmap of this site.
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

```text
PR and push to main
  filtro (filter)             only docs, README and configs? nothing runs and ok passes
  verificar (verify)          npm ci, astro check, build and lychee (links)
  terraform                   fmt + validate, in parallel with verify
  ok                          the only required check: aggregates the result

push to main, all green
  deploy                      blocked if there are unconfirmed numbers + wrangler pages deploy of the same dist
```

- `main` deploys straight to production, so a ruleset (a rule that protects the branch) requires a PR and the `ok` check.
- Actions are pinned by SHA; Dependabot opens a weekly PR for actions and npm.
- No preview URL: staging runs on my machine with `docker compose up`, on the same Node version as CI and reachable only from `localhost`.
- `terraform apply` runs on my machine; CI only checks that the code is still valid.

## Roadmap

**Done**

- [x] Infrastructure as code with Terraform and remote state
- [x] CI with change filtering, link checking and a ruleset requiring a PR

**Up next**

- [ ] A custom domain instead of `*.pages.dev`
- [ ] **Observability and metrics:** availability, performance and what the pipeline delivers, measured and open to browse

**Later: chatbot**

A chat about the cases, answering from these same texts. The focus is on how it's run and evaluated: evals in CI that grow with every real failure, abuse protection (invisible captcha, rate limiting, a daily usage cap), a kill switch (an emergency off button) and zero cost.

**Further ahead**

- [ ] New cases
