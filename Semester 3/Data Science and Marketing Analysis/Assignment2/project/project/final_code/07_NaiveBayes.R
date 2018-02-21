############ Naive Bayes ###############3
ptm <- proc.time()
library(e1071)
classifier<-naiveBayes(BaseFormula,data=x.train[,1:13]) 
naiveBayesCorrect <- table(predict(classifier, x.evaluate[,1:12]), x.evaluate[,13])

print(paste("% of predicted classifications correct", sum(diag(naiveBayesCorrect))/sum(naiveBayesCorrect) )) 
naiveBayesPredict <- predict(classifier, x.evaluate[,1:11], type = "raw")
naiveBayesOutput <- makeLiftPlot(naiveBayesPredict[,1],x.evaluate,"Naive Bayes")

TimeAux <- proc.time() - ptm 
naiveBayesOutput$TimeElapsed <- TimeAux[3]
naiveBayesOutput$PercCorrect <- sum(diag(naiveBayesCorrect))/sum(naiveBayesCorrect)*100
rm(TimeAux)

#update machine laerning properties
newmachinelearningproperties <- getMachineLearningProperties("Naive Bayes",naiveBayesOutput)
machinelearning.properties <- rbind(machinelearning.properties,newmachinelearningproperties)
#Save again the training and evaluation set so the output of your model can be loaded later
write.csv(machinelearning.properties, file = "datasets/ml_performances")


