FROM python:3.10-slim

WORKDIR /app

# Install system dependencies including ffmpeg and curl
RUN apt-get update && apt-get install -y \
    build-essential \
    libsndfile1 \
    git \
    ffmpeg \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Copy only requirements first to leverage Docker caching
COPY requirements.txt .

# Install Python dependencies directly (without virtual env)
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application
COPY . .

# Expose the port
EXPOSE 8083

ENV PYTHONUNBUFFERED=1
ENV OMP_NUM_THREADS=1

# Command to run the application
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8083"]
