rm(list = ls()) #clear workspace

setwd("x://My Downloads") #set working directory
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
ptm <- proc.time()
Churn_logit <- glm(BaseFormula1 , data = x.train, family = "binomial")

summary(Churn_logit)

x.evaluate$predictionlogit <- predict(Churn_logit, newdata=x.evaluate, type = "response")
x.evaluate$predictionlogitclass[x.evaluate$predictionlogit>.5] <- "Churn"
x.evaluate$predictionlogitclass[x.evaluate$predictionlogit<=.5] <- "Stay"

x.evaluate$correctlogit <- x.evaluate$predictionlogitclass == x.evaluate$ChurnString
print(paste("% of predicted classifications correct", mean(x.evaluate$correctlogit)))
LogitOutput <- makeLiftPlot(x.evaluate$predictionlogit,x.evaluate,"Logit")

TimeAux <- proc.time() - ptm 
LogitOutput$TimeElapsed <- TimeAux[3]
LogitOutput$PercCorrect <- mean(x.evaluate$correctlogit)*100
rm(TimeAux)

## Nearest Neighbour


#BaseVariables.train <- cbind(x.train$AccountLength,x.train$IntlPlan,x.train$VMailPlan,x.train$VMailMessage,x.train$DayCharge,x.train$EveCharge,x.train$NightCharge,x.train$IntlCharge,x.train$CustServCalls)
#BaseVariables.evaluate <- cbind(x.evaluate$AccountLength,x.evaluate$IntlPlan,x.evaluate$VMailPlan,x.evaluate$VMailMessage,x.evaluate$DayCharge,x.evaluate$EveCharge,x.evaluate$NightCharge,x.evaluate$IntlCharge,x.evaluate$CustServCalls)

library(caret)

ptm <- proc.time()

NearN <- knn3(BaseFormula, data=x.train, k=10, prob = FALSE, use.all = TRUE)

x.evaluate$predictionNearN <- predict(NearN, newdata = x.evaluate, type="class")
x.evaluate$correctNearN <- x.evaluate$predictionNearN == x.evaluate$ChurnString
print(paste("% of predicted classifications correct", mean(x.evaluate$correctNearN)))
x.evaluate$probabilitiesNearN <- predict(NearN, newdata = x.evaluate, type="prob")[,1]
NearNOutput <- makeLiftPlot(x.evaluate$probabilitiesNearN,x.evaluate,"Nearest Neighbour")

TimeAux <- proc.time() - ptm 
NearNOutput$TimeElapsed <- TimeAux[3]
NearNOutput$PercCorrect <- mean(x.evaluate$correctNearN)*100
rm(TimeAux)



## Naive Bayes
ptm <- proc.time()
install.packages(e1071)
library(e1071)
classifier<-naiveBayes(BaseFormula,data=x.train) 
naiveBayesCorrect <- table(predict(classifier, x.evaluate[,1:20]), x.evaluate[,22])
#naiveBayesCorrect1 <- table(predict(classifier, newdata=x.evaluate))

print(paste("% of predicted classifications correct", sum(diag(naiveBayesCorrect))/sum(naiveBayesCorrect) )) 
naiveBayesPredict <- predict(classifier, x.evaluate[,1:20], type = "raw")
naiveBayesOutput <- makeLiftPlot(naiveBayesPredict[,1],x.evaluate,"Naive Bayes")

TimeAux <- proc.time() - ptm 
naiveBayesOutput$TimeElapsed <- TimeAux[3]
naiveBayesOutput$PercCorrect <- sum(diag(naiveBayesCorrect))/sum(naiveBayesCorrect)*100
rm(TimeAux)

############ SVM
ptm <- proc.time()
Churn_SVM <- svm(BaseFormula , data = x.train, probability=T)
summary(Churn_SVM)

x.evaluate$predictionSVM <- predict(Churn_SVM, newdata=x.evaluate, probability = T)

x.evaluate$correctSVM <- x.evaluate$predictionSVM == x.evaluate$ChurnString
print(paste("% of predicted classifications correct", mean(x.evaluate$correctSVM)))

# Extract the class probabilities.
x.evaluate$probabilitiesSVM <- attr(x.evaluate$predictionSVM,"probabilities")[,2]

SVMOutput <- makeLiftPlot(x.evaluate$probabilitiesSVM,x.evaluate,"SVM")

TimeAux <- proc.time() - ptm 
SVMOutput$TimeElapsed <- TimeAux[3]
SVMOutput$PercCorrect <- mean(x.evaluate$correctSVM)*100
rm(TimeAux)

########## TREE
ptm <- proc.time()

library(rpart)				        # Popular decision tree algorithm
library(rattle)					# Fancy tree plot
library(rpart.plot)				# Enhanced tree plots
#library(RColorBrewer)				# Color selection for fancy tree plot
#library(party)					# Alternative decision tree algorithm
#library(partykit)				# Convert rpart object to BinaryTree
#library(caret)					# Just a data source for t

tree.2 <- rpart(BaseFormula,x.train)			# A more reasonable tree
#prp(tree.2)                                 # A fast plot													
#fancyRpartPlot(tree.2)				# A fancy plot from rat
#plot(tree.2)

x.evaluate$predictionTree <- predict(tree.2, newdata = x.evaluate, type = "vector")

x.evaluate$predictionTreeString[x.evaluate$predictionTree==1]="Churn"
x.evaluate$predictionTreeString[x.evaluate$predictionTree==2]="Stay"

x.evaluate$predictionTreeString <- as.factor(x.evaluate$predictionTreeString)

x.evaluate$correctTree <- x.evaluate$predictionTreeString == x.evaluate$ChurnString
print(paste("% of predicted classifications correct", mean(x.evaluate$correctTree)))

x.evaluate$probabilitiesTree <- predict(tree.2, newdata = x.evaluate, type = "prob")[,1]

TreeOutput <- makeLiftPlot(x.evaluate$probabilitiesTree,x.evaluate,"Tree")

TimeAux <- proc.time() - ptm 
TreeOutput$TimeElapsed <- TimeAux[3]
TreeOutput$PercCorrect <- mean(x.evaluate$correctTree)*100
rm(TimeAux)

############ Bagging
ptm <- proc.time()
# Create a model using bagging ensemble algorithms
library(adabag)
library(party)

#Model1 
x.modelBagging  <- bagging(BaseFormula, data=x.train, control = cforest_unbiased(mtry = 3))

# Use the model to predict the evaluation.
x.evaluate$predictionBagging <- predict(x.modelBagging, newdata=x.evaluate)$class

# Calculate the overall accuracy.
x.evaluate$correctBagging <- x.evaluate$predictionBagging == x.evaluate$ChurnString
print(paste("% of predicted classifications correct", mean(x.evaluate$correctBagging)))

# Extract the class probabilities.
x.evaluate$probabilitiesBagging <- predict(x.modelBagging,newdata=x.evaluate)$prob[,1]

BaggingOutput <- makeLiftPlot(x.evaluate$probabilitiesBagging,x.evaluate,"Bagging")

TimeAux <- proc.time() - ptm 
BaggingOutput$TimeElapsed <- TimeAux[3]
BaggingOutput$PercCorrect <- mean(x.evaluate$correctBagging)*100
rm(TimeAux)

############ Boosting
ptm <- proc.time()
# Create a model using boosting ensemble algorithms

#Model1 
x.modelBoosting  <- boosting(BaseFormula, data=x.train, control = cforest_unbiased(mtry = 3))

# Use the model to predict the evaluation.
x.evaluate$predictionBoosting <- predict(x.modelBoosting, newdata=x.evaluate)$class

# Calculate the overall accuracy.
x.evaluate$correctBoosting <- x.evaluate$predictionBoosting == x.evaluate$ChurnString
print(paste("% of predicted classifications correct", mean(x.evaluate$correctBoosting)))

# Extract the class probabilities.
x.evaluate$probabilitiesBoosting <- predict(x.modelBoosting,newdata=x.evaluate)$prob[,1]

# Make a lift curve

BoostingOutput <- makeLiftPlot(x.evaluate$probabilitiesBoosting,x.evaluate,"Boosting")

TimeAux <- proc.time() - ptm 
BoostingOutput$TimeElapsed <- TimeAux[3]
BoostingOutput$PercCorrect <- mean(x.evaluate$correctBoosting)*100
rm(TimeAux)

############ RANDOM FOREST
ptm <- proc.time()
# Create a model using "random forest and bagging ensemble algorithms
library(randomForest)

x.modelRF <- randomForest(BaseFormula, data=x.train, control = cforest_unbiased(mtry = 3)) 

# Use the model to predict the evaluation.
x.evaluate$predictionRF <- predict(x.modelRF, newdata=x.evaluate, type = "response")

# Calculate the overall accuracy.
x.evaluate$correctRF <- x.evaluate$predictionRF == x.evaluate$ChurnString
print(paste("% of predicted classifications correct", mean(x.evaluate$correctRF)))

# Extract the class probabilities.
x.evaluate$probabilitiesRF <- predict(x.modelRF,newdata=x.evaluate,type="prob")[,1]

RFOutput <- makeLiftPlot(x.evaluate$probabilitiesRF,x.evaluate,"Random Forest")

TimeAux <- proc.time() - ptm 
RFOutput$TimeElapsed <- TimeAux[3]
RFOutput$PercCorrect <- mean(x.evaluate$correctRF)*100
rm(TimeAux)

########## Neural network
ptm <- proc.time()
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

TimeAux <- proc.time() - ptm 
NNetOutput$TimeElapsed <- TimeAux[3]
NNetOutput$PercCorrect <- mean(x.evaluate$correctNNet)*100
rm(TimeAux)


# SOME Summarizing plots:

#barplot(c(LogitOutput$TDL,naiveBayesOutput$TDL, SVMOutput$TDL,TreeOutput$TDL,BaggingOutput$TDL,BoostingOutput$TDL,RFOutput$TDL,NNetOutput$TDL), names.arg = c("Logit","Naive Bayes","SVM","Tree","Bagging","Boosting","Random Forest","Neural Network"), main="Top Decile Lifts of the models")
#barplot(c(LogitOutput$GINI,naiveBayesOutput$GINI, SVMOutput$GINI,TreeOutput$GINI,BaggingOutput$GINI,BoostingOutput$GINI,RFOutput$GINI,NNetOutput$GINI), names.arg = c("Logit","Naive Bayes","SVM","Tree","Bagging","Boosting","Random Forest","Neural Network"), main="GINI coefficients of the models")

OverallTDL <- c(LogitOutput$TDL,NearNOutput$TDL,naiveBayesOutput$TDL,SVMOutput$TDL,TreeOutput$TDL,BaggingOutput$TDL,BoostingOutput$TDL,RFOutput$TDL,NNetOutput$TDL)
OverallGINI <- c(LogitOutput$GINI,NearNOutput$GINI,naiveBayesOutput$GINI,SVMOutput$GINI,TreeOutput$GINI,BaggingOutput$GINI,BoostingOutput$GINI,RFOutput$GINI,NNetOutput$GINI)

ForGraph <- data.frame(OverallTDL,OverallGINI)

myLeftAxisLabs <- pretty(seq(0, max(ForGraph$OverallTDL), length.out = 10))
myRightAxisLabs <- pretty(seq(0, max(ForGraph$OverallGINI), length.out = 10))

myLeftAxisAt <- myLeftAxisLabs/max(ForGraph$OverallTDL)
myRightAxisAt <- myRightAxisLabs/max(ForGraph$OverallGINI)

ForGraph$OverallTDL1 <- ForGraph$OverallTDL/max(ForGraph$OverallTDL)
ForGraph$OverallGINI1 <- ForGraph$OverallGINI/max(ForGraph$OverallGINI)

op <- par(mar = c(5,4,4,4) + 0.1)

barplot(t(as.matrix(ForGraph[, c("OverallTDL1", "OverallGINI1")])), beside = TRUE, yaxt = "n", names.arg = c("Logit","N. Neighbour", "Naive Bayes","SVM","Tree","Bagging","Boosting","Random Forest","Neural Network"), ylim=c(0, max(c(myLeftAxisAt, myRightAxisAt))), ylab =	"Top Decile Lift", legend = c("TDL","GINI"), main="Performance of the Machine Learning Algorithms")

axis(2, at = myLeftAxisAt, labels = myLeftAxisLabs)

axis(4, at = myRightAxisAt, labels = myRightAxisLabs)

mtext("GINI Coefficient", side = 4, line = 3, cex = par("cex.lab"))

mtext(c(paste(round(LogitOutput$TimeElapsed,digits=2),"sec"),
        paste(round(NearNOutput$TimeElapsed,digits=2),"sec"),
        paste(round(naiveBayesOutput$TimeElapsed,digits=2),"sec"),
        paste(round(SVMOutput$TimeElapsed,digits=2),"sec"),
        paste(round(TreeOutput$TimeElapsed,digits=2),"sec"),
        paste(round(BaggingOutput$TimeElapsed,digits=2),"sec"),
        paste(round(BoostingOutput$TimeElapsed,digits=2),"sec"),
        paste(round(RFOutput$TimeElapsed,digits=2),"sec"),
        paste(round(NNetOutput$TimeElapsed,digits=2),"sec")), side = 1, line = 3, cex = par("cex.lab"), at = c(2,5,8,11,14,17,20,23,26))
mtext(c(paste(round(LogitOutput$PercCorrect,digits=0),"%"),
        paste(round(NearNOutput$PercCorrect,digits=0),"%"),
        paste(round(naiveBayesOutput$PercCorrect,digits=0),"%"),
        paste(round(SVMOutput$PercCorrect,digits=0),"%"),
        paste(round(TreeOutput$PercCorrect,digits=0),"%"),
        paste(round(BaggingOutput$PercCorrect,digits=0),"%"),
        paste(round(BoostingOutput$PercCorrect,digits=0),"%"),
        paste(round(RFOutput$PercCorrect,digits=0),"%"),
        paste(round(NNetOutput$PercCorrect,digits=0),"%")), side = 1, line = 4, cex = par("cex.lab"), at = c(2,5,8,11,14,17,20,23,26))

mtext("Calc. time", side = 1, line = 3, cex = par("cex.lab"), at = -.8)
mtext("% correct", side = 1, line = 4, cex = par("cex.lab"), at = -.8)

#par(op)
#uu <- cbind(apply(Churn_data,2,min),apply(Churn_data,2,max),sapply(Churn_data,mean),sapply(Churn_data,sd))
#as.matrix(apply(Churn_data,2,min))
#as.matrix(sapply(Churn_data,mean))
#as.matrix(sapply(Churn_data,sd))

#save(list = ls(), file = "Boekdata")