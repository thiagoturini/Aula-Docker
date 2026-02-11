# Imagem base do Python
FROM python:3.11-slim

# Define o diretório de trabalho
WORKDIR /app

# Copia requirements.txt
COPY requirements.txt .

# Instala dependências
RUN pip install --no-cache-dir -r requirements.txt

# Copia o código da API
COPY app.py .

# Expõe a porta
EXPOSE 8000

# Comando para iniciar
CMD ["python", "app.py"]

