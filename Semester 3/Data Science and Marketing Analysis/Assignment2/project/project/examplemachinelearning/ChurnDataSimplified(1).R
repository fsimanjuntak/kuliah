rm(list = ls()) #clear workspace

setwd("x://Assignment2/") #set working directory
Churn_data <- read.csv("Churn.csv",header=TRUE) #read csv file

Churn_data$ChurnString[Churn_data$Churn==1]="Churn"
Churn_data$ChurnString[Churn_data$Churn==0]="Stay"
Churn_data$ChurnString <- as.factor(Churn_data$ChurnString)
Churn_data$ChurnString <- relevel(Churn_data$ChurnString,ref="Churn")

# Split randomly
x <- Churn_data[sample(1:nrow(Churn_data), nrow(Churn_data), replace = F),]
x.train <- x[1:floor(nrow(x)*.75), ]
x.evaluate <- x[(floor(nrow(x)*.75)+1):nrow(x), ]

makeLiftPlot <- function(Prediction, Evaluate, ModelName){
  iPredictionsSorted <- sort(Prediction,index.return=T,decreasing=T)[2]$ix #extract the index order according to predicted retention
  CustomersSorted <- Evaluate$ChurnString[iPredictionsSorted] #sort the true behavior of customers according to predictions
  SumChurnReal<- sum(Evaluate$ChurnString == "Churn") #total number of real churners in the evaluation set
  CustomerCumulative=seq(nrow(Evaluate))/nrow(Evaluate) #cumulative fraction of customers
  ChurnCumulative=apply(matrix(CustomersSorted=="Churn"),2,cumsum)/SumChurnReal #cumulative fraction of churners
  ProbTD = sum(CustomersSorted[1:floor(nrow(Evaluate)*.1)]=="Churn")/floor(nrow(Evaluate)*.1) #probability of churn in 1st decile
  ProbOverall = SumChurnReal / nrow(Evaluate) #overall churn probability
  TDL = ProbTD / ProbOverall
  GINI = sum((ChurnCumulative-CustomerCumulative)/(t(matrix(1,1,nrow(Evaluate))-CustomerCumulative)),na.rm=T)/nrow(Evaluate)
  plot(CustomerCumulative,ChurnCumulative,type="l",main=paste("Lift curve of", ModelName),xlab="Cumulative fraction of customers (sorted by predicted churn probability)",ylab="Cumulative fraction of churners")
  lines(c(0,1),c(0,1),col="blue",type="l",pch=22, lty=2)
  legend(.66,.2,c("According to model","Random selection"),cex=0.8,  col=c("black","blue"), lty=1:2)
  text(0.15,1,paste("TDL = ",round(TDL,2), "; GINI = ", round(GINI,2) ))
  return(data.frame(TDL,GINI))
}

BaseFormula <- as.formula(ChurnString ~ AccountLength + IntlPlan + VMailPlan + VMailMessage + DayCharge + EveCharge + NightCharge + IntlCharge + CustServCalls)
BaseFormula1 <- as.formula(Churn ~ AccountLength + IntlPlan + VMailPlan + VMailMessage + DayCharge + EveCharge + NightCharge + IntlCharge + CustServCalls)


######### LOGIT
Churn_logit <- glm(BaseFormula1 , data = x.train, family = "binomial")

summary(Churn_logit)

x.evaluate$predictionlogit <- predict(Churn_logit, newdata=x.evaluate, type = "response")
x.evaluate$predictionlogitclass[x.evaluate$predictionlogit>.5] <- "Churn"
x.evaluate$predictionlogitclass[x.evaluate$predictionlogit<=.5] <- "Stay"

x.evaluate$correctlogit <- x.evaluate$predictionlogitclass == x.evaluate$ChurnString
print(paste("% of predicted classifications correct", mean(x.evaluate$correctlogit)))
LogitOutput <- makeLiftPlot(x.evaluate$predictionlogit,x.evaluate,"Logit")

LogitOutput$PercCorrect <- mean(x.evaluate$correctlogit)*100


############ SVM
library(e1071)
Churn_SVM <- svm(BaseFormula , data = x.train, probability=T)
summary(Churn_SVM)

x.evaluate$predictionSVM <- predict(Churn_SVM, newdata=x.evaluate, probability = T)

x.evaluate$correctSVM <- x.evaluate$predictionSVM == x.evaluate$ChurnString
print(paste("% of predicted classifications correct", mean(x.evaluate$correctSVM)))

# Extract the class probabilities.
x.evaluate$probabilitiesSVM <- attr(x.evaluate$predictionSVM,"probabilities")[,2]

SVMOutput <- makeLiftPlot(x.evaluate$probabilitiesSVM,x.evaluate,"SVM")

########## Neural network
library(nnet)
library(caret)

x.modelNNet <- train(BaseFormula, data=x.train, method='nnet', trControl=trainControl(method='cv')) 

x.evaluate$predictionNNet <- predict(x.modelNNet, newdata = x.evaluate, type="raw")
x.evaluate$correctNNet <- x.evaluate$predictionNNet == x.evaluate$ChurnString
print(paste("% of predicted classifications correct", mean(x.evaluate$correctNNet)))

#library(devtools)
#source_url('https://gist.githubusercontent.com/fawda123/7471137/raw/466c1474d0a505ff044412703516c34f1a4684a5/nnet_plot_update.r')
#plot.nnet(x.modelNNet)

x.evaluate$probabilitiesNNet <- predict(x.modelNNet, newdata = x.evaluate, type='prob')[,1]

NNetOutput <- makeLiftPlot(x.evaluate$probabilitiesNNet,x.evaluate,"Neural Network")

