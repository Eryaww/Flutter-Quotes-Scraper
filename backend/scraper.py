import scrapy

class Pipeline():
    def open_spider(self, spider):
        spider.data['quotes'] = []

    def process_item(self, item, spider:scrapy.Spider):
        spider.data['quotes'].append(item)

class QuotesScraper(scrapy.Spider):
    custom_settings = {
        'ITEM_PIPELINES': {
            Pipeline : 300,
        }
    }
    def start_requests(self):
        yield scrapy.Request(url='https://www.quotery.com/quotes')

    def parse(self, response):
        return super().parse(response)