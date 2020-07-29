from scrapy import Spider, Request
from ScrapyApp.items import ScrapyappItem
import re

class LinkedInJobs(Spider):
    name = 'LinkedInJobs'
    allowed_domains = ['www.linkedin.com']
    start_urls = ['https://www.linkedin.com/jobs/search?location=United%20States&redirect=false&geoId=103644278&keywords=&trk=homepage-jobseeker_recent-search&position=1&pageNum=0']

    def parse(self, response):
        job_urls = response.xpath('//a[@class="result-card__full-card-link"]/@href').extract()
        
        # print('-'*55)
        # print(len(job_urls))
        # print('-'*55)
        for url in job_urls:
            yield Request(url=url, callback=self.parse_detail_page)
    
    def parse_detail_page(self, response):
        job_title = response.xpath('//h1[@class="topcard__title"]/text()').extract()
        company = response.xpath('//a[@class="topcard__org-name-link topcard__flavor--black-link"]/text()').extract()
        location = response.xpath('//span[@class="topcard__flavor topcard__flavor--bullet"]/text()').extract()
        posted_time = response.xpath('//span[contains(@class,  "topcard__flavor--metadata posted-time-ago__text")]/text()').extract()   
        description = response.xpath('//div[@class="show-more-less-html__markup show-more-less-html__markup--clamp-after-5"]/text()').extract()
        seniority_level = response.xpath('//span[@class="job-criteria__text job-criteria__text--criteria"]/text()').extract()[0]
        employment_type = response.xpath('//span[@class="job-criteria__text job-criteria__text--criteria"]/text()').extract()[1]
        job_function = response.xpath('//span[@class="job-criteria__text job-criteria__text--criteria"]/text()').extract()[2]
        industries = response.xpath('//span[@class="job-criteria__text job-criteria__text--criteria"]/text()').extract()[3]

        item = ScrapyappItem()
        item['job_title'] = job_title
        item['company'] = company
        item['location'] = location
        item['description'] = description
        item['date_posted'] = posted_time
        item['seniority_level'] = seniority_level
        item['employment_type'] = employment_type
        item['industries'] = job_function
        item['job_function'] = industries

        yield item