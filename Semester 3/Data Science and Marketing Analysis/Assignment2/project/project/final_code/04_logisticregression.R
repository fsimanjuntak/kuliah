######### LOGIT ############
ptm <- proc.time()
Session_logit <- glm(BaseFormula1 , data = x.train, family = "binomial")
summary(Session_logit)

x.evaluate$predictionlogit <- predict(Session_logit, newdata=x.evaluate, type = "response")
x.evaluate$predictionlogitclass[x.evaluate$predictionlogit>.5] <- "Buy"
x.evaluate$predictionlogitclass[x.evaluate$predictionlogit<=.5] <- "NotBuy"

x.evaluate$correctlogit <- x.evaluate$predictionlogitclass == x.evaluate$SaleString
print(paste("% of predicted classifications correct", mean(x.evaluate$correctlogit)))
LogitOutput <- makeLiftPlot(x.evaluate$predictionlogit,x.evaluate,"Logit")

TimeAux <- proc.time() - ptm 
LogitOutput$TimeElapsed <- TimeAux[3]
LogitOutput$PercCorrect <- mean(x.evaluate$correctlogit)*100
rm(TimeAux)

#update machine laerning properties
newmachinelearningproperties <- getMachineLearningProperties("Logit",LogitOutput)
machinelearning.properties <- rbind(machinelearning.properties,newmachinelearningproperties)
#Save again the training and evaluation set so the output of your model can be loaded later
write.csv(machinelearning.properties, file = "datasets/ml_performances")

