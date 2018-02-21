#clear workspace
rm(list = ls()) 
#set working directory
library(readr)
library(missForest)
library(dplyr)
library(mice)

sessionleveldata <- read_delim("sessionleveldata.csv", ";", escape_double = FALSE, trim_ws = TRUE)
sessionleveldata$date <- as.Date(as.factor(sessionleveldata$date),"%d-%m-%Y")
sessionleveldata$lastorderdate <- as.Date(as.factor(sessionleveldata$lastorderdate),"%d-%m-%Y")

sessionleveldata <- sessionleveldata %>%
  mutate(gender = as.factor(gender)) %>% 
  mutate(segment = as.factor(segment)) %>%
  mutate(subcategory = as.factor(subcategory)) %>% 
  mutate(maingroup = as.factor(maingroup)) %>% 
  mutate(articlegroup = as.factor(articlegroup)) %>% 
  mutate(articletype = as.factor(articletype))

#impute missing values, using all parameters as default values
temp_sessiondata <- sessionleveldata %>% select(datetime,views, carts, abandon, sale,remove,startyear,birthyear, numbersearches, numberitems, avgprice,gender, segment,subcategory, maingroup, articlegroup, articletype)
#count(temp_sessiondata)
#get 100 records
#n_values <- temp_sessiondata[1:100,]
#using mice
MiceImputed_sessiondata <- mice(temp_sessiondata, m=1, maxit = 50, method = 'pmm', seed = 500)
#get complete data set ( 2nd out of 5)
MiceComplete_sessiondata <- complete(MiceImputed_sessiondata)

#Load datetime
MiceComplete_sessiondata$datetime = sessionleveldata$date
MiceComplete_sessiondata$session = sessionleveldata$session
#Load Temperature
temperature_data <- read.csv("Temperature.csv",header=TRUE) #read csv file
temperature_data$date <- as.Date(as.factor(temperature_data$YYYYMMDD),"%Y%m%d") #give a few more options
MiceComplete_sessiondata$TG_avg_temp <- rep(0,nrow(MiceComplete_sessiondata)) #make a new variable in wehkamp_data frame
MiceComplete_sessiondata$FG_avg_wind <- rep(0,nrow(MiceComplete_sessiondata)) #make a new variable in wehkamp_data frame
MiceComplete_sessiondata$SQ_sunshine <- rep(0,nrow(MiceComplete_sessiondata)) #make a new variable in wehkamp_data frame
MiceComplete_sessiondata$RH_precipitation <- rep(0,nrow(MiceComplete_sessiondata)) #make a new variable in wehkamp_data frame
MiceComplete_sessiondata$NG_avg_cloud <- rep(0,nrow(MiceComplete_sessiondata)) #make a new variable in wehkamp_data frame
MiceComplete_sessiondata$UG_humidity <- rep(0,nrow(MiceComplete_sessiondata)) #make a new variable in wehkamp_data frame

for (i in 1:nrow(MiceComplete_sessiondata)) {
  MiceComplete_sessiondata$TG_avg_temp[i] <- temperature_data$TG[temperature_data$date == MiceComplete_sessiondata$datetime[i]]
  MiceComplete_sessiondata$FG_avg_wind[i] <- temperature_data$FG[temperature_data$date == MiceComplete_sessiondata$datetime[i]]
  MiceComplete_sessiondata$SQ_sunshine[i] <- temperature_data$SQ[temperature_data$date == MiceComplete_sessiondata$datetime[i]]
  MiceComplete_sessiondata$RH_precipitation[i] <- temperature_data$RH[temperature_data$date == MiceComplete_sessiondata$datetime[i]]
  MiceComplete_sessiondata$NG_avg_cloud[i] <- temperature_data$NG[temperature_data$date == MiceComplete_sessiondata$datetime[i]]
  MiceComplete_sessiondata$UG_humidity[i] <- temperature_data$UG[temperature_data$date == MiceComplete_sessiondata$datetime[i]]
}

MiceComplete_sessiondata$issale <- ifelse(MiceComplete_sessiondata$sale>0,1,0)


# Write CSV in R
write.csv(MiceComplete_sessiondata, file = "MiceCompleteSessionData.csv")



#str(sessionleveldata)