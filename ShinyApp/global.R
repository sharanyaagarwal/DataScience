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

Startup_Data <- Startup_Data %>% mutate(employeePerYear = case_when(`Employee Count` >= 0  & `Employee Count` <= 10 ~ '0-10',
                                                                `Employee Count` >= 11  & `Employee Count` <= 20 ~ '11-20',
                                                                `Employee Count` >= 21  & `Employee Count` <= 30 ~ '21-30',
                                                                `Employee Count` >= 31 & `Employee Count` <= 40 ~ '31-40',
                                                                `Employee Count` >= 41 & `Employee Count` <= 50 ~ '41-50',
                                                                `Employee Count` >= 51 & `Employee Count` <= 60 ~ '51-60',
                                                                `Employee Count` >= 61 & `Employee Count` <= 70 ~ '61-70',
                                                                `Employee Count` >= 71 & `Employee Count` <= 80 ~ '71-80',
                                                                `Employee Count` >= 81 & `Employee Count` <= 90 ~ '81-90',
                                                                `Employee Count` >= 91 & `Employee Count` <= 100 ~ '91-100',
                                                                `Employee Count` >= 101  & `Employee Count` <= 110 ~ '101-110',
                                                                `Employee Count` >= 111  & `Employee Count` <= 120 ~ '111-120',
                                                                `Employee Count` >= 121 & `Employee Count` <= 130 ~ '121-130',
                                                                `Employee Count` >= 131 & `Employee Count` <= 140 ~ '131-140',
                                                                `Employee Count` >= 141 & `Employee Count` <= 150 ~ '141-150',
                                                                `Employee Count` >= 151 & `Employee Count` <= 160 ~ '151-160',
                                                                `Employee Count` >= 161 & `Employee Count` <= 170 ~ '161-170',
                                                                `Employee Count` >= 171 & `Employee Count` <= 180 ~ '171-180',
                                                                `Employee Count` >= 181 & `Employee Count` <= 190 ~ '181-190',
                                                                `Employee Count` >= 191 ~ '190+'))

dfAgeCompany <- Startup_Data %>% group_by(`ageCategory`) %>% summarise(success = sum(`Dependent-Company Status` == "Success"), failed = sum(`Dependent-Company Status` == "Failed"))
dfEmployeeYearly <- Startup_Data %>% group_by(`employeePerYear`) %>% summarise(success = sum(`Dependent-Company Status` == "Success"), failed = sum(`Dependent-Company Status` == "Failed"))

gartner <- Startup_Data %>% group_by(`Gartner hype cycle stage`, `Dependent-Company Status`) %>% summarise(n = n())

v <- Startup_Data %>% select(`Last Funding Amount`, `Dependent-Company Status`)

yearsOfExp <- Startup_Data %>% group_by(`Average Years of experience for founder and co founder`, `Dependent-Company Status`) %>% summarise(n = n())
higherEd <- Startup_Data %>% group_by(`Highest education`, `Dependent-Company Status`) %>% summarise(n = n())
pastStartups <- Startup_Data %>% group_by(`Have been part of successful startups in the past?`, `Dependent-Company Status`) %>% summarise(n = n())

teamScore <- Startup_Data %>% group_by(`Team Composition score`, `Dependent-Company Status`) %>% summarise(n = n())

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