terraform {
  required_version = ">= 1.0"

  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

provider "local" {}

resource "local_file" "infra_demo" {
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
    Em produção, Terraform gerencia recursos reais na cloud! ☁️
  EOT

  filename        = "${path.module}/infra.txt"
  file_permission = "0644"
}

output "arquivo_criado" {
  value       = local_file.infra_demo.filename
  description = "Caminho do arquivo criado"
}

output "tamanho_bytes" {
  value       = length(local_file.infra_demo.content)
  description = "Tamanho do conteúdo em bytes"
}

output "mensagem" {
  value       = <<-EOT
    
    ╔═══════════════════════════════════════════════════════╗
    ║           🎉 INFRAESTRUTURA CRIADA COM SUCESSO!       ║
    ╚═══════════════════════════════════════════════════════╝
    
    📄 Arquivo: ${local_file.infra_demo.filename}
    📏 Tamanho: ${length(local_file.infra_demo.content)} bytes
    
    Verificar: cat infra.txt
    Destruir:  terraform destroy -auto-approve
    
    ⚠️  Em produção AWS/Azure/GCP: "destroy" deletaria servidores/bancos (CUIDADO!)
    
  EOT
  description = "Mensagem de sucesso"
}
