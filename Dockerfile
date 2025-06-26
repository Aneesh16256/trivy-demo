# Stage 1: Build environment
FROM python:3.11 as builder

WORKDIR /app
COPY app/requirements.txt .

# Install dependencies in a virtual environment
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
RUN pip install --no-cache-dir -r requirements.txt

# Stage 2: Runtime environment
FROM python:3.11-slim

WORKDIR /app

# Copy only necessary files from builder
COPY --from=builder /opt/venv /opt/venv
COPY app/app.py .

# Use the virtual environment
ENV PATH="/opt/venv/bin:$PATH"

# Security best practices
RUN useradd -m appuser && \
    chown -R appuser:appuser /app
USER appuser

EXPOSE 5000
CMD ["python", "app.py"]