library(tidyverse)
library(ggplot2)

# define the mean, standard deviation, and z values
x_avg <- 100
sd <- 35
z1 <- -1.428
z2 <- 0.1428
z3 <- 1

# create a series of x values
xvals = seq(-50, 250, 1)
dist_data = data.frame(x=xvals, 
                       dist = dnorm(xvals, mean=x_avg, sd=sd),
                       cumulative_dist = pnorm(xvals, mean=x_avg, sd=sd))
# plot
ggplot() + 
geom_line(data=dist_data, aes(x=x, y=dist, color="probability density")) + 
geom_line(data=dist_data, aes(x=x, y=cumulative_dist, color="cumulative distribution")) + 
ylab("Probability") + 
xlab("X Values")+
geom_vline(xintercept = z1, linetype="dashed") +
geom_vline(xintercept = z2, linetype="dashed") +
geom_vline(xintercept = z3, linetype="dashed") +
ggtitle("The distribution of yearly amount of precipitation")
