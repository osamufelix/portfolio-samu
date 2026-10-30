# ADR 002: Cloudflare e o plano de saída

- Status: aceito
- Data: 2026-10-29

## Contexto

O projeto tem custo zero como regra. O site é estático agora, mas a fase 3 traz um chatbot que precisa de backend, modelo de linguagem, captcha e rate limit, também sem custo.

## Decisão

Cloudflare no plano gratuito: Pages para o site e Web Analytics (sem cookies) para as visitas. Na fase 3, Workers, Workers AI, Turnstile e o binding de Rate Limiting ficam na mesma conta.

## Consequências

- **A favor:** custo zero, CDN e, na fase 3, os recursos do chatbot na mesma plataforma, sem chave de API externa.
- **Contra:** dependência de um fornecedor e de limites gratuitos que podem mudar sem aviso.

## Plano de saída

O site é HTML estático, então sair é barato:

| Peça | Troca | O que muda |
|---|---|---|
| Cloudflare Pages | GitHub Pages, Netlify ou qualquer bucket com CDN | O passo de deploy do `ci.yml` e o Terraform. O build do Astro não muda |
| Web Analytics | Outro analytics sem cookies, ou nenhum | O `<script>` do beacon em `site/src/layouts/Base.astro` |
| Terraform (provider Cloudflare) | Provider do novo host | O conteúdo de `infra/terraform/` |

Na fase 3, o chatbot fica isolado atrás de um endpoint (`/api/chat`). Trocar o Worker e o Workers AI por outro backend e outro modelo não muda o site, só esse endpoint.
