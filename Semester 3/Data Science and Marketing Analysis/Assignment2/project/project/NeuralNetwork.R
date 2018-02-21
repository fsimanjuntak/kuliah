########## Neural network
library(nnet)
library(caret)

x.modelNNet <- train(BaseFormula, data=x.train, method='nnet', trControl=trainControl(method='cv')) 

x.evaluate$predictionNNet <- predict(x.modelNNet, newdata = x.evaluate, type="raw")
x.evaluate$correctNNet <- x.evaluate$predictionNNet == x.evaluate$ChurnString
print(paste("% of predicted classifications correct", mean(x.evaluate$correctNNet)))

#library(devtools)
#source_url('https://gist.githubusercontent.com/fawda123/7471137/raw/466c1474d0a505ff044412703516c34f1a4684a5/nnet_plot_update.r')
#plot.nnet(x.modelNNet)

x.evaluate$probabilitiesNNet <- predict(x.modelNNet, newdata = x.evaluate, type='prob')[,1]

NNetOutput <- makeLiftPlot(x.evaluate$probabilitiesNNet,x.evaluate,"Neural Network")