#Machine Learning
#This code should be executed first before performing other techniques
rm(list = ls()) #clear workspace

Sessionlevel_data <- read.csv("MiceCompleteSessionData.csv",header=TRUE) #read csv file
Sessionlevel_data$SaleString <- ifelse(Sessionlevel_data$sale==1,"Sale","NotSale")

# Split randomly
x <- Sessionlevel_data[sample(1:nrow(Sessionlevel_data), nrow(Sessionlevel_data), replace = F),]
x.train <- x[1:floor(nrow(x)*.75), ]
x.evaluate <- x[(floor(nrow(x)*.75)+1):nrow(x), ]

makeLiftPlot <- function(Prediction, Evaluate, ModelName){
  iPredictionsSorted <- sort(Prediction,index.return=T,decreasing=T)[2]$ix #extract the index order according to predicted retention
  SessionSorted <- Evaluate$SaleString[iPredictionsSorted] #sort the true behavior of customers according to predictions
  SumSaleReal<- sum(Evaluate$SaleString == "Sale") #total number of real churners in the evaluation set
  TotalCumulative=seq(nrow(Evaluate))/nrow(Evaluate) #cumulative fraction of customers
  SaleCumulative=apply(matrix(SessionSorted=="Sale"),2,cumsum)/SumSaleReal #cumulative fraction of churners
  ProbTD = sum(SessionSorted[1:floor(nrow(Evaluate)*.1)]=="Sale")/floor(nrow(Evaluate)*.1) #probability of churn in 1st decile
  ProbOverall = SumSaleReal / nrow(Evaluate) #overall churn probability
  TDL = ProbTD / ProbOverall
  GINI = sum((SaleCumulative-TotalCumulative)/(t(matrix(1,1,nrow(Evaluate))-TotalCumulative)),na.rm=T)/nrow(Evaluate)
  plot(TotalCumulative,SaleCumulative,type="l",main=paste("Lift curve of", ModelName),xlab="Cumulative fraction of Session Data (sorted by predicted sale probability)",ylab="Cumulative fraction of churners")
  lines(c(0,1),c(0,1),col="blue",type="l",pch=22, lty=2)
  legend(.66,.2,c("According to model","Random selection"),cex=0.8,  col=c("black","blue"), lty=1:2)
  text(0.15,1,paste("TDL = ",round(TDL,2), "; GINI = ", round(GINI,2) ))
  return(data.frame(TDL,GINI))
}

BaseFormula <- as.formula(SaleString ~ datetime+ views + carts + abandon + sale + remove+ startyear+ birthyear+numbersearches+numberitems+avgprice+gender_bin+segment_bin+subcategory_bin+maingroup_bin+articlegroup_bin+articletype_bin+TG_avg_temp+TG_avg_temp+FG_avg_wind+SQ_sunshine+RH_precipitation+NG_avg_cloud+UG_humidity)
BaseFormula1 <- as.formula(issale ~ datetime+ views + carts + abandon + sale + remove+ startyear+ birthyear+numbersearches+numberitems+avgprice+gender_bin+segment_bin+subcategory_bin+maingroup_bin+articlegroup_bin+articletype_bin+TG_avg_temp+TG_avg_temp+FG_avg_wind+SQ_sunshine+RH_precipitation+NG_avg_cloud+UG_humidity)