rm(list = ls()) #clear workspace

#setwd("x://Files/Teaching/Data Science and Marketing Analytics (EBM165A05)/2016-2017/Session 04/") #set working directory


#load data
chocolate <- read.csv("chocolate_dataset.csv", header = TRUE)
chocolate <- subset(chocolate, select = c(sales,price1,display1,temp)) #retain only four variables

summary(chocolate) #summary of data

hist(chocolate$sales) #histogram of sales
hist(chocolate$price) #histogram of price1
boxplot(chocolate$sales) #boxplot of sales
boxplot(chocolate$price1) #boxplot of price1

plot(chocolate$price1,chocolate$sales) #scatter plot

#estimate model on all data:
FullDataModel <- lm(sales~price1+display1+temp,data=chocolate)
summary(FullDataModel)

library(missForest) #load library - in case of error: install it first via Tools>Install Packages

#create missing values ( 20% )
chocolate.mis <- prodNA(chocolate, noNA = 0.2)
summary(chocolate.mis)

typeof(chocolate.mis)

#estimate listwise deletion model
ListwiseDeletionModel <- lm(sales~price1+display1+temp,data=chocolate.mis)
summary(ListwiseDeletionModel)

#use MICE library
library(mice)

#inspect pattern of missings
md.pattern(chocolate.mis)

#impute data
MiceImputedData <- mice(chocolate.mis, m=5, maxit = 50, method = 'pmm', seed = 500)
summary(MiceImputedData)


test_chocolate <- chocolate.mis %>% select(temp) %>% distinct
typeof(test_chocolate$temp)

#get complete data set ( 2nd out of 5)
MiceCompleteData <- complete(MiceImputedData,2)

#estimate imputed model
MiceModel <- lm(sales~price1+display1+temp,data=MiceCompleteData)
summary(MiceModel)

#build predictive model for all generated imputed data sets
MiceAllModels <- with(data = MiceImputedData, exp = lm(sales ~ price1 + display1 + temp)) 

#combine results of all 5 models
MiceCombineModels <- pool(MiceAllModels)
summary(MiceCombineModels)


#impute missing values, using all parameters as default values
missForestImputeData <- missForest(chocolate.mis)

#check imputation error
missForestImputeData$OOBerror
#NRMSE is normalized mean squared error. It is used to represent error derived from imputing continuous values. PFC (proportion of falsely classified) is used to represent error derived from imputing categorical values.

#check imputed values
missForestCompleteData <- missForestImputeData$ximp

missForestModel <- lm(sales~price1+display1+temp,data=missForestCompleteData)
summary(missForestModel)

