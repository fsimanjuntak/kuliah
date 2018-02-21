######### LOGIT
Session_logit <- glm(BaseFormula1 , data = x.train, family = "binomial")

summary(Session_logit)

x.evaluate$predictionlogit <- predict(Session_logit, newdata=x.evaluate, type = "response")
x.evaluate$predictionlogitclass[x.evaluate$predictionlogit>.5] <- "Sale"
x.evaluate$predictionlogitclass[x.evaluate$predictionlogit<=.5] <- "NotSale"

x.evaluate$correctlogit <- x.evaluate$predictionlogitclass == x.evaluate$SaleString
print(paste("% of predicted classifications correct", mean(x.evaluate$correctlogit)))
LogitOutput <- makeLiftPlot(x.evaluate$predictionlogit,x.evaluate,"Logit")

LogitOutput$PercCorrect <- mean(x.evaluate$correctlogit)*100