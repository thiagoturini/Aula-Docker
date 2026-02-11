# 📁 Exercício 2 - Orquestração e Infraestrutura

**Da Orquestração Local à Mentalidade Cloud**

---

## 🎯 Objetivo da Aula

**Desenvolver mentalidade de orquestração e infraestrutura como código.**

Ao final desta aula, você será capaz de:

✅ Orquestrar múltiplos containers com Docker Compose  
✅ Entender quando usar Compose vs Kubernetes  
✅ Compreender o conceito de "estado desejado"  
✅ Reconhecer o valor de Infraestrutura como Código

**Foco:** Arquitetura e estratégia, não detalhes internos profundos.

---

## 📂 Estrutura da Pasta

```
Exercicio_2_Compose_K8s_Terraform_Demo/
│
├── 📖 GUIA_EXERCICIO_2.md                    ← 📚 Guia do aluno (LEIA PRIMEIRO!)
├── 📄 README.md                              ← Você está aqui
│
├── 🐍 api/                                   ← Código da API FastAPI
│   ├── app.py                                ← Endpoints: /health, /filmes, /reviews
│   ├── Dockerfile                            ← Build da imagem
│   └── requirements.txt
│
├── 🐳 1-docker-compose/                      ← Docker Compose (Nível 1)
│   ├── GUIA_DOCKER_COMPOSE.md                ← 📚 Guia completo
│   ├── README.md                             ← Quick start
│   ├── docker-compose.yml                    ← Orquestra API + PostgreSQL
│   └── docker-compose.comentado.yml          ← Versão explicada
│
├── ☸️ 2-kubernetes/                          ← Kubernetes (Nível 2)
│   ├── GUIA_KUBERNETES.md                    ← 📚 Guia completo
│   ├── README.md                             ← Quick start
│   ├── namespace.yaml                        ← Namespace isolado
│   ├── postgres/                             ← PostgreSQL organizado
│   │   ├── configmap.yaml
│   │   ├── secret.yaml
│   │   ├── pvc.yaml
│   │   ├── deployment.yaml
│   │   └── service.yaml
│   └── api/                                  ← API organizada
│       ├── configmap.yaml
│       ├── deployment.yaml
│       ├── service.yaml
│       └── hpa.yaml
│
└── 🏗️ 3-terraform/                          ← Terraform (Nível 3)
    ├── GUIA_TERRAFORM.md                     ← 📚 Guia completo
    ├── README.md                             ← Quick start
    ├── main.tf                               ← Demo local
    ├── .gitignore
    └── exemplos/                             ← Exemplos progressivos
        ├── 1-basico/
        ├── 2-variaveis/
        ├── 3-modulos/
        └── 4-aws-completo/
```

---

## 🎓 Como Funciona a Aula

### Formato: Hands-on + Demos

| Parte | Tópico | Quem Faz | Tempo |
|-------|--------|----------|-------|
| **A** | Docker Compose | 🙋 Alunos (hands-on) | 90 min |
| **B** | Kubernetes | 👨‍🏫 Professor (demo) | 60 min |
| **C** | Terraform | 👨‍🏫 Professor (demo) | 30 min |
| **D** | Consolidação | 💬 Discussão | 10 min |

---

## 🚀 Quick Start

### 📦 **Nível 1: Docker Compose** (Mais Simples)

```bash
# 1. Entrar na pasta
cd 1-docker-compose/

# 2. Subir stack (API + PostgreSQL)
docker-compose up -d

# 3. Testar API
curl http://localhost:8000/health
curl http://localhost:8000/filmes

# 4. Ver logs
docker-compose logs -f

# 5. Parar tudo
docker-compose down

# 📚 Ver guia completo
cat GUIA_DOCKER_COMPOSE.md
```

### ☸️ **Nível 2: Kubernetes** (Orquestração Avançada)

```bash
# 1. Construir imagem
docker build -t filmes-api:local ../api

# 2. Aplicar recursos
kubectl apply -f 2-kubernetes/

# 3. Ver status
kubectl get all -n filmes-app

# 4. Testar (porta diferente!)
curl http://localhost:30080/health
curl http://localhost:30080/filmes

# 5. Ver pods se auto-recuperando
kubectl delete pod -n filmes-app -l app=filmes-api
kubectl get pods -n filmes-app -w

# 6. Limpar
kubectl delete -f 2-kubernetes/

# 📚 Ver guia completo
cat 2-kubernetes/GUIA_KUBERNETES.md
```

### 🏗️ **Nível 3: Terraform** (Infraestrutura como Código)

```bash
# 1. Entrar na pasta
cd 3-terraform/

# 2. Inicializar
terraform init

# 3. Ver o que será criado
terraform plan

# 4. Aplicar (criar recursos)
terraform apply -auto-approve

# 5. Ver arquivo criado
cat infra.txt

# 6. Destruir
terraform destroy -auto-approve

# 📚 Ver guia completo
cat GUIA_TERRAFORM.md
```
- State management

---

## 🧭 Filosofia da Aula

### O Que Esta Aula **É**

✅ **Introdução estratégica** a orquestração  
✅ **Mentalidade** de infraestrutura declarativa  
✅ **Conexão** entre Docker → Compose → K8s → Terraform  
✅ **Prática** com ferramentas reais

### O Que Esta Aula **Não É**

❌ Curso completo de Kubernetes  
❌ Livro de Terraform  
❌ Manual de produção cloud  
❌ Detalhamento interno de control planes

**Princípio:** Ensinar arquitetura e quando usar cada ferramenta, não memorizar todos os detalhes.

---

## 🎯 Conexão com DevOps Moderno

```
┌─────────────────────────────────────────────┐
│            TERRAFORM                        │  ← Provisiona infraestrutura
│  (Cria servidores, redes, bancos)          │     (AWS, Azure, GCP)
└──────────────────┬──────────────────────────┘
                   │
                   ↓
┌─────────────────────────────────────────────┐
│            KUBERNETES                       │  ← Orquestra containers
│  (Gerencia pods, deploys, services)        │     (Produção, HA, scaling)
└──────────────────┬──────────────────────────┘
                   │
                   ↓
┌─────────────────────────────────────────────┐
│            DOCKER COMPOSE                   │  ← Orquestra containers
│  (Dev local, testes integração)            │     (1 máquina)
└──────────────────┬──────────────────────────┘
                   │
                   ↓
┌─────────────────────────────────────────────┐
│            DOCKER                           │  ← Empacota aplicação
│  (Containers, imagens)                      │     (Portabilidade)
└─────────────────────────────────────────────┘
```

### Analogia Simplificada

- **Docker:** Padroniza como aplicações rodam
- **Compose:** Orquestra containers (dev local, 1 máquina)
- **Kubernetes:** Orquestra containers (produção, cluster, HA)
- **Terraform:** Cria a infraestrutura onde tudo roda

---

## 🤔 Quando Usar Cada Ferramenta?

### Docker Compose

✅ **Use para:**
- Desenvolvimento local
- Testes de integração
- Aplicações simples (1 servidor, sem HA)

❌ **Não use para:**
- Produção com múltiplos servidores
- Alta disponibilidade crítica
- Auto-scaling sob demanda

### Kubernetes

✅ **Use para:**
- Produção (múltiplos servidores)
- Alta disponibilidade necessária
- Aplicações que precisam escalar
- Self-healing automático

❌ **Não use para:**
- Desenvolvimento local simples
- Aplicações pequenas (1 servidor)
- Quando complexidade não se justifica

### Terraform

✅ **Use para:**
- Gerenciar infraestrutura cloud (AWS, Azure, GCP)
- Criar ambientes reproduzíveis (dev = staging = prod)
- Auditar mudanças de infraestrutura
- Colaboração em time (IaC versionado)

❌ **Não use para:**
- Configuração de aplicação (use ConfigMaps/Secrets)
- Deploy de código (use CI/CD)
- Infraestrutura que nunca muda

---

## 📚 Material de Apoio

### Para Alunos

- **GUIA_EXERCICIO_2.md** - Tutorial hands-on completo
- **README.md** (este arquivo) - Visão geral e filosofia

### Para Professores

- **ROTEIRO_AULA_2.md** - Timing, perguntas estratégicas, momentos de pausa

---

## 🔧 Troubleshooting Rápido

### Docker Compose

**API não conecta no banco:**
```bash
docker compose logs db
docker compose logs api
docker compose up --build --force-recreate
```

**Porta já em uso:**
```bash
# Alterar no docker-compose.yml
ports:
  - "8001:8000"  # Host:Container
```

### Kubernetes

**Pods não iniciam:**
```bash
kubectl describe pod <nome>
kubectl logs <nome>
```

**Imagem não encontrada:**
```bash
# Garantir imagePullPolicy: Never
# Buildar imagem localmente:
docker build -t filmes-api:local ../api
```

---

## ✅ Checklist de Aprendizado

Ao final da aula, você deve conseguir:

- [ ] Explicar diferença entre Compose e Kubernetes
- [ ] Subir stack multi-container com Compose
- [ ] Entender conceito de "estado desejado"
- [ ] Reconhecer quando usar cada ferramenta
- [ ] Compreender valor de Infraestrutura como Código

**Mentalidade > Memorização**

---

## 🚀 Próximos Passos

**Aprofundar Compose:**
- Adicionar Redis (cache)
- Adicionar nginx (proxy reverso)
- Múltiplos ambientes (dev, staging)

**Explorar Kubernetes:**
- Namespaces (isolar ambientes)
- ConfigMaps e Secrets
- Ingress (roteamento HTTP avançado)

**Terraform Real:**
- Provisionar EC2 na AWS
- Criar RDS (banco gerenciado)
- Configurar VPC (rede isolada)

---

**Bons estudos! 🎉**

### Divisão de Responsabilidades

| Parte | Quem Faz | O Que | Duração |
|-------|----------|-------|---------|
| **PARTE A: Docker Compose** | 🙋 Alunos (hands-on) | Subir stack, criar reviews, testar persistência | 90 min |
| **PARTE B: Kubernetes** | 👨‍🏫 Professor (demo) | Mostrar self-healing, escalar réplicas | 60 min |
| **PARTE C: Terraform** | 👨‍🏫 Professor (demo) | Conceitos de IaC, apply/destroy | 30 min |

**Total:** 3h30 de aula (180 minutos + 10 min de intervalo)

---

## 📖 Como Usar Este Material

### 🙋 Se você é ALUNO:

1. **LEIA PRIMEIRO:** Abra [GUIA_EXERCICIO_2.md](GUIA_EXERCICIO_2.md)
2. **FOQUE NA PARTE A:** Docker Compose (você vai executar!)
3. **PARTE 0** explica CONTEXTO (por que Compose existe)
4. **PARTE A** tem explicações linha-por-linha do YAML
5. **EXPERIMENTO DE PERSISTÊNCIA** é a parte mais legal (dados sobrevivem!)
6. **PARTES B e C:** Apenas LEIA para entender (professor vai demonstrar)

**⚠️ Não pule PARTE 0!** Ela conecta com a aula anterior e explica o problema.

### 👨‍🏫 Se você é PROFESSOR:

1. **LEIA PRIMEIRO:** [GUIA_PROFESSOR_EXERCICIO_2.md](GUIA_PROFESSOR_EXERCICIO_2.md)
2. **IMPORTANTE:** Guia do professor tem:
   - Roteiros de fala prontos
   - Gestão de tempo e carga cognitiva
   - Respostas para perguntas esperadas
   - Como reagir a erros comuns
3. **COMANDOS PRONTOS:** [../CHECKLIST_DEMO.md](../CHECKLIST_DEMO.md) (copy-paste)
4. **VALIDAR AMBIENTE:** Um dia antes, rode comandos para testar

**📋 Checklist Pré-Aula:**
- [ ] Docker Desktop rodando
- [ ] Kubernetes habilitado no Docker Desktop (Settings → Kubernetes → Enable)
- [ ] Terraform instalado (`brew install terraform` ou download)
- [ ] Testar docker compose up uma vez
- [ ] Testar kubectl get nodes (deve retornar docker-desktop)
- [ ] Ter terminal com fonte grande (legível no projetor)

---

## ⚡ Quick Start

### 🐳 Docker Compose (Alunos fazem)

```bash
# 1. Navegar para pasta Compose
cd compose/

# 2. Subir stack completa (API + PostgreSQL)
docker compose up --build -d

# 3. Verificar saúde
curl http://localhost:8000/health
# Esperado: {"status":"healthy"}

# 4. Criar uma review
curl -X POST http://localhost:8000/reviews \
  -H "Content-Type: application/json" \
  -d '{
    "filme_id": 1,
    "autor": "Seu Nome",
    "nota": 5,
    "comentario": "Filme incrível!"
  }'

# 5. Listar reviews
curl http://localhost:8000/reviews

# 6. EXPERIMENTO: Testar persistência
docker compose down          # Destrói containers
docker compose up -d         # Recria containers
curl http://localhost:8000/reviews  # Reviews voltaram! 🎉
```

**🎯 Objetivo:** Entender orquestração multi-container e persistência.

---

### ☸️ Kubernetes (Professor demonstra)

```bash
# 1. Construir imagem local
cd api/
docker build -t filmes-api:local .

# 2. Aplicar deployment (cria 2 pods)
cd ../k8s/
kubectl apply -f deployment.yaml

# 3. Aplicar service (expõe na porta 30080)
kubectl apply -f service.yaml

# 4. Verificar pods
kubectl get pods
# Esperado: 2 pods com STATUS "Running"

# 5. Testar acesso
curl http://localhost:30080/health

# 6. DEMONSTRAÇÃO DE SELF-HEALING:
# Deletar um pod e ver Kubernetes recriar automaticamente
kubectl delete pod <nome-do-pod>
kubectl get pods  # Novo pod já sendo criado!
```

**🎯 Objetivo:** Ver self-healing e escalabilidade horizontal acontecerem ao vivo.

---

### 🏗️ Terraform (Professor demonstra)

```bash
# 1. Navegar para pasta Terraform
cd terraform_demo/

# 2. Inicializar (baixa provider "local")
terraform init

# 3. Ver o que vai criar (dry-run)
terraform plan

# 4. Criar infraestrutura
terraform apply -auto-approve
# Cria arquivo infra.txt

# 5. Verificar arquivo criado
cat infra.txt
ls -lh infra.txt

# 6. Destruir infraestrutura
terraform destroy -auto-approve
# Arquivo é deletado!

# 7. Validar destruição
ls infra.txt  # Erro: No such file
```

**🎯 Objetivo:** Entender conceito de Infraestrutura como Código (IaC).

---

## 🎓 O Que Você Vai Aprender

### PARTE A: Docker Compose (90 min - Hands-on)

**Conceitos:**
- ✅ Por que precisamos orquestrar múltiplos containers
- ✅ Como definir serviços (API, DB) em um único arquivo YAML
- ✅ Comunicação via hostname (nome do serviço vira DNS)
- ✅ Persistência de dados com volumes nomeados
- ✅ Healthcheck para garantir ordem de inicialização
- ✅ depends_on com condition: service_healthy

**Prática:**
- ✅ Subir stack API + PostgreSQL
- ✅ Criar e consultar reviews no banco
- ✅ **EXPERIMENTO IMPACTANTE:** Destruir containers e ver dados voltarem

**Reflexão:**
- ✅ O que Compose resolve? (orquestração local, dev)
- ✅ O que Compose NÃO resolve? (produção multi-servidor)

---

### PARTE B: Kubernetes (60 min - Demo Professor)

**Conceitos:**
- ✅ Diferença entre Compose (1 máquina) vs K8s (cluster)
- ✅ Pod = menor unidade (geralmente 1 container)
- ✅ Deployment = gerenciador de réplicas (garante N pods sempre)
- ✅ Service = load balancer com IP fixo
- ✅ **Estado desejado** = filosofia declarativa ("quero 2 pods, sempre")
- ✅ **Self-healing** = se pod cai, K8s recria automaticamente

**Demonstração ao Vivo:**
- ✅ Aplicar deployment.yaml (2 réplicas)
- ✅ Aplicar service.yaml (NodePort 30080)
- ✅ **MOMENTO WOW:** Deletar um pod e ver novo surgir automaticamente
- ✅ Escalar para 5 réplicas com um comando

**Reflexão:**
- ✅ Quando usar K8s? (produção, alta disponibilidade, escala)
- ✅ Trade-off: complexidade vs recursos

---

### PARTE C: Terraform (30 min - Demo Professor)

**Conceitos:**
- ✅ Infraestrutura como Código (IaC) = descrever infra em arquivos
- ✅ Declarativo (diz "quero isso", não "faça isso")
- ✅ State management (Terraform rastreia o que criou)
- ✅ Idempotência (rodar 2x = mesmo resultado)
- ✅ Providers (plugins para AWS, Azure, GCP, local, etc)

**Demonstração ao Vivo:**
- ✅ terraform init (baixa provider)
- ✅ terraform plan (mostra o que vai fazer)
- ✅ terraform apply (CRIA arquivo)
- ✅ terraform destroy (DELETA arquivo)
- ✅ Mostrar terraform.tfstate (brain do Terraform)

**Reflexão:**
- ✅ Em produção: Terraform cria clusters K8s, bancos RDS, redes VPC
- ✅ Compose define containers. Terraform provisiona ONDE containers rodam.

---

## 🧩 Como Tudo Se Conecta

```
CICLO DE VIDA COMPLETO DE UMA APLICAÇÃO:

1. DESENVOLVIMENTO (Sua Máquina)
   ├─▶ Docker: Empacota aplicação em container
   └─▶ Docker Compose: Orquestra API + DB localmente

2. BUILD/CI (Pipeline)
   ├─▶ Docker: Constrói imagem
   └─▶ Push para registry (Docker Hub, ECR, ACR)

3. PROVISIONAMENTO DE INFRAESTRUTURA (Cloud)
   ├─▶ Terraform: Cria cluster Kubernetes (EKS, AKS, GKE)
   ├─▶ Terraform: Cria banco gerenciado (RDS, Azure SQL)
   └─▶ Terraform: Cria redes, load balancers, storage

4. DEPLOY E ORQUESTRAÇÃO (Produção)
   ├─▶ Kubernetes: Gerencia containers em múltiplos servidores
   ├─▶ Kubernetes: Self-healing (recria pods que falham)
   ├─▶ Kubernetes: Auto-scaling (aumenta réplicas sob carga)
   └─▶ Kubernetes: Rolling updates (atualiza sem downtime)

5. MONITORAMENTO E GESTÃO
   ├─▶ Prometheus/Grafana: Métricas
   ├─▶ ELK/Loki: Logs centralizados
   └─▶ Terraform: Ajusta infra conforme necessidade
```

**ANALOGIA DIDÁTICA:**

| Ferramenta | Analogia | O Que Gerencia |
|------------|----------|----------------|
| **Docker** | 📦 Caixas de mudança | Empacota aplicação |
| **Compose** | 📋 Lista de caixas | Orquestra caixas na SUA casa |
| **Kubernetes** | 🏢 Empresa de logística | Orquestra caixas em MÚLTIPLOS armazéns |
| **Terraform** | 🏗️ Construtora | Constrói os armazéns onde caixas ficam |

---

## 🔗 Pré-Requisitos

### Conhecimentos

- ✅ Docker básico (Dockerfile, docker run, docker build) - **Aula 1**
- ✅ Conceitos de API REST (GET, POST)
- ✅ Conhecimento básico de bancos de dados

### Ferramentas Instaladas

- ✅ **Docker Desktop** (inclui Docker Engine + Compose)
  - Download: https://www.docker.com/products/docker-desktop
  - Verificar: `docker --version` e `docker compose version`

- ✅ **Kubernetes (via Docker Desktop)**
  - Docker Desktop → Settings → Kubernetes → Enable Kubernetes
  - Verificar: `kubectl get nodes` (deve retornar `docker-desktop`)

- ✅ **Terraform** (para demo do professor)
  - macOS: `brew install terraform`
  - Windows: `choco install terraform`
  - Linux: https://developer.hashicorp.com/terraform/downloads
  - Verificar: `terraform --version`

- ✅ **curl** (para testar endpoints)
  - Já vem instalado em macOS/Linux
  - Windows: `choco install curl` ou usar Git Bash

---

## 📚 Documentação Adicional

### Arquivos do Exercício

| Arquivo | Propósito | Público |
|---------|-----------|---------|
| [GUIA_EXERCICIO_2.md](GUIA_EXERCICIO_2.md) | Tutorial pedagógico completo com teoria + prática | Alunos + Professor |
| [GUIA_PROFESSOR_EXERCICIO_2.md](GUIA_PROFESSOR_EXERCICIO_2.md) | Manual de condução com roteiros, timing, gestão de sala | Professor |
| [../CHECKLIST_DEMO.md](../CHECKLIST_DEMO.md) | Comandos prontos para copy-paste na aula | Professor |
| [terraform_demo/README.md](terraform_demo/README.md) | Guia específico de Terraform com exemplos | Alunos + Professor |

### Recursos Externos

- 📖 [Docker Compose Docs](https://docs.docker.com/compose/) - Referência oficial
- 📖 [Kubernetes Basics](https://kubernetes.io/docs/tutorials/kubernetes-basics/) - Tutorial interativo
- 📖 [Terraform Getting Started](https://developer.hashicorp.com/terraform/tutorials/aws-get-started) - Tutorial oficial
- 🎥 [Docker Compose in 12 Minutes](https://www.youtube.com/watch?v=Qw9zlE3t8Ko) - Video introdutório
- 🎥 [Kubernetes Explained in 15 Minutes](https://www.youtube.com/watch?v=VnvRFRk_51k) - Visão geral

---

## ❓ FAQ - Perguntas Frequentes

### Para Alunos

**P: Preciso fazer tudo (Compose + K8s + Terraform)?**  
R: NÃO. Foque no **Docker Compose** (PARTE A). K8s e Terraform são apenas demonstrações do professor para você ENTENDER os conceitos.

**P: Meu docker compose up deu erro "port already allocated".**  
R: Porta 8000 ou 5432 já está em uso. Opções:
1. Descobrir o que está usando: `lsof -i :8000` e matar o processo
2. Mudar porta no docker-compose.yml: `"8001:8000"`

**P: "Error: database connection failed" - o que fazer?**  
R: Ver logs do banco: `docker compose logs db`. Provavelmente healthcheck não passou ainda (aguarde 10-15s) ou senha está errada.

**P: Como sei se persistência funcionou?**  
R: Crie reviews, rode `docker compose down`, rode `docker compose up -d`, liste reviews novamente. Se voltaram = funcionou!

**P: Posso mudar o código da API?**  
R: SIM! Edite `api/app.py`, depois rode `docker compose up --build` (flag `--build` reconstrói imagem).

---

### Para Professores

**P: Quanto tempo devo gastar em cada parte?**  
R: Ver GUIA_PROFESSOR_EXERCICIO_2.md → Capítulo 7 (Gestão de Tempo). Recomendado: Compose (90min), K8s (60min), Terraform (30min).

**P: Alunos devem fazer hands-on de Kubernetes?**  
R: NÃO. K8s é complexo para configurar em 3h30. Professor demonstra, alunos absorvem conceitos. Foco do hands-on é Compose.

**P: E se alguém perguntar sobre Helm/Istio/outras ferramentas?**  
R: Use técnica "Parking Lot" (GUIA_PROFESSOR → Capítulo 7): anote pergunta, responda depois. Não desvie do roteiro.

**P: Como lidar com sobrecarga cognitiva?**  
R: Ver GUIA_PROFESSOR_EXERCICIO_2.md → "Gestão de Carga Cognitiva". Faça checkpoints a cada 20 min, use técnica 80/20.

---

## 🐛 Troubleshooting Comum

| Erro | Causa | Solução |
|------|-------|---------|
| `bind: address already in use` | Porta já ocupada | `lsof -i :8000` → `kill -9 <PID>` ou mudar porta |
| `database connection failed` | Banco ainda não subiu | Aguardar 10s, verificar `docker compose logs db` |
| `no such image: filmes-api:local` | Esqueceu de buildar | `cd api && docker build -t filmes-api:local .` |
| `connection refused localhost:8080` | K8s não habilitado | Docker Desktop → Settings → Kubernetes → Enable |
| `ImagePullBackOff` | K8s tentou baixar imagem | Verificar `imagePullPolicy: Never` em deployment.yaml |
| `terraform: command not found` | Terraform não instalado | `brew install terraform` (macOS) |

---

## 🎉 Conclusão

Você está prestes a aprender 3 tecnologias fundamentais para DevOps/DataOps moderno:

1. **Docker Compose** → Orquestração local (dev)
2. **Kubernetes** → Orquestração produção (escala, HA)
3. **Terraform** → Provisionamento de infraestrutura

**IMPORTANTE:** Não tente dominar tudo em uma aula. Foque em ENTENDER OS CONCEITOS. Com o tempo, você vai aprofundar em cada ferramenta.

**🚀 COMEÇAR AGORA:**  
👉 [Abrir GUIA_EXERCICIO_2.md](GUIA_EXERCICIO_2.md)

---

**Boa sorte e bons estudos! 🎓**
