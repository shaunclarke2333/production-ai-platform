# stage 1, build
FROM python:3.12-slim-trixie AS builder
# Installing UV
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/
# Creating the app environment
WORKDIR /app
# Install uv, install dependencies from lockfile
COPY pyproject.toml uv.lock /app/
# Installing uv dependencies using UV sync.
# --no-install-project skips installing the actual app code until next step
RUN uv sync --frozen --no-install-project
# Copy src
COPY src /app/src
# Installing the actual project
RUN uv sync --frozen

# Stage 2, runtime
FROM python:3.12-slim-trixie
# Creating a dedicated system group and user with a fixed UID/GID
RUN groupadd -g 10001 knowledgeappgroup && \
    useradd -u 10001 -g knowledgeappgroup -m -s /bin/bash knowledgeappuser
# Copying artifact from build stage and changing ownership to the app user
COPY --from=builder --chown=knowledgeappuser:knowledgeappgroup /app /app
EXPOSE 8000
USER knowledgeappuser
ENV PATH="/app/.venv/bin:$PATH"
CMD ["uvicorn", "knowledge_service.main:app", "--host", "0.0.0.0", "--port", "8000"]
