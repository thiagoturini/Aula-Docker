# ☸️ Guia Completo: Kubernetes para Iniciantes

## 📚 O que é Kubernetes?

Kubernetes (K8s) é uma **plataforma de orquestração de containers** que automatiza o deployment, scaling e gerenciamento de aplicações containerizadas.

**Quando usar:**
- ✅ Múltiplos hosts/servidores (cluster)
- ✅ Alta disponibilidade
- ✅ Auto-scaling
- ✅ Self-healing (recuperação automática)
- ✅ Produção com tráfego alto
- ✅ Rollouts e rollbacks automatizados

**Quando NÃO usar:**
- ❌ Desenvolvimento local simples → Use Docker Compose
- ❌ Aplicação single-host → Use Docker
- ❌ Protótipos rápidos → Use Docker Compose

---

## 🎯 Conceitos Fundamentais

### **Pod** 🐋
- Menor unidade do Kubernetes
- Agrupa 1 ou mais containers
- Compartilham rede e armazenamento
- Efêmero (pode ser destruído/recriado a qualquer momento)

```yaml
# Pod individual (não recomendado para produção)
apiVersion: v1
kind: Pod
metadata:
  name: meu-pod
spec:
  containers:
  - name: app
    image: nginx
    ports:
    - containerPort: 80
```

### **Deployment** 🚀
- Gerencia ReplicaSets
- Define **estado desejado** (quantas réplicas)
- Self-healing (recria pods que falham)
- Rollout e rollback automatizados
- **Use sempre Deployments, não Pods individuais!**

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: meu-app
spec:
  replicas: 3                    # 3 pods idênticos
  selector:
    matchLabels:
      app: meu-app
  template:                      # Template do Pod
    metadata:
      labels:
        app: meu-app
    spec:
      containers:
      - name: app
        image: nginx:latest
        ports:
        - containerPort: 80
```

### **Service** 🌐
- Expõe pods na rede
- Load balancer entre pods
- IP estável (pods têm IPs efêmeros)
- Tipos: ClusterIP, NodePort, LoadBalancer

```yaml
apiVersion: v1
kind: Service
metadata:
  name: meu-app-service
spec:
  type: NodePort                 # Acessível fora do cluster
  selector:
    app: meu-app                 # Seleciona pods com essa label
  ports:
  - port: 80                     # Porta do Service
    targetPort: 80               # Porta do container
    nodePort: 30080              # Porta externa (30000-32767)
```

### **Namespace** 📁
- Isolamento lógico de recursos
- Útil para ambientes (dev, staging, prod)
- Default: `default`

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: producao
```

---

## 🏗️ Arquitetura Básica

```
┌─────────────────────────────────────────┐
│           Kubernetes Cluster            │
│                                         │
│  ┌────────────────────────────────┐   │
│  │      Control Plane (Master)     │   │
│  │  - API Server                   │   │
│  │  - Scheduler                    │   │
│  │  - Controller Manager           │   │
│  │  - etcd (banco de dados)        │   │
│  └────────────────────────────────┘   │
│                                         │
│  ┌──────────────┐  ┌──────────────┐   │
│  │   Node 1     │  │   Node 2     │   │
│  │              │  │              │   │
│  │  ┌────┐ ┌────┐│  │  ┌────┐ ┌────┐│ │
│  │  │Pod │ │Pod ││  │  │Pod │ │Pod ││ │
│  │  └────┘ └────┘│  │  └────┘ └────┘│ │
│  │              │  │              │   │
│  │  Kubelet     │  │  Kubelet     │   │
│  └──────────────┘  └──────────────┘   │
└─────────────────────────────────────────┘
```

---

## 🔧 Passo a Passo: Criando Recursos

### **1️⃣ Deployment Simples - Nginx**

```yaml
# nginx-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx

spec:
  replicas: 2                    # 2 pods
  
  selector:
    matchLabels:
      app: nginx                 # Seleciona pods com label app=nginx
  
  template:                      # Template do Pod
    metadata:
      labels:
        app: nginx               # Label do pod
    
    spec:
      containers:
      - name: nginx
        image: nginx:latest
        ports:
        - containerPort: 80
```

**Aplicar:**
```bash
kubectl apply -f nginx-deployment.yaml
kubectl get deployments
kubectl get pods
```

---

### **2️⃣ Service - Expor o Nginx**

```yaml
# nginx-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
  labels:
    app: nginx

spec:
  type: NodePort                 # Acessível externamente
  
  selector:
    app: nginx                   # Roteia tráfego para pods com essa label
  
  ports:
  - protocol: TCP
    port: 80                     # Porta do Service (interna)
    targetPort: 80               # Porta do container
    nodePort: 30080              # Porta externa (localhost:30080)
```

**Aplicar:**
```bash
kubectl apply -f nginx-service.yaml
kubectl get services

# Acessar
curl http://localhost:30080
```

---

### **3️⃣ API com Variáveis de Ambiente**

```yaml
# api-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-deployment
  labels:
    app: api

spec:
  replicas: 3
  
  selector:
    matchLabels:
      app: api
  
  template:
    metadata:
      labels:
        app: api
    
    spec:
      containers:
      - name: api
        image: minha-api:latest
        imagePullPolicy: Never      # Para imagens locais
        
        ports:
        - containerPort: 8000
        
        # Variáveis de ambiente
        env:
        - name: ENV
          value: "production"
        - name: DATABASE_URL
          value: "postgresql://user:pass@postgres:5432/db"
        - name: LOG_LEVEL
          value: "info"
        
        # Limites de recursos
        resources:
          requests:
            memory: "128Mi"
            cpu: "100m"
          limits:
            memory: "256Mi"
            cpu: "500m"
```

---

### **4️⃣ Health Checks - Liveness e Readiness Probes**

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-deployment
  labels:
    app: api

spec:
  replicas: 2
  
  selector:
    matchLabels:
      app: api
  
  template:
    metadata:
      labels:
        app: api
    
    spec:
      containers:
      - name: api
        image: minha-api:latest
        
        ports:
        - containerPort: 8000
        
        # Verifica se app está viva (reinicia se falhar)
        livenessProbe:
          httpGet:
            path: /health
            port: 8000
          initialDelaySeconds: 10    # Aguarda 10s antes de começar
          periodSeconds: 10          # Testa a cada 10s
          timeoutSeconds: 5
          failureThreshold: 3        # Reinicia após 3 falhas
        
        # Verifica se app está pronta para receber tráfego
        readinessProbe:
          httpGet:
            path: /health
            port: 8000
          initialDelaySeconds: 5
          periodSeconds: 5
          timeoutSeconds: 3
          failureThreshold: 3
```

**Diferenças:**
- **livenessProbe**: Reinicia o container se falhar
- **readinessProbe**: Remove do load balancer se falhar (não reinicia)

---

### **5️⃣ ConfigMap - Configurações Externalizadas**

```yaml
# configmap.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
data:
  APP_NAME: "Minha API"
  LOG_LEVEL: "debug"
  DATABASE_HOST: "postgres"
  DATABASE_PORT: "5432"
  config.json: |
    {
      "feature_flags": {
        "new_ui": true,
        "beta": false
      }
    }
```

**Usar no Deployment:**
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-deployment
spec:
  template:
    spec:
      containers:
      - name: api
        image: minha-api:latest
        
        # Opção 1: Todas as variáveis do ConfigMap
        envFrom:
        - configMapRef:
            name: app-config
        
        # Opção 2: Variáveis específicas
        env:
        - name: APP_NAME
          valueFrom:
            configMapKeyRef:
              name: app-config
              key: APP_NAME
        
        # Opção 3: Arquivo montado
        volumeMounts:
        - name: config
          mountPath: /app/config.json
          subPath: config.json
      
      volumes:
      - name: config
        configMap:
          name: app-config
```

---

### **6️⃣ Secrets - Dados Sensíveis**

```yaml
# secret.yaml
apiVersion: v1
kind: Secret
metadata:
  name: db-secret
type: Opaque
data:
  # Valores em base64
  username: cG9zdGdyZXM=          # postgres
  password: c2VuaGExMjM=          # senha123
```

**Criar secret via CLI:**
```bash
kubectl create secret generic db-secret \
  --from-literal=username=postgres \
  --from-literal=password=senha123
```

**Usar no Deployment:**
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-deployment
spec:
  template:
    spec:
      containers:
      - name: api
        image: minha-api:latest
        
        env:
        - name: DB_USERNAME
          valueFrom:
            secretKeyRef:
              name: db-secret
              key: username
        
        - name: DB_PASSWORD
          valueFrom:
            secretKeyRef:
              name: db-secret
              key: password
```

---

### **7️⃣ Volumes - Persistência de Dados**

```yaml
# postgres-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: postgres
spec:
  replicas: 1
  selector:
    matchLabels:
      app: postgres
  
  template:
    metadata:
      labels:
        app: postgres
    
    spec:
      containers:
      - name: postgres
        image: postgres:15-alpine
        
        env:
        - name: POSTGRES_PASSWORD
          value: postgres
        
        ports:
        - containerPort: 5432
        
        # Volume montado
        volumeMounts:
        - name: postgres-storage
          mountPath: /var/lib/postgresql/data
      
      # Volume (local - não recomendado para produção)
      volumes:
      - name: postgres-storage
        emptyDir: {}               # Temporário (perde dados se pod morre)

---
# PersistentVolume para produção
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: postgres-pvc
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 5Gi

---
# Usar o PVC no Deployment
apiVersion: apps/v1
kind: Deployment
metadata:
  name: postgres
spec:
  template:
    spec:
      containers:
      - name: postgres
        volumeMounts:
        - name: postgres-storage
          mountPath: /var/lib/postgresql/data
      
      volumes:
      - name: postgres-storage
        persistentVolumeClaim:
          claimName: postgres-pvc
```

---

## 🎮 Comandos Essenciais

### **Básicos**
```bash
# Ver recursos
kubectl get pods
kubectl get deployments
kubectl get services
kubectl get all                          # Tudo

# Detalhes de um recurso
kubectl describe pod <nome>
kubectl describe deployment <nome>

# Logs
kubectl logs <pod-name>
kubectl logs <pod-name> -f               # Follow (tail -f)
kubectl logs deployment/<nome>           # Logs de um deployment

# Executar comandos
kubectl exec -it <pod-name> -- bash      # Shell dentro do pod
kubectl exec <pod-name> -- ls /app       # Comando one-off

# Porta forward (testar sem service)
kubectl port-forward pod/<nome> 8080:80
kubectl port-forward deployment/<nome> 8080:80
```

### **Aplicar Manifestos**
```bash
# Aplicar arquivo
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml

# Aplicar pasta inteira
kubectl apply -f k8s/

# Ver o que seria aplicado (dry-run)
kubectl apply -f deployment.yaml --dry-run=client

# Deletar recurso
kubectl delete -f deployment.yaml
kubectl delete deployment <nome>
kubectl delete pod <nome>
```

### **Escalar**
```bash
# Escalar deployment
kubectl scale deployment <nome> --replicas=5

# Ver replicas
kubectl get deployment <nome>
```

### **Editar**
```bash
# Editar recurso (abre editor)
kubectl edit deployment <nome>

# Ver YAML atual
kubectl get deployment <nome> -o yaml
```

### **Rollout (Deploy)**
```bash
# Ver histórico
kubectl rollout history deployment/<nome>

# Ver status
kubectl rollout status deployment/<nome>

# Fazer rollback
kubectl rollout undo deployment/<nome>
kubectl rollout undo deployment/<nome> --to-revision=2

# Reiniciar deployment (recria pods)
kubectl rollout restart deployment/<nome>
```

### **Namespaces**
```bash
# Listar namespaces
kubectl get namespaces

# Criar namespace
kubectl create namespace producao

# Aplicar em namespace específico
kubectl apply -f deployment.yaml -n producao

# Ver recursos de um namespace
kubectl get pods -n producao

# Ver recursos de todos namespaces
kubectl get pods --all-namespaces
kubectl get pods -A                      # Atalho
```

### **Debug**
```bash
# Ver eventos
kubectl get events
kubectl get events --sort-by='.lastTimestamp'

# Ver recursos com mais detalhes
kubectl get pods -o wide

# Ver labels
kubectl get pods --show-labels

# Filtrar por label
kubectl get pods -l app=nginx

# Top (uso de recursos)
kubectl top nodes
kubectl top pods
```

### **Context (Cluster)**
```bash
# Ver contexto atual
kubectl config current-context

# Listar contextos
kubectl config get-contexts

# Trocar contexto
kubectl config use-context docker-desktop
kubectl config use-context minikube
```

---

## 📋 Tipos de Services

### **1. ClusterIP (padrão)**
- Acesso **apenas interno** (dentro do cluster)
- Outros pods podem acessar
- Não acessível externamente

```yaml
apiVersion: v1
kind: Service
metadata:
  name: backend-service
spec:
  type: ClusterIP                # Padrão (pode omitir)
  selector:
    app: backend
  ports:
  - port: 8080
    targetPort: 8080
```

### **2. NodePort**
- Acessível **externamente** via porta do node
- Porta: 30000-32767
- Útil para desenvolvimento local

```yaml
apiVersion: v1
kind: Service
metadata:
  name: frontend-service
spec:
  type: NodePort
  selector:
    app: frontend
  ports:
  - port: 80
    targetPort: 80
    nodePort: 30080              # Acessa via localhost:30080
```

### **3. LoadBalancer**
- Cria load balancer externo (cloud)
- AWS ELB, Google Cloud LB, Azure LB
- Apenas em ambientes cloud

```yaml
apiVersion: v1
kind: Service
metadata:
  name: web-service
spec:
  type: LoadBalancer
  selector:
    app: web
  ports:
  - port: 80
    targetPort: 80
```

---

## 🔥 Exemplo Completo: API + PostgreSQL

### **Estrutura:**
```
k8s/
├── namespace.yaml
├── postgres-secret.yaml
├── postgres-deployment.yaml
├── postgres-service.yaml
├── api-configmap.yaml
├── api-deployment.yaml
└── api-service.yaml
```

### **1. Namespace**
```yaml
# namespace.yaml
apiVersion: v1
kind: Namespace
metadata:
  name: minha-app
```

### **2. Secret do PostgreSQL**
```yaml
# postgres-secret.yaml
apiVersion: v1
kind: Secret
metadata:
  name: postgres-secret
  namespace: minha-app
type: Opaque
stringData:
  POSTGRES_USER: postgres
  POSTGRES_PASSWORD: senha123
  POSTGRES_DB: meudb
```

### **3. Deployment PostgreSQL**
```yaml
# postgres-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: postgres
  namespace: minha-app
  labels:
    app: postgres
spec:
  replicas: 1
  selector:
    matchLabels:
      app: postgres
  
  template:
    metadata:
      labels:
        app: postgres
    
    spec:
      containers:
      - name: postgres
        image: postgres:15-alpine
        
        envFrom:
        - secretRef:
            name: postgres-secret
        
        ports:
        - containerPort: 5432
        
        volumeMounts:
        - name: postgres-data
          mountPath: /var/lib/postgresql/data
      
      volumes:
      - name: postgres-data
        emptyDir: {}
```

### **4. Service PostgreSQL**
```yaml
# postgres-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: postgres
  namespace: minha-app
spec:
  type: ClusterIP                # Apenas interno
  selector:
    app: postgres
  ports:
  - port: 5432
    targetPort: 5432
```

### **5. ConfigMap da API**
```yaml
# api-configmap.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: api-config
  namespace: minha-app
data:
  ENV: "production"
  LOG_LEVEL: "info"
  DATABASE_HOST: "postgres"     # Nome do service
  DATABASE_PORT: "5432"
```

### **6. Deployment da API**
```yaml
# api-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api
  namespace: minha-app
  labels:
    app: api
spec:
  replicas: 3
  
  selector:
    matchLabels:
      app: api
  
  template:
    metadata:
      labels:
        app: api
    
    spec:
      containers:
      - name: api
        image: minha-api:latest
        imagePullPolicy: Never
        
        ports:
        - containerPort: 8000
        
        envFrom:
        - configMapRef:
            name: api-config
        
        env:
        - name: DATABASE_URL
          value: "postgresql://$(POSTGRES_USER):$(POSTGRES_PASSWORD)@$(DATABASE_HOST):$(DATABASE_PORT)/$(POSTGRES_DB)"
        - name: POSTGRES_USER
          valueFrom:
            secretKeyRef:
              name: postgres-secret
              key: POSTGRES_USER
        - name: POSTGRES_PASSWORD
          valueFrom:
            secretKeyRef:
              name: postgres-secret
              key: POSTGRES_PASSWORD
        - name: POSTGRES_DB
          valueFrom:
            secretKeyRef:
              name: postgres-secret
              key: POSTGRES_DB
        
        livenessProbe:
          httpGet:
            path: /health
            port: 8000
          initialDelaySeconds: 10
          periodSeconds: 10
        
        readinessProbe:
          httpGet:
            path: /health
            port: 8000
          initialDelaySeconds: 5
          periodSeconds: 5
        
        resources:
          requests:
            memory: "128Mi"
            cpu: "100m"
          limits:
            memory: "256Mi"
            cpu: "500m"
```

### **7. Service da API**
```yaml
# api-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: api-service
  namespace: minha-app
  labels:
    app: api
spec:
  type: NodePort
  selector:
    app: api
  ports:
  - protocol: TCP
    port: 8000
    targetPort: 8000
    nodePort: 30080
```

### **Aplicar tudo:**
```bash
# Ordem recomendada
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/postgres-secret.yaml
kubectl apply -f k8s/postgres-deployment.yaml
kubectl apply -f k8s/postgres-service.yaml
kubectl apply -f k8s/api-configmap.yaml
kubectl apply -f k8s/api-deployment.yaml
kubectl apply -f k8s/api-service.yaml

# Ou tudo de uma vez
kubectl apply -f k8s/

# Ver status
kubectl get all -n minha-app

# Testar
curl http://localhost:30080/health
```

---

## 🎯 Boas Práticas

### ✅ **Fazer:**

1. **Use Deployments, não Pods**
```yaml
# ✅ Correto
kind: Deployment
spec:
  replicas: 3
```

2. **Defina Resource Limits**
```yaml
resources:
  requests:
    memory: "128Mi"
    cpu: "100m"
  limits:
    memory: "256Mi"
    cpu: "500m"
```

3. **Use Health Checks**
```yaml
livenessProbe:
  httpGet:
    path: /health
    port: 8000
readinessProbe:
  httpGet:
    path: /health
    port: 8000
```

4. **Use Labels e Selectors**
```yaml
metadata:
  labels:
    app: api
    version: v1.0
    env: production
```

5. **Externalize Configurações**
```yaml
# ConfigMap para configs
# Secrets para senhas
envFrom:
- configMapRef:
    name: app-config
- secretRef:
    name: app-secrets
```

6. **Use Namespaces**
```bash
kubectl create namespace dev
kubectl create namespace staging
kubectl create namespace prod
```

### ❌ **Evitar:**

```yaml
# ❌ Pods individuais
kind: Pod

# ❌ latest tag
image: nginx:latest
# ✅ Use versões específicas
image: nginx:1.25.3

# ❌ Senhas hardcoded
env:
- name: PASSWORD
  value: "senha123"
# ✅ Use Secrets

# ❌ Sem resource limits
# Pode consumir todos os recursos do node

# ❌ Sem health checks
# Kubernetes não sabe se app está saudável
```

---

## 🆚 Docker Compose vs Kubernetes

| Aspecto | Docker Compose | Kubernetes |
|---------|----------------|------------|
| **Complexidade** | Simples | Complexo |
| **Escopo** | Single host | Multi-host (cluster) |
| **Escalabilidade** | Manual | Automática |
| **Self-healing** | Não | Sim |
| **Load balancing** | Básico | Avançado |
| **Rolling updates** | Não | Sim |
| **Health checks** | Sim | Sim (mais robusto) |
| **Uso** | Dev/teste local | Produção |
| **Configuração** | YAML simples | Múltiplos YAMLs |

---

## 🎓 Checklist: Deploy no Kubernetes

```markdown
✅ 1. Criar imagem Docker
✅ 2. Criar Deployment YAML
   ✅ Definir replicas
   ✅ Configurar image
   ✅ Adicionar env vars
   ✅ Configurar resources
   ✅ Adicionar probes
✅ 3. Criar Service YAML
   ✅ Escolher tipo (ClusterIP/NodePort/LoadBalancer)
   ✅ Configurar portas
   ✅ Definir selector
✅ 4. (Opcional) Criar ConfigMap
✅ 5. (Opcional) Criar Secrets
✅ 6. Aplicar recursos
   ✅ kubectl apply -f k8s/
✅ 7. Verificar status
   ✅ kubectl get all
   ✅ kubectl get pods
   ✅ kubectl logs deployment/<nome>
✅ 8. Testar aplicação
✅ 9. Monitorar
   ✅ kubectl top pods
   ✅ kubectl get events
```

---

## 🚀 Próximos Passos

### **Ferramentas Locais:**
- **Minikube**: Cluster local completo
- **Docker Desktop**: Kubernetes integrado
- **Kind**: Kubernetes in Docker

### **Conceitos Avançados:**
- **Ingress**: Roteamento HTTP avançado
- **StatefulSets**: Apps stateful (bancos de dados)
- **DaemonSets**: 1 pod por node (monitoramento)
- **Jobs/CronJobs**: Tarefas batch
- **Helm**: Gerenciador de pacotes K8s
- **Kustomize**: Customização de manifestos
- **Operators**: Automação customizada

### **Produção:**
- **Managed Kubernetes**: EKS (AWS), GKE (Google), AKS (Azure)
- **Monitoring**: Prometheus + Grafana
- **Logging**: ELK Stack, Loki
- **Service Mesh**: Istio, Linkerd
- **CI/CD**: ArgoCD, Flux

---

## 📚 Recursos

- **Documentação oficial**: https://kubernetes.io/docs/
- **Tutorials interativos**: https://kubernetes.io/docs/tutorials/
- **Playground online**: https://labs.play-with-k8s.com/
- **Kubectl Cheat Sheet**: https://kubernetes.io/docs/reference/kubectl/cheatsheet/

---

**🎯 Resumo:**
- Docker Compose = Dev local, simples
- Kubernetes = Produção, escalável, resiliente
- Use Deployments + Services sempre
- Health checks são essenciais
- ConfigMaps/Secrets para configs
- Labels para organização
