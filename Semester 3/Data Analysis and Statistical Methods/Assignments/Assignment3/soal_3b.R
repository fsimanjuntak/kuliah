rm(list = ls())
library("dplyr")
setwd("~/Desktop/Kuliah/Semester 3/Data Analysis and Statistical Methods/Assignments/Assignment1")
df <- read.csv("data1(2).csv", header = TRUE)
df[, "date"] = lapply(df["date"],function(x){strptime(x, "%d/%m/%y")})

weekdays_data <- df %>% select(weekday,month, O3) %>% filter(weekday %in% c(2:6) & month ==1) %>% select(O3)
weekends_data <- df %>% select(weekday,month, O3) %>% filter(weekday %in% c(1,7) & month ==1) %>% select(O3)

summary_weekdays <- weekdays_data %>% summarise(avg_O3 = mean(O3), sd_O3 =sd(O3))
summary_weekends <- weekends_data %>% summarise(avg_O3 = mean(O3), sd_O3 =sd(O3))

summary_weekdays
summary_weekends

t_result <- t.test(weekends_data, weekdays_data, alternative = "greater", conf.level = 0.95, var.equal = TRUE, paired = FALSE)

t_result

t_alpha <- qt(0.95, t_result$parameter)
t_alpha

count(weekdays_data)
count(weekends_data)


(20.55985*20.55985)/(20.44157*20.44157)