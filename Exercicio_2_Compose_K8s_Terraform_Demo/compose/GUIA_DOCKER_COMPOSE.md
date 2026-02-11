# 🐳 Guia Completo: Como Criar um Docker Compose

## 📚 O que é Docker Compose?

Docker Compose é uma ferramenta para **orquestrar múltiplos containers** de forma declarativa usando um arquivo YAML.

**Quando usar:**
- ✅ Múltiplos serviços (API + Banco + Redis + etc)
- ✅ Desenvolvimento local
- ✅ Testes integrados
- ✅ Ambiente reproduzível

---

## 🎯 Estrutura Básica

```yaml
version: '3.8'              # Versão do Docker Compose

services:                   # Lista de containers (serviços)
  nome-do-servico:
    # configurações...
  
  outro-servico:
    # configurações...

volumes:                    # Volumes compartilhados (opcional)
  nome-do-volume:

networks:                   # Redes customizadas (opcional)
  nome-da-rede:
```

---

## 🔧 Passo a Passo: Criando do Zero

### **1️⃣ Serviço Simples - API Python**

```yaml
version: '3.8'

services:
  api:
    # Opção 1: Usar imagem pronta do Docker Hub
    image: python:3.11-slim
    
    # Comando para executar
    command: python -m http.server 8000
    
    # Porta: host:container
    ports:
      - "8000:8000"
```

**Comandos:**
```bash
# Criar arquivo
touch docker-compose.yml

# Subir
docker-compose up

# Parar
docker-compose down
```

---

### **2️⃣ Serviço com Build - API Customizada**

```yaml
version: '3.8'

services:
  api:
    # Opção 2: Construir a partir de um Dockerfile
    build:
      context: ./api              # Pasta com Dockerfile
      dockerfile: Dockerfile      # Nome do arquivo (padrão)
    
    # Nome do container (opcional, mas recomendado)
    container_name: minha-api
    
    # Porta exposta
    ports:
      - "8000:8000"
    
    # Variáveis de ambiente
    environment:
      ENV: production
      DEBUG: false
```

**Estrutura de pastas:**
```
projeto/
├── docker-compose.yml
└── api/
    ├── Dockerfile
    ├── app.py
    └── requirements.txt
```

---

### **3️⃣ Múltiplos Serviços - API + Banco de Dados**

```yaml
version: '3.8'

services:
  # ===== BANCO DE DADOS =====
  db:
    image: postgres:15-alpine
    container_name: postgres-db
    
    # Variáveis de ambiente
    environment:
      POSTGRES_USER: usuario
      POSTGRES_PASSWORD: senha123
      POSTGRES_DB: meubancodedados
    
    # Volume para persistir dados
    volumes:
      - db_data:/var/lib/postgresql/data
    
    # Porta (opcional, só se precisar acessar externamente)
    ports:
      - "5432:5432"
    
    # Reiniciar automaticamente
    restart: unless-stopped

  # ===== API =====
  api:
    build: ./api
    container_name: minha-api
    
    # Variáveis de ambiente
    environment:
      # IMPORTANTE: usar hostname 'db' (nome do serviço)
      DATABASE_URL: postgresql://usuario:senha123@db:5432/meubancodedados
    
    ports:
      - "8000:8000"
    
    # Dependências: API só sobe depois do banco
    depends_on:
      - db
    
    restart: unless-stopped

# Volumes nomeados (dados persistem após 'down')
volumes:
  db_data:
```

**Como funciona a comunicação:**
- Containers se comunicam pelos **nomes dos serviços**
- `db` é o hostname do PostgreSQL
- Compose cria uma rede interna automaticamente

---

### **4️⃣ Com Health Check - Garantir que Banco Está Pronto**

```yaml
version: '3.8'

services:
  db:
    image: postgres:15-alpine
    container_name: postgres-db
    environment:
      POSTGRES_USER: usuario
      POSTGRES_PASSWORD: senha123
      POSTGRES_DB: meubancodedados
    volumes:
      - db_data:/var/lib/postgresql/data
    
    # Health check - verifica se banco aceitando conexões
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U usuario"]
      interval: 5s      # Testa a cada 5 segundos
      timeout: 5s       # Timeout de 5 segundos
      retries: 5        # Tenta 5 vezes

  api:
    build: ./api
    container_name: minha-api
    environment:
      DATABASE_URL: postgresql://usuario:senha123@db:5432/meubancodedados
    ports:
      - "8000:8000"
    
    # Aguarda banco passar no healthcheck
    depends_on:
      db:
        condition: service_healthy
    
    restart: unless-stopped

volumes:
  db_data:
```

---

### **5️⃣ Exemplo Completo - Sistema com Redis**

```yaml
version: '3.8'

services:
  # ===== BANCO DE DADOS =====
  db:
    image: postgres:15-alpine
    container_name: postgres-db
    environment:
      POSTGRES_USER: usuario
      POSTGRES_PASSWORD: senha123
      POSTGRES_DB: meubancodedados
    volumes:
      - db_data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U usuario"]
      interval: 5s
      timeout: 5s
      retries: 5
    restart: unless-stopped
    # Rede customizada
    networks:
      - backend

  # ===== CACHE REDIS =====
  redis:
    image: redis:7-alpine
    container_name: redis-cache
    ports:
      - "6379:6379"
    restart: unless-stopped
    networks:
      - backend

  # ===== API =====
  api:
    build: ./api
    container_name: minha-api
    environment:
      DATABASE_URL: postgresql://usuario:senha123@db:5432/meubancodedados
      REDIS_URL: redis://redis:6379
    ports:
      - "8000:8000"
    depends_on:
      db:
        condition: service_healthy
      redis:
        condition: service_started
    restart: unless-stopped
    networks:
      - backend
    # Volume para desenvolvimento (hot reload)
    volumes:
      - ./api:/app

  # ===== NGINX (Proxy Reverso) =====
  nginx:
    image: nginx:alpine
    container_name: nginx-proxy
    ports:
      - "80:80"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf:ro
    depends_on:
      - api
    restart: unless-stopped
    networks:
      - backend

volumes:
  db_data:

networks:
  backend:
    driver: bridge
```

---

## 📋 Principais Configurações

### **Build**
```yaml
services:
  api:
    build:
      context: ./api                    # Pasta com Dockerfile
      dockerfile: Dockerfile.prod       # Dockerfile customizado
      args:                             # Argumentos para build
        PYTHON_VERSION: 3.11
```

### **Environment (Variáveis)**
```yaml
services:
  api:
    # Opção 1: Inline
    environment:
      VAR1: valor1
      VAR2: valor2
    
    # Opção 2: Array
    environment:
      - VAR1=valor1
      - VAR2=valor2
    
    # Opção 3: Arquivo .env
    env_file:
      - .env
```

### **Ports (Portas)**
```yaml
services:
  api:
    ports:
      - "8000:8000"        # host:container
      - "127.0.0.1:8001:8001"  # bind em IP específico
      - "9000-9005:9000-9005"  # range de portas
```

### **Volumes (Persistência)**
```yaml
services:
  db:
    volumes:
      # Volume nomeado (gerenciado pelo Docker)
      - db_data:/var/lib/postgresql/data
      
      # Bind mount (pasta local)
      - ./app:/app
      
      # Volume read-only
      - ./config.json:/app/config.json:ro

volumes:
  db_data:
```

### **Depends On (Dependências)**
```yaml
services:
  api:
    depends_on:
      # Simples: aguarda container iniciar (não espera estar pronto)
      - db
      
      # Com condição: aguarda healthcheck
      db:
        condition: service_healthy
      
      redis:
        condition: service_started
```

### **Restart Policies**
```yaml
services:
  api:
    restart: no                # Nunca reinicia
    restart: always            # Sempre reinicia
    restart: on-failure        # Reinicia apenas se falhar
    restart: unless-stopped    # Reinicia exceto se parado manualmente
```

---

## 🎮 Comandos Essenciais

```bash
# ===== BÁSICOS =====
docker-compose up              # Sobe todos os serviços
docker-compose up -d           # Modo detached (background)
docker-compose down            # Para e remove containers
docker-compose down -v         # Para e remove volumes também

# ===== BUILD =====
docker-compose build           # Reconstrói imagens
docker-compose up --build      # Reconstrói e sobe
docker-compose build api       # Reconstrói só um serviço

# ===== LOGS =====
docker-compose logs            # Ver logs de todos
docker-compose logs -f         # Seguir logs (tail -f)
docker-compose logs api        # Logs de um serviço específico

# ===== STATUS =====
docker-compose ps              # Lista containers
docker-compose top             # Processos rodando
docker-compose images          # Imagens usadas

# ===== GERENCIAR SERVIÇOS =====
docker-compose start           # Inicia serviços parados
docker-compose stop            # Para serviços
docker-compose restart         # Reinicia serviços
docker-compose pause           # Pausa serviços
docker-compose unpause         # Despausa serviços

# ===== EXECUTAR COMANDOS =====
docker-compose exec api bash   # Shell dentro do container
docker-compose exec db psql -U usuario  # Psql no banco
docker-compose run api python script.py # Comando one-off

# ===== ESCALAR =====
docker-compose up -d --scale api=3  # 3 réplicas da API

# ===== VALIDAR =====
docker-compose config          # Valida sintaxe YAML
docker-compose config --services  # Lista serviços
```

---

## 🎯 Boas Práticas

### ✅ **Fazer:**
```yaml
# 1. Use variáveis de ambiente
environment:
  DATABASE_URL: ${DATABASE_URL}

# 2. Nomeie volumes e redes
volumes:
  postgres_data:
networks:
  backend:

# 3. Use healthchecks
healthcheck:
  test: ["CMD", "curl", "-f", "http://localhost/health"]

# 4. Defina ordem de inicialização
depends_on:
  db:
    condition: service_healthy

# 5. Use restart policies
restart: unless-stopped
```

### ❌ **Evitar:**
```yaml
# Senhas hardcoded
environment:
  DB_PASSWORD: senha123  # ❌ Usar arquivo .env

# Expor portas desnecessárias
ports:
  - "5432:5432"  # ❌ Se só API precisa, não exponha

# Volumes absolutos
volumes:
  - /home/user/data:/data  # ❌ Use caminhos relativos

# Sem healthcheck em serviços críticos
# ❌ Adicione healthchecks
```

---

## 🔥 Exemplo Real: API + PostgreSQL + Redis

```yaml
version: '3.8'

services:
  db:
    image: postgres:15-alpine
    container_name: filmes-postgres
    environment:
      POSTGRES_USER: ${DB_USER:-postgres}
      POSTGRES_PASSWORD: ${DB_PASSWORD:-postgres}
      POSTGRES_DB: ${DB_NAME:-filmesdb}
    volumes:
      - postgres_data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${DB_USER:-postgres}"]
      interval: 5s
      timeout: 5s
      retries: 5
    restart: unless-stopped
    networks:
      - backend

  redis:
    image: redis:7-alpine
    container_name: filmes-redis
    restart: unless-stopped
    networks:
      - backend

  api:
    build:
      context: ../api
      dockerfile: Dockerfile
    container_name: filmes-api
    environment:
      DATABASE_URL: postgresql://${DB_USER:-postgres}:${DB_PASSWORD:-postgres}@db:5432/${DB_NAME:-filmesdb}
      REDIS_URL: redis://redis:6379
      PYTHONUNBUFFERED: 1
    ports:
      - "${API_PORT:-8000}:8000"
    depends_on:
      db:
        condition: service_healthy
      redis:
        condition: service_started
    volumes:
      - ../api:/app  # Hot reload em desenvolvimento
    restart: unless-stopped
    networks:
      - backend

volumes:
  postgres_data:

networks:
  backend:
    driver: bridge
```

**Arquivo `.env`:**
```env
DB_USER=postgres
DB_PASSWORD=senha_segura
DB_NAME=filmesdb
API_PORT=8000
```

---

## 🆚 Docker Compose vs Dockerfile

| Aspecto | Dockerfile | Docker Compose |
|---------|------------|----------------|
| **Propósito** | Define **como construir** uma imagem | Orquestra **múltiplos containers** |
| **Arquivo** | `Dockerfile` | `docker-compose.yml` |
| **Escopo** | 1 imagem | N serviços |
| **Comandos** | `docker build` | `docker-compose up` |
| **Uso** | Build de imagem | Desenvolvimento/testes |

**Você precisa de AMBOS:**
- `Dockerfile` → Cria a imagem da aplicação
- `docker-compose.yml` → Orquestra app + banco + redis + etc

---

## 🎓 Checklist: Criar Docker Compose

```markdown
✅ 1. Criar arquivo `docker-compose.yml`
✅ 2. Definir `version: '3.8'`
✅ 3. Listar todos os `services:` necessários
✅ 4. Para cada serviço:
   ✅ Escolher `image:` ou `build:`
   ✅ Definir `container_name:`
   ✅ Configurar `environment:`
   ✅ Expor `ports:` (se necessário)
   ✅ Adicionar `volumes:` (para persistência)
   ✅ Configurar `depends_on:`
   ✅ Adicionar `healthcheck:` (serviços críticos)
   ✅ Definir `restart:` policy
✅ 5. Criar `volumes:` nomeados
✅ 6. Criar `networks:` (se customizar)
✅ 7. Criar arquivo `.env` para secrets
✅ 8. Testar: `docker-compose config`
✅ 9. Subir: `docker-compose up`
✅ 10. Verificar: `docker-compose ps`
```

---

## 🚀 Próximos Passos

- **Desenvolvimento:** Use volumes para hot reload
- **Produção:** Use imagens buildadas, não build em runtime
- **CI/CD:** Integre com pipelines (GitHub Actions, GitLab CI)
- **Kubernetes:** Migre quando precisar de múltiplos hosts e orquestração avançada

---

**Documentação oficial:** https://docs.docker.com/compose/
