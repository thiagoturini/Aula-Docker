# 🏗️ Guia Completo: Terraform - Infraestrutura como Código

## 📚 O que é Terraform?

Terraform é uma ferramenta **open-source** de **Infraestrutura como Código (IaC)** criada pela HashiCorp que permite:

- ✅ **Definir** infraestrutura em arquivos de texto (código)
- ✅ **Versionar** infraestrutura no Git (como código)
- ✅ **Automatizar** criação, atualização e destruição de recursos
- ✅ **Gerenciar** infraestrutura em múltiplos providers (AWS, Azure, GCP, Kubernetes, etc.)
- ✅ **Reutilizar** configurações através de módulos
- ✅ **Colaborar** em equipe com state compartilhado

**Quando usar:**
- ✅ Provisionar infraestrutura cloud (VMs, redes, bancos, etc.)
- ✅ Manter múltiplos ambientes consistentes (dev, staging, prod)
- ✅ Versionar mudanças de infraestrutura
- ✅ Automatizar deploys de infraestrutura
- ✅ Documentar infraestrutura como código

**Quando NÃO usar:**
- ❌ Gerenciar configuração de servidores → Use Ansible, Chef, Puppet
- ❌ Deploy de aplicações → Use CI/CD (GitHub Actions, GitLab CI)
- ❌ Infraestrutura muito simples e estática

---

## 🎯 Conceitos Fundamentais

### **1. Infrastructure as Code (IaC)**

**Antes (Manual):**
```
1. Acessar console AWS
2. Clicar em "Create EC2 Instance"
3. Selecionar AMI, tipo, rede...
4. Configurar security group
5. Criar instance
❌ Não reproduzível
❌ Não versionado
❌ Propenso a erros
```

**Depois (IaC com Terraform):**
```hcl
resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  tags = {
    Name = "WebServer"
  }
}
```
```bash
terraform apply
✅ Reproduzível
✅ Versionado no Git
✅ Consistente
```

### **2. Declarativo vs Imperativo**

**Imperativo** (como fazer):
```bash
# Ansible, scripts bash
create_vm("web-server")
if not exists("load-balancer"):
    create_lb("my-lb")
attach_vm_to_lb("web-server", "my-lb")
```

**Declarativo** (estado desejado):
```hcl
# Terraform
resource "aws_instance" "web" {
  # Estado desejado
}

resource "aws_lb" "main" {
  # Estado desejado
}
```

Terraform calcula **o que precisa ser feito** para chegar ao estado desejado.

### **3. State (Estado)**

Terraform mantém um arquivo de **state** (`terraform.tfstate`) que:
- 📋 Rastreia recursos criados
- 🔗 Mapeia recursos reais com código
- 🎯 Sabe o que precisa criar/atualizar/deletar
- 🔒 Previne conflitos em equipe

**Importante:**
- ⚠️ State contém informações sensíveis (IPs, IDs)
- 🔐 Sempre use backend remoto (S3, Terraform Cloud) em produção
- 🚫 Nunca commite `terraform.tfstate` no Git

### **4. Providers**

Providers são **plugins** que permitem Terraform interagir com APIs:

```hcl
provider "aws" {
  region = "us-east-1"
}

provider "azurerm" {
  features {}
}

provider "google" {
  project = "my-project"
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}
```

**Providers populares:**
- AWS, Azure, GCP (cloud)
- Kubernetes, Docker (containers)
- GitHub, GitLab (repositórios)
- PostgreSQL, MySQL (bancos)
- Datadog, New Relic (monitoramento)

### **5. Resources**

Resources são **componentes de infraestrutura**:

```hcl
resource "tipo_do_provider" "nome_local" {
  # configurações...
}
```

**Exemplos:**
```hcl
# EC2 instance na AWS
resource "aws_instance" "web" {
  ami           = "ami-123456"
  instance_type = "t2.micro"
}

# Virtual Machine na Azure
resource "azurerm_virtual_machine" "app" {
  name     = "app-vm"
  location = "East US"
}

# Arquivo local (demo)
resource "local_file" "demo" {
  content  = "Hello Terraform!"
  filename = "output.txt"
}
```

---

## 🔄 Terraform Lifecycle

### **Workflow Completo:**

```
┌─────────────────────────────────────────────┐
│  1. terraform init                          │
│     ↓ Inicializa, baixa providers          │
│                                             │
│  2. terraform plan                          │
│     ↓ Preview das mudanças                  │
│                                             │
│  3. terraform apply                         │
│     ↓ Cria/atualiza recursos                │
│                                             │
│  4. terraform destroy                       │
│     ↓ Deleta tudo                           │
└─────────────────────────────────────────────┘
```

### **1. `terraform init`**

Inicializa o diretório Terraform:
- 📦 Baixa providers necessários
- 🔧 Configura backend (state remoto)
- 🔌 Instala módulos referenciados

```bash
terraform init

# Saída:
# Initializing provider plugins...
# - Finding latest version of hashicorp/local...
# - Installing hashicorp/local v2.4.0...
# Terraform has been successfully initialized!
```

**Quando rodar:**
- ✅ Primeira vez no projeto
- ✅ Após adicionar novos providers
- ✅ Após mudar backend

### **2. `terraform plan`**

Mostra **o que será feito** (preview):
- ➕ Criar (verde)
- 🔄 Atualizar (amarelo)
- ➖ Deletar (vermelho)
- 🔁 Recriar (vermelho + verde)

```bash
terraform plan

# Saída:
# Terraform will perform the following actions:
#
#   # local_file.demo will be created
#   + resource "local_file" "demo" {
#       + content  = "Hello!"
#       + filename = "output.txt"
#     }
#
# Plan: 1 to add, 0 to change, 0 to destroy.
```

**Boas práticas:**
```bash
# Salvar plano para review
terraform plan -out=plan.tfplan

# Ver plano salvo em formato legível
terraform show plan.tfplan
```

### **3. `terraform apply`**

Aplica as mudanças:
- ✅ Cria recursos novos
- 🔄 Atualiza recursos existentes
- ❌ Deleta recursos removidos do código

```bash
# Modo interativo (pede confirmação)
terraform apply

# Modo automático (CI/CD)
terraform apply -auto-approve

# Aplicar plano salvo
terraform apply plan.tfplan
```

**Saída:**
```
local_file.demo: Creating...
local_file.demo: Creation complete after 0s [id=abc123]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

Outputs:
arquivo_criado = "output.txt"
```

### **4. `terraform destroy`**

Deleta **todos** os recursos:

```bash
# Modo interativo
terraform destroy

# Modo automático
terraform destroy -auto-approve

# Deletar apenas um recurso específico
terraform destroy -target=aws_instance.web
```

⚠️ **CUIDADO:** Isso deleta TUDO na AWS/Azure/etc!

---

## 📁 Estrutura de Arquivos

### **Projeto Simples:**

```
projeto/
├── main.tf              # Recursos principais
├── variables.tf         # Declaração de variáveis
├── outputs.tf           # Outputs (valores de retorno)
├── terraform.tfvars     # Valores das variáveis
└── .gitignore           # Ignora state e secrets
```

### **Projeto Médio:**

```
projeto/
├── main.tf
├── variables.tf
├── outputs.tf
├── providers.tf         # Configuração de providers
├── backend.tf           # State remoto (S3)
├── terraform.tfvars
├── dev.tfvars          # Variáveis de dev
├── prod.tfvars         # Variáveis de prod
└── modules/            # Módulos reutilizáveis
    └── webserver/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

### **Projeto Grande:**

```
projeto/
├── environments/
│   ├── dev/
│   │   ├── main.tf
│   │   ├── terraform.tfvars
│   │   └── backend.tf
│   ├── staging/
│   └── prod/
├── modules/
│   ├── vpc/
│   ├── ec2/
│   ├── rds/
│   └── s3/
└── .gitignore
```

---

## 🔧 Sintaxe Básica

### **1. Blocos Principais**

```hcl
# Terraform settings
terraform {
  required_version = ">= 1.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Provider configuration
provider "aws" {
  region = "us-east-1"
}

# Resource
resource "aws_instance" "web" {
  ami           = "ami-123"
  instance_type = "t2.micro"
  
  tags = {
    Name = "WebServer"
  }
}

# Data source (consulta recursos existentes)
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]
  
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*"]
  }
}

# Output
output "instance_ip" {
  value = aws_instance.web.public_ip
}
```

### **2. Variáveis**

**Declaração (`variables.tf`):**
```hcl
variable "instance_type" {
  description = "Tipo da instância EC2"
  type        = string
  default     = "t2.micro"
}

variable "ambiente" {
  description = "Ambiente (dev, staging, prod)"
  type        = string
}

variable "enable_monitoring" {
  description = "Habilitar monitoring"
  type        = bool
  default     = false
}

variable "availability_zones" {
  description = "Lista de AZs"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "tags" {
  description = "Tags comuns"
  type        = map(string)
  default     = {
    Managed = "Terraform"
  }
}
```

**Uso:**
```hcl
resource "aws_instance" "web" {
  ami           = "ami-123"
  instance_type = var.instance_type  # Usa variável
  
  tags = merge(
    var.tags,
    {
      Name = "web-${var.ambiente}"
    }
  )
}
```

**Definir valores (`terraform.tfvars`):**
```hcl
instance_type      = "t3.medium"
ambiente           = "production"
enable_monitoring  = true
availability_zones = ["us-east-1a", "us-east-1c"]

tags = {
  Project = "MyApp"
  Owner   = "DevOps Team"
}
```

**Passar via CLI:**
```bash
terraform apply -var="ambiente=dev"
terraform apply -var-file="prod.tfvars"
```

### **3. Outputs**

**Definir (`outputs.tf`):**
```hcl
output "instance_id" {
  description = "ID da instância EC2"
  value       = aws_instance.web.id
}

output "instance_public_ip" {
  description = "IP público"
  value       = aws_instance.web.public_ip
}

output "instance_private_ips" {
  description = "IPs privados"
  value       = aws_instance.web.*.private_ip
}

# Sensitive output (não mostra no terminal)
output "db_password" {
  value     = aws_db_instance.main.password
  sensitive = true
}
```

**Ver outputs:**
```bash
terraform output
terraform output instance_public_ip
terraform output -json
```

### **4. Locals (variáveis locais)**

```hcl
locals {
  common_tags = {
    Project     = "MyApp"
    ManagedBy   = "Terraform"
    Environment = var.ambiente
  }
  
  instance_name = "${var.projeto}-${var.ambiente}-web"
  
  # Expressões complexas
  is_production = var.ambiente == "prod"
  instance_count = local.is_production ? 3 : 1
}

resource "aws_instance" "web" {
  count = local.instance_count
  
  ami           = "ami-123"
  instance_type = var.instance_type
  
  tags = merge(
    local.common_tags,
    {
      Name = "${local.instance_name}-${count.index}"
    }
  )
}
```

---

## 🎯 Exemplo Prático: Hello World

### **Arquivo: `main.tf`**

```hcl
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

resource "local_file" "hello" {
  content  = "Hello, Terraform!"
  filename = "${path.module}/hello.txt"
}

output "file_path" {
  value = local_file.hello.filename
}
```

### **Executar:**

```bash
# 1. Inicializar
terraform init

# 2. Ver o que será criado
terraform plan

# 3. Criar o arquivo
terraform apply

# 4. Ver output
terraform output file_path

# 5. Verificar
cat hello.txt

# 6. Destruir
terraform destroy
```

---

## 📦 Módulos (Reutilização)

### **Criar Módulo:**

**Arquivo: `modules/webserver/main.tf`**
```hcl
variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "name" {
  type = string
}

resource "aws_instance" "web" {
  ami           = "ami-123"
  instance_type = var.instance_type
  
  tags = {
    Name = var.name
  }
}

output "instance_id" {
  value = aws_instance.web.id
}

output "public_ip" {
  value = aws_instance.web.public_ip
}
```

### **Usar Módulo:**

**Arquivo: `main.tf`**
```hcl
module "webserver_dev" {
  source = "./modules/webserver"
  
  name          = "web-dev"
  instance_type = "t2.micro"
}

module "webserver_prod" {
  source = "./modules/webserver"
  
  name          = "web-prod"
  instance_type = "t3.medium"
}

output "dev_ip" {
  value = module.webserver_dev.public_ip
}

output "prod_ip" {
  value = module.webserver_prod.public_ip
}
```

**Executar:**
```bash
terraform init     # Baixa módulos
terraform apply
```

---

## 🔐 Backend Remoto (State Compartilhado)

### **Local (não recomendado para produção):**
```hcl
# Padrão - terraform.tfstate no diretório local
```

### **S3 + DynamoDB (recomendado para AWS):**

**Arquivo: `backend.tf`**
```hcl
terraform {
  backend "s3" {
    bucket         = "my-terraform-state"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"  # Para lock
  }
}
```

**Vantagens:**
- ✅ State compartilhado (equipe)
- ✅ State versionado (S3 versioning)
- ✅ State criptografado
- ✅ Lock (evita conflitos com DynamoDB)

### **Terraform Cloud (recomendado para todos):**

```hcl
terraform {
  cloud {
    organization = "my-org"
    
    workspaces {
      name = "production"
    }
  }
}
```

**Vantagens:**
- ✅ State seguro na nuvem
- ✅ UI web para visualizar
- ✅ Execução remota
- ✅ Controle de acesso
- ✅ Histórico de runs

---

## 🎮 Comandos Essenciais

### **Básicos:**
```bash
terraform init              # Inicializar
terraform validate          # Validar sintaxe
terraform fmt               # Formatar código
terraform plan              # Preview mudanças
terraform apply             # Aplicar mudanças
terraform destroy           # Destruir tudo
```

### **State:**
```bash
terraform state list                    # Listar recursos
terraform state show aws_instance.web   # Ver detalhes
terraform state mv SOURCE DEST          # Renomear recurso
terraform state rm aws_instance.old     # Remover do state
terraform state pull                    # Baixar state remoto
```

### **Workspaces (ambientes):**
```bash
terraform workspace list                # Listar
terraform workspace new dev             # Criar
terraform workspace select prod         # Mudar
terraform workspace show                # Ver atual
terraform workspace delete staging      # Deletar
```

### **Import (trazer recurso existente):**
```bash
terraform import aws_instance.web i-1234567890abcdef0
```

### **Outputs:**
```bash
terraform output                # Ver todos
terraform output instance_ip    # Ver específico
terraform output -json          # JSON
```

### **Validação e Debug:**
```bash
terraform validate              # Validar sintaxe
terraform fmt -check            # Verificar formatação
terraform fmt -recursive        # Formatar tudo
terraform console               # Console interativo
TF_LOG=DEBUG terraform apply    # Debug verboso
```

---

## 🎯 Boas Práticas

### ✅ **Fazer:**

**1. Use backend remoto:**
```hcl
terraform {
  backend "s3" {
    bucket = "terraform-state"
    key    = "prod/terraform.tfstate"
  }
}
```

**2. Use variáveis:**
```hcl
# ✅ Bom
instance_type = var.instance_type

# ❌ Ruim - hardcoded
instance_type = "t2.micro"
```

**3. Use módulos para reutilização:**
```hcl
module "vpc" {
  source = "./modules/vpc"
  cidr   = "10.0.0.0/16"
}
```

**4. Use locals para valores calculados:**
```hcl
locals {
  common_tags = {
    Project   = var.project
    Terraform = "true"
  }
}
```

**5. Use `terraform fmt`:**
```bash
terraform fmt -recursive
```

**6. Versione providers:**
```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"  # Major fixo, minor/patch flexível
    }
  }
}
```

**7. Use `.gitignore`:**
```gitignore
# .gitignore
*.tfstate
*.tfstate.*
.terraform/
*.tfvars
!terraform.tfvars.example
```

**8. Documente com `terraform-docs`:**
```bash
terraform-docs markdown . > README.md
```

### ❌ **Evitar:**

```hcl
# ❌ Hardcoded secrets
password = "senha123"
# ✅ Use variables ou secrets manager

# ❌ Sem versionamento de provider
provider "aws" {}
# ✅ Sempre versione

# ❌ Resources com nomes genéricos
resource "aws_instance" "instance1" {}
# ✅ Nomes descritivos
resource "aws_instance" "web_server" {}

# ❌ Tudo em um arquivo main.tf gigante
# ✅ Separe em arquivos lógicos

# ❌ Commitar terraform.tfstate
# ✅ Use .gitignore e backend remoto
```

---

## 🆚 Comparação com Outras Ferramentas

| Aspecto | Terraform | CloudFormation | Ansible | Pulumi |
|---------|-----------|----------------|---------|--------|
| **Linguagem** | HCL | YAML/JSON | YAML | Python/TS/Go |
| **Multi-cloud** | ✅ Sim | ❌ AWS only | ✅ Sim | ✅ Sim |
| **Declarativo** | ✅ Sim | ✅ Sim | ⚠️ Misto | ✅ Sim |
| **State** | Externo | AWS gerencia | ❌ Não | Externo |
| **Curva aprendizado** | Média | Média | Baixa | Alta |
| **Community** | Grande | Média | Grande | Crescente |
| **Uso principal** | Infraestrutura | AWS infra | Config mgmt | Infra |

---

## 🚀 Exemplo Real: AWS Completo

```hcl
# providers.tf
terraform {
  required_version = ">= 1.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  
  backend "s3" {
    bucket         = "my-terraform-state"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}

provider "aws" {
  region = var.aws_region
}

# variables.tf
variable "aws_region" {
  default = "us-east-1"
}

variable "environment" {
  type = string
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

# main.tf
locals {
  common_tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Project     = "MyApp"
  }
}

# VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  
  tags = merge(
    local.common_tags,
    {
      Name = "vpc-${var.environment}"
    }
  )
}

# Subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, 1)
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true
  
  tags = merge(
    local.common_tags,
    {
      Name = "subnet-public-${var.environment}"
    }
  )
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  
  tags = merge(
    local.common_tags,
    {
      Name = "igw-${var.environment}"
    }
  )
}

# Security Group
resource "aws_security_group" "web" {
  name        = "web-${var.environment}"
  description = "Allow HTTP/HTTPS"
  vpc_id      = aws_vpc.main.id
  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = local.common_tags
}

# EC2 Instance
resource "aws_instance" "web" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.web.id]
  
  user_data = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y nginx
              systemctl start nginx
              EOF
  
  tags = merge(
    local.common_tags,
    {
      Name = "web-${var.environment}"
    }
  )
}

# Data source
data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]
  
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-20.04-amd64-server-*"]
  }
}

# outputs.tf
output "vpc_id" {
  value = aws_vpc.main.id
}

output "web_server_ip" {
  value = aws_instance.web.public_ip
}

output "web_server_url" {
  value = "http://${aws_instance.web.public_ip}"
}
```

**Usar:**
```bash
terraform init
terraform plan -var="environment=prod"
terraform apply -var="environment=prod"
```

---

## 📚 Recursos de Aprendizado

### **Documentação Oficial:**
- [Terraform Docs](https://www.terraform.io/docs)
- [Provider Registry](https://registry.terraform.io/)
- [Learn Terraform](https://learn.hashicorp.com/terraform)

### **Ferramentas Úteis:**
- **terraform-docs**: Gera documentação
- **tflint**: Linter para Terraform
- **checkov**: Security scanning
- **terragrunt**: DRY configuration

### **Práticas:**
- [Terraform Best Practices](https://www.terraform-best-practices.com/)
- [AWS Terraform Examples](https://github.com/hashicorp/terraform-provider-aws/tree/main/examples)

---

## 🎓 Checklist de Aprendizado

```markdown
✅ Conceitos básicos
  ✅ IaC (Infrastructure as Code)
  ✅ Declarativo vs Imperativo
  ✅ State
  ✅ Providers

✅ Comandos essenciais
  ✅ init, plan, apply, destroy
  ✅ state, workspace
  ✅ output, console

✅ Sintaxe HCL
  ✅ Resources
  ✅ Variables
  ✅ Outputs
  ✅ Locals
  ✅ Data sources

✅ Organização
  ✅ Estrutura de arquivos
  ✅ Módulos
  ✅ Backend remoto

✅ Boas práticas
  ✅ Versionamento
  ✅ .gitignore
  ✅ Variables em vez de hardcode
  ✅ Backend remoto
```

---

**🎯 Resumo:**
- Terraform = Infraestrutura como Código
- Declarativo (estado desejado)
- Multi-cloud e multi-provider
- State rastreia recursos
- Modules para reutilização
- Backend remoto para colaboração
- HCL: linguagem simples e legível

**Próximos passos:** Praticar com examples oficiais e criar módulos reutilizáveis! 🚀
