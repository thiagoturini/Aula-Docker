# 🐳 Docker & Kubernetes - Projeto de Demonstração

Projeto de demonstração de orquestração de containers usando **Docker Compose**, **Kubernetes** e **Terraform**, com uma API REST de filmes construída em FastAPI e PostgreSQL.

## 📋 Visão Geral

Este repositório demonstra três abordagens diferentes para implantação de aplicações containerizadas:

- **Docker Compose** - Orquestração local multi-container para desenvolvimento
- **Kubernetes** - Orquestração em escala com auto-healing, auto-scaling e load balancing
- **Terraform** - Infrastructure as Code para automação de deploy

## 🚀 Quick Start

### Pré-requisitos
- [Docker Desktop](https://www.docker.com/products/docker-desktop) instalado e rodando
- Kubernetes habilitado no Docker Desktop (opcional, para testes K8s)
- [Terraform](https://www.terraform.io/downloads) (opcional, para testes IaC)

### Execução Rápida com Docker Compose

```bash
cd Exercicio_2_Compose_K8s_Terraform_Demo/compose
docker-compose up -d
curl http://localhost:8000/health
```

## 📂 Estrutura do Projeto

### Raiz do Repositório
- `app.py` - Exemplo simples de containerização
- `Dockerfile` - Configuração de imagem Docker
- `docker-compose.yml` - Orquestração básica
- `requirements.txt` - Dependências Python

### Exercício 2 - Projeto Completo
```
Exercicio_2_Compose_K8s_Terraform_Demo/
├── api/                    # Aplicação FastAPI
│   ├── app.py             # API REST de filmes e reviews
│   ├── Dockerfile         # Imagem da aplicação
│   └── requirements.txt   # Dependências
├── compose/               # Docker Compose
│   └── docker-compose.yml # Orquestração local
├── k8s/                   # Kubernetes Manifests
│   ├── namespace.yaml     # Isolamento de recursos
│   ├── postgres-*.yaml    # Banco de dados
│   └── api-*.yaml         # Aplicação e auto-scaling
├── terraform_demo/        # Infrastructure as Code
│   └── main.tf           # Definição Terraform
└── docs/
    ├── COMO_EXECUTAR.md      # Guia de testes e validação
    ├── NARRATIVA_PROJETO.md  # Explicação detalhada
    └── GUIA_*.md            # Guias específicos
```

## 🔧 Tecnologias Utilizadas

**Backend:**
- Python 3.11
- FastAPI
- PostgreSQL 15
- psycopg2

**Container & Orquestração:**
- Docker & Docker Compose
- Kubernetes (Deployments, Services, HPA, PVC, ConfigMaps, Secrets)
- Terraform (IaC)

**Observabilidade:**
- Health checks (Liveness & Readiness Probes)
- Resource limits (CPU/Memory)
- Horizontal Pod Autoscaling

## 📖 Documentação

| Documento | Descrição |
|-----------|-----------|
| [COMO_EXECUTAR.md](Exercicio_2_Compose_K8s_Terraform_Demo/COMO_EXECUTAR.md) | Guia de testes e validação com troubleshooting |
| [NARRATIVA_PROJETO.md](Exercicio_2_Compose_K8s_Terraform_Demo/NARRATIVA_PROJETO.md) | Explicação detalhada de cada componente |
| [GUIA_DOCKER_COMPOSE.md](Exercicio_2_Compose_K8s_Terraform_Demo/compose/GUIA_DOCKER_COMPOSE.md) | Específico sobre Docker Compose |
| [GUIA_KUBERNETES.md](Exercicio_2_Compose_K8s_Terraform_Demo/k8s/GUIA_KUBERNETES.md) | Específico sobre Kubernetes |
| [GUIA_TERRAFORM.md](Exercicio_2_Compose_K8s_Terraform_Demo/terraform_demo/GUIA_TERRAFORM.md) | Específico sobre Terraform |

## 🎯 Features Implementadas

### API REST
- ✅ Health check endpoint (`/health`)
- ✅ CRUD de reviews de filmes
- ✅ Conexão com PostgreSQL
- ✅ Retry automático de conexão
- ✅ Inicialização automática de schema

### Docker Compose
- ✅ Multi-container (API + PostgreSQL)
- ✅ Health checks
- ✅ Volumes persistentes
- ✅ Networking automático
- ✅ Restart policies

### Kubernetes
- ✅ 3 réplicas da API (alta disponibilidade)
- ✅ Horizontal Pod Autoscaler (3-10 réplicas)
- ✅ ConfigMaps e Secrets
- ✅ Persistent Volume Claims
- ✅ Liveness & Readiness Probes
- ✅ Resource requests e limits
- ✅ LoadBalancer service

### Terraform
- ✅ Deployment completo via IaC
- ✅ Gerenciamento de estado
- ✅ Plan/Apply/Destroy workflow
- ✅ Dependências automáticas

## 🧪 Testes

### Docker Compose
```bash
cd Exercicio_2_Compose_K8s_Terraform_Demo/compose
docker-compose up -d
curl http://localhost:8000/health
docker-compose down
```

### Kubernetes
```bash
cd Exercicio_2_Compose_K8s_Terraform_Demo
docker build -t filmes-api:latest ./api
kubectl apply -f k8s/
kubectl get pods -n filmes-app
```

### Terraform
```bash
cd Exercicio_2_Compose_K8s_Terraform_Demo/terraform_demo
terraform init
terraform plan
terraform apply
terraform destroy
```

## 🛠️ Desenvolvimento

### Extensões VS Code Recomendadas
- Docker (`ms-azuretools.vscode-docker`)
- Kubernetes (`ms-kubernetes-tools.vscode-kubernetes-tools`)
- REST Client (`humao.rest-client`)
- YAML (`redhat.vscode-yaml`)
- Terraform (`hashicorp.terraform`)

### Instalação em Batch
```bash
code --install-extension ms-azuretools.vscode-docker
code --install-extension ms-kubernetes-tools.vscode-kubernetes-tools
code --install-extension humao.rest-client
code --install-extension redhat.vscode-yaml
code --install-extension hashicorp.terraform
```

## 📊 Comparação de Abordagens

| Feature | Docker Compose | Kubernetes | Terraform |
|---------|---------------|------------|-----------|
| Complexidade | Baixa | Alta | Média |
| Auto-scaling | ❌ | ✅ | Configura |
| Multi-host | ❌ | ✅ | ✅ |
| IaC | Limitado | Via YAML | ✅ Completo |
| Ideal para | Desenvolvimento | Produção | Automação |

## 🤝 Contribuindo

Este é um projeto de demonstração educacional. Sugestões e melhorias são bem-vindas via issues ou pull requests.

## 📝 Licença

Projeto de código aberto para fins educacionais.

## 👥 Autor

Thiago Pinto - [GitHub](https://github.com/thiagoturini)
