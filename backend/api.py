from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
import scrapydo

scrapydo.setup()

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins = ['*'],
    allow_methods = ['*'],
    allow_headers = ['*'],
)

@app.get('/')
def root():
    return {'Hello' : 'World'}

@app.get('/{page}')
def get_page(page: int):
    scrapydo.run_spider( command = 'main_page', page = page)
