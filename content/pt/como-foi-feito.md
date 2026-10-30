---
title: Como foi feito
description: Peças, pipeline e roadmap deste site.
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

```text
PR e push no main
  filtro                      só docs, README e configs? nada roda e o ok passa
  verificar                   npm ci, astro check, build e lychee (links)
  terraform                   fmt + validate, em paralelo com verificar
  ok                          o único check obrigatório: agrega o resultado

push no main, com tudo verde
  deploy                      barra se houver números não confirmados + wrangler pages deploy do mesmo dist
```

- A `main` publica direto em produção, então um ruleset (regra que protege o branch) exige PR e o check `ok`.
- Actions fixadas por SHA; o Dependabot abre PR semanal para actions e npm.
- Sem URL de preview: a homologação roda na minha máquina com `docker compose up`, com o mesmo Node do CI e acessível só por `localhost`.
- O `terraform apply` roda na minha máquina; o CI só confere se o código continua válido.

## Roadmap

**Feito**

- [x] Infraestrutura como código com Terraform e state remoto
- [x] CI com filtro de mudanças, checagem de links e ruleset exigindo PR

**Em seguida**

- [ ] Domínio próprio no lugar do `*.pages.dev`
- [ ] **Observabilidade e métricas:** disponibilidade, desempenho e o que o pipeline entrega, medidos e abertos para consulta

**Depois: chatbot**

Um chat sobre os cases, que responde a partir destes mesmos textos. O foco é como ele é operado e avaliado: evals no CI que crescem a cada falha real, proteção contra abuso (captcha invisível, rate limit, teto diário de uso), kill switch (desligamento de emergência) e custo zero.

**Mais adiante**

- [ ] Novos cases
