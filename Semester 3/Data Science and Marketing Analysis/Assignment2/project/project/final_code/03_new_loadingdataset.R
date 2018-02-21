#################### Load Training and Validation Set ####################################
#clear workspace
rm(list = ls())
#set working directory
setwd("~/Desktop/Kuliah/Semester 3/Data Science and Marketing Analysis/Assignment2/project/project/final_code")
#load library
library(dplyr)
#load training set
x.train  <- read.csv("datasets/trainingset.csv",header=TRUE)
#load evaluation set
x.evaluate <- read.csv("datasets/evaluationset.csv",header=TRUE)

#convert categorical data to factor
x.train  <- x.train %>%
  mutate(gender = as.factor(gender)) %>% 
  mutate(subcategory = as.factor(subcategory)) %>% 
  mutate(articletype = as.factor(articletype)) %>%
  mutate(SaleString = as.factor(SaleString))

x.evaluate  <- x.evaluate %>%
  mutate(gender = as.factor(gender)) %>% 
  mutate(subcategory = as.factor(subcategory)) %>% 
  mutate(articletype = as.factor(articletype)) %>%
  mutate(SaleString = as.factor(SaleString))

#create a dataframe to add the performance of each model
machinelearning.properties <- data.frame(Predictor=character(),
                                         TDL = double(),
                                         GiniIndex = double(),
                                         TimeElapsed= double(),
                                         PercCorrect = double())

makeLiftPlot <- function(Prediction, Evaluate, ModelName){
  iPredictionsSorted <- sort(Prediction,index.return=T,decreasing=T)[2]$ix 
  CustomersSorted <- Evaluate$SaleString[iPredictionsSorted] 
  SumSaleReal<- sum(Evaluate$SaleString == "Buy") 
  CustomerCumulative=seq(nrow(Evaluate))/nrow(Evaluate) 
  SaleCumulative=apply(matrix(CustomersSorted=="Buy"),2,cumsum)/SumSaleReal 
  ProbTD = sum(CustomersSorted[1:floor(nrow(Evaluate)*.1)]=="Buy")/floor(nrow(Evaluate)*.1) 
  ProbOverall = SumSaleReal / nrow(Evaluate) 
  TDL = ProbTD / ProbOverall
  GINI = sum((SaleCumulative-CustomerCumulative)/(t(matrix(1,1,nrow(Evaluate))-CustomerCumulative)),na.rm=T)/nrow(Evaluate)
  plot(CustomerCumulative,SaleCumulative,type="l",main=paste("Lift curve of", ModelName),xlab="Cumulative fraction of customers (sorted by predicted sale probability)",ylab="Cumulative fraction of buyers")
  lines(c(0,1),c(0,1),col="blue",type="l",pch=22, lty=2)
  legend(.66,.2,c("According to model","Random selection"),cex=0.8,  col=c("black","blue"), lty=1:2)
  text(0.15,1,paste("TDL = ",round(TDL,2), "; GINI = ", round(GINI,2) ))
  return(data.frame(TDL,GINI))
}

getMachineLearningProperties <- function(predictorname,machinelearningoutput){
  return (data.frame(Predictor = predictorname, TDL = machinelearningoutput$TDL, GiniIndex = machinelearningoutput$GINI,
                                                                             TimeElapsed = machinelearningoutput$TimeElapsed,
                                                                             PercCorrect = machinelearningoutput$PercCorrect))
} 

BaseFormula <- as.formula(SaleString ~ views + remove + carts + birthyear + startyear + numbersearches + avgprice + TG_avg_temp +SQ_sunshine+ gender + subcategory + articletype) 
BaseFormula1 <- as.formula(IsSale ~  views + remove + carts + birthyear + startyear + numbersearches + avgprice + TG_avg_temp +SQ_sunshine+ gender + subcategory + articletype)

x.train$SaleStringWithoutConvertingToFactor <- ifelse(x.train$IsSale==1,"Buy","NotBuy")
x.evaluate$SaleStringWithoutConvertingToFactor <- ifelse(x.evaluate$IsSale==1,"Buy","NotBuy")

x.train <- x.train %>% select(views,remove,carts,birthyear,startyear,numbersearches,avgprice,TG_avg_temp,SQ_sunshine,gender,subcategory,articletype,SaleString,IsSale,SaleStringWithoutConvertingToFactor)
x.evaluate <- x.evaluate %>% select(views,remove,carts,birthyear,startyear,numbersearches,avgprice,TG_avg_temp,SQ_sunshine,gender,subcategory,articletype,SaleString,IsSale,SaleStringWithoutConvertingToFactor)


