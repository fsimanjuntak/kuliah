rm(list = ls()) #clear workspace

setwd("x://My Downloads/")  #set working directory

wehkamp_data <- read.csv("session_level_data.csv",header=TRUE) #read csv file

wehkamp_data$date <- as.Date(wehkamp_data$date) #format date field

summary (wehkamp_data)

temperature_data <- read.csv("Temperature.csv",header=TRUE) #read csv file

temperature_data$date <- as.Date(as.factor(temperature_data$YYYYMMDD),"%Y%m%d") #give a few more options

# required_fields <- as.vector(c("date","TG")) #obtain only date and temperature fields

# temperature_subdata <- temperature_data[,required_fields]

# temperature_subdata$date <- as.Date(temperature_subdata$date)

# temperature_data <- with(temperature_subdata, temperature_subdata[(date >= "2017-01-01" & date <= "2017-07-31"), ]) #filter only dates of interest

wehkamp_data$TG_avg_temp <- rep(0,nrow(wehkamp_data)) #make a new variable in wehkamp_data frame
wehkamp_data$FG_avg_wind <- rep(0,nrow(wehkamp_data)) #make a new variable in wehkamp_data frame
wehkamp_data$SQ_sunshine <- rep(0,nrow(wehkamp_data)) #make a new variable in wehkamp_data frame
wehkamp_data$RH_precipitation <- rep(0,nrow(wehkamp_data)) #make a new variable in wehkamp_data frame
wehkamp_data$NG_avg_cloud <- rep(0,nrow(wehkamp_data)) #make a new variable in wehkamp_data frame
wehkamp_data$UG_humidity <- rep(0,nrow(wehkamp_data)) #make a new variable in wehkamp_data frame

for (i in 1:nrow(wehkamp_data)) {
  wehkamp_data$TG_avg_temp[i] <- temperature_data$TG[temperature_data$date == wehkamp_data$date[i]]
  wehkamp_data$FG_avg_wind[i] <- temperature_data$FG[temperature_data$date == wehkamp_data$date[i]]
  wehkamp_data$SQ_sunshine[i] <- temperature_data$SQ[temperature_data$date == wehkamp_data$date[i]]
  wehkamp_data$RH_precipitation[i] <- temperature_data$RH[temperature_data$date == wehkamp_data$date[i]]
  wehkamp_data$NG_avg_cloud[i] <- temperature_data$NG[temperature_data$date == wehkamp_data$date[i]]
  wehkamp_data$UG_humidity[i] <- temperature_data$UG[temperature_data$date == wehkamp_data$date[i]]
  } #fill up the new variable with the right values

#temperature_data$TG <- temperature_data$TG/10; #convert temperature to a normal scale 
summary(wehkamp_data)

#Data imputation

#Replace \N string with R NA value
# wehkamp_data[ wehkamp_data == "\\N" ] <- NA


#use MICE library
library(mice)

#inspect pattern of missings
md.pattern(wehkamp_data)

#impute data
MiceImputedData <- mice(wehkamp_data, m=2, maxit = 5, method = 'pmm', seed = 500)

#final_dataset <- merge(wehkamp_data, temperature_data) #merge the two datasets


# write.csv(final_dataset, file = "Assignment1_dataset.csv",row.names=TRUE) #Save the final dataset as csv file
