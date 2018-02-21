## Naive Bayes
ptm <- proc.time()
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
