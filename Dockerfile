# Multi-stage Dockerfile for Loan Processing App
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    tesseract-ocr \
    tesseract-ocr-eng \
    libgl1-mesa-glx \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    libgomp1 \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements first for better caching
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Create non-root user for security
RUN useradd --create-home --shell /bin/bash app && chown -R app:app /app
USER app

# Expose ports
EXPOSE 8000 8501

# Create startup script
RUN echo '#!/bin/bash\n\
if [ "$SERVICE" = "backend" ]; then\n\
    echo "Starting FastAPI backend..."\n\
    uvicorn main:app --host 0.0.0.0 --port 8000\n\
elif [ "$SERVICE" = "frontend" ]; then\n\
    echo "Starting Streamlit frontend..."\n\
    streamlit run app.py --server.port 8501 --server.address 0.0.0.0\n\
else\n\
    echo "Please set SERVICE environment variable to 'backend' or 'frontend'"\n\
    exit 1\n\
fi' > /app/start.sh && chmod +x /app/start.sh

CMD ["/app/start.sh"]
