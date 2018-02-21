rm(list = ls())
library("dplyr")
setwd("~/Desktop/Kuliah/Semester 3/Data Analysis and Statistical Methods/Assignments/Assignment1")
df <- read.csv("data1(2).csv", header = TRUE)
df[, "date"] = lapply(df["date"],function(x){strptime(x, "%d/%m/%y")})

weekdays_data <- df %>% select(weekday,month, O3) %>% filter(weekday %in% c(2:6) & month ==1) %>% select(O3)
weekends_data <- df %>% select(weekday,month, O3) %>% filter(weekday %in% c(1,7) & month ==1) %>% select(O3)

count(weekdays_data)
count(weekends_data)

vector_weekdays <- unlist(weekdays_data['O3'])
vector_weekends <- unlist(weekends_data['O3'])

var.test(vector_weekdays, vector_weekends, ratio = 1, alternative = "two.sided", conf.level = 0.95)

#cari F-value
qf(c(0.025,0.975),480,164)