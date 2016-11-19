library(datasets)

# close current device to let the next plot create its own device
if (dev.cur() != 1) dev.off(dev.cur())

# read the data file into a data frame
hpower<-read.csv("household_power_consumption.txt", sep = ";", header = TRUE)

# copy the data for Feb 1st and 2nd of 2007 to hpower0
hpower0<-hpower[hpower$Date=="1/2/2007" | hpower$Date=="2/2/2007",]

# setup plot panel for four graphs
par(mfrow = c(2, 2), mar = c(5,5,2,1), oma = c(0,0,2,0))

with(hpower0, {

# plot 1
plot(strptime(paste(Date, Time), "%d/%m/%Y %H:%M:%S"), as.numeric(as.character(Global_active_power)), type="l", xlab="", ylab="Global Active Power(kilowatts)")

# plot 2
plot(strptime(paste(Date, Time), "%d/%m/%Y %H:%M:%S"), as.numeric(as.character(Voltage)), type="l", xlab="datetime", ylab="Global Active Power(kilowatts)")

# plot 3
plot(strptime(paste(Date, Time), "%d/%m/%Y %H:%M:%S"), as.numeric(as.character(Sub_metering_1)), type="l", xlab="", ylab="Energy sub metering")
lines(strptime(paste(Date, Time), "%d/%m/%Y %H:%M:%S"), as.numeric(as.character(Sub_metering_2)), type = "l", col = "red")
lines(strptime(paste(Date, Time), "%d/%m/%Y %H:%M:%S"), as.numeric(as.character(Sub_metering_3)), type = "l", col = "blue")
legend("topright", bty = "n", lty = 1, col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

# plot 4
plot(strptime(paste(Date, Time), "%d/%m/%Y %H:%M:%S"), as.numeric(as.character(Global_reactive_power)), type="l", xlab="datetime", ylab="Global_reactive_power")
})

# copy the plot to plot4.png
dev.copy(png, "plot4.png")  

# close current device to let the next plot create its own device
if (dev.cur() != 1) dev.off(dev.cur())

