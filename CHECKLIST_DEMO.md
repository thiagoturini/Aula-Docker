# ✅ CHECKLIST DEMO - Docker Compose, Kubernetes e Terraform

## 🔍 VERIFICAÇÃO INICIAL (já executado)

```bash
# Verificar ferramentas instaladas
docker --version           # ✅ Docker 29.2.0
docker compose version     # ✅ Docker Compose v5.0.2
kubectl version --client   # ✅ kubectl v1.34.1
terraform version          # ✅ Terraform v1.5.7
```

---

## 🚨 HABILITAR KUBERNETES NO DOCKER DESKTOP (se necessário)

⚠️ **Status atual:** Kubernetes DESABILITADO

### Passos para habilitar:

1. **Abrir Docker Desktop**
2. Clicar no ícone de **Settings** (⚙️) no canto superior direito
3. Ir em **Kubernetes** no menu lateral
4. Marcar **"Enable Kubernetes"**
5. Clicar em **"Apply & Restart"**
6. Aguardar ~2-3 minutos (ícone ficará verde quando pronto)

### Verificar se funcionou:
```bash
kubectl get nodes
# Deve retornar: docker-desktop   Ready   control-plane   Xm   vX.XX.X
```

---

## 🎯 COMANDOS PARA DEMO EM SALA

### 📦 DEMO 1: Docker Compose (API + PostgreSQL)

```bash
# Navegar para a pasta do exercício
cd "/Users/thiago.pinto/Documents/EDIT/DataOps2026/Case/Aula Docker/Exercicio_2_Compose_K8s_Terraform_Demo/compose"

# Construir e subir containers
docker compose up --build -d

# Testar endpoints
curl http://localhost:8000/health
curl http://localhost:8000/filmes
curl http://localhost:8000/

# Criar review (testar persistência)
curl -X POST http://localhost:8000/reviews \
  -H "Content-Type: application/json" \
  -d '{"filme_id": 1, "autor": "João Silva", "nota": 5, "comentario": "Filme incrível!"}'

# Listar reviews
curl http://localhost:8000/reviews

# DEMONSTRAR PERSISTÊNCIA: derrubar e subir novamente
docker compose down
docker compose up -d

# Reviews devem continuar lá!
curl http://localhost:8000/reviews

# Ver logs da API
docker compose logs -f api

# Parar tudo
docker compose down
```

---

### ☸️ DEMO 2: Kubernetes (Self-Healing e Replicas)

⚠️ **Requer Kubernetes habilitado no Docker Desktop**

```bash
# Navegar para a pasta k8s
cd "/Users/thiago.pinto/Documents/EDIT/DataOps2026/Case/Aula Docker/Exercicio_2_Compose_K8s_Terraform_Demo/k8s"

# Aplicar deployment (2 replicas)
kubectl apply -f deployment.yaml

# Aplicar service (NodePort)
kubectl apply -f service.yaml

# Ver pods criados
kubectl get pods

# Ver services
kubectl get svc

# DEMONSTRAR SELF-HEALING: deletar um pod
kubectl delete pod <nome-do-pod>

# Kubernetes recria automaticamente!
kubectl get pods
# (um pod novo aparece com status "ContainerCreating" → "Running")

# Acessar API (NodePort ~30000-32767)
kubectl get svc filmes-api-service
# Anotar a porta (ex: 30080)
# curl http://localhost:30080/health

# Escalar para 3 replicas
kubectl scale deployment filmes-api --replicas=3
kubectl get pods

# Limpar tudo
kubectl delete -f deployment.yaml
kubectl delete -f service.yaml
```

---

### 🏗️ DEMO 3: Terraform (Infraestrutura como Código - Local)

```bash
# Navegar para a pasta terraform_demo
cd "/Users/thiago.pinto/Documents/EDIT/DataOps2026/Case/Aula Docker/Exercicio_2_Compose_K8s_Terraform_Demo/terraform_demo"

# Inicializar Terraform
terraform init

# Ver plano de execução
terraform plan

# Aplicar (criar arquivo infra.txt)
terraform apply -auto-approve

# Verificar que arquivo foi criado
cat infra.txt
ls -lh infra.txt

# DESTRUIR infraestrutura
terraform destroy -auto-approve

# Verificar que arquivo foi removido
ls infra.txt
# (deve dar erro: arquivo não existe)
```

---

## 📊 RESUMO DAS DEMOS

| Demo | Conceito | Comando Principal | Tempo |
|------|----------|------------------|-------|
| **Compose** | Orquestração multi-container | `docker compose up` | 5 min |
| **Kubernetes** | Self-healing e escalabilidade | `kubectl apply -f` | 7 min |
| **Terraform** | Infrastructure as Code | `terraform apply` | 3 min |

---

## 🆘 TROUBLESHOOTING

### Docker Compose não sobe:
```bash
# Ver logs detalhados
docker compose logs

# Rebuild forçado
docker compose build --no-cache
docker compose up
```

### Kubernetes não aceita comandos:
```bash
# Verificar contexto
kubectl config current-context
# Deve ser: docker-desktop

# Resetar configuração
kubectl config use-context docker-desktop
```

### Terraform dá erro:
```bash
# Limpar estado e reiniciar
rm -rf .terraform .terraform.lock.hcl terraform.tfstate*
terraform init
```

---

## ✅ CHECKLIST PRÉ-DEMO

- [ ] Docker Desktop rodando
- [ ] Kubernetes habilitado (ícone verde no Docker Desktop)
- [ ] Terminal aberto na pasta correta
- [ ] Portas 8000 e 5432 livres
- [ ] Comandos copiados e prontos

**Boa demo! 🚀**
