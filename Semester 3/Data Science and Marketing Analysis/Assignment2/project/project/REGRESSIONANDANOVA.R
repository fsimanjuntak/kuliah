library(dplyr)
library(GGally)
library(lmodel2)
library(tidyverse)

#1. ------------------ dependent variable: number_items_sold, independent variables: temperatures
#load dataset
df = read.csv(file = "Assignment1_dataset_v2.csv", header = TRUE)
#convert date to date object
df$date <- as.Date(as.factor(df$date),"%Y-%m-%d")
#get the month name from date object
df$month <- format(df$date, "%b")


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

############### ANOVA TEST #################
#our null hypothesis, we want to know if there is a difference in number of items sold between the months
#Ho : m1 = m2 = m3 = m4 = m5 = m6
#H1 : Not at  m are equal
#alpha = 0.05 (95 % confidence interval)
#Rejection region: Reject Ho if p-value <= 0.05

#get the number items sold and group them by month
data_anova <- df %>% select(number_items_sold, month)
# perform the 1-way ANOVA test
oneway.test(number_items_sold~month, data_anova, var.equal = FALSE)

#p-value < 2.2e-1
#since p-value is less than 0.05 therefore we reject the null hypothesis


######### LINEAR REGRESSION ##########

#plot diagnostic regression
ggpairs(df[,c("TG", "FG", "SQ", "RH", "NG", "UG")])
z1 = lm(number_items_sold~TG+FG+SQ+RH+NG+UG, data=df)
z2 = lm(number_items_sold~TG+FG+SQ+RH+NG, data=df)
summary(z1)

###### Test the regression using ANOVA #######
results = anova(z1, z2)
print(results)

#From the regression result, we can easily see that the significant independent variables are TG and FG
z_final = lm(number_items_sold~TG+FG, data=df)
summary(z_final)