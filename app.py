from fastapi import FastAPI
import uvicorn

app = FastAPI(title="API Simples - Exercício Docker")

@app.get("/")
def inicio():
    return {"mensagem": "API funcionando no Docker!"}

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
    return {"status": "ok"}

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
