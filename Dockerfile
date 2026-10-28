FROM python:3.10-slim

# ── Ensure unbuffered stdout so Fly.io captures logs in real time ──────
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

WORKDIR /app

# ── Install system deps required by uvloop / pypdf (if wheels are absent)
RUN apt-get update && apt-get install -y --no-install-recommends \
        gcc \
        libffi-dev \
    && rm -rf /var/lib/apt/lists/*

# ── Install Python deps first (layer caching) ─────────────────────────
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# ── Copy application code ─────────────────────────────────────────────
COPY . .

# ── Run the bot ────────────────────────────────────────────────────────
CMD ["python", "bot.py"]
