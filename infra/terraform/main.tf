terraform {
  required_version = ">= 1.6"

  # State no HCP Terraform (plano gratuito), com o workspace em execution mode "Local":
  # o apply roda na máquina do autor e só o state fica remoto (ADR 003).
  cloud {
    organization = "Portfolio_SamuFelix"
    workspaces {
      name = "Portfolio"
    }
  }

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.0"
    }
  }
}

# Token lido de CLOUDFLARE_API_TOKEN (permissões: Pages Edit e Account Analytics Edit).
provider "cloudflare" {}

variable "account_id" {
  type        = string
  description = "ID da conta Cloudflare"
}

# Sem bloco "source": projeto de direct upload; quem publica é o GitHub Actions (ADR 004).
resource "cloudflare_pages_project" "site" {
  account_id        = var.account_id
  name              = "portfolio-samuel"
  production_branch = "main"
}

# *.pages.dev não é uma zona da conta, então o beacon entra manualmente no HTML com o site_token.
# subdomain é o *.pages.dev real: se o nome já existir na Cloudflare, ela gera outro.
resource "cloudflare_web_analytics_site" "site" {
  account_id   = var.account_id
  host         = cloudflare_pages_project.site.subdomain
  auto_install = false
}

output "pages_url" {
  value = "https://${cloudflare_pages_project.site.subdomain}"
}

# Vai para a variable PUBLIC_CF_BEACON_TOKEN do repositório. Não é segredo: aparece no HTML de qualquer site com o beacon.
output "web_analytics_token" {
  value = cloudflare_web_analytics_site.site.site_token
}
