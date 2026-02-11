# 🎓 Exercício 2 - Orquestração e Infraestrutura

**Da Orquestração Local à Mentalidade Cloud**

---

## 📋 Estrutura da Aula

**Duração:** 3h30  
**Formato:** Hands-on + Demos

| Parte | Tópico | Formato | Tempo |
|-------|--------|---------|-------|
| **A** | Docker Compose | 🙋 Alunos (hands-on) | 90 min |
| **B** | Kubernetes | 👨‍🏫 Professor (demo) | 60 min |
| **C** | Terraform | 👨‍🏫 Professor (demo) | 30 min |
| **D** | Consolidação | 💬 Discussão | 10 min |

---

## 🎯 O Que Você Vai Aprender

Ao final desta aula, você será capaz de:

✅ Orquestrar múltiplos containers com Docker Compose  
✅ Entender quando usar Compose vs Kubernetes  
✅ Compreender o conceito de "estado desejado"  
✅ Reconhecer o valor de Infraestrutura como Código

**Mentalidade, não memorização.**

---

# PARTE A - Docker Compose (90 min)

## 🔗 Conectando com a Aula Anterior

**Aula 1:** Você aprendeu a containerizar uma aplicação individual.

**Problema real:** Aplicações precisam de bancos de dados, caches, filas...

**Solução:** Docker Compose orquestra múltiplos containers.

---

## 💡 Conceito Central

### O Que é Docker Compose?

**Orquestrador de containers em uma única máquina.**

```yaml
# docker-compose.yml - Orquestra múltiplos serviços
services:
  api:      # Serviço 1: Aplicação
  db:       # Serviço 2: Banco de dados
```

### Por Que Usar?

| Sem Compose | Com Compose |
|-------------|-------------|
| `docker run` múltiplas vezes | `docker compose up` (uma vez) |
| Criar rede manualmente | Rede criada automaticamente |
| Configurar cada container | Configuração centralizada |
| Ordem manual de inicialização | `depends_on` gerencia ordem |

---

## 📂 Nossa Stack

```
┌─────────────────────────────────────┐
│         API (FastAPI)               │  ← Porta 8000
│  Endpoints: /filmes, /reviews       │
└─────────────────┬───────────────────┘
                  │
                  │ DATABASE_URL
                  ↓
┌─────────────────────────────────────┐
│       PostgreSQL 15                 │  ← Porta 5432
│  Banco: filmesdb                    │
└─────────────────────────────────────┘
```

---

## 🔍 Entendendo o docker-compose.yml

Abra: `compose/docker-compose.yml`

### Anatomia do Arquivo

```yaml
version: '3.8'

services:
  db:                        # Nome do serviço (vira hostname!)
    image: postgres:15-alpine
    environment:
      POSTGRES_DB: filmesdb  # Cria banco automaticamente
    volumes:
      - postgres_data:/var/lib/postgresql/data  # Persistência
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]

  api:
    build: ../api            # Constrói do Dockerfile
    environment:
      DATABASE_URL: postgresql://postgres:postgres@db:5432/filmesdb
    depends_on:
      db:
        condition: service_healthy  # Espera banco estar pronto

volumes:
  postgres_data:             # Volume nomeado (persiste dados)
```

### Conceitos-Chave

**1. Rede interna automática:**
- Compose cria rede privada entre containers
- API acessa banco via hostname `db` (não `localhost`!)

**2. Healthcheck:**
- Garante que banco está **realmente pronto** antes da API subir
- Sem isso: API tenta conectar em banco ainda inicializando = erro

**3. Volume nomeado:**
- Dados persistem mesmo após `docker compose down`
- Para apagar dados: `docker compose down -v` (⚠️ cuidado!)

---

## 🚀 Hands-On: Executando a Stack

### Passo 1: Subir a Stack

```bash
cd compose/
docker compose up --build -d
```

**O que acontece:**
1. Compose constrói imagem da API (`--build`)
2. Cria rede interna
3. Inicia container do PostgreSQL
4. Aguarda healthcheck passar
5. Inicia container da API
6. Modo detached (`-d`) - containers rodam em background

### Passo 2: Verificar Status

```bash
docker compose ps
```

**Esperado:**
```
NAME              STATUS
filmes-postgres   Up (healthy)
filmes-api        Up
```

Se API mostrar `Restarting`: banco ainda não estava pronto. Aguarde 10s.

### Passo 3: Testar API

```bash
# Healthcheck
curl http://localhost:8000/health

# Listar filmes (banco vazio ainda)
curl http://localhost:8000/filmes

# Criar review
curl -X POST http://localhost:8000/reviews \
  -H "Content-Type: application/json" \
  -d '{
    "filme": "Matrix",
    "nota": 10,
    "comentario": "Revolucionário!"
  }'

# Verificar que foi salvo
curl http://localhost:8000/reviews
```

---

## 🔬 Teste: Persistência de Dados

### Experimento

**1. Criar dado:**
```bash
curl -X POST http://localhost:8000/reviews \
  -H "Content-Type: application/json" \
  -d '{"filme": "Inception", "nota": 9, "comentario": "Mind-bending"}'
```

**2. Derrubar containers:**
```bash
docker compose down
```

**3. Subir novamente:**
```bash
docker compose up -d
```

**4. Verificar dado:**
```bash
curl http://localhost:8000/reviews
```

**Resultado:** Dado ainda existe! Volume persiste.

### Para Apagar Tudo

```bash
docker compose down -v  # -v remove volumes
```

---

## 🤔 Reflexão

### O Que Docker Compose Resolve?

✅ **Orquestração local** - Múltiplos containers trabalhando juntos  
✅ **Ambiente de desenvolvimento** - Reproduzível em qualquer máquina  
✅ **Comunicação simples** - Rede e DNS automáticos  
✅ **Persistência** - Volumes gerenciam dados

### Quando Usar Compose?

✅ Desenvolvimento local  
✅ Testes de integração  
✅ Aplicações simples (1 servidor)  

❌ **Não para:**
- Produção com múltiplos servidores
- Alta disponibilidade
- Auto-scaling

**Para isso, precisamos de Kubernetes.**

---

# PARTE B - Kubernetes (60 min - Demo Professor)

## 🚀 Transição: De Dev para Produção

### O Limite do Compose

Docker Compose orquestra containers em **uma única máquina**.

**E se precisar de:**
- Múltiplos servidores (cluster)
- Alta disponibilidade (se 1 servidor cair, app continua)
- Auto-scaling (aumentar réplicas sob demanda)
- Self-healing (restart automático de containers falhos)

**Resposta:** Kubernetes (K8s)

---

## 💡 Conceito Central

### O Que é Kubernetes?

**Orquestrador de containers em cluster (múltiplas máquinas).**

### Filosofia: Estado Desejado

Você declara:
> "Quero 3 instâncias da API rodando sempre"

Kubernetes garante:
- Se 1 cair → cria nova automaticamente
- Se servidor cair → reagenda containers em outros servidores
- Se aumentar carga → pode escalar automaticamente

**Declarativo, não imperativo.**

---

## 🏗️ Conceitos Fundamentais

### 1. Pod
- Menor unidade do Kubernetes
- Geralmente 1 container por pod
- Tem IP efêmero (muda ao recriar)

### 2. Deployment
- Gerencia réplicas de pods
- Garante estado desejado
- Self-healing automático

### 3. Service
- Endpoint estável para acessar pods
- Load balancing automático
- DNS interno

```
┌─────────────────────────────────────┐
│        Service (IP estável)         │
│     filmes-api-service:8000         │
└────────┬──────────────┬─────────────┘
         │              │
         ↓              ↓
   ┌─────────┐    ┌─────────┐
   │  Pod 1  │    │  Pod 2  │  ← Deployment garante 2 réplicas
   └─────────┘    └─────────┘
```

---

## 🔍 Entendendo os Manifestos

### deployment.yaml (Simplificado)

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: filmes-api

spec:
  replicas: 2  # Kubernetes mantém sempre 2 pods
  
  template:
    spec:
      containers:
      - name: api
        image: filmes-api:local
        
        livenessProbe:    # Se falhar → K8s mata e recria
          httpGet:
            path: /health
            port: 8000
        
        readinessProbe:   # Se falhar → K8s remove do load balancing
          httpGet:
            path: /health
            port: 8000
```

**Conceito:** K8s verifica saúde constantemente.

### service.yaml (Simplificado)

```yaml
apiVersion: v1
kind: Service
metadata:
  name: filmes-api-service

spec:
  type: NodePort
  selector:
    app: filmes-api  # Roteia para pods com esta label
  ports:
  - port: 8000
    nodePort: 30080  # Acesso externo: localhost:30080
```

---

## 🎬 Demo: Self-Healing em Ação

### Setup

```bash
cd ../k8s/

# 1. Buildar imagem (K8s precisa dela localmente)
cd ../api && docker build -t filmes-api:local .

# 2. Aplicar manifestos
cd ../k8s
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml

# 3. Verificar pods
kubectl get pods
```

### Demonstração: Self-Healing

```bash
# Ver pods rodando
kubectl get pods -l app=filmes-api

# Deletar um pod manualmente
kubectl delete pod <nome-do-pod>

# Observar: K8s cria novo imediatamente!
kubectl get pods -l app=filmes-api -w  # -w = watch
```

**Resultado:** Deployment detecta que há apenas 1 pod (estado desejado = 2) e cria novo.

### Demonstração: Load Balancing

```bash
# Acessar várias vezes
curl http://localhost:30080/health

# Ver logs de ambos os pods (tráfego distribuído)
kubectl logs -l app=filmes-api --tail=20
```

### Limpeza

```bash
kubectl delete -f deployment.yaml
kubectl delete -f service.yaml
```

---

## 🤔 Reflexão

### O Que Kubernetes Resolve?

✅ **Orquestração em cluster** - Múltiplos servidores  
✅ **Alta disponibilidade** - Self-healing automático  
✅ **Escalabilidade** - Aumentar/diminuir réplicas facilmente  
✅ **Load balancing** - Distribui tráfego automaticamente

### Quando Usar K8s?

✅ Produção (múltiplos servidores)  
✅ Alta disponibilidade crítica  
✅ Aplicações que precisam escalar  

❌ **Não para:**
- Desenvolvimento local simples (use Compose)
- Aplicações pequenas com 1 servidor
- Onde complexidade não se justifica

**Complexidade tem custo. Use quando necessário.**

---

# PARTE C - Terraform (30 min - Demo Professor)

## 🔗 O Desafio Final

Você tem:
- ✅ Aplicação containerizada (Docker)
- ✅ Orquestração local (Compose)
- ✅ Orquestração produção (Kubernetes)

**Mas falta algo:**

> "Como criar a infraestrutura onde Kubernetes roda?"

Servidores, redes, bancos de dados gerenciados, load balancers...

---

## 💡 Conceito Central

### Infraestrutura como Código (IaC)

**Descrever infraestrutura em arquivos versionáveis.**

```terraform
# Antes (manual, clique-clique na AWS):
# 1. Login no console AWS
# 2. Clicar "Create EC2 Instance"
# 3. Escolher tipo, região, rede...
# 4. Esperar não esquecer nada

# Depois (código, reproduzível):
resource "aws_instance" "web" {
  ami           = "ami-12345"
  instance_type = "t3.micro"
}
```

### Vantagens

✅ **Versionável** - Git rastreia mudanças  
✅ **Reproduzível** - Criar ambiente dev = prod  
✅ **Auditável** - Quem mudou o quê, quando  
✅ **Documentado** - Código É a documentação

---

## 🛠️ Terraform: Workflow Básico

```
┌──────────────────────────────────────────┐
│  terraform init                          │  ← Baixa plugins necessários
│  terraform plan                          │  ← Preview das mudanças
│  terraform apply                         │  ← Aplica mudanças
│  terraform destroy                       │  ← Destrói tudo
└──────────────────────────────────────────┘
```

**Estado (State):** Terraform rastreia o que criou em `terraform.tfstate`

---

## 🎬 Demo: Terraform Local

```bash
cd ../terraform_demo/

# 1. Inicializar
terraform init

# 2. Ver o que será criado (preview)
terraform plan

# 3. Aplicar (criar infraestrutura)
terraform apply

# 4. Verificar arquivo criado
cat infra.txt

# 5. Destruir
terraform destroy
```

### O Que Aconteceu?

1. **init** - Baixou provider `local` (gerencia arquivos locais)
2. **plan** - Mostrou que criaria 1 arquivo
3. **apply** - Criou arquivo `infra.txt`
4. **destroy** - Deletou arquivo

**Em produção:** Mesma lógica, mas criando servidores AWS, bancos Azure, clusters GKE...

---

## 🤔 Reflexão

### O Que Terraform Resolve?

✅ **Automação** - Sem clique manual  
✅ **Consistência** - Ambientes idênticos  
✅ **Rastreabilidade** - Histórico de mudanças  
✅ **Colaboração** - Time usa mesmo código

### Quando Usar?

✅ Gerenciar infraestrutura cloud (AWS, Azure, GCP)  
✅ Criar ambientes reproduzíveis  
✅ Auditar mudanças  

**Mentalidade:** Infraestrutura é código, não clique.

---

# PARTE D - Consolidação (10 min)

## 🎯 A Stack Completa

```
┌─────────────────────────────────────────────┐
│            TERRAFORM                        │  ← Provisiona infraestrutura
│  (Cria servidores, redes, bancos)          │
└──────────────────┬──────────────────────────┘
                   │
                   ↓
┌─────────────────────────────────────────────┐
│            KUBERNETES                       │  ← Orquestra containers
│  (Gerencia pods, deploys, services)        │
└──────────────────┬──────────────────────────┘
                   │
                   ↓
┌─────────────────────────────────────────────┐
│            DOCKER                           │  ← Empacota aplicação
│  (Containers, imagens)                      │
└─────────────────────────────────────────────┘
```

### Analogia Simplificada

- **Docker:** Padroniza como aplicações rodam
- **Compose:** Orquestra containers (dev local)
- **Kubernetes:** Orquestra containers (produção, cluster)
- **Terraform:** Cria a infraestrutura onde tudo roda

---

## 🚀 Próximos Passos

**1. Praticar Compose:**
- Adicionar Redis (cache)
- Adicionar nginx (proxy reverso)
- Múltiplos ambientes (dev, staging)

**2. Explorar K8s:**
- Namespaces (isolar ambientes)
- ConfigMaps e Secrets (configuração)
- Ingress (roteamento HTTP)

**3. Terraform Real:**
- Provisionar VM na AWS
- Criar RDS (banco gerenciado)
- Configurar VPC (rede)

---

## 🔧 Troubleshooting Rápido

### Compose

**API não conecta no banco:**
```bash
# Verificar logs
docker compose logs db
docker compose logs api

# Forçar rebuild
docker compose up --build --force-recreate
```

**Porta já em uso:**
```bash
# Mudar porta no docker-compose.yml
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
# Verificar imagePullPolicy: Never (usa imagem local)
# Garantir que buildar foi executado
```

---

## ✅ Checklist Final

Você aprendeu:

- [ ] Docker Compose orquestra múltiplos containers (1 máquina)
- [ ] Kubernetes orquestra containers (cluster)
- [ ] Estado desejado = Kubernetes garante réplicas
- [ ] Terraform = Infraestrutura como Código
- [ ] Quando usar cada ferramenta

**Mentalidade > Memorização**

---

**Fim do Exercício 2** 🎉
