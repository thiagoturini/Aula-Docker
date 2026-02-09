# 🐳 Docker - Guia Prático Simples

## 🎯 O que vamos fazer?

Criar uma API simples e colocá-la dentro de um container Docker.

**Tempo:** 30 minutos  
**Nível:** Iniciante  
**Tudo que você precisa está nesta pasta!**

---

## 📦 Passo 1: Instalar Docker (15 minutos)

### **Windows:**
1. Baixe: https://www.docker.com/products/docker-desktop
2. Instale o Docker Desktop
3. Reinicie o computador
4. Abra o Docker Desktop

### **Mac:**
1. Baixe: https://www.docker.com/products/docker-desktop
2. Escolha: Apple Silicon OU Intel
3. Instale o Docker Desktop
4. Abra o Docker Desktop

### **Linux:**
```bash
sudo apt-get update
sudo apt-get install docker.io docker-compose
sudo usermod -aG docker $USER
```
Faça logout e login.

### **Testar:**
```bash
docker --version
docker run hello-world
```

Se aparecer "Hello from Docker!" → ✅ Pronto!

---

## 🔧 Passo 2: Extensão VS Code (2 minutos)

1. Abra VS Code
2. Extensions (Ctrl+Shift+X)
3. Busque "Docker"
4. Instale da **Microsoft**
5. Ícone do Docker aparece na barra lateral ✅

---

## 📂 Passo 3: Entender os Arquivos

Nesta pasta você já tem:

**app.py** - API simples em Python
```python
# Uma API com 3 endpoints:
# GET /          → mensagem de boas-vindas
# GET /filmes    → lista de filmes
# GET /health    → status da API
```

**requirements.txt** - Dependências
```
fastapi
uvicorn
```

**Dockerfile** - Receita do container
```dockerfile
# Veja a explicação completa na seção abaixo!
# Este arquivo diz ao Docker COMO montar seu container
```

### 📋 **Entendendo o Dockerfile Linha por Linha**

O Dockerfile é a **receita** que diz ao Docker como montar seu container. Vamos entender cada linha:

```dockerfile
# FROM python:3.11-slim
```
**O que faz:** Define a imagem base (ponto de partida)  
**Por que:** Você precisa de um "sistema operacional" com Python já instalado  
**Alternativas:** 
- `python:3.11-slim` → Leve, recomendado (180 MB)
- `python:3.11` → Completo (1 GB)
- `python:3.11-alpine` → Mínimo (50 MB, mas pode ter problemas de compatibilidade)

```dockerfile
# WORKDIR /app
```
**O que faz:** Define o diretório de trabalho dentro do container  
**Por que:** Organização! Todos os comandos seguintes acontecem em `/app`  
**Analogia:** É como fazer `cd /app` automaticamente

```dockerfile
# COPY requirements.txt .
```
**O que faz:** Copia `requirements.txt` da sua máquina → `/app` do container  
**Por que:** Docker precisa saber quais bibliotecas instalar  
**Nota:** O `.` significa "diretório atual" (que é `/app` por causa do WORKDIR)

```dockerfile
# RUN pip install --no-cache-dir -r requirements.txt
```
**O que faz:** Instala as dependências Python dentro do container  
**Por que:** Seu código precisa do FastAPI e Uvicorn para funcionar  
**Detalhe:** `--no-cache-dir` → economiza espaço, não guarda cache do pip

```dockerfile
# COPY . .
```
**O que faz:** Copia TODOS os arquivos da pasta → `/app` do container  
**Por que:** Seu código (`app.py`) precisa estar dentro do container  
**Importante:** Copia **depois** de instalar dependências (otimização de cache)

```dockerfile
# EXPOSE 8000
```
**O que faz:** Documenta que o container usa a porta 8000  
**Por que:** Informativo - não abre a porta, só avisa  
**Nota:** A porta só funciona de verdade com `-p 8000:8000` no `docker run`

```dockerfile
# CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]
```
**O que faz:** Comando que RODA quando o container inicia  
**Por que:** Inicia o servidor Uvicorn com sua API  
**Detalhe:** `--host 0.0.0.0` → Aceita conexões externas (essencial no Docker!)

---

### 🛠️ **Como Criar um Dockerfile do Zero**

**Opção 1: Use este modelo** (recomendado para iniciantes)  
O Dockerfile desta pasta já está pronto! Apenas ajuste se necessário.

**Opção 2: Crie do zero** (para aprender o processo)

**Passo a passo:**

1. **Crie o arquivo** `Dockerfile` (sem extensão!) na raiz do projeto

2. **Defina a imagem base:**
```dockerfile
FROM python:3.11-slim
```
💡 Escolha conforme necessidade: slim (leve), alpine (mínimo), ou padrão (completo)

3. **Configure o diretório de trabalho:**
```dockerfile
WORKDIR /app
```
💡 Pode ser `/app`, `/code`, `/usr/src/app` - escolha o que fizer sentido

4. **Copie e instale dependências:**
```dockerfile
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
```
💡 Copie requirements.txt **primeiro** para aproveitar cache do Docker

5. **Copie seu código:**
```dockerfile
COPY . .
```
💡 Copia tudo da pasta atual para dentro do container

6. **Documente a porta:**
```dockerfile
EXPOSE 8000
```
💡 Use a porta que seu app escuta (8000, 3000, 5000, etc.)

7. **Defina o comando de inicialização:**
```dockerfile
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]
```
💡 Para outros frameworks:
- Flask: `CMD ["python", "app.py"]`
- Django: `CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]`
- Node.js: `CMD ["node", "server.js"]`

**Dockerfile completo:**
```dockerfile
FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
EXPOSE 8000
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]
```

**Pronto!** Agora você pode fazer `docker build -t minha-api .`

💡 **Dicas de boas práticas:**
- ✅ Copie `requirements.txt` antes do resto (cache eficiente)
- ✅ Use `.dockerignore` para excluir arquivos desnecessários
- ✅ Use imagens `slim` ou `alpine` para economizar espaço
- ✅ Sempre use `--host 0.0.0.0` em servidores web no Docker
- ✅ Um comando por linha = melhor legibilidade

**docker-compose.yml** - Jeito fácil de rodar (OPCIONAL)
```yaml
# Um comando para subir tudo
# Você pode ignorar esse arquivo por enquanto!
# É só uma forma mais avançada de rodar containers
```

💡 **Nota:** O `docker-compose.yml` é opcional! Serve para quem quer aprender uma forma mais avançada de gerenciar containers. Por enquanto, use o VS Code ou `docker run` - é mais simples!

---

## 🏗️ Passo 4: Construir a Imagem (5 minutos)

Abra o terminal **nesta pasta** (`Aula Docker`):

### **Opção A: VS Code (Recomendado)**

1. **Botão direito** no arquivo `Dockerfile`
2. **"Build Image..."**
3. Digite: `minha-api`
4. Enter
5. Aguarde (~2 min)

### **Opção B: Terminal**

```bash
docker build -t minha-api .
```

**Como saber que funcionou?**
```bash
docker images
```
Deve aparecer `minha-api` na lista! ✅

---

## 🚀 Passo 5: Executar o Container (3 minutos)

### **👉 Opção A: VS Code (Recomendado - Mais Simples!)**

1. Clique no ícone **Docker** na barra lateral esquerda
2. Vá em **IMAGES** (seção de imagens)
3. Expanda **minha-api**
4. **Botão direito** em **latest**
5. Clique em **"Run"**
6. Uma caixa de diálogo aparece pedindo configurações:
   - Deixe tudo padrão
   - OU adicione: `-p 8000:8000` (mapeia a porta)
7. Pressione **Enter**

✅ **Pronto! Container criado e rodando!**

💡 **Mais fácil ainda:** Se a porta já estiver mapeada corretamente (você vai ver `8000:8000` no container), basta clicar em Run sem configurar nada!

### **👉 Opção B: Terminal**

Se preferir linha de comando, abra o terminal **nesta pasta** e execute:

```bash
docker run -d -p 8000:8000 minha-api
```

**O que significam esses parâmetros?**
- `-d` → Roda em background (detached)
- `-p 8000:8000` → **Mapeia a porta 8000** (essencial para acessar!)
- `minha-api` → Qual imagem usar

✅ **Pronto! Container criado e rodando!**

💡 **O que acabou de acontecer?**
- Docker criou um **container** da sua imagem
- Deu um **nome aleatório** para ele (tipo `tender_darwin`, `happy_einstein`)
- O container está **ATIVO** e rodando sua API na porta 8000

### **Onde ver o container rodando?**

**No VS Code:**
1. Clique no ícone **Docker** (barra lateral esquerda)
2. Vá em **CONTAINERS**
3. Você verá seu container com nome aleatório rodando (ícone verde 🟢)

**No Docker Desktop:**
1. Abra o **Docker Desktop**
2. Vá na aba **Containers**
3. Você verá seu container rodando com:
   - Nome aleatório
   - Status: Running 🟢
   - Porta: `8000:8000`

💡 **Dica:** Docker Desktop e extensão VS Code mostram a mesma informação. Use o que preferir para acompanhar!

---

## ✅ Passo 6: Testar a API (2 minutos)

1. Abra o navegador
2. Acesse: **http://localhost:8000/docs**
3. Você verá a documentação interativa!

**Teste os endpoints:**
- `GET /` → Mensagem de boas-vindas
- `GET /filmes` → Lista de 3 filmes
- `GET /health` → Status OK

🎉 **Funcionou!** Sua API está rodando em Docker!

---

## 📊 Gerenciar o Container

### **👉 Você tem 3 opções para gerenciar:**

#### **1. Extensão VS Code**
1. Clique no ícone **Docker** na barra lateral
2. Vá em **CONTAINERS**
3. Você verá seu container (nome aleatório)
4. **Botão direito** → ações disponíveis

#### **2. Docker Desktop**
1. Abra o Docker Desktop
2. Aba **Containers**
3. Clique no container para ver opções

#### **3. Terminal**
```bash
docker ps                           # Ver containers rodando
docker stop <nome-ou-id>            # Parar
docker start <nome-ou-id>           # Iniciar
docker rm <nome-ou-id>              # Remover
docker logs <nome-ou-id>            # Ver logs
```

### **Ações disponíveis:**

| Ação | O que faz | Quando usar |
|------|-----------|-------------|
| **View Logs** 📋 | Mostra o que está acontecendo | Ver requisições e erros em tempo real |
| **Stop** ⏹️ | Para completamente | Terminou de usar por enquanto |
| **Start** ▶️ | Inicia container parado | Quer usar novamente |
| **Restart** 🔄 | Reinicia | Aplicar mudanças ou resolver problemas |
| **Remove** 🗑️ | Deleta o container | Não precisa mais dele |
| **Attach Shell** 💻 | Entrar dentro do container | Explorar arquivos e testar comandos |

💡 **Importante entender:**
- **Container ATIVO (Running)** 🟢 → Consome CPU e memória
- **Container PARADO (Stopped)** ⚫ → Não consome recursos, mas ainda existe
- **Container REMOVIDO** ❌ → Deletado completamente (mas a imagem fica!)

### **📝 Fluxo típico de uso:**

```
1. docker run             → Container ATIVO 🟢 (usando recursos)
2. Usar a API             → Fazendo testes e desenvolvimento
3. docker stop            → Container PARADO ⚫ (não usa recursos)
   
   [Quando precisar novamente]
4. docker start           → Container ATIVO 🟢 de novo
   
   [Quando não precisar mais]
5. docker rm              → Container DELETADO ❌
```

**⚠️ Dica importante:** Sempre **pare** os containers quando terminar de usar! Eles ficam consumindo recursos mesmo quando você não está testando.

<details>
<summary>🖥️ <strong>Comandos úteis de terminal</strong></summary>

```bash
# Ver o que está rodando
docker ps

# Ver TODOS (inclusive parados)
docker ps -a

# Ver logs em tempo real
docker logs -f <nome-ou-id>

# Entrar no container
docker exec -it <nome-ou-id> /bin/bash

# Ver uso de recursos
docker stats <nome-ou-id>

# Parar todos os containers
docker stop $(docker ps -q)
```
</details>

---

## 🆘 Problemas Comuns

### **"Docker daemon not running"**
**Solução:** Abra o Docker Desktop e aguarde ele iniciar (ícone na barra de tarefas)

### **"Port 8000 already allocated"**
**Solução:** Mude a porta:
```bash
docker run -d -p 8001:8000 --name api-container minha-api
```
Acesse: http://localhost:8001/docs

### **"Container name already in use"**
**Solução:** Remova o antigo:
```bash
docker stop api-container
docker rm api-container
```

### **Build muito lento**
**Solução:** Normal na primeira vez! Docker está baixando Python. Próximas vezes são rápidas.

### **Não sei se funcionou**
**Solução:** Veja os logs:
```bash
docker logs api-container
```
Deve mostrar: `Uvicorn running on http://0.0.0.0:8000`

---

## 💡 Entendendo o que Aconteceu

### **O que é Docker?**
Empacota sua aplicação com tudo que ela precisa (Python, bibliotecas, código) em um "container" que roda em qualquer lugar.

### **O que fizemos?**
1. **Dockerfile** → Receita de como montar o container
2. **docker build** → Montou o container (criou a "imagem")
3. **docker run** → Executou o container
4. **Resultado** → API rodando isolada e portável!

### **Docker vs Sem Docker - Qual a diferença?**

**🚫 SEM Docker (modo tradicional):**
```bash
# Instalar Python na sua máquina
# Instalar dependências (pode conflitar com outros projetos)
pip install fastapi uvicorn
# Rodar direto na sua máquina
python app.py
```
❌ Se funciona na sua máquina, pode não funcionar na do colega  
❌ Bibliotecas podem conflitar entre projetos  
❌ Difícil de limpar depois  
❌ Precisa instalar tudo de novo em outra máquina  

**✅ COM Docker:**
```bash
# Tudo empacotado no container
docker build -t minha-api .
# Roda isolado
docker run -d -p 8000:8000 --name api-container minha-api
```
✅ Funciona IGUAL em qualquer lugar  
✅ Isolado - não interfere com nada  
✅ Deleta tudo com 2 comandos  
✅ Compartilha só 2 arquivos (Dockerfile + app.py)  

### **O que está acontecendo agora?**

1. **Container rodando** = Minicomputador Linux isolado dentro da sua máquina
2. **Porta 8000** = Túnel entre sua máquina e o container
3. **API dentro do container** = Processo Python rodando nesse minicomputador
4. **Você acessa** = Sua máquina → porta 8000 → container → API

```
┌─────────────────────────────────────┐
│     Sua Máquina (Windows/Mac)       │
│                                     │
│  ┌───────────────────────────────┐ │
│  │   Container Docker (Linux)    │ │
│  │                               │ │
│  │  Python 3.11                  │ │
│  │  FastAPI + Uvicorn            │ │
│  │  app.py rodando               │ │
│  │  Porta 8000 ←─────────────────┼─┤ localhost:8000
│  │                               │ │
│  └───────────────────────────────┘ │
└─────────────────────────────────────┘
```

---

## 🔍 Explorando o Container (Prático!)

### **👉 Usando VS Code (Recomendado):**

#### **1. Ver o que está rodando:**
- Clique no ícone **Docker** (barra lateral)
- Seção **Containers** → veja todos rodando
- Seção **Images** → veja suas imagens

#### **2. Ver os logs (o que a API está fazendo):**
- **Containers** → Botão direito em `api-container` → **View Logs**
- Uma aba abre mostrando:
  - ✅ Quando o Uvicorn iniciou
  - ✅ Cada requisição que chega
  - ✅ Erros (se houver)
- **Logs atualizam sozinhos!** Deixe aberto e use a API

#### **3. Entrar DENTRO do container:**
- **Containers** → Botão direito em `api-container` → **Attach Shell**
- Um terminal abre **dentro do container**!
- Agora você pode explorar:
```bash
ls              # Ver arquivos
pwd             # Onde estou? (/app)
cat app.py      # Ver o código
python -V       # Versão do Python (3.11)
pip list        # Bibliotecas instaladas
exit            # Sair
```

#### **4. Ver detalhes técnicos:**
- **Containers** → Botão direito → **Inspect**
- Mostra JSON com TUDO: IP, portas, volumes, variáveis, etc.

#### **5. Ver uso de recursos:**
- **Containers** → Passe o mouse em `api-container`
- Veja: CPU%, Memória usada, I/O

### **Alternativa: Comandos de Terminal**

<details>
<summary>Clique aqui se preferir linha de comando</summary>

```bash
# Ver o que está rodando
docker ps

# Ver TODOS (inclusive parados)
docker ps -a

# Ver logs
docker logs api-container

# Ver logs AO VIVO
docker logs -f api-container

# Entrar no container
docker exec -it api-container /bin/bash

# Ver uso de CPU/Memória
docker stats api-container

# Inspecionar
docker inspect api-container

# Ver imagens
docker images

# Ver espaço em disco
docker system df
```
</details>

---

## 🎯 Experimente Agora!

### **Teste 1: Ver logs em tempo real 👁️**

**No VS Code:**
1. **Docker** (ícone lateral) → **CONTAINERS**
2. Botão direito no seu container → **View Logs**
3. Deixe a janela de logs aberta
4. Abra o navegador: http://localhost:8000/filmes
5. 👀 **Volte pro VS Code e veja a requisição aparecer nos logs!**

**No Docker Desktop:**
1. Clique no seu container
2. Aba **Logs**
3. Acesse a API e veja os logs em tempo real!

💡 **Você verá:** Cada request HTTP com status code, path, e tempo de resposta.

### **Teste 2: Entrar no container 🚪**

**No VS Code:**
1. **Docker** → **CONTAINERS**
2. Botão direito no container → **Attach Shell**
3. Um terminal abre **dentro do container**!
4. Explore:
```bash
ls              # Ver arquivos
pwd             # Onde estou? (/app)
cat app.py      # Ver o código
python -V       # Versão do Python
pip list        # Bibliotecas instaladas
exit            # Sair
```

💡 **É como entrar dentro de um mini-Linux!** Tudo está isolado.

### **Teste 3: Parar e ver a diferença ⏹️**

**No VS Code ou Docker Desktop:**
1. **Stop** o container (botão direito)
2. Tente acessar: http://localhost:8000
   - ❌ **Falha:** "This site can't be reached"
3. **Start** o container novamente
4. Acesse de novo: http://localhost:8000
   - ✅ **Funciona!**

💡 **Container parado = aplicação offline. Simples assim!**

<details>
<summary>🖥️ <strong>Comandos alternativos de terminal</strong></summary>

```bash
# Ver logs em tempo real
docker logs -f <nome-do-container>

# Entrar no container
docker exec -it <nome-do-container> /bin/bash

# Parar/Iniciar
docker stop <nome-do-container>
docker start <nome-do-container>
```
</details>

---

## 🧹 Limpeza: Removendo Tudo

Quando terminar a aula e não precisar mais:

### **👉 No VS Code:**

**Passo 1: Parar**
1. **Docker** → **CONTAINERS**
2. Botão direito no container → **Stop**

**Passo 2: Remover o container**
1. Botão direito → **Remove**
2. Confirme

**Passo 3: (Opcional) Remover a imagem**
1. **Docker** → **IMAGES**
2. Expanda **minha-api**
3. Botão direito em **latest** → **Remove**

### **👉 No Docker Desktop:**

1. Aba **Containers** → Ícone da lixeira 🗑️
2. (Opcional) Aba **Images** → Delete **minha-api**

### **👉 No Terminal:**

```bash
# Parar e remover tudo
docker stop <nome-ou-id>
docker rm <nome-ou-id>
docker rmi minha-api

# OU forçar (remove mesmo rodando)
docker rm -f <nome-ou-id>
```

💡 **Por que limpar?**
- ✅ Libera espaço em disco
- ✅ Mantém o Docker organizado
- ✅ Você pode recriar tudo rapidamente depois!

<details>
<summary>🧹 <strong>Limpar TUDO de uma vez (avançado)</strong></summary>

**Cuidado:** Isso remove TODOS containers e imagens não usados!

```bash
docker system prune -a
```

No VS Code: Botão direito em qualquer lugar → **Prune System**
</details>

---

## � Próximos Passos

### **1. Modificar a API**

Quer adicionar mais endpoints? Edite [app.py](app.py):

```python
@app.get("/ola/{nome}")
def ola(nome: str):
    return {"mensagem": f"Olá, {nome}!"}
```

**Como aplicar as mudanças:**

1. **Parar e remover** o container antigo (VS Code ou Docker Desktop)
2. **Remover a imagem** antiga
3. **Rebuild** da imagem:
   - VS Code: Botão direito no `Dockerfile` → **Build Image** → `minha-api`
   - Terminal: `docker build -t minha-api .`
4. **Rodar** novamente: `docker run -d -p 8000:8000 minha-api`
5. **Testar:** http://localhost:8000/ola/SeuNome 🎉

💡 **Por que rebuild?** Mudanças no código só entram na imagem quando você reconstrói!

### **2. Compartilhar com outros**

Quer que um colega rode sua API? É simples:

**Você envia:**
- `app.py`
- `requirements.txt`
- `Dockerfile`

**Ele executa:**
```bash
docker build -t minha-api .
docker run -d -p 8000:8000 minha-api
```

✅ **Funciona IGUAL!** Não importa se é Windows, Mac ou Linux!

### **3. Docker Compose (OPCIONAL - Avançado)**

O arquivo `docker-compose.yml` está nesta pasta como **bônus opcional**.

**Quando usar?**
- Quer um comando só para subir tudo
- Vai ter múltiplos containers (API + banco + cache)
- Quer automatizar configurações

**Comandos básicos:**
```bash
docker-compose up -d         # Sobe tudo
docker-compose logs -f       # Ver logs
docker-compose down          # Para e remove
docker-compose up -d --build # Rebuild e sobe
```

⚠️ **Não é obrigatório!** Só use quando estiver confortável com Docker básico.

---

## ✅ Checklist Final

- [ ] Docker instalado e funcionando
- [ ] Extensão Docker do VS Code (ou Docker Desktop)
- [ ] Entendi: **Imagem** = receita, **Container** = aplicação rodando
- [ ] Consegui construir a imagem
- [ ] Consegui rodar o container
- [ ] Acessei http://localhost:8000/docs
- [ ] Testei os 3 endpoints (/, /filmes, /health)
- [ ] Vi os logs em tempo real
- [ ] Entrei dentro do container
- [ ] Sei parar e remover containers
- [ ] Entendi a diferença entre Docker vs sem Docker

---

## 🎓 O que você aprendeu!

✅ O que é Docker e containers  
✅ Diferença entre imagem e container  
✅ Criar Dockerfile  
✅ Construir imagens  
✅ Executar containers  
✅ Mapear portas  
✅ Gerenciar containers (logs, stop, start, remove)  
✅ Explorar containers por dentro  
✅ Entender os benefícios de containerização  

---

## 🎉 Parabéns!

Sua primeira aplicação containerizada está funcionando! 🚀

**O que vem depois:**
- Containers com bancos de dados
- Networks entre containers
- Volumes para persistir dados
- Docker em produção
- Kubernetes (orquestração de containers)

**Dúvidas?**
- Revise as seções deste guia
- Veja os logs: `docker logs <container>`
- Consulte a [documentação oficial](https://docs.docker.com/)
- Pergunte ao professor! 🙋‍♂️

---

## 📖 Referência Rápida de Comandos

### **Essencial:**
```bash
# Construir imagem
docker build -t minha-api .

# Rodar container (comando mais importante!)
docker run -d -p 8000:8000 minha-api

# Ver o que está rodando
docker ps

# Ver logs
docker logs <nome-ou-id>

# Parar
docker stop <nome-ou-id>

# Remover
docker rm <nome-ou-id>
```

### **Interfaces visuais:**
- **VS Code:** Extensão Docker → gerencia tudo visualmente
- **Docker Desktop:** App completo com stats e monitoramento
- **Terminal:** Controle total via comandos

### **Lembrete importante:**
```
Imagem = Receita (o Dockerfile gera isto)
Container = Prato pronto (resultado de "docker run")
```

**Você pode:**
- Criar VÁRIOS containers da mesma imagem
- Cada container é independente
- Containers não interferem entre si

---

**📝 Feito com ❤️ para facilitar seu aprendizado de Docker!**

# Gerenciar
docker ps                    # Ver rodando
docker logs api-container    # Ver logs
docker stop api-container    # Parar
docker start api-container   # Iniciar
docker rm api-container      # Remover container
docker rmi minha-api         # Remover imagem

# Explorar
docker exec -it api-container /bin/bash  # Entrar
docker stats api-container                # Recursos

# Limpar
docker system prune -a       # Limpar tudo
```
</details>
