######################### Split datasest #################################
#clear workspace
rm(list = ls())
#set working directory
setwd("~/Desktop/Kuliah/Semester 3/Data Science and Marketing Analysis/Assignment2/project/project/final_code")
#load library
library(dplyr)

Sessionlevel_data <- read.csv("datasets/MiceCompleteSessionData.csv",header=TRUE) #read csv file
Sessionlevel_data$SaleString <- ifelse(Sessionlevel_data$IsSale==1,"Buy","NotBuy")

#convert categorical data to factor
Sessionlevel_data <- Sessionlevel_data %>%
  mutate(gender = as.factor(gender)) %>% 
  mutate(segment = as.factor(segment)) %>%
  mutate(subcategory = as.factor(subcategory)) %>% 
  mutate(maingroup = as.factor(maingroup)) %>% 
  mutate(articlegroup = as.factor(articlegroup)) %>% 
  mutate(articletype = as.factor(articletype)) %>%
  mutate(SaleString = as.factor(SaleString))

# Split datasets randomly into training and validation set
x <- Sessionlevel_data[sample(1:nrow(Sessionlevel_data), nrow(Sessionlevel_data), replace = F),]
x.train <- x[1:floor(nrow(x)*.75), ]
x.evaluate <- x[(floor(nrow(x)*.75)+1):nrow(x), ]

#Save the training and evaluation set to csv file
write.csv(x.train, file = "datasets/trainingset.csv")
write.csv(x.evaluate, file = "datasets/evaluationset.csv")