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

