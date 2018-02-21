########## Neural network ############
library(nnet)
library(caret)

ptm <- proc.time()
x.modelNNet <- train(BaseFormula, data=x.train, method='nnet', trControl=trainControl(method='cv')) 

x.evaluate$predictionNNet <- predict(x.modelNNet, newdata = x.evaluate, type="raw")
x.evaluate$correctNNet <- x.evaluate$predictionNNet == x.evaluate$SaleString
print(paste("% of predicted classifications correct", mean(x.evaluate$correctNNet)))

x.evaluate$probabilitiesNNet <- predict(x.modelNNet, newdata = x.evaluate, type='prob')[,1]
NNetOutput <- makeLiftPlot(x.evaluate$probabilitiesNNet,x.evaluate,"Neural Network")

TimeAux <- proc.time() - ptm 
NNetOutput$TimeElapsed <- TimeAux[3]
NNetOutput$PercCorrect <- mean(x.evaluate$correctNNet)*100
rm(TimeAux)

#update machine laerning properties
newmachinelearningproperties <- getMachineLearningProperties("Neural Network",NNetOutput)
machinelearning.properties <- rbind(machinelearning.properties,newmachinelearningproperties)
#Save again the training and evaluation set so the output of your model can be loaded later
write.csv(machinelearning.properties, file = "datasets/ml_performances")

