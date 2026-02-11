from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import uvicorn
import psycopg2
from psycopg2.extras import RealDictCursor
import os
import time

app = FastAPI(title="API Filmes com PostgreSQL - Exercício 2")

# Modelos Pydantic
class Review(BaseModel):
    filme_id: int
    autor: str
    nota: int
    comentario: str

# Configuração do banco de dados
DATABASE_URL = os.getenv("DATABASE_URL", "postgresql://postgres:postgres@localhost:5432/filmesdb")

def get_db_connection():
    """Conecta ao banco de dados com retry"""
    max_retries = 5
    for attempt in range(max_retries):
        try:
            conn = psycopg2.connect(DATABASE_URL)
            return conn
        except psycopg2.OperationalError as e:
            if attempt < max_retries - 1:
                print(f"Tentativa {attempt + 1} falhou. Tentando novamente em 2 segundos...")
                time.sleep(2)
            else:
                raise e

def init_db():
    """Inicializa o banco de dados criando a tabela de reviews"""
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        
        cursor.execute("""
            CREATE TABLE IF NOT EXISTS reviews (
                id SERIAL PRIMARY KEY,
                filme_id INTEGER NOT NULL,
                autor VARCHAR(255) NOT NULL,
                nota INTEGER NOT NULL CHECK (nota >= 1 AND nota <= 5),
                comentario TEXT,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )
        """)
        
        conn.commit()
        cursor.close()
        conn.close()
        print("✅ Banco de dados inicializado com sucesso!")
    except Exception as e:
        print(f"❌ Erro ao inicializar banco: {e}")
        raise e

@app.on_event("startup")
async def startup_event():
    """Executado quando a API inicia"""
    print("🚀 Iniciando API...")
    init_db()

@app.get("/")
def inicio():
    return {
        "mensagem": "API de Filmes com PostgreSQL - Exercício 2",
        "endpoints": {
            "health": "/health",
            "filmes": "/filmes",
            "reviews": "/reviews (GET e POST)",
            "docs": "/docs"
        }
    }

@app.get("/filmes")
def listar_filmes():
    return {
        "filmes": [
            {"id": 1, "titulo": "Matrix", "ano": 1999},
            {"id": 2, "titulo": "Inception", "ano": 2010},
            {"id": 3, "titulo": "Interstellar", "ano": 2014}
        ]
    }

@app.get("/health")
def health():
    """Health check - verifica conexão com o banco"""
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT 1")
        cursor.close()
        conn.close()
        return {"status": "ok", "database": "connected"}
    except Exception as e:
        return {"status": "error", "database": "disconnected", "error": str(e)}

@app.post("/reviews")
def criar_review(review: Review):
    """Cria uma nova review de filme"""
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        
        cursor.execute("""
            INSERT INTO reviews (filme_id, autor, nota, comentario)
            VALUES (%s, %s, %s, %s)
            RETURNING id, created_at
        """, (review.filme_id, review.autor, review.nota, review.comentario))
        
        result = cursor.fetchone()
        conn.commit()
        cursor.close()
        conn.close()
        
        return {
            "mensagem": "Review criada com sucesso!",
            "id": result[0],
            "created_at": result[1]
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Erro ao criar review: {str(e)}")

@app.get("/reviews")
def listar_reviews():
    """Lista todas as reviews"""
    try:
        conn = get_db_connection()
        cursor = conn.cursor(cursor_factory=RealDictCursor)
        
        cursor.execute("""
            SELECT id, filme_id, autor, nota, comentario, created_at
            FROM reviews
            ORDER BY created_at DESC
        """)
        
        reviews = cursor.fetchall()
        cursor.close()
        conn.close()
        
        return {
            "total": len(reviews),
            "reviews": reviews
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Erro ao listar reviews: {str(e)}")

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
