# Use the official Python image as the base image
FROM python:3.10-slim

# Set the working directory in the container
WORKDIR /app

ENV PORT 8000


# Install Tesseract OCR and other necessary packages
RUN apt-get update \
    && apt-get install -y tesseract-ocr \
    && apt-get clean

# Copy the project files to the working directory
COPY . /app

# Install the project dependencies
RUN pip install --no-cache-dir poetry \
    && poetry config virtualenvs.create false \
    && poetry install --no-interaction --no-ansi \
    && pip install --no-cache-dir --upgrade -r /app/requirements.txt

# Expose the port that the FastAPI server will listen on
EXPOSE 8000

# Start the FastAPI server using Uvicorn
# CMD ["sh", "-c", "poetry run uvicorn app:app --host 0.0.0.0 --port $PORT"]
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]

