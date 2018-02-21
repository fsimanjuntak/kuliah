library(tidyverse)
library(ggplot2)

n = 64 # sample size
s = 50 # standard deviation
x_bar = 150 # sample average
mu_0 = 165
alpha = 0.05

z = (x_bar - mu_0)/(s/sqrt(n))  # test statistic 
z.half.alpha = qnorm(1-alpha/2)
p_value = 2 * pnorm(z) # two−tailed p−value

p_value

x = seq(-4, 4, 0.1) # sequence from -4 to 4 in increments of 0.1
y = dt(x, df=n-1)   # probability density of the t distribution

dist = data.frame(x=x,y=y)

#Plot with ggplot
ggplot(dist, aes(x,y)) + 
  annotate(geom = "label", x = 0,y = p_value,label = "p value", parse = FALSE) +
  geom_area(data = subset(dist, x <= -z.half.alpha), aes(x=x, y=y), fill="red")+
  geom_area(data = subset(dist, x >= z.half.alpha), aes(x=x, y=y), fill="red")+
  annotate(geom = "point", x=-z.half.alpha, y=p_value,color = "blue", size = 4)+
  annotate(geom = "point", x=z.half.alpha, y=p_value,color = "blue", size = 4)+
  geom_text(x=-z.half.alpha, y=0.03, label="-1.96", col="Black")+
  geom_text(x=z.half.alpha, y=0.03, label="1.96", col="Black")+
  geom_line() +                     
  geom_vline(xintercept = -z.half.alpha,linetype="dashed") +       
  annotate(geom = "label",x = -z.half.alpha,y = 0.35,label = "z[(alpha/2)]",parse = TRUE) +          
  geom_vline(xintercept = z,linetype="dashed") + 
  annotate(geom = "label", x = z,y = 0.35,label = "z",parse = FALSE)+          
  geom_vline(xintercept = z.half.alpha,linetype="dashed") +            
  annotate(geom = "label",x = z.half.alpha, y = 0.35,label = "z[(1-alpha/2)]",parse = TRUE)+          
  geom_hline(yintercept = p_value, linetype="dashed")