# Build stage: create an isolated Python runtime.
FROM python:3.12.6-slim-bookworm AS builder
WORKDIR /build
RUN python -m venv /opt/venv
COPY requirements.txt .
RUN /opt/venv/bin/pip install --no-cache-dir --no-compile -r requirements.txt

# Runtime stage: minimal image and non-root process.
FROM python:3.12.6-slim-bookworm AS runtime
ENV PATH="/opt/venv/bin:$PATH" \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1
RUN groupadd --system --gid 10001 app && \
    useradd --system --uid 10001 --gid 10001 --no-create-home app
WORKDIR /app
COPY --from=builder /opt/venv /opt/venv
COPY app.py .
USER 10001:10001
EXPOSE 8080
CMD ["python", "app.py"]
