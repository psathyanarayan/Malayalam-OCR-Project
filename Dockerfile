# Use the official Python base image
FROM python:3.10

# Set the working directory in the container
WORKDIR /app

# Copy the requirements file
COPY requirements.txt .

# Install Tesseract OCR and its dependencies
RUN apt-get update \
    && apt-get install -y tesseract-ocr \
    && apt-get install -y libtesseract-dev \
    && apt-get clean

# Install the required Python packages
RUN pip install --no-cache-dir -r requirements.txt

# Install Malayalam language data for Tesseract
RUN apt-get install -y tesseract-ocr-mal

# Copy the FastAPI app code into the container
COPY . .

# Expose the FastAPI port
EXPOSE 8000

# Start the FastAPI server
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
