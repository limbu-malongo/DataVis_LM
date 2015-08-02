# Programming Assignment 1: Visualize Data Using a Chart

# Download the data from the following url
# https://d396qusza40orc.cloudfront.net/datavisualization/programming_assignment_1/Programming%20Assignment%201%20Data%20New.zip

# Extract the downloaded data and make sure you put ExcelFormattedGISTEMPDataCSV.csv into your
# working directory

gistemp <- read.csv("ExcelFormattedGISTEMPDataCSV.csv", colClasses = "character")
head(gistemp)

# Check the dimension of the data
dim(gistemp)

## Select seasonal data in last 6 columns
ts_gistemp <- gistemp[,c(1,14:19)]
head(ts_gistemp)

## Convert all variables (columns) to numeric format
# Packages
# install.packages("plyr")
library(plyr)

ts_gistemp <- colwise(as.numeric) (ts_gistemp)
str(ts_gistemp)
summary(ts_gistemp)

## Remove rows where Year=NA from the dataframe and check the dimension
ts_gistemp <- ts_gistemp[!is.na(ts_gistemp$Year),]
dim(ts_gistemp)

# Simplify the long variable names to plot
x <- ts_gistemp$Year  
y1 <- ts_gistemp$J.D  # January-December
y2 <- ts_gistemp$D.N  # December-November
y3 <- ts_gistemp$DJF  # December-January-February (Winter)
y4 <- ts_gistemp$MAM  # Spring
y5 <- ts_gistemp$JJA  # summer
y6 <- ts_gistemp$SON  # Fall/Autumn

## Set on of the graphic device
#jpeg(filename="images/data_vis_assgn1.jpg",  width = 960, height = 960)  ## Save A Plot As An Image

# Set the background color
par(mar =  c(5, 4, 4, 3) + 0.1, bg = "#BFAE96")
# Plot the Annual Average Temperature
plot(x,y1, 
     ylim = c(-60,80),
     type="l", 
     xlab="x", ylab="y", 
     col="red", lwd=4, 
     axes=FALSE,
     ann = FALSE)


# Add the layers for Seasonal Temperatures
lines(x, y3, col="darkmagenta")  # Winter
lines(x, y4, col="#f5f5f5")  # Spring
lines(x, y5, col="#80cdc1")  # summer
lines(x, y6, col="khaki1")  # Fall/Autumn

# Set the
box()   # The surounding box
axis(2, las=2)  # The left y-axis
axis(4, las=2)  # The left y-axis
axis(1, las=0)  # The down x-axis

# The legend
legend("topleft",
       inset = 0.05,
       cex = 1.2,
       title="Period",
       c("Annual","Winter","Spring","summer","Fall"),
       horiz=TRUE,
       lty=c(1,1),
       lwd=c(2,2),
       col=c("red","darkmagenta","#f5f5f5","#80cdc1","khaki1"),
       bg="white")

# Set the grids
grid()

# Add title
title(main = "Surface Temperature Change")

# Lable the axis
mtext("Year", side = 1, line = 3 )  # x-axix
mtext("Average Temperature in Farenheit", side = 2, line = 3 )  # y-axis


#dev.off()  ##Turn Off the graphic device after saving the image

par(mar =  c(5, 4, 4, 2) + 0.1)