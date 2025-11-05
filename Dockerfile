# Use official Python image
FROM python:3.11-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy project files (everything from Django folder)
COPY . /app/

# Install Python dependencies
RUN pip install --upgrade pip && pip install -r requirements.txt

# Set working directory to where manage.py is
WORKDIR /app/todo_site

# Add Python path to find Django modules
ENV PYTHONPATH=/app/todo_site

# Collect static files (ignore errors if whitenoise isn’t configured)
RUN python manage.py collectstatic --noinput || true

# Expose the port Render will use
EXPOSE 8000



# Start the server with Gunicorn
CMD ["gunicorn", "todo_site.wsgi:application", "--bind", "0.0.0.0:8000"]
