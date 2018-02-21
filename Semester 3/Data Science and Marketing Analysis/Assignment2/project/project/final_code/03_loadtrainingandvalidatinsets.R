#################### Load Training and Validation Set ####################################
#clear workspace
rm(list = ls())
#set working directory
setwd("~/Desktop/Kuliah/Semester 3/Data Science and Marketing Analysis/Assignment2/project/project/final_code")
#load library
library(dplyr)
#load training set
x.temptrain  <- read.csv("datasets/trainingset.csv",header=TRUE)
#load evaluation set
x.tempevaluate <- read.csv("datasets/evaluationset.csv",header=TRUE)

#Define a function lo create a liftplot
makeLiftPlot <- function(Prediction, Evaluate, ModelName){
  iPredictionsSorted <- sort(Prediction,index.return=T,decreasing=T)[2]$ix #extract the index order according to predicted retention
  CustomersSorted <- Evaluate$SaleString[iPredictionsSorted] #sort the true behavior of customers according to predictions
  SumChurnReal<- sum(Evaluate$SaleString == "Sale") #total number of real churners in the evaluation set
  CustomerCumulative=seq(nrow(Evaluate))/nrow(Evaluate) #cumulative fraction of customers
  ChurnCumulative=apply(matrix(CustomersSorted=="Sale"),2,cumsum)/SumChurnReal #cumulative fraction of churners
  ProbTD = sum(CustomersSorted[1:floor(nrow(Evaluate)*.1)]=="Sale")/floor(nrow(Evaluate)*.1) #probability of churn in 1st decile
  ProbOverall = SumChurnReal / nrow(Evaluate) #overall churn probability
  TDL = ProbTD / ProbOverall
  GINI = sum((ChurnCumulative-CustomerCumulative)/(t(matrix(1,1,nrow(Evaluate))-CustomerCumulative)),na.rm=T)/nrow(Evaluate)
  plot(CustomerCumulative,ChurnCumulative,type="l",main=paste("Lift curve of", ModelName),xlab="Cumulative fraction of session (sorted by predicted  sale probability)",ylab="Cumulative fraction of sales")
  lines(c(0,1),c(0,1),col="blue",type="l",pch=22, lty=2)
  legend(.66,.2,c("According to model","Random selection"),cex=0.8,  col=c("black","blue"), lty=1:2)
  text(0.15,1,paste("TDL = ",round(TDL,2), "; GINI = ", round(GINI,2) ))
  return(data.frame(TDL,GINI))
}

#FG_avg_wind+SQ_sunshine+RH_precipitation+NG_avg_cloud+UG_humidity

#BaseFormula <- as.formula(SaleString ~ views + carts + abandon + sale + remove+ startyear+ 
#                            birthyear+avgprice+gender+TG_avg_temp+
#                            FG_avg_wind+SQ_sunshine+RH_precipitation+NG_avg_cloud+UG_humidity)
#BaseFormula1 <- as.formula(IsSale ~ views + carts + abandon + sale + remove+ startyear+ 
#                             birthyear+avgprice+gender+TG_avg_temp+
#                             FG_avg_wind+SQ_sunshine+RH_precipitation+NG_avg_cloud+UG_humidity)

#+SQ_sunshine+RH_precipitation+NG_avg_cloud+UG_humidity

#BaseFormula <- as.formula(SaleString ~ views + carts + abandon  + remove+ startyear+ 
#                            birthyear+avgprice+gender+TG_avg_temp+
#                            FG_avg_wind)
#BaseFormula1 <- as.formula(IsSale ~ views + carts + abandon  + remove+ startyear+ 
#                             birthyear+avgprice+gender+TG_avg_temp+
#                             FG_avg_wind)


BaseFormula <- as.formula(SaleString ~ views + birthyear + startyear + numbersearches + avgprice + TG_avg_temp + FG_avg_wind + gender + subcategory + segment + articletype) 
BaseFormula1 <- as.formula(IsSale ~ views + birthyear + startyear + numbersearches + avgprice + TG_avg_temp + FG_avg_wind + gender + subcategory + segment + articletype)



x.train <- x.temptrain %>% select(views,carts, abandon,remove,startyear,birthyear,avgprice,gender,TG_avg_temp,FG_avg_wind, IsSale, SaleString)
x.evaluate <- x.tempevaluate %>% select(views,carts, abandon,remove,startyear,birthyear,avgprice,gender,TG_avg_temp,FG_avg_wind, IsSale, SaleString)

