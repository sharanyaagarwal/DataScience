library(memoise)
library(tm)
library(wordcloud)
library(readxl)
library(readr)
library(dplyr)
library(RColorBrewer)

myPalette <- brewer.pal(5, "Set2") 

Failed_Companies <- read_excel("Failed-Companies.xlsx")
Failed_Companies_Sorted <- read_excel("Failed-Companies_Sorted.xlsx")
Startup_Data <- read_csv("datasets_723212_1257436_CAX_Startup_Data.csv")

dfReasonsFailure <- dplyr::count(Failed_Companies_Sorted, Reason_Failure_Categorized, sort = TRUE)
dfYearDistinct <- Startup_Data %>% group_by(`year of founding`, `Focus functions of company`) %>% summarise(n = n())
Startup_Data <- read_csv("datasets_723212_1257436_CAX_Startup_Data.csv")
print(Startup_Data)
dfSuccessByYearIndustry <- Startup_Data %>% group_by(`Focus functions of company`, `year of founding`) %>% summarise(success = sum(`Dependent-Company Status` == "Success"), failed = sum(`Dependent-Company Status` == "Failed"))


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