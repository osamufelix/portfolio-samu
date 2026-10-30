---
title: Como foi feito
description: Referência rápida da arquitetura, do pipeline e das decisões deste site.
---

## Peças

| Peça | Função |
|---|---|
| Astro | Gera o site estático a partir do Markdown em `content/` |
| Cloudflare Pages | Hospeda e serve pela CDN (plano gratuito) |
| Cloudflare Web Analytics | Conta visitas sem cookies |
| Terraform | Cria o projeto do Pages e o Web Analytics |
| HCP Terraform | Guarda o state do Terraform |
| GitHub Actions | Valida cada PR e publica cada push no `main` |
| Docker Compose | Homologação local, só em `localhost` |

## Pipeline

1. **PR ou push:** `astro check`, `astro build`, checagem de links e `terraform validate`.
2. **Push no `main`:** se não houver conteúdo marcado como pendente, o build vai para produção com `wrangler pages deploy`.
3. **Homologação:** `docker compose up` serve o build de produção em `localhost`. Não existe URL de preview pública.

A infraestrutura muda pouco. Por isso o `terraform apply` roda na minha máquina, e o CI só confere se o código continua válido.

## Decisões (ADRs)

| ADR | Decisão |
|---|---|
| [001](https://github.com/PENDENTE/portfolio/blob/main/docs/adr/001-astro-e-markdown.md) | Astro, com o texto em Markdown numa pasta própria |
| [002](https://github.com/PENDENTE/portfolio/blob/main/docs/adr/002-cloudflare-e-plano-de-saida.md) | Cloudflare no plano gratuito, com plano de saída escrito |
| [003](https://github.com/PENDENTE/portfolio/blob/main/docs/adr/003-terraform.md) | Terraform com state remoto e apply local |
| [004](https://github.com/PENDENTE/portfolio/blob/main/docs/adr/004-deploy-pelo-actions.md) | Deploy pelo GitHub Actions, não pela integração Git do Pages |

## Limites declarados

- Sem servidor e sem banco: o site não guarda nada de quem visita.
- Depende do Cloudflare; o ADR 002 descreve como sair.
- Conteúdo em português e inglês.

## Código

Tudo está em [github.com/PENDENTE/portfolio](https://github.com/PENDENTE/portfolio).
