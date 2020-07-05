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

Startup_Data$internet_score <- round((Startup_Data$`Internet Activity Score` - mean(Startup_Data$`Internet Activity Score`))/sd(Startup_Data$`Internet Activity Score`), 2)
Startup_Data$score_type <- ifelse(Startup_Data$`Internet Activity Score` < 0, "below", "above")
Startup_Data <- Startup_Data[order(Startup_Data$internet_score), ]
Startup_Data$`Company_Name` <- factor(Startup_Data$`Company_Name`, levels = Startup_Data$`Company_Name`)

Startup_Data <- Startup_Data %>% mutate(ageCategory = case_when(`Age of company in years` >= 0  & `Age of company in years` <= 2 ~ '0-2',
                                                                 `Age of company in years` >= 3  & `Age of company in years` <= 5 ~ '3-5',
                                                                 `Age of company in years` >= 6  & `Age of company in years` <= 8 ~ '6-8',
                                                                 `Age of company in years` >= 9 & `Age of company in years` <= 11 ~ '9-11',
                                                                 `Age of company in years` >= 12 & `Age of company in years` <= 14 ~ '12-14',
                                                                 `Age of company in years` >= 15 ~ '15+'))

dfAgeCompany <- Startup_Data %>% group_by(`ageCategory`) %>% summarise(success = sum(`Dependent-Company Status` == "Success"), failed = sum(`Dependent-Company Status` == "Failed"))

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