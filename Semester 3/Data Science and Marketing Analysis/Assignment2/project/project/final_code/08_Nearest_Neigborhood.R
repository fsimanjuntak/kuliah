## Nearest Neighbour ##
library(caret)

ptm <- proc.time()

NearN <- knn3(BaseFormula, data=x.train, k=10, prob = FALSE, use.all = TRUE)
x.evaluate$predictionNearN <- predict(NearN, newdata = x.evaluate, type="class")
x.evaluate$correctNearN <- x.evaluate$predictionNearN == x.evaluate$SaleString

print(paste("% of predicted classifications correct", mean(x.evaluate$correctNearN)))
x.evaluate$probabilitiesNearN <- predict(NearN, newdata = x.evaluate, type="prob")[,1]
NearNOutput <- makeLiftPlot(x.evaluate$probabilitiesNearN,x.evaluate,"Nearest Neighbour")

TimeAux <- proc.time() - ptm 
NearNOutput$TimeElapsed <- TimeAux[3]
NearNOutput$PercCorrect <- mean(x.evaluate$correctNearN)*100
rm(TimeAux)

#update machine laerning properties
newmachinelearningproperties <- getMachineLearningProperties("Nearest Neighbour",NearNOutput)
machinelearning.properties <- rbind(machinelearning.properties,newmachinelearningproperties)
#Save again the training and evaluation set so the output of your model can be loaded later
write.csv(machinelearning.properties, file = "datasets/ml_performances")

