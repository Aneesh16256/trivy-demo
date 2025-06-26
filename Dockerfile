FROM python:3.11 as builder
WORKDIR /app
COPY app/requirements.txt .
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
RUN pip install --no-cache-dir -r requirements.txt

FROM python:3.11-slim
WORKDIR /app
COPY --from=builder /opt/venv /opt/venv
COPY app/app.py .
ENV PATH="/opt/venv/bin:$PATH"
RUN useradd -m appuser && chown -R appuser:appuser /app
USER appuser
CMD ["python", "app.py"]
