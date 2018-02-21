#mthod 2 - linear model
#Statistical methods
library(dplyr)
library(ggplot2)
library(GGally)
library(lmodel2)

z = lm(CO2_60~datetime, data=df)

summary(z)

#plot lm
ggplot(df, aes(x=datetime, y=CO2_60)) + geom_point() +
  geom_abline(intercept = z$coefficients[1],  # but add in the regression line
             slope = z$coefficients[2])


df$fit = fitted(z)
df$res = residuals(z)



ggplot(df) + 
  geom_point(aes(x=datetime, y=CO2_60, color="original value"), size=3) + 
  geom_point(aes(x=datetime, y=CO2_60, color="fitted value"), size=3) + 
  geom_abline(intercept = z$coefficients[1], slope=z$coefficients[2])


#res vs datetime
ggplot(df) + 
  geom_point(aes(x=datetime, y=res))

#res vs fitted
ggplot(df, aes(x=fit, y=res)) + geom_point() + ggtitle("residual vs. fitted values")

#plot qqnorm
qqnorm(df$res)
qqline(df$res)