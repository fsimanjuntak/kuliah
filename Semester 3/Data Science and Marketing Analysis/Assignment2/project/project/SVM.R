############ SVM
library(e1071)
ptm <- proc.time()
Session_SVM <- svm(BaseFormula1 , data = x.train, probability=T)
summary(Session_SVM)

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

#update machine laerning properties
newmachinelearningproperties <- getMachineLearningProperties("Neural Network",NNetOutput)
machinelearning.properties <- rbind(machinelearning.properties,newmachinelearningproperties)
#Save again the training and evaluation set so the output of your model can be loaded later
write.csv(machinelearning.properties, file = "datasets/ml_performances")