# ADR 004: deploy pelo GitHub Actions

- Status: aceito
- Data: 2026-10-29

## Contexto

O Cloudflare Pages tem duas formas de publicar: a integração Git (o Cloudflare clona o repositório e faz o build sozinho) ou o direct upload (alguém envia a pasta já construída).

## Decisão

Direct upload pelo GitHub Actions, com `wrangler pages deploy`. O projeto do Pages é criado pelo Terraform sem bloco `source`.

O workflow (`.github/workflows/ci.yml`) tem dois jobs:

1. **verificar:** `astro check`, build, checagem de links, `terraform validate`. Guarda o build como artefato.
2. **deploy:** publica **esse mesmo artefato** em produção, só em push no `main`. Antes, uma trava recusa o deploy se houver conteúdo marcado como pendente.

Não há deploy de preview nos PRs: toda branch publicada no Pages vira uma URL pública, e rascunho não deve ficar exposto. A homologação é local, com `docker compose up` (só `localhost`). PR serve para revisão e merge.

## Consequências

- O pipeline inteiro está no repositório, visível e versionado. Com a integração Git, metade dele ficaria nas configurações do painel da Cloudflare.
- O que vai para produção é exatamente o build que passou nos testes.
- A trava de pendências é possível; a integração Git publicaria qualquer push.
- Custo: um API token da Cloudflare guardado como secret no GitHub, com permissão só de Pages.
