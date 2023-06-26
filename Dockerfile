# Use the official Python image as the base image
FROM python:3.10-slim-buster

# Set the working directory in the container
WORKDIR /app

# Copy the requirements file to the working directory
COPY poetry.lock pyproject.toml /app/

# Install Poetry and project dependencies
RUN pip install poetry && \
    poetry config virtualenvs.create false && \
    poetry install --no-interaction --no-ansi

# Copy the rest of the application code to the working directory
COPY . /app

# Set the path to the Tesseract executable
ENV TESSERACT_PATH=/usr/bin/tesseract

# Expose port 8000
EXPOSE 8000

# Start the FastAPI application using uvicorn
CMD ["poetry", "run", "uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
