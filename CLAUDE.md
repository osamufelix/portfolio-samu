# Portfolio

Site de portfólio pessoal. Visão geral e arquitetura: [README.md](README.md).

## Estrutura
- `site/`: Astro. Comandos rodam dentro de `site/`.
- `content/pt` e `content/en`: todo conteúdo existe nas duas línguas. Alterou um, altere o outro.
- `infra/terraform`: Cloudflare. Nunca rode `terraform apply` sem eu pedir.
- `docs/adr`: decisões já tomadas. Não reabra sem eu pedir.

## Comandos
- `npm ci` (primeira vez em cada worktree)
- `npm run dev`: servidor local
- `npm run check && npm run build`: o mesmo que o CI roda. Só considere pronto se passar.

## Fluxo
- Qualquer alteração de arquivo: trabalhe numa worktree, numa branch `tipo/descricao`.
- `main` publica direto em produção (Cloudflare Pages). Entregue com `/ship pr`, não com push na main.
- Commits: conventional commits em pt-BR (ex.: `feat: ...`, `fix(ci): ...`).