library(readr)
library(wordcloud)
library(memoise)
library(dplyr)
library(tidyverse)
library(jsonlite)
library(sp)
library(wordcloud)
library(leaflet)
library(tm)
library(ggmap)
library(sf)

LinkedInJobs <- read_csv("jobs_with_location.csv")

dateposted <- LinkedInJobs %>% group_by(`Posted Time Ago`) %>% summarise(n = n())

jobFunction <- dplyr::count(LinkedInJobs, `Job Function`, sort = TRUE)
seniorityLevel <- dplyr::count(LinkedInJobs, `Seniority Level`, sort = TRUE)
employmentType <- dplyr::count(LinkedInJobs, `Employment Type`, sort = TRUE)
industries <- dplyr::count(LinkedInJobs, `Industries Sorted`, sort = TRUE)

getTermMatrix <- memoise(function(text){
  
  myCorpus = Corpus(VectorSource(text))
  myCorpus = tm_map(myCorpus, content_transformer(tolower))
  myCorpus = tm_map(myCorpus, removePunctuation)
  myCorpus = tm_map(myCorpus, removeNumbers)
  myCorpus = tm_map(myCorpus, removeWords,
                    c(stopwords("SMART"), "the", "and", "but"))
  
  myDTM = TermDocumentMatrix(myCorpus,
                             control = list(minWordLength = 1))
  
  m = as.matrix(myDTM)
  
  sort(rowSums(m), decreasing = TRUE)
})