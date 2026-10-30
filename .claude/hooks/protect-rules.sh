#!/usr/bin/env bash
# PreToolUse (Bash|PowerShell): bloqueia comandos de shell que escrevem nas regras do agente.
# Edit/Write já são barrados pelo permissions.deny do settings.json; isto cobre o atalho pelo shell.
# ponytail: heurística por regex (alvo + verbo de escrita); um script ofuscado passa. Limite real = revisar o diff antes do merge.
cmd=$(jq -r '.tool_input.command // ""')

alvo='CLAUDE\.md|\.claude[/\\]+(settings[^ ]*\.json|hooks|skills|agents)'
escrita='(^|[^0-9&>])>|\btee\b|sed +(-[a-z]*i|--in-place)|\b(mv|cp|rm|touch|truncate|ln|chmod)\b|Set-Content|Add-Content|Out-File|Remove-Item|Move-Item|Copy-Item|New-Item|Rename-Item|WriteAll|git +(checkout|restore|rm|mv|reset|apply|stash)'

if printf '%s' "$cmd" | grep -qiE "$alvo" && printf '%s' "$cmd" | grep -qiE "$escrita"; then
  echo "Bloqueado: CLAUDE.md e .claude/ (settings, hooks, skills, agents) só podem ser alterados pelo usuário. Proponha a mudança em texto." >&2
  exit 2
fi
exit 0
