# Use official Python image
FROM python:3.11-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV PYTHONPATH=/app 

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy project files
COPY . /app/

# Upgrade pip and install Python dependencies
RUN python -m pip install --upgrade pip
RUN python -m pip install --no-cache-dir -r requirements.txt

# Set working directory to where manage.py is
WORKDIR /app/todo_site

# Collect static files (ignore errors if directory is missing)
RUN python manage.py collectstatic --noinput || true

# Expose port for Render
EXPOSE 8000

# Start the server with Gunicorn
CMD ["gunicorn", "todo_site.wsgi:application", "--bind", "0.0.0.0:8000"]
