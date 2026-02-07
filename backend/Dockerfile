# Use Python 3.12 on Alpine
FROM python:3.12-alpine

# Install runtime dependencies (curl for health check, postgresql client for CLI tools)
RUN apk add --no-cache \
    curl \
    postgresql-client \
    # Required for psycopg2-binary to work properly on Alpine
    libpq

# Create non-root user
RUN addgroup -g 1001 -S app && adduser -u 1001 -S app -G app
USER app

WORKDIR /app

# Copy and install Python deps
COPY --chown=app:app requirements.txt .
# Force binary install (do NOT build from source)
RUN pip install --no-cache-dir --only-binary=psycopg2-binary -r requirements.txt

# Copy app code
COPY --chown=app:app . .

EXPOSE 5000

CMD ["python", "app.py"]
