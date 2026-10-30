---
title: Este site
description: Portfólio bilíngue, estático e de custo zero, com infraestrutura como código e deploy automático.
order: 2
metric: IaC + CI/CD · custo US$ 0
tags: [Astro, Cloudflare Pages, Terraform, GitHub Actions]
---

## Resumo

Este site é um projeto como os outros: tem decisões registradas, pipeline, infraestrutura como código e limites declarados. Tudo está no [repositório](https://github.com/osamufelix/portifolio-samu) para conferir.

<!-- PENDENTE: números medidos depois do primeiro deploy (tempo do pipeline, peso da home em KB) -->

## Por que existe

- **Portfólio:** reunir o que eu construí, com evidência verificável.
- **Aprendizado:** ser o ponto de partida para operar e avaliar um serviço com LLM (o chatbot do roadmap).
- **Visibilidade:** mostrar em público o caminho que estou seguindo em DevOps/SRE com IA.

## Arquitetura

- **Astro** gera HTML estático. Não há servidor, banco nem JavaScript de framework no navegador; o único script troca o tema.
- **Cloudflare Pages** serve o site pela CDN, no plano gratuito.
- **Cloudflare Web Analytics** conta visitas sem cookies.
- **Terraform** cria o projeto do Pages e o Web Analytics. O state fica no HCP Terraform.
- **GitHub Actions** valida cada PR e publica cada push no `main`.

O texto de todas as páginas fica em Markdown, numa pasta `content/` separada do código do site. Essa pasta vai ser a base de conhecimento do chatbot, sem copiar texto.

## Decisões

Cada decisão tem um ADR (registro de decisão de arquitetura) com contexto, alternativas e consequências:

- [ADR 001: Astro e Markdown como fonte única](https://github.com/osamufelix/portifolio-samu/blob/main/docs/adr/001-astro-e-markdown.md). O mesmo texto serve o site e, depois, o chatbot.
- [ADR 002: Cloudflare e o plano de saída](https://github.com/osamufelix/portifolio-samu/blob/main/docs/adr/002-cloudflare-e-plano-de-saida.md). Custo zero e simplicidade, em troca de dependência de um fornecedor. O ADR descreve o que trocar se for preciso sair.
- [ADR 003: Terraform com state remoto](https://github.com/osamufelix/portifolio-samu/blob/main/docs/adr/003-terraform.md). O apply é local; o CI só valida.
- [ADR 004: deploy pelo GitHub Actions](https://github.com/osamufelix/portifolio-samu/blob/main/docs/adr/004-deploy-pelo-actions.md). O pipeline fica visível e versionado, em vez de escondido na integração Git do Pages.

## Pipeline

```text
todo PR e push
  npm ci                      dependências travadas no lockfile
  astro check                 tipos e conteúdo (o Markdown segue um schema)
  astro build                 gera o HTML
  lychee                      nenhum link quebrado
  terraform fmt + validate    a infra continua válida

push no main, com tudo verde
  trava de pendências         conteúdo marcado como pendente não vai para produção
  wrangler pages deploy       publica em produção o build que passou
```

Não há URL de preview: a homologação roda na minha máquina com `docker compose up`, com o mesmo Node do CI e acessível só por `localhost`. PR serve para revisar e fazer merge.

A trava de pendências existe porque alguns números dos cases dependem de material que ainda vou receber. Enquanto isso, eles ficam marcados no texto e o deploy de produção recusa.

## Limites

- Depende do Cloudflare e de limites gratuitos que podem mudar. O [plano de saída](https://github.com/osamufelix/portifolio-samu/blob/main/docs/adr/002-cloudflare-e-plano-de-saida.md) está escrito.
- Conteúdo só em português e inglês.
- Ainda em `*.pages.dev`, sem domínio próprio.

## Roadmap

**Encontrado no caminho**

- Relatório de teste de mutação no case do Guardião Impacta.
- Versão final da monografia do Guardião Impacta.
- Prints novos do Guardião Impacta em resolução maior.
- Domínio próprio no lugar do `*.pages.dev`.

**Próximo: chatbot**

Um chat sobre os cases, que responde a partir destes mesmos textos. O foco é como ele é operado e avaliado: evals no CI que crescem a cada falha real, proteção contra abuso (captcha invisível, rate limit, teto diário de uso), kill switch e custo zero.

**Mais adiante**

Novos cases.
