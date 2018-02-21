#Statistical methods
library(dplyr)
library(ggplot2)

#a. t-test
#get data
#all data
all_CO2_60 <- df %>%  select(CO2_60) 

#CO2 60 metres
summer_CO2_60 <- df %>% filter(season == "summer") %>% select(CO2_60) 
winter_CO2_60 <- df %>% filter(season == "winter") %>% select(CO2_60) 
autumn_CO2_60 <- df %>% filter(season == "autumn") %>% select(CO2_60) 
spring_CO2_60 <- df %>% filter(season == "spring") %>% select(CO2_60) 
#CO2 7 metres
summer_CO2_07 <- df %>% filter(season == "summer") %>% select(CO2_7)
winter_CO2_07 <- df %>% filter(season == "winter") %>% select(CO2_7)
autumn_CO2_07 <- df %>% filter(season == "autumn") %>% select(CO2_7)
spring_CO2_07 <- df %>% filter(season == "spring") %>% select(CO2_7)

#summary of CO2 60 metres per season
summary_summer_CO2_60 <- df %>%select(CO2_60, CO2_7, season) %>% group_by(season)%>% summarise ( avg_CO2_60 = mean (CO2_60) , sd_CO2_60 =sd (CO2_60), avg_CO2_07 = mean (CO2_7) , sd_CO2_07 =sd (CO2_7))

#get the value of Ttable
t_alpha <- qt (0.95 , t_result_summer_vs_all$parameter, lower.tail = TRUE)

#decision : reject H0 if the Ttest > TTable

#perform t-test on summer data
t_result_summer_vs_all <- t.test(all_CO2_60,summer_CO2_60, alternative = "greater", conf.level = 0.95, var.equal = TRUE, paired = FALSE)

#perform t-test on winter data
t_result_winter_vs_all <- t.test(all_CO2_60,winter_CO2_60, alternative = "greater", conf.level = 0.95, var.equal = TRUE, paired = FALSE)

#perform t-test on spring data
t_result_spring_vs_all <- t.test(all_CO2_60,spring_CO2_60, alternative = "greater", conf.level = 0.95, var.equal = TRUE, paired = FALSE)

#perform t-test on spring data
t_result_autumn_vs_all <- t.test(all_CO2_60,autumn_CO2_60, alternative = "greater", conf.level = 0.95, var.equal = TRUE, paired = FALSE)





