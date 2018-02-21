library(dplyr)
library(plyr) 
library(ggplot2)

#load dataframe and omit values that contain NA
df <- na.omit(read.csv("data8(1).csv"))
#rename the column
df <- rename(df,c("COS.60" = "COS_60", "CO2.60" = "CO2_60", 
                  "CO.60" = "CO_60", "H2O.60" = "H2O_60",
                  "COS.7" = "COS_7","CO2.7" = "CO2_7",
                  "CO.7" = "CO_7","H2O.7" = "H2O_7"))

#construct all variables of date into a single string
str_dateformat <- "%d-%m-%Y %H:%M:%S"
str_date <- paste(df$day,df$mon,df$yr, sep = "-")
str_time <- paste(df$hr,0,0, sep = ":")
str_datetime <- paste(str_date,str_time,sep = " ")

#add new datetime variable to data frame
df$datetime = as.POSIXct(str_datetime, format=str_dateformat)

#add column season to group the record by season
df$season <- ifelse(df$mon %in% c(1,2,12),"winter", 
                    ifelse(df$mon %in% 3:5, "spring", 
                    ifelse(df$mon %in% 6:8, "summer", "autumn")))

df$seasonid <- ifelse(df$mon %in% c(1,2,12),1, 
                    ifelse(df$mon %in% 3:5, 2, 
                           ifelse(df$mon %in% 6:8, 3, 4)))

#df$monthname <- month.abb[df$mon]
