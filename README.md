# Samuel Felix: portfólio

[![CI](https://github.com/osamufelix/portfolio-samu/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/osamufelix/portfolio-samu/actions/workflows/ci.yml)
![Astro 7](https://img.shields.io/badge/Astro-7-BC52EE?logo=astro&logoColor=white)
![TypeScript 6](https://img.shields.io/badge/TypeScript-6-3178C6?logo=typescript&logoColor=white)
![Node 26](https://img.shields.io/badge/Node-26-339933?logo=nodedotjs&logoColor=white)
![Cloudflare Pages](https://img.shields.io/badge/Cloudflare-Pages-F38020?logo=cloudflare&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-HCP-844FBA?logo=terraform&logoColor=white)
![GitHub Actions](https://img.shields.io/badge/CI%2FCD-GitHub%20Actions-2088FF?logo=githubactions&logoColor=white)

> DevOps/SRE que entrega com automação, testes e agentes de IA sob controle.

Portfólio estático e bilíngue (pt/en), publicado em **https://portfolio-samuel.pages.dev**. O site é também um case: infraestrutura como código, pipeline com validação antes de produção, decisões registradas em ADRs e custo zero.

## Sumário

- [Cases](#cases)
- [Stack](#stack)
- [Arquitetura](#arquitetura)
- [Rodar localmente](#rodar-localmente)
- [CI/CD](#cicd)
- [Infra](#infra)
- [Decisões](#decisões)
- [Conteúdo pendente](#conteúdo-pendente)

## Cases

- **[Guardião Impacta](content/pt/cases/guardiao-impacta.md):** app de conscientização em segurança da informação (TCC), com 475 + 385 testes, teste de carga com k6, deploy automático por OIDC e agentes de IA sob guardrails.
- **[Este site](content/pt/cases/este-site.md):** portfólio estático e bilíngue, com Terraform, CI/CD e ADRs, custo zero.

## Stack

| Camada | Tecnologia |
|---|---|
| Site | [Astro](https://astro.build) 7, TypeScript 6, conteúdo em Markdown com schema validado |
| Hospedagem | Cloudflare Pages (direct upload) e Web Analytics |
| Infra como código | Terraform (provider Cloudflare 5.x), state no HCP Terraform |
| CI/CD | GitHub Actions, Dependabot, ruleset exigindo PR e o check `ok` |
| Qualidade | `astro check` (tipos e conteúdo), build, verificação de links com lychee |
| Homologação | Docker Compose com o mesmo Node do CI |

## Arquitetura

```
content/{pt,en}/      todo o texto do site, em Markdown (fonte única; o chatbot da fase 3 lê daqui)
site/                 Astro: layout, estilos e páginas (uma por rota, gera pt e en)
infra/terraform/      projeto do Cloudflare Pages + Web Analytics
docs/adr/             decisões de arquitetura
.github/workflows/    CI e deploy
compose.yaml          homologação local
```

Todo conteúdo existe nas duas línguas: alterou `content/pt`, altere `content/en`.

## Rodar localmente

**Homologação (Docker):** `docker compose up` na raiz roda check e build com o Node do CI e serve o build de produção em http://localhost:4321, acessível só desta máquina.

**Desenvolvimento (Node na máquina):**

```bash
cd site
npm ci
npm run dev      # http://localhost:4321
npm run check    # tipos e schema do conteúdo
npm run build    # gera site/dist
```

Antes de abrir PR, `npm run check && npm run build` precisa passar: é o mesmo que o CI roda.

## CI/CD

A `main` publica direto em produção, então nada entra nela sem PR e sem o CI verde.

```
          ┌─► verificar ─┬─► ok (check obrigatório)
filtro ───┤              │
          └─► terraform ─┴─► deploy (só no push na main)
```

Em PR roda tudo até o `ok`; no push na `main` roda de novo e publica.

| Job | O que faz |
|---|---|
| `filtro` | Decide se há código a validar. Só README, docs, configs do agente e workflows: nada roda e o `ok` passa |
| `verificar` | `astro check`, build, verificação de links; gera o artefato `dist` |
| `terraform` | `fmt -check`, `init -backend=false` e `validate`, em paralelo com `verificar` |
| `ok` | Agrega o resultado; pular conta como sucesso, falha ou cancelamento reprova |
| `deploy` | Só no push na `main`: publica o mesmo `dist` validado ([ADR 004](docs/adr/004-deploy-pelo-actions.md)) |

Actions fixadas por SHA; o Dependabot abre PR semanal para actions e npm. Sem preview de PR: a homologação é local.

## Infra

O `terraform apply` roda localmente; o state fica no HCP Terraform ([ADR 003](docs/adr/003-terraform.md)).

```bash
cd infra/terraform
export CLOUDFLARE_API_TOKEN=...      # Pages: Edit + Account Settings: Edit
terraform login                      # HCP Terraform
terraform init
terraform apply -var account_id=<id da conta Cloudflare>
```

Depois do apply, configurar no repositório do GitHub:

| Tipo | Nome | Valor |
|---|---|---|
| Variable | `CLOUDFLARE_ACCOUNT_ID` | ID da conta (liga o job de deploy) |
| Variable | `PUBLIC_CF_BEACON_TOKEN` | `terraform output -raw web_analytics_token` |
| Secret | `CLOUDFLARE_API_TOKEN` | token só com Pages: Edit |

## Decisões

| ADR | Tema |
|---|---|
| [001](docs/adr/001-astro-e-markdown.md) | Astro e Markdown como fonte única |
| [002](docs/adr/002-cloudflare-e-plano-de-saida.md) | Cloudflare e o plano de saída |
| [003](docs/adr/003-terraform.md) | Terraform com state remoto e apply local |
| [004](docs/adr/004-deploy-pelo-actions.md) | Deploy pelo GitHub Actions |

## Conteúdo pendente

Números e links que dependem de material ainda não recebido ficam marcados com `PENDENTE` no texto. O deploy de produção recusa enquanto houver algum (`grep -rn PENDENTE content site/src`).
