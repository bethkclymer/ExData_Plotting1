#####
#This R script downloads the Electric Power Consumption data from the UC Irvine
##Machine Learning Repository

#This data contains measurements of electrical power consumption from one household
##with a one-minute sampling rate over almost 4 years. 

#Variables: Date, Time, Global_active_power, Global_reactive_power, Voltage, 
##Global_intensity, Sub_metering_1, Sub_metering_2, Sub_metering_3 

#See Readme for more details

#This code was written to reproduce plot4 for the Exploratory Data Analysis course
##provided by faculty at Johns Hopkins via coursera

#Author: Beth Clymer
#Last Modified: 6/4/2015
#####

if(!file.exists("household_power_consumption.txt")){ #Check for data file
  if(!file.exists("powerConsumption.zip")){ #check for zip file
    #if no zip file present, download the file to current directory
    url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
    download.file(url, "./powerConsumption.zip", mode="wb")
  }
  unzip("./powerConsumption.zip") #unzip data
}

#Read in data file
data <- read.table("household_power_consumption.txt", sep=";", header=T, 
                   colClasses = c("character", "character", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric"),
                   na.strings="?")

#parse the date/time
data$DateTime <- strptime(paste(data$Date, data$Time, sep=" "), format="%d/%m/%Y %H:%M:%S")
data$Time <- strptime(data$Time, format="%H:%M:%S")
data$Date <- as.Date(data$Date, format="%d/%m/%Y")

#Subset the data so it only contains Feb. 1 and 2 of 2007
data <- subset(data, Date == as.Date("2007-02-01", "%Y-%m-%d") | Date == as.Date("2007-02-02", "%Y-%m-%d"))


png(filename="plot4.png") #generate the png file
par(mfrow=c(2,2)) #set mfrow to have two rows and two columns of plots

plot(data$DateTime, data$Global_active_power, ann=FALSE, type="l") 
title(ylab="Global Active Power")

plot(data$DateTime, data$Voltage, type="l", ann=FALSE)
title(xlab="datetime", ylab="Voltage")

plot(data$DateTime, data$Sub_metering_1, type="l", col="black", ann=FALSE)
lines(data$DateTime, data$Sub_metering_2, col="red")
lines(data$DateTime, data$Sub_metering_3, col="blue")
title(ylab="Energy sub metering")
legend(x="topright", legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col=c("black", "red", "blue"), lty=1, bty='n')

plot(data$DateTime, data$Global_reactive_power, type="l", ann=FALSE)
title(ylab="Global_reactive_power", xlab="datetime")
dev.off() #close the png file

par(mfrow=c(1,1)) #reset mfrow