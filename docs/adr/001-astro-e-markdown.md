# ADR 001: Astro e Markdown como fonte única

- Status: aceito
- Data: 2026-10-29

## Contexto

O site precisa de páginas em pt-BR e inglês, textos longos (os cases) e nenhum backend. Na fase 3, um chatbot vai responder sobre os mesmos textos, com o conteúdo injetado no prompt.

## Alternativas

- **HTML/CSS puro:** zero build, mas cada texto existiria duas vezes (pt e en) em HTML, e o chatbot não teria uma fonte limpa para ler.
- **Hugo ou Eleventy:** também geram site estático a partir de Markdown. Nenhum ganho claro sobre o Astro para este tamanho de site.
- **Astro:** lê Markdown com schema validado (`astro check`), gera HTML sem JavaScript de framework e faz deploy direto no Cloudflare Pages.

## Decisão

Astro, com todo o texto em `content/{pt,en}/` na raiz do repositório, fora de `site/`. O site lê essa pasta como content collection (`site/src/content.config.ts`); o chatbot vai ler a mesma pasta.

Cada página existe uma vez em `site/src/pages/[...lang]/` e gera as duas versões. Os slugs são iguais nos dois idiomas, então trocar de idioma é só pôr ou tirar `/en` da URL.

## Consequências

- Um texto, uma fonte: corrigir um case corrige o site e, depois, o chatbot.
- O Markdown tem schema; frontmatter errado quebra o `astro check` no CI.
- Slugs iguais deixam URLs em português na versão em inglês (`/en/como-foi-feito`). Aceito em troca de não manter um mapa de rotas.
