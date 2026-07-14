from fastapi import FastAPI

# Instantiating FastAPI
app = FastAPI()


@app.get("/health")
async def health_check():
    return {"status": "ok"}
