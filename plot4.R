#################################################.
## File: plot4.R
## Course: Exploratory Data Analysis
## URL: https://class.coursera.org/exdata-011
## Course Project 1
## Author: GG
## R 3.1.2 "Pumpkin Helmet"
## Created on February 5th, 2015
## Last modified on February 8th, 2015
#################################################.

## verify if file exists : information on the data
dataUrl<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
dataZip <- "exdata_data_household_power_consumption.zip"
dataFile <- "household_power_consumption.txt"

## verify the operating system and create download functions
if(.Platform$OS.type == "windows"){ ## for windows
        dataDl <- function(){download.file(url=dataUrl, destfile = dataZip)}}
if(.Platform$OS.type != "windows"){ ## for Mac, Linux and other OS
        dataDl <- function(){download.file(url=dataUrl, destfile = dataZip, 
                                           method="curl")}}

## Verify if the file exists, if not download and/or unzip the data
if(!file.exists(dataFile)){
        if(!file.exists(dataZip)){
                ## download the file (see functions lines 17 to 22)
                dataDl()
                # record the date of download and write it in a text file
                dateDownloaded <- date()
                fileConn <- file("exdata_data_dateDownloaded.txt")
                writeLines(dateDownloaded, fileConn)
                close(fileConn)
                ## clean the global environement
                rm(list = c("dateDownloaded", "fileConn"))
        }
        unzip(dataZip)
}
## clean the global environement
rm(list= c("dataUrl", "dataZip", "dataFile", "dataDl"))

## due to the length of the data more than 2 millions lines,
## we'll read only the relevant lines for this study
## the functions below (readThisData() and readThisData2())
## write a small 176ko txt file (hpc_subset.txt)
## much easier to handle and with only the relevant lines
## readThisData() will be launched for Windos OS
## readThisData2() will be launch for other OS

#### Note : I've tested several ways to read the data this one is
#### one of the quickest and more automated one (less than 3 seconds)

## for Windows OS, use the shell() function
readThisData <- function(){ # process duration : three seconds
        ## read the firstline and write it in a new file
        shell("head -n 1 household_power_consumption.txt > hpc_subset.txt")
        ## grab the desired lines
        ## and append them to the first line in the new file
        #### note that the regular expression is slightly modified
        #### and we'll use the extended regular expressions (-E)
        #### in order to accomodate the shell() function syntax
        shell("grep -E \"^1/2/2007|^2/2/2007\" household_power_consumption.txt >> hpc_subset.txt")
}

## for other OS (Mac, Linux,...), use the system() function
readThisData2 <- function(){ # process duration : three seconds
        system("head -n 1 household_power_consumption.txt > hpc_subset.txt")
        system("grep -E \"^1/2/2007|^2/2/2007\" household_power_consumption.txt >> hpc_subset.txt")
}

cat("reading and subsetting the data ")
## launch the function according to the OS
if(.Platform$OS.type == "windows"){readThisData()}
if(.Platform$OS.type != "windows"){readThisData2()}
cat(": done ")
## clean the global environement
rm(list=c("readThisData", "readThisData2"))

## read the simplified data (less than a second)
dataLines <- read.table("hpc_subset.txt", header = TRUE, sep = ";",
                        na.strings = "?", stringsAsFactors = FALSE)
## due to the argument stringAsFactors = FALSE :
## columns Date and Time are directly of class "character"
## all the others columns are directly of class "numeric"
## so there is no need for further transformations

## fusion date and time in one new column
## can also be done with dplyr but I prefer to reduce 
## the number of packages required 
cat("\n","fusion date and time ")
dataLines$Date <- strptime(paste(dataLines$Date,dataLines$Time),
                           format = "%d/%m/%Y %H:%M:%S")
# remove the time column
dataLines <-dataLines[,-2]
# change firstcolumn name
colnames(dataLines) <- c("datetime", c(colnames(dataLines[2:8])))
cat(": done ")

# plot the data (plot4)

plot4 <- function(){
        ## set temporary the locale to english to automatize the x-axis label
        #### record locale
        userLocale <- Sys.getlocale("LC_TIME")
        #### change temporary the locale and set it back on exit
        if(.Platform$OS.type == "windows"){Sys.setlocale("LC_TIME", "English")}
        if(.Platform$OS.type != "windows"){Sys.setlocale("LC_TIME", "C")}
        on.exit(Sys.setlocale("LC_TIME", userLocale))
        ## prepare the x-axis label for all plots
        #### catch the values of the plot, add one minute for the end of plot
        ####  in order to catch the next day's name
        xAxisNames <- c(weekdays(min(dataLines$datetime), abbreviate=TRUE),
                        weekdays(dataLines$datetime[1441], abbreviate=TRUE),
                        weekdays(max(dataLines$datetime)+60, abbreviate=TRUE))
                
        # open an empty png file
        if(.Platform$OS.type == "windows"){
                png(file = "plot4.png", width = 480, height = 480, 
                    type = "cairo", bg = "transparent")}
        if(.Platform$OS.type != "windows"){
                png(file = "plot4.png", width = 480, height = 480, 
                    bg = "transparent")}
        # set the par value 
        # in order to put the four plots two by two
        # mfcol() will draw the plot in the order :
        # top left - lower left - top right - lower right
        par(mfcol=c(2,2))
        
        #plot the data topleft
        plot(dataLines$Global_active_power, 
             ylab = "Global Active Power",
             xlab = "", type = "l", axes = FALSE)
        ## put the plot in a box with a lighter dark color
        box(col="bisque4")
        ## write the axis
        axis(1, at = c(1, 1440, 2881), labels = xAxisNames)
        axis(2) ## set automatically the y axis
        ## it's the same as :
        ## axis(2, at = c(0, 2, 4, 6), labels = c(0, 2, 4, 6))
        
        #plot the data lowerleft
        plot(dataLines$Sub_metering_1, 
             ylab = "Energy sub metering",
             xlab = "", type = "l", axes = FALSE, col = "black")
        lines(dataLines$Sub_metering_2, col= "red")
        lines(dataLines$Sub_metering_3, col="blue")
        ## put the plot in a box with a lighter dark color
        box(col="bisque4")
        ## write the axis
        axis(1, at = c(1, 1440, 2881), labels = xAxisNames)
        axis(2) ## set automatically the y axis
        ## it's the same as :
        ## axis(2, at = c(0, 10, 20, 30), labels = c(0, 10, 20, 30))
        
        ## add a legend
        ## suppress the box surrounding the legend (argument bty = "n")
        ## reduce text size (argument cex)
        legend("topright", 
               c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
               col = c("black", "red", "blue"), lwd = 1, bty = "n", cex = 0.95)
        
        ## plot data top right
        plot(dataLines$Voltage, 
             ylab = "Voltage",
             xlab = "datetime", type = "l", axes = FALSE)
        ## put the plot in a box with a lighter dark color
        box(col="bisque4")
        ## write the axis
        axis(1, at = c(1, 1440, 2881), labels = xAxisNames)
        axis(2) ## set the y axis automatically
        ## it's the same as :
        ## axis(2, at = c(234,236, 238,240, 242,244,246), labels = c(234,"", 238,"",242,"",246))
        
        ## plot the data lower right
        plot(dataLines$Global_reactive_power,
             ylab = "Global_reactive_power",
             xlab = "datetime", type = "l", axes = FALSE)
        ## put the plot in a box with a lighter dark color
        box(col="bisque4")
        ## write the axis
        axis(1, at = c(1, 1440, 2881), labels = xAxisNames)
        axis(2) ## set automatically the y axis
        ## it's the same as :
        ## axis(2, at = c(0.0, 0.1, 0.2, 0.3, 0.4, 0.5), labels = c("0.0", 0.1, 0.2, 0.3, 0.4, 0.5))
        
        ## close the connection
        dev.off()
}
cat("\n", "plotting the data ")
plot4()
cat(": done ")
cat("\n", "plot4.png is now in your working directory ")
