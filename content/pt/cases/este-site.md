---
title: Este site
description: Portfólio bilíngue e estático, publicado na Cloudflare Pages.
order: 2
metrics:
  - { value: "US$ 0", label: custo mensal }
  - { value: "~30 s", label: CI completo }
tags: [Astro, Cloudflare Pages, Terraform, GitHub Actions]
---

## TL;DR

- Site estático e bilíngue (Astro, texto em Markdown), na Cloudflare Pages a custo zero.
- Infraestrutura como código (Terraform) e pipeline no GitHub Actions, que só publica com PR e o check `ok` verde.
- Cada decisão registrada em ADR, com alternativas e plano de saída.

Um projeto como os outros, com limites declarados. Peças, pipeline e roadmap estão em [como foi feito](/como-foi-feito).

| | |
|---|---|
| Peso da home | 7,3 KB (2,9 KB comprimida), com o CSS embutido e sem JavaScript de framework |
| Verificação no CI | cerca de 30 s (check, build, links e Terraform) |
| Custo | US$ 0 |

## Por que existe

- **Portfólio:** reunir o que eu construí, com evidência verificável.
- **Aprendizado:** praticar, de forma contínua, observabilidade, CI/CD e IaC num projeto real, e ser o ponto de partida para operar e avaliar um serviço com LLM (o chatbot do [roadmap](/como-foi-feito#roadmap)).
- **Visibilidade:** mostrar em público o caminho que estou seguindo em DevOps/SRE com IA.

## Decisões

Cada decisão tem um ADR (registro de decisão de arquitetura) com contexto, alternativas e consequências:

- [ADR 001: Astro e Markdown como fonte única](https://github.com/osamufelix/portfolio-samu/blob/main/docs/adr/001-astro-e-markdown.md). O texto fica em Markdown, separado do código, e serve o site e, depois, o chatbot.
- [ADR 002: Cloudflare e o plano de saída](https://github.com/osamufelix/portfolio-samu/blob/main/docs/adr/002-cloudflare-e-plano-de-saida.md). Custo zero e simplicidade, em troca de dependência de um fornecedor. O ADR descreve o que trocar se for preciso sair.
- [ADR 003: Terraform com state remoto](https://github.com/osamufelix/portfolio-samu/blob/main/docs/adr/003-terraform.md). O apply é local; o CI só valida.
- [ADR 004: deploy pelo GitHub Actions](https://github.com/osamufelix/portfolio-samu/blob/main/docs/adr/004-deploy-pelo-actions.md). O pipeline fica visível e versionado, em vez de escondido na integração Git do Pages.

## Limites

- Depende do Cloudflare e de limites gratuitos que podem mudar. O plano de saída está escrito.
- Conteúdo só em português e inglês.
- Ainda em `*.pages.dev`, sem domínio próprio.

## Links

Ficou interessado no código? Veja o [GitHub](https://github.com/osamufelix/portfolio-samu).
