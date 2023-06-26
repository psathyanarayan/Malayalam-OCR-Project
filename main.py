from fastapi import FastAPI, File, UploadFile
from starlette.responses import FileResponse
from fastapi.staticfiles import StaticFiles
from typing import Dict
import pytesseract
import io
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from PIL import Image
from googletrans import Translator


# Set the path to the Tesseract executable
# pytesseract.pytesseract.tesseract_cmd = 'tesseract'

app = FastAPI()

# Mount the static files directory
app.mount("/static", StaticFiles(directory="static"), name="static")
translator = Translator(service_urls=['translate.google.com'])

@app.get('/')
async def home():
    # Return the static HTML file as the home page
    return FileResponse('static/index.html')
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)


class OCRResponse(BaseModel):
    text: str


class TranslationRequest(BaseModel):
    text: str


class TranslationResponse(BaseModel):
    translation: str



@app.post("/translate/malayalam-to-english")
async def translate_malayalam_to_english(request: TranslationRequest):
    text = request.text
    translator = Translator()
    translation = translator.translate(text, src="ml", dest="en")
    x = TranslationResponse(translation=translation.text)
    print(TranslationResponse(translation=translation.text))
    return x
@app.post('/ocr/malayalam')
async def ocr_malayalam(file: UploadFile = File(...)) -> Dict[str, str]:
    # Check if a file was uploaded
    if not file:
        return {'error': 'No file uploaded'}
    
    # Check if the file is an image
    if not file.content_type.startswith('image/'):
        return {'error': 'File must be an image'}
    
    # Read the image
    img = Image.open(io.BytesIO(await file.read()))
    
    # Perform OCR on the image with Malayalam language
    text = pytesseract.image_to_string(img, lang='mal')
    
    # Return the OCR result as JSON
    return {'text': text}

if __name__ == '__main__':
    import uvicorn
    uvicorn.run(app, host='0.0.0.0', port=8000)
