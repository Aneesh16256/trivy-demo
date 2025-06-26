# Stage 1: Builder
FROM python:3.11 as builder
WORKDIR /app
COPY app/requirements.txt .
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
RUN pip install --upgrade pip setuptools==78.1.1 && \
    pip install --no-cache-dir -r requirements.txt

# Stage 2: Runtime
FROM python:3.11-slim
WORKDIR /app

# First upgrade system setuptools
RUN pip install --upgrade setuptools==78.1.1

# Then copy virtual environment
COPY --from=builder /opt/venv /opt/venv
COPY app/app.py .
ENV PATH="/opt/venv/bin:$PATH"

# Security hardening
RUN useradd -m appuser && chown -R appuser:appuser /app
USER appuser
CMD ["python", "app.py"]
