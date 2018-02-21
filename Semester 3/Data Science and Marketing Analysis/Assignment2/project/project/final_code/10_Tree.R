ptm <- proc.time()

library(rpart)				        # Popular decision tree algorithm
library(rattle)					# Fancy tree plot
library(rpart.plot)				# Enhanced tree plots
library(RColorBrewer)				# Color selection for fancy tree plot
library(party)					# Alternative decision tree algorithm
library(partykit)				# Convert rpart object to BinaryTree
library(caret)					# Just a data source for t
tree.2 <- rpart(BaseFormula,x.train)			# A more reasonable tree
x.evaluate$predictionTree <- predict(tree.2, newdata = x.evaluate, type = "vector")

x.evaluate$predictionTreeString[x.evaluate$predictionTree==1]="Buy"
x.evaluate$predictionTreeString[x.evaluate$predictionTree==2]="NotBuy"

x.evaluate$correctTree <- x.evaluate$predictionTreeString == x.evaluate$SaleStringWithoutConvertingToFactor
print(paste("% of predicted classifications correct", mean(x.evaluate$correctTree)))

x.evaluate$probabilitiesTree <- predict(tree.2, newdata = x.evaluate, type = "prob")[,1]

TreeOutput <- makeLiftPlot(x.evaluate$probabilitiesTree,x.evaluate,"Tree")

TimeAux <- proc.time() - ptm 
TreeOutput$TimeElapsed <- TimeAux[3]
TreeOutput$PercCorrect <- mean(x.evaluate$correctTree)*100
rm(TimeAux)

#update machine laerning properties
newmachinelearningproperties <- getMachineLearningProperties("Tree",TreeOutput)
machinelearning.properties <- rbind(machinelearning.properties,newmachinelearningproperties)
#Save again the training and evaluation set so the output of your model can be loaded later
write.csv(machinelearning.properties, file = "datasets/ml_performances")
