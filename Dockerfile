FROM python:3.9 
WORKDIR /app 
COPY . .
RUN apt-get update && apt-get upgrade -y && apt-get install -y tesseract-ocr tesseract-ocr-mal libopencv-dev python3-opencv
RUN pip install  --upgrade -r  requirements.txt
CMD cd app && sh -c "uvicorn main:app --host 0.0.0.0 --port 8084 --reload"