from fastapi import FastAPI
from knowledge_service.core.logging_config import setup_logging

# Defining the logging built for this app
# to run at startup before anything else.
# Order matters, the logging module being at the top
# catches logs for everything that runs afte rit.
setup_logging()

# Instantiating FastAPI
app: FastAPI = FastAPI()


@app.get("/health")
async def health_check():
    return {"status": "ok"}
