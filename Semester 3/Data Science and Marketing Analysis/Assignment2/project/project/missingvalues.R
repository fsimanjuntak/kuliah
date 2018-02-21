#clear workspace
rm(list = ls()) 

#set working directory
library(readr)
library(missForest)
library(dplyr)
library(mice)


sessionleveldata <- read_delim("sessionleveldata.csv", ";", escape_double = FALSE, trim_ws = TRUE)
#convert char to binary or integer or date
sessionleveldata$gender_bin <- ifelse(sessionleveldata$gender=="F",0,ifelse(sessionleveldata$gender=="M",1,NA))
sessionleveldata$date <- as.Date(as.factor(sessionleveldata$date),"%d-%m-%Y")
sessionleveldata$lastorderdate <- as.Date(as.factor(sessionleveldata$lastorderdate),"%d-%m-%Y")
#sessionleveldata$subcategory_bin <- as.Date(as.factor(sessionleveldata$lastorderdate),"%d-%m-%Y")
sessionleveldata$segment_bin <- ifelse(sessionleveldata$segment=="Child 2-12",0,
                                 ifelse(sessionleveldata$segment=="Living together without children",1,
                                 ifelse(sessionleveldata$segment=="Big size",2,
                                 ifelse(sessionleveldata$segment=="Not set",3,
                                 ifelse(sessionleveldata$segment=="Men",4,
                                 ifelse(sessionleveldata$segment=="Other 36-54",5,
                                 ifelse(sessionleveldata$segment=="Other 55-64",6,
                                 ifelse(sessionleveldata$segment=="People with babies",7,
                                 ifelse(sessionleveldata$segment=="Other 0-20",8,
                                 ifelse(sessionleveldata$segment=="Other 65-999",9,
                                  NA))))))))))
sessionleveldata$subcategory_bin <- ifelse(sessionleveldata$subcategory=="Ladies Beachwear",0,
                                    ifelse(sessionleveldata$subcategory=="Childrens Beachwear",1,
                                    ifelse(sessionleveldata$subcategory=="Men Beachwear",2,
                                    NA)))
sessionleveldata$maingroup_bin <- ifelse(sessionleveldata$maingroup=="Mix & Match",0,
                                    ifelse(sessionleveldata$maingroup=="Swimsuits",1,
                                    ifelse(sessionleveldata$maingroup=="Additionals",2,
                                    ifelse(sessionleveldata$maingroup=="Bikinis",3,
                                    ifelse(sessionleveldata$maingroup=="Men Beachwear",4,
                                    ifelse(sessionleveldata$maingroup=="Swimwear",5,
                                    ifelse(sessionleveldata$maingroup=="Boys",6,
                                    NA)))))))

sessionleveldata$articlegroup_bin <- ifelse(sessionleveldata$articlegroup=="Separates",0,
                                  ifelse(sessionleveldata$articlegroup=="Fashion",1,
                                  ifelse(sessionleveldata$articlegroup=="Dresses",2,
                                  ifelse(sessionleveldata$articlegroup=="Skirts",3,
                                  ifelse(sessionleveldata$articlegroup=="Swimsuit Non Branded",4,
                                  ifelse(sessionleveldata$articlegroup=="Brands",5,
                                  ifelse(sessionleveldata$articlegroup=="Functional",6,
                                  ifelse(sessionleveldata$articlegroup=="Boxers Branded",7,
                                  ifelse(sessionleveldata$articlegroup=="Bikini Branded",8,
                                  ifelse(sessionleveldata$articlegroup=="Bikini Non Branded",9,
                                  ifelse(sessionleveldata$articlegroup=="Trunks Branded",10,
                                  ifelse(sessionleveldata$articlegroup=="Swimsuit Branded",11,
                                  ifelse(sessionleveldata$articlegroup=="Sets",12,
                                  ifelse(sessionleveldata$articlegroup=="Pareos",13,
                                  ifelse(sessionleveldata$articlegroup=="Historie",14,
                                  NA)))))))))))))))

sessionleveldata$articletype_bin <- ifelse(sessionleveldata$articletype=="Bikinibroekje",0,
                                ifelse(sessionleveldata$articletype=="Bikinitopje met cupmaat",1,
                                ifelse(sessionleveldata$articletype=="Badpak (Corrigerend)",2,
                                ifelse(sessionleveldata$articletype=="Jurk",3,
                                ifelse(sessionleveldata$articletype=="Short (<14 cm)",4,
                                ifelse(sessionleveldata$articletype=="Bikini",5,
                                ifelse(sessionleveldata$articletype=="Bikinitopje",6,
                                ifelse(sessionleveldata$articletype=="Badpak",7,
                                ifelse(sessionleveldata$articletype=="Badpak met cupmaat (Corrigerend)",8,
                                ifelse(sessionleveldata$articletype=="Zwemboxer",9,
                                ifelse(sessionleveldata$articletype=="Zwemshort",10,
                                ifelse(sessionleveldata$articletype=="Strandtuniek",11,
                                ifelse(sessionleveldata$articletype=="Strandshort",12,
                                ifelse(sessionleveldata$articletype=="Badpak met cupmaat",13,
                                ifelse(sessionleveldata$articletype=="Badpak (Sport)",14,
                                ifelse(sessionleveldata$articletype=="Playsuit",15,
                                ifelse(sessionleveldata$articletype=="Zwembroek",16,
                                ifelse(sessionleveldata$articletype=="Bikinipads",17,
                                ifelse(sessionleveldata$articletype=="Bikini met cupmaat",18,
                                ifelse(sessionleveldata$articletype=="Zwembandjes",19,
                                ifelse(sessionleveldata$articletype=="Accessoire",20,
                                ifelse(sessionleveldata$articletype=="Jumpsuit",21,
                                ifelse(sessionleveldata$articletype=="Pareo",22,
                                ifelse(sessionleveldata$articletype=="Zwembril",23,
                                ifelse(sessionleveldata$articletype=="Boardshort",24,
                                ifelse(sessionleveldata$articletype=="T-shirt",25,
                                ifelse(sessionleveldata$articletype=="Badpak (Prothese)",26,
                                ifelse(sessionleveldata$articletype=="Top",27,
                                ifelse(sessionleveldata$articletype=="Kimono",28,
                                ifelse(sessionleveldata$articletype=="UV shirt",29,
                                ifelse(sessionleveldata$articletype=="Singlet",30,
                                NA)))))))))))))))))))))))))))))))


#impute missing values, using all parameters as default values
temp_sessiondata <- sessionleveldata %>% select(datetime,views, carts, abandon, sale,remove,startyear,birthyear, numbersearches, numberitems, avgprice,gender_bin, segment_bin,subcategory_bin, maingroup_bin, articlegroup_bin, articletype_bin)
#count(temp_sessiondata)
#get 100 records
#n_values <- temp_sessiondata[1:112584,]
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

#segment_distinc <- sessionleveldata %>% select(articletype) %>% distinct
#articlegroup = c('Separates','Fashion','Dresses','Skirts','Swimsuit Non Branded','Brands','Functional','Boxers Branded','Bikini Branded','Bikini Non Branded','Trunks Branded','Swimsuit Branded','Sets','Pareos','Historie')
#typeof(n_values$gender_bin)
