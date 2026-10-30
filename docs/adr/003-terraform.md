# ADR 003: Terraform com state remoto e apply local

- Status: aceito
- Data: 2026-10-29

## Contexto

A infraestrutura é pequena (um projeto do Pages e um site do Web Analytics) e muda raramente. Mesmo assim, tem que estar em código: é parte do que o site mostra. O state do Terraform não pode ficar no repositório (é público) nem só na minha máquina (se o disco morre, o state vai junto).
Este arquivo Terraform também serve como estudo de IaC.

## Alternativas para o state

- **Arquivo local, fora do Git:** nada a configurar, mas some com a máquina.
- **Bucket R2 do Cloudflare:** compatível com S3, mas exige cadastrar meio de pagamento na conta.
- **HCP Terraform, plano gratuito:** guarda o state, com histórico e lock, sem custo.

## Decisão

- State no HCP Terraform, com o workspace em execution mode **Local**: o `terraform apply` roda na minha máquina e só o state fica remoto.
- O CI não aplica nada. Ele roda `terraform fmt -check` e `terraform validate` em todo PR.
- O token da Cloudflare usado no apply tem só as permissões necessárias (Pages: Edit e Account Settings: Edit, que é a permissão exigida para criar o site do Web Analytics) e não fica no repositório.

## Consequências

- Uma mudança de infra exige um apply manual. Para uma infra que muda poucas vezes por ano, é mais simples do que dar ao CI um token com poder de criar e apagar recursos.
- Se a infra começar a mudar com frequência (por exemplo, na fase 3), a decisão é revista: apply pelo CI no `main`, com `plan` comentado no PR.
