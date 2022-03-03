import json
import requests
import scrapy
from urllib.parse import urlencode
from scrapy.datahelper import SpiderData

class Pipeline():
    def open_spider(self, spider:scrapy.Spider):
        # self.f = open('output.json', 'w')
        spider.data['quotes'] = []

    def process_item(self, item, spider:scrapy.Spider):
        # self.f.write(json.dumps(dict(item), indent=4) + '\n')
        spider.data['quotes'].append(item)

class QuotesScraper(scrapy.Spider):
    custom_settings = {
        'ITEM_PIPELINES': {
            Pipeline : 300,
        }
    }
    kwargs = {}
    def __init__(self, name=None, **kwargs):
        super().__init__(name, **kwargs)
        self.kwargs = kwargs
        
    def start_requests(self):
        # TODO ADD MORE SCRAPE OPTION
        url = None
        if self.name == 'quotes':
            param = urlencode(self.kwargs['param'])
            url = 'https://api.quotery.com/wp-json/quotery/v1/quotes?'+param
        yield scrapy.Request(url=url, callback=self.parse_quotes)

    def parse_quotes(self, response):
        quotes = json.loads(response.text)
        for quote in quotes:
            print(quote)
            yield {
                'author': quote['author']['name'].encode('ascii', 'ignore').decode('utf-8'),
                'quote': quote['body'].encode('ascii', 'ignore').decode('utf-8'),
                'tags': quote['link'].split('-'),
            }

if __name__ == '__main__':
    # https://api.quotery.com/wp-json/quotery/v1/topics?orderby=popular&page=1&per_page=11
    # https://api.quotery.com/wp-json/quotery/v1/authors?orderby=popular&page=1&per_page=11
    # https://api.quotery.com/wp-json/quotery/v1/collections?orderby=popular&page=1&per_page=1

    from scrapy.crawler import CrawlerProcess
    runner = CrawlerProcess()
    dt = SpiderData()
    runner.crawl(QuotesScraper, 'quotes', param = {'page': 2}, data = dt)
    runner.start()