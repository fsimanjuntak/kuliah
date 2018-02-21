#exploratory data analysis
library(dplyr)
library(ggplot2)

#histogram
#CO2
ggplot(df, aes(x=CO2_60)) + geom_histogram()
ggplot(df, aes(x=CO2_7)) + geom_histogram()
#H20
ggplot(df, aes(x=H2O_60)) + geom_histogram()
ggplot(df, aes(x=H2O_7)) + geom_histogram()
#C0
ggplot(df, aes(x=CO_60)) + geom_histogram()
ggplot(df, aes(x=CO_7)) + geom_histogram()
#COS
ggplot(df, aes(x=COS_60)) + geom_histogram()
ggplot(df, aes(x=COS_7)) + geom_histogram()

#boxplot
#CO2 per month
ggplot(df, aes( x= factor(season) , y=CO2_60))+geom_boxplot()
ggplot(df, aes( x= factor(season) , y=CO2_7))+geom_boxplot()

#CO2 per season
ggplot(df, aes( x= factor(season) , y=CO2_60))+geom_boxplot()
ggplot(df, aes( x= factor(season) , y=CO2_7))+geom_boxplot()

#scatter plot CO2 per month
ggplot(df, aes(x=season, y=CO2_60)) + geom_point(colour="red")
ggplot(df, aes(x=season, y=CO2_7)) + geom_point(colour="red")

#scatter plot CO2 per month
ggplot(df, aes(x=datetime, y=CO2_60)) + geom_point(colour="red")
ggplot(df, aes(x=datetime, y=CO2_7)) + geom_point(colour="red")


#get summary table *this result still wrong
result <- df %>% select(season, CO2_60, CO2_7)%>% filter(season == "summer"  | season == "winter")  %>% group_by(season) %>% summarise(Cmean_O2_60= mean(CO2_60), mean_CO2_7= mean(CO2_7), sd_CO2_60= sd(CO2_60), sd_CO2_7= sd(CO2_7))
result

#qqplot
rnorm_CO2_60 <- rnorm(df$CO2_60)
qqnorm(rnorm_CO2_60)
qqline(rnorm_CO2_60)

rnorm_CO2_7 <- rnorm(df$CO2_7)
qqnorm(rnorm_CO2_7)
qqline(rnorm_CO2_7)








