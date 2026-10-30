# Samuel Felix: portfólio

<!-- PENDENTE: frase de posicionamento final (igual à home e ao headline do LinkedIn) -->
> DevOps/SRE que entrega com automação, testes e agentes de IA sob controle.

Site: <!-- PENDENTE: URL do *.pages.dev depois do primeiro deploy -->

## Cases

- **[Guardião Impacta](content/pt/cases/guardiao-impacta.md):** app de conscientização em segurança da informação (TCC), com 475 + 385 testes, teste de carga com k6, deploy automático por OIDC e agentes de IA sob guardrails.
- **[Este site](content/pt/cases/este-site.md):** portfólio estático e bilíngue, com Terraform, CI/CD e ADRs, custo zero.

## Estrutura

```
content/{pt,en}/      todo o texto do site, em Markdown (fonte única; o chatbot da fase 3 lê daqui)
site/                 Astro: layout, estilos e páginas (uma por rota, gera pt e en)
infra/terraform/      projeto do Cloudflare Pages + Web Analytics
docs/adr/             decisões de arquitetura
.github/workflows/    CI (check, build, links, terraform validate) e deploy
```

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

## Infra

O `terraform apply` roda localmente; o state fica no HCP Terraform ([ADR 003](docs/adr/003-terraform.md)).

```bash
cd infra/terraform
export CLOUDFLARE_API_TOKEN=...      # Pages: Edit + Account Analytics: Edit
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

## Conteúdo pendente

Números e links que dependem de material ainda não recebido ficam marcados com `PENDENTE` no texto. O deploy de produção recusa enquanto houver algum (`grep -rn PENDENTE content site/src`).
