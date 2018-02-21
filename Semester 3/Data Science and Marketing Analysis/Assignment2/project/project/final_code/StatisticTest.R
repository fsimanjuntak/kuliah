library(dplyr)
library(GGally)
library(lmodel2)
#library(tidyverse)


df = read.csv(file = "datasets/Assignment1_dataset_v3.csv", header = TRUE)
#convert date to date object
df$date <- as.Date(as.factor(df$date),"%Y-%m-%d")
#get the month name from date object
df$month <- format(df$date, "%b")

df$season <- ifelse(df$date >= "2017-01-01" & df$date<"2017-02-28", "winter", ifelse(df$date >= "2017-06-01" & df$date<"2017-07-31", "summer","spring"))


##################### T-Test #############################
#We define season by using these formula
#winter = [month --> 1,2]
#spring = [month --> 3,4,5]
#summer = [month --> 6,7]

#get the winter data
winter_data <- df %>% select(number_items_sold, date) %>% filter(date >= "2017-01-01" & date<"2017-02-28") %>% select(number_items_sold)

#get the summer data
summer_data <- df %>% select(number_items_sold, date) %>% filter(date >= "2017-06-01" & date<"2017-07-31") %>% select(number_items_sold)

#get the spring data
spring_data <- df %>% select(number_items_sold, date) %>% filter(date >= "2017-03-01" & date<"2017-05-31") %>% select(number_items_sold)



#The null hypothesis: the total item sold in summer is equal with the item sales in winter
#The alternative : The total item sold in summer is higher than in winter
#m1 - m2 = 0
#m1 - m2 > 0
#alpha = 0.05 (95% confidence interval)
#rejection region: Reject Ho if the t_test > t_alpha

#1. Compare the item sales  between summer and winter
#lets perform two sample t-test
t_test<- t.test(summer_data, winter_data,
                alternative = c("greater"),
                mu = 0, paired = FALSE, var.equal = FALSE,
                conf.level = 0.95)

#get the t-alpha 0.05
t_alpha <- qt(0.95 , t_test$parameter)

#t_test: 17.433, t_alpha: 1.66864
#Since the t_value is greater than t_alpha therefore we reject the null hypothesis

#2. compare the item sales  between the summer and spring
#now lets perform two sample t-test
t_test<- t.test(summer_data, spring_data,
                alternative = c("greater"),
                mu = 0, paired = FALSE, var.equal = FALSE,
                conf.level = 0.95)

#get the t-alpha 0.05
t_alpha <- qt(0.95 , t_test$parameter)

#t_test: 8.5805, t_alpha: 1.658833
#Since the t_value is greater than t_alpha therefore we reject the null hypothesis

#3. compare the item sales  between the winter and spring
#lets perform two sample t-test
t_test<- t.test(winter_data, spring_data,
                alternative = c("greater"),
                mu = 0, paired = FALSE, var.equal = FALSE,
                conf.level = 0.95)

#get the t-alpha 0.05
t_alpha <- qt(0.95 , t_test$parameter)

#t_test: -10.582, t_alpha: 1.658939
#Since the t_value is greater than t_alpha therefore we can not reject the null hypothesis


##################### Two way ANOVA-Test ###############################################
twowayanova = aov(number_items_sold~season+TG_avg_temp+FG_avg_wind+SQ_sunshine+RH_precipitation+NG_avg_cloud+UG_humidity, data=df)
summary(twowayanova)

#################### Linier Regression ####################################
z1 = lm(number_items_sold~TG_avg_temp+FG_avg_wind+SQ_sunshine+RH_precipitation+NG_avg_cloud+UG_humidity, data=df)
z2 = lm(number_items_sold~TG_avg_temp+SQ_sunshine, data=df)
summary(z1)
summary(z2)

###### Test the regression using ANOVA #######
results = anova(z1, z2)
print(results)
