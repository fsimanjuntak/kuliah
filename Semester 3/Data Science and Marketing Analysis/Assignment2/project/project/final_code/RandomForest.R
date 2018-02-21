############ RANDOM FOREST
ptm <- proc.time()
# Create a model using "random forest and bagging ensemble algorithms
library(randomForest)

x.modelRF <- randomForest(BaseFormula, data=x.train, control = cforest_unbiased(mtry = 3)) 

# Use the model to predict the evaluation.
x.evaluate$predictionRF <- predict(x.modelRF, newdata=x.evaluate, type = "response")

# Calculate the overall accuracy.
x.evaluate$correctRF <- x.evaluate$predictionRF == x.evaluate$SaleString
print(paste("% of predicted classifications correct", mean(x.evaluate$correctRF)))

# Extract the class probabilities.
x.evaluate$probabilitiesRF <- predict(x.modelRF,newdata=x.evaluate,type="prob")[,1]
RFOutput <- makeLiftPlot(x.evaluate$probabilitiesRF,x.evaluate,"Random Forest")

TimeAux <- proc.time() - ptm 
RFOutput$TimeElapsed <- TimeAux[3]
RFOutput$PercCorrect <- mean(x.evaluate$correctRF)*100
rm(TimeAux)

#update machine laerning properties
newmachinelearningproperties <- getMachineLearningProperties("Random Forest",RFOutput)
machinelearning.properties <- rbind(machinelearning.properties,newmachinelearningproperties)
#Save again the training and evaluation set so the output of your model can be loaded later
write.csv(machinelearning.properties, file = "datasets/ml_performances")
