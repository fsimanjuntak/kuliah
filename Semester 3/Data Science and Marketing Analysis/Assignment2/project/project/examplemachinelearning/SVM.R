############ SVM ###############
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
