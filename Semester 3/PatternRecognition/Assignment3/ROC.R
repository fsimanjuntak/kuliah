library(ggplot2)

# create a series of x values
xvals = seq(-5, 13, 0.01)
mu1 = 2
mu2 = 5.15
sd = 2

dist_data = data.frame(x=xvals, 
                       dist1 = dnorm(xvals, mean=mu1, sd=sd),
                       dist2 = dnorm(xvals, mean=mu2, sd=sd))

p_hit = 0.44
p_false_alarm = 0.045

#dist_1
decision_boundary_dist1 = qnorm(p_false_alarm, mean = mu1, sd = sd, lower.tail = FALSE)

#dist_2
decision_boundary_dist2 = qnorm(p_hit, mean = mu2, sd =sd, lower.tail = TRUE)

# plot probability of distribution 1 and distribution 2
ggplot() + 
  geom_line(data=dist_data, aes(x=x, y=dist1, color="distribution 1 (mu= 2, sd=2)")) +
  geom_line(data=dist_data, aes(x=x, y=dist2, color="distribution 2 (mu= 5.7, sd=2)")) +
  geom_point(data=data.frame(X=decision_boundary_dist1,Y=0), aes(x = X, y = Y),colour="green",size=4)+
  geom_vline(xintercept = decision_boundary_dist1, linetype="dashed") + 
  ylab("Probability") + 
  xlab("X Values")


discriminability = (mu2-mu1)/sd



#ROC plot

# create a series of x values
plot(pnorm(xvals, mean=4, sd=sd), pnorm(xvals, mean=2, sd=sd), xlim = c(0, 1), ylim = c(0, 1), type = "l",  xlab = "false alarm", ylab = "hit", col = 'blue')
abline(0, 1, col= "black")
lines(pnorm(xvals, mean=6, sd=sd), pnorm(xvals, mean=2, sd=sd), col='green')
lines(pnorm(xvals, mean=mu2, sd=sd), pnorm(xvals, mean=mu1, sd=sd), col='red')
lines(pnorm(xvals, mean=8, sd=sd), pnorm(xvals, mean=2, sd=sd), col='yellow')
points(0.045,0.44, cex=2,pch=16,col="red")
legend("topleft", legend = c("d1","d1.575","d2","d3") , pch = 15, bty = 'n', col = c("blue",'red',"green",'yellow'))
title(main = "ROC curve Hit versus False Alarm")





