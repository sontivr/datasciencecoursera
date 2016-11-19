library(datasets)

# close current device to let the next plot create its own device
if (dev.cur() != 1) dev.off(dev.cur())

# read the data file into a data frame
hpower<-read.csv("household_power_consumption.txt", sep = ";", header = TRUE)

# copy the data for Feb 1st and 2nd of 2007 to hpower0
hpower0<-hpower[hpower$Date=="1/2/2007" | hpower$Date=="2/2/2007",]

# create the plot on screen device
plot(strptime(paste(hpower0$Date, hpower0$Time), "%d/%m/%Y %H:%M:%S"), as.numeric(as.character(hpower0$Sub_metering_1)), type="l", xlab="", ylab="Energy sub metering")

lines(strptime(paste(hpower0$Date, hpower0$Time), "%d/%m/%Y %H:%M:%S"), as.numeric(as.character(hpower0$Sub_metering_2)), type = "l", col = "red")

lines(strptime(paste(hpower0$Date, hpower0$Time), "%d/%m/%Y %H:%M:%S"), as.numeric(as.character(hpower0$Sub_metering_3)), type = "l", col = "blue")

legend("topright", lty = 1, col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

# copy the plot to plot3.png
dev.copy(png, "plot3.png")  

# close current device to let the next plot create its own device
if (dev.cur() != 1) dev.off(dev.cur())

