# Guia de Testes e Validação do Projeto

Este guia ajuda você a **testar se tudo está funcionando** e **resolver problemas comuns** caso algo não esteja rodando corretamente.

## 📦 ANTES DE COMEÇAR: VERIFICAR PRÉ-REQUISITOS

### Software Necessário
Primeiro, verifique se você tem tudo instalado:

```bash
# Testar Docker
docker --version
# Deve mostrar: Docker version 20.x.x ou superior

# Testar Docker Compose
docker compose version
# Deve mostrar: Docker Compose version v2.x.x ou superior

# Verificar se Docker está rodando
docker ps
# Se der erro "Cannot connect to the Docker daemon", abra o Docker Desktop
```

**Se algo falhar:**
- Docker Desktop não instalado → [Baixar aqui](https://www.docker.com/products/docker-desktop)
- Docker não está rodando → Abrir Docker Desktop e aguardar inicializar
- Versão antiga → Atualizar Docker Desktop

### 🔌 Extensões VS Code Recomendadas

Essas extensões facilitam muito o trabalho com Docker e Kubernetes:

1. **Docker** (`ms-azuretools.vscode-docker`)
   - Visualiza containers, imagens, volumes
   - Gerencia Docker Compose
   - Logs integrados

2. **Kubernetes** (`ms-kubernetes-tools.vscode-kubernetes-tools`)
   - Visualiza recursos K8s
   - Aplica manifestos com 1 clique
   - Shell direto nos pods

3. **Rtodas as reviews
curl http://localhost:8000/reviews
```

**Ou usando Thunder Client / REST Client no VS Code:**
- GET `http://localhost:8000/health`
- GET `http://localhost:8000/filmes`
- POST `http://localhost:8000/reviews` com body JSON
- GET `http://localhost:8000/reviews - Substitui curl e Postman

4. **YAML** (`redhat.vscode-yaml`)
   - Validação de YAML
   - AuTESTAR DOCKER COMPOSE

### Subir os Containers

```bash
cd Exercicio_2_Compose_K8s_Terraform_Demo/compose
docker-compose up -d
```

**O que esperar:**
```
[+] Running 2/2
 ✔ Container filmes-postgres  Started
 ✔ Container filmes-api       Started
```

**Se der erro:**
- `port is already allocated` → Algo já está usando a porta 5432 ou 8000
  - Solução: `docker-compose down` em outro projeto ou mude as portas no docker-compose.yml
- `Cannot connect to Docker daemon` → Docker Desktop não está rodando
  - Solução: Abrir Docker Desktop
- `no such file` → Você não está no diretório correto
  - Solução: `cd` para o diretório `compose/`

### Verificar se Está Rodando todas de uma vez:**
```bash
code --install-extension ms-azuretools.vscode-docker
code --install-extension ms-kubernetes-tools.vscode-kubernetes-tools
code --install-extension humao.rest-client
code --install-extension redhat.vscode-yaml
code --install-extension hashicorp.terraform
```

---

## 1️⃣ DOCKER COMPOSE (Método Mais Simples)

### Executar
```bash
cd Exercicio_2_Compose_K8s_Terraform_Demo/compose
docker-compose up -d
```

### Testar
```bash
# Health check
curl http://localhost:8000/health

# Ver filmes
curl http://localhost:8000/filmes

# Criar review
curl -X POST http://localhost:8000/reviews \
  -H "Content-Type: application/json" \
  -d '{"filme_id": 1, "autor": "João", "nota": 5, "comentario": "Excelente!"}'

# Ver reviews do filme 1
curl http://localhost:8000/reviews/1
```

### Parar e Limpar
```bash
docker-compose do

### Opção A: Docker Desktop (Mais Simples)

**Habilitar Kubernetes no Docker Desktop:**
1. Docker Desktop → Settings (⚙️) → Kubernetes
2. Marcar "Enable Kubernetes"
3. Clicar "Apply & Restart"
4. Aguardar (~2-3 minutos) até aparecer "Kubernetes is running"

**Verificar:**
```bash
kubectl version --client
kubectl cluster-info
```

**Se usar Docker Desktop:**
```bash
cd Exercicio_2_Compose_K8s_Terraform_Demo/api
docker build -t filmes-api:latest .
```

**Se usar Minikube:**

### Opção B: Minikube (Alternativa)

**Via linha de comando:**
```bash
cd ../k8s

# Aplicar todos os manifestos na ordem correta
kubectl apply -f namespace.yaml
kubectl apply -f postgres-secret.yaml
kubectl apply -f postgres-pvc.yaml
kubectl apply -f postgres-deployment.yaml
kubectl apply -f postgres-service.yaml
kubectl apply -f api-configmap.yaml
kubectl apply -f api-deployment.yaml
kubectl apply -f api-service.yaml
kubectl apply -f api-hpa.yaml

# Ou aplicar tudo de uma vez (ordem automática)
kubectl apply -f .
```

**Ou via VS Code (com extensão Kubernetes):**
1. Abrir a view "Kubernetes" na sidebar

**Via linha de comando:**
```bash
# Ver todos os recursos
kubectl get all -n filmes-app

# Ver pods
kubectl get pods -n filmes-app

# Ver logs da API
kubectl logs -n filmes-app -l app=api --tail=50

# Ver logs do Postgres
kubectl logs -n filmes-app -l app=postgres --tail=50

# Verificar HPA
kubectl get hpa -n filmes-app
```

**Via VS Code (extensão Kubernetes):**
1. Abrir view "Kubernetes" na sidebar
2. Expandir cluster → Namespaces → filmes-app
3. Ver pods, services, deployments visualmente
4. Right-click em pod → "Get Logs" para ver logs
5. Right-click em pod → "Describe" para detalhes completos

**Via Docker Desktop:**
1. Docker Desktop → Kubernetes
2. Ver todos os recursos graficamenteker build -t filmes-api:latest .
```


**Docker Desktop (LoadBalancer funciona):**
```bash
# Verificar IP externo (pode demorar 1-2 min)
kubectl get service api -n filmes-app

# Testar (use o EXTERNAL-IP que aparecer, ou localhost)
curl http://localhost/health
curl http://localhost/filmes
```

**Minikube (precisa de tunnel ou port-forward):**
```bash
# Opção 1: Obter URL do serviço
minikube service api -n filmes-app --url

# Opção 2: Port-forward
kubectl port-forward -n filmes-app service/api 8080:80
curl http://localhost:8080/health
```

**Via VS Code (extensão Kubernetes):**
1. View Kubernetes → Workloads → Services
2. Right-click no service "api" → "Port Forward"
3. Escolher porta local (ex: 8080)
4. Testar em Thunder Client/REST Clientectl apply -f api-configmap.yaml
kubectl apply -f api-deployment.yaml
kubectl apply -f api-service.yaml
kubectl apply -f api-hpa.yaml
```

### Verificar Status
```bash
# Ver todos os recursos
kubectl get all -n filmes-app

# Ver pods
kubectl get pods -n filmes-app

# Ver logs da API
kubectl logs -n filmes-app -l app=api --tail=50

# Ver logs do Postgres
kubectl logs -n filmes-app -l app=postgres --tail=50

# Verificar HPA
kubectl get hpa -n filmes-app
```

### Testar
```bash
# Obter URL do serviço
minikube service api -n filmes-app --url

# Ou usar port-forward
kubectl port-forward -n filmes-app service/api 8080:80

# Testar
curl http://localhost:8080/health
curl http://localhost:8080/filmes
```

### Verificar Auto-Scaling (HPA)

```bash
kubectl get hpa -n filmes-app
```

**✅ Deve mostrar:**
```
NAME      REFERENCE        TARGETS   MINPODS   MAXPODS
api-hpa   Deployment/api   15%/70%   3         10
```

**Se TARGETS aparecer "<unknown>":**
- MeVerificar se Terraform Está Instalado

```bash
terraform version
```

**✅ Deve mostrar:**
```
Terraform v1.x.x
```

**❌ Se der "command not found":**
- Instalar Terraform: https://developer.hashicorp.com/terraform/install
- Ou via Homebrew (Mac): `brew install terraform`

### Preparar Terraform

```bash
cd Exercicio_2_Compose_K8s_Terraform_Demo/terraform_demo

# Inicializar (baixar providers)
terraform init
```

**✅ Deve mostrar:**
```
Initializing provider plugins...
- Installing hashicorp/kubernetes v2.23.x...
Terraform has been successfully initialized!
```

**❌ Se der erro:**
- Sem internet → Providers não podem ser baixados
- Arquivo .terraform.lock.hcl corrompido → Deletar e rodar init novamente

### Ver o Que Será Criado

```bash
terraform plan
```

**✅ Deve mostrar:**
```
Plan: 9 to add, 0 to change, 0 to destroy.
```

Isso lista os 9 recursos que serão criados (namespace, secret, pvc, deployments, etc).

**❌ Se mostrar erros:**
- Contexto errado do kubectl → `kubectl config current-context`
- Kubernetes não está rodando → Verificar Docker Desktop
- Sintaxe errada no .tf → Corrigir o arquivo

### Aplicar (Criar Recursos)

```bash
terraform apply
# Digite "yes" quando perguntar
```

**✅ Deve mostrar:**
```
Apply complete! Resources: 9 added, 0 changed, 0 destroyed.
```

**❌ Se der erro durante apply:**
- Recursos já existem → `kubectl delete namespace filmes-app` antes
- Permissões insuficientes → Verificar kubeconfig
- Erro em recurso específico → Ver mensagem de erro detalhada

### Verificar se Funcionou

```bash
# Ver recursos criados pelo Terraform
terraform show

# Ver no Kubernetes
kubectl get all -n filmes-app
```

**✅ Deve mostrar os mesmos recursos** que criamos manualmente com kubectl apply

### Testar API

Use os **mesmos testes da seção Kubernetes** acima (curl localhost/health, etc)

### Quando Terminar: Destruir Tudo

```bash
terraform destroy
# Digite "yes" quando perguntar
```

**✅ Deve mostrar:**
```
Destroy complete! Resources: 9 destroyed.
```

### 🐛 Troubleshooting Terraform

**State file corrompido:**
```bash
rm terraform.tfstate*
terraform init
terraform apply
```

**Provider não encontrado:**
```bash
rm .terraform.lock.hcl
terraform init
```

**Diferenças entre apply e destroy:**
```bash
# Ver o que será destruído antes
terrafSETUP INICIAL PARA ALUNOS

Se é sua primeira vez com este projeto:

### 1. Instalar Ferramentas Básicas

```bash
# Verificar se tem Git
git --version

# Verificar se tem Docker
docker --version

# Se não tiver, instalar:
# - Git: https://git-scm.com/downloads
# - Docker Desktop: https://www.docker.com/products/docker-desktop
```

### 2. Clonar o Repositório

```bash
git clone https://github.com/thiagoturini/Aula-Docker.git
cd Aula-Docker
cd "Exercicio_2_Compose_K8s_Terraform_Demo"
```

### 3. Instalar VS Code e Extensões (Opcional mas Recomendado)

**Baixar VS Code:** https://code.visualstudio.com/

**Instalar extensões em batch:**
```bash
code --install-extension ms-azuretools.vscode-docker
code --install-extension ms-kubernetes-tools.vscode-kubernetes-tools
code --install-extension humao.rest-client
code --install-extension redhat.vscode-yaml
code --install-extension hashicorp.terraform
```

### 4. Começar pelos Testes

**Ordem recomendada:**
1. **Docker Compose** primeiro (mais simples)
2. **Kubernetes** depois (mais complexo)
3. **Terraform** por último (automação)

Se Docker Compose funcionar, você já entende 70% do projeto! 🎯
# Ver o que será criado
terraform plan

# Aplicar
terraform apply
```

### Verificar
```bash
# Ver estado
terraform show

# Ver outputs
terraform output

# Ver recursos no Kubernetes
kubectl get all -n filmes-app
```

### Destruir
```bash
terraform destroy
```

---

## 🔍 CHECKLIST DE VALIDAÇÃO

### Docker Compose ✅
- [ ] `docker-compose ps` mostra 2 containers rodando
- [ ] `curl localhost:8000/health` retorna `{"sta

---

## 🎨 DICAS COM EXTENSÕES VS CODE

### Docker Extension
- **View Containers**: Ver containers rodando em tempo real
- **View Images**: Gerenciar imagens Docker
- **Logs**: Click em container → "View Logs"
- **Shell**: Right-click → "Attach Shell"
- **Compose**: Right-click no docker-compose.yml → "Compose Up"

### Kubernetes Extension
- **Visualização Hierárquica**: Cluster → Namespaces → Workloads
- **Apply YAML**: Right-click → "Kubernetes: Apply"
- **Port Forward**: Right-click em service → "Port Forward"
- **Logs em Tempo Real**: Right-click em pod → "Follow Logs"
- **Terminal no Pod**: Right-click → "Terminal"

### Thunder Client / REST Client
- **Coleções**: Salvar requests da API para reusar
- **Environment Variables**: Mudar entre localhost, staging, prod
- **Test Scripts**: Automatizar testes de API
- **History**: Ver todas as requisições passadas

### YAML Extension
- **Schema Validation**: Detecta erros em Kubernetes YAML
- **Autocomplete**: Ctrl+Space para sugestões
- **Hover Documentation**: Passar mouse sobre propriedades para ver docs

---

## 🎓 PARA ALUNOS: COMEÇANDO DO ZERO

### 1. Instalar tudo
```bash
# Instalar Docker Desktop
# https://www.docker.com/products/docker-desktop

# Instalar VS Code
# https://code.visualstudio.com/

# Clonar repositório
git clone <repo-url>
cd Aula\ Docker/
```

### 2. Configurar VS Code
- Instalar as 5 extensões recomendadas acima
- Abrir o workspace no VS Code

### 3. Testar Docker
```bash
docker --version
docker compose version
```

### 4. Habilitar Kubernetes no Docker Desktop
- Settings → Kubernetes → Enable

### 5. Começar pelo Docker Compose
É o mais simples - se funcionar, você está pronto!tus":"healthy"}`
- [ ] `curl localhost:8000/filmes` retorna lista de filmes
- [ ] Consegue criar e listar reviews

### Kubernetes ✅
- [ ] `kubectl get pods -n filmes-app` mostra todos RUNNING
- [ ] API tem 3 réplicas rodando
- [ ] Postgres tem 1 réplica rodando
- [ ] Service API é do tipo LoadBalancer
- [ ] HPA está configurado (min 3, max 10)
- [ ] Consegue acessar API via minikube service ou port-forward
- [ ] Health check responde
- [ ] Consegue criar e listar reviews

### Terraform ✅
- [ ] `terraform plan` não mostra erros
- [ ] `terraform apply` cria recursos no Kubernetes
- [ ] Recursos aparecem com `kubectl get all -n filmes-app`
- [ ] API funciona corretamente

---

## 🐛 TROUBLESHOOTING

### Docker Compose
```bash
# Ver logs
docker-compose logs -f

# Recriar containers
docker-compose up -d --force-recreate
```

### Kubernetes
```bash
# Descrever pod com problema
kubectl describe pod <pod-name> -n filmes-app

# Ver eventos
kubectl get events -n filmes-app --sort-by='.lastTimestamp'

# Shell no pod
kubectl exec -it <pod-name> -n filmes-app -- sh
```

### Imagem não encontrada no Kubernetes
```bash
# Garantir que está usando Docker do Minikube
eval $(minikube docker-env)

# Rebuild
docker build -t filmes-api:latest ../api/

# Verificar imagens
docker images | grep filmes-api
```

---

## 📝 ORDEM RECOMENDADA PARA DEMONSTRAÇÃO

1. **Docker Compose** - Mostrar conceito básico de orquestração
2. **Kubernetes** - Mostrar produção com réplicas, health checks, scaling
3. **Terraform** - Mostrar Infrastructure as Code
