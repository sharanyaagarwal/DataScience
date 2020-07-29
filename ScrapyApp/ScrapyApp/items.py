# Define here the models for your scraped items
#
# See documentation in:
# https://docs.scrapy.org/en/latest/topics/items.html

import scrapy


class ScrapyappItem(scrapy.Item):
    # define the fields for your item here like:
    job_title = scrapy.Field()
    company = scrapy.Field()
    location = scrapy.Field()
    description = scrapy.Field()
    date_posted = scrapy.Field()
    seniority_level = scrapy.Field()
    employment_type = scrapy.Field()
    industries = scrapy.Field()
    job_function = scrapy.Field()
    pass
