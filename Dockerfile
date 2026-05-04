# TODO: Write a production-ready Dockerfile
#
# All of these are tested by the grader:
#
# [ ] Multi-stage build (2+ FROM instructions)
# [ ] Base image: python:3.14-slim (pinned version, no :latest)
# [ ] Copy requirements.txt and pip install BEFORE copying source code (layer caching)
# [ ] Run as a non-root USER
# [ ] EXPOSE 8080
# [ ] HEALTHCHECK instruction
# [ ] No hardcoded secrets (no ENV PASSWORD=..., no ENV SECRET_KEY=...)
# [ ] Final image under 200MB
#
# Start command: uvicorn src.app:app --host 0.0.0.0 --port 8080
FROM python:3.14-slim AS builder
WORKDIR /build
RUN python -m venv /venv
COPY requirements.txt .
RUN /venv/bin/pip install --no-cache-dir -r requirements.txt

# Stage 2: final image — copy only the venv and source code
FROM python:3.14-slim
WORKDIR /app
COPY --from=builder /venv /venv
COPY src/ src/
RUN adduser --disabled-password --gecos "" appuser
USER appuser
EXPOSE 8080
HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
    CMD /venv/bin/python -c "import urllib.request; urllib.request.urlopen('http://localhost:8080/health')"
CMD ["/venv/bin/uvicorn", "src.app:app", "--host", "0.0.0.0", "--port", "8080"]