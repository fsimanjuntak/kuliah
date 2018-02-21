############ Boosting
library(adabag)
library(party)
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