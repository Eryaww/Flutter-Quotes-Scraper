from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from scrapy.datahelper import SpiderData
from scraper import QuotesScraper
from starlette.responses import Response
import json, typing
import scrapydo

scrapydo.setup()

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins = ['*'],
    allow_methods = ['*'],
    allow_headers = ['*'],
)

import json, typing
from starlette.responses import Response

class PrettyJSONResponse(Response):
    media_type = "application/json"

    def render(self, content: typing.Any) -> bytes:
        return json.dumps(
            content,
            ensure_ascii=False,
            allow_nan=False,
            indent=4,
            separators=(", ", ": "),
        ).encode("utf-8")

@app.get('/')
def root():
    return {'Hello' : 'World'}

@app.get('/{page}', response_class=PrettyJSONResponse)
def get_page(page: int):
    data = SpiderData()
    scrapydo.run_spider(QuotesScraper, name = 'quotes', param = {'page': page}, data = data)
    return data['quotes']