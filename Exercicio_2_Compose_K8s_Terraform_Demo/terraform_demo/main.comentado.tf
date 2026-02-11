# Terraform - Infraestrutura como Código (IaC)
# Versão comentada para estudo

# Bloco terraform - configurações do próprio Terraform
terraform {
  # Versão mínima do Terraform necessária
  required_version = ">= 1.0"

  # Providers necessários (plugins que falam com APIs)
  required_providers {
    local = {
      source  = "hashicorp/local"  # Provider oficial
      version = "~> 2.0"            # Versão 2.x (compatível)
    }
  }
}

# Inicializa o provider local
# Em produção seria: provider "aws" { region = "us-east-1" }
provider "local" {}

# Resource - unidade básica de infraestrutura gerenciada
# Formato: resource "<tipo>" "<nome_local>" { ... }
resource "local_file" "infra_demo" {
  # Conteúdo do arquivo (multiline com <<-EOT)
  content = <<-EOT
    ╔════════════════════════════════════════════════════════╗
    ║       INFRAESTRUTURA GERENCIADA POR TERRAFORM          ║
    ╚════════════════════════════════════════════════════════╝
    
    ✅ Arquivo criado por: Terraform
    📅 Data: ${timestamp()}
    🏗️  Tipo: Demo Infrastructure as Code
    
    Conceitos demonstrados:
    - Infraestrutura como Código (IaC)
    - Versionamento de infraestrutura
    - Terraform state management
    - Comandos: init, plan, apply, destroy
    
    Próximos passos para produção:
    - Usar providers cloud (AWS, Azure, GCP)
    - Gerenciar bancos de dados (RDS, Azure SQL)
    - Criar redes (VPC, subnets, security groups)
    - Provisionar load balancers (ALB, Azure Load Balancer)
    - Criar Kubernetes clusters (EKS, AKS, GKE)
    
    Este é apenas um exemplo DIDÁTICO usando recursos locais.
    Em produção, Terraform gerencia recursos reais na cloud!
  EOT

  # Nome do arquivo a ser criado
  # path.module = diretório onde este .tf está
  filename        = "${path.module}/infra.txt"
  
  # Permissões Unix (0644 = rw-r--r--)
  file_permission = "0644"
}

# Outputs - valores exibidos após terraform apply
# Útil para compartilhar informações (IPs, URLs, etc)
output "arquivo_criado" {
  value       = local_file.infra_demo.filename
  description = "Caminho do arquivo criado"
}

output "tamanho_bytes" {
  value       = length(local_file.infra_demo.content)
  description = "Tamanho do conteúdo em bytes"
}

output "timestamp_criacao" {
  value       = timestamp()
  description = "Timestamp de quando o terraform apply foi executado"
}
