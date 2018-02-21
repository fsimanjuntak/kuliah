######### LOGIT
ptm <- proc.time()
Churn_logit <- glm(BaseFormula1 , data = x.train, family = "binomial")

#summary(Churn_logit)

#evaluating the model
x.evaluate$predictionlogit <- predict(Churn_logit, newdata=x.evaluate, type = "response")
x.evaluate$predictionlogitclass[x.evaluate$predictionlogit>.5] <- "Churn"
x.evaluate$predictionlogitclass[x.evaluate$predictionlogit<=.5] <- "Stay"
x.evaluate$correctlogit <- x.evaluate$predictionlogitclass == x.evaluate$ChurnString

print(paste("% of predicted classifications correct", mean(x.evaluate$correctlogit)))

LogitOutput <- makeLiftPlot(x.evaluate$predictionlogit,x.evaluate,"Logit")

#another variable
TimeAux <- proc.time() - ptm 
LogitOutput$TimeElapsed <- TimeAux[3]
LogitOutput$PercCorrect <- mean(x.evaluate$correctlogit)*100
rm(TimeAux)