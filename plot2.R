#################################################.
## File: plot2.R
## Course: Exploratory Data Analysis
## URL: https://class.coursera.org/exdata-011
## Course Project 1
## Author: GG
## OS Windows 7 // R 3.1.2 "Pumpkin Helmet"
## Last modified on February 7th, 2015
#################################################.

## Verify if the file exists, if not download and unzip the data
dataUrl<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
dataZip <- "exdata_data_household_power_consumption.zip"
dataFile <- "household_power_consumption.txt"
if(!file.exists(dataFile)){
        if(!file.exists(dataZip)){                
                data <- download.file(url=dataUrl, destfile = dataZip)
                # record the date of download and write it in a text file
                dateDownloaded <- date()
                fileConn <- file("exdata_data_dateDownloaded.txt")
                writeLines(dateDownloaded, fileConn)
                close(fileConn)
                ## clean the global environement
                rm(list = c("data", "dateDownloaded", "fileConn"))
        }
        unzip(dataZip)
}
## clean the global environement
rm(list= c("dataUrl", "dataZip", "dataFile"))


## due to the length of the data more than 2 millions lines,
## we'll read only the relevant lines for this study
## the function below (readThisData())
## write a small 176ko txt file (hpc_subset.txt)
## much easier to handle and with only the relevant lines

#### Note : I've tested several ways to read the data this one is
#### one of the quickest and more automated one (less than 3 seconds)

#### however this function in this form work for Windows OS only !
#### shell() does not exist on MAC or LINUX
#### to make it work on MAC or LINUX, you will have to replace :
#### "shell" by "system" (2 lines) and maybe "grep -E" by "grep" (1 line)
#### in the regular expression you may have to suppress the backlash "\"
#### or replace it by a forwardlash "/" but I dont'think so.

#### an alternate multi-platform reading function (readThisData2)
#### has been commented out below (lines 69 to 93)
#### However as readThisData2() can take up to 4 minutes
#### I'll go with the three seconds of readThisData()

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
cat("reading and subsetting the data ")
readThisData()
cat(": done ")
## clean the global environement
rm("readThisData")

#### alternate multi-platform function : (4 minutes)
# readThisData2 <- function(){
#         con  <- file("household_power_consumption.txt", open = "r")
#         con2 <- file("hpc_subset.txt", open = "w")
#         #the loop check if there is still some text to read
#         while(length(oneLine <- readLines(con, n = 1, warn = FALSE)) > 0) {
#             # grab the header line
#             if(grepl("^Date", oneLine)){cat(oneLine, file = con2, sep ="\n")}
#             # grab the observations recorded on Feb. 1st, 2007
#             if(grepl("^1/2/2007", oneLine)){
#                 # write each relevant lines to the hpc_subset.txt file
#                 cat(oneLine, file = con2, sep = "\n")}
#             # grab the observations recorded on Feb. 2nd, 2007
#             if(grepl("^2/2/2007", oneLine)){
#                     cat(oneLine, file = con2, sep = "\n")}  
#         }
#         close(con)
#         close(con2)
# }
# cat("reading and subsetting the data ")
# readThisData2()
# cat(": done ")
# ## clean the global environement
# rm("readThisData2")
#### end of alternate mutli-platform function


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

# plot the data (plot1)

plot2 <- function(){
        library(stringr)
        # open an empty png file
        png(file = "plot2.png", width = 480, height = 480,
            type = "cairo", bg = "transparent")
        #plot the data
        plot(dataLines$Global_active_power, 
             ylab = "Global Active Power (kilowatts)",
             xlab = "", type = "l", axes = FALSE)
        ## put the plot in a box with a lighter dark color than the axis
        box(col="bisque4")
        ## making our own axis in English
        #### record locale
        userLocale <- Sys.getlocale("LC_TIME")
        #### change temporary the locale and set it back on exit
        Sys.setlocale("LC_TIME", "English")
        on.exit(Sys.setlocale("LC_TIME", userLocale))
        #### catch the values of the plot, add one minute for the end of plot
        #### in order to catch the next day's name
        xAxisNames <- c(weekdays(min(dataLines$datetime)),
                        weekdays(dataLines$datetime[1441]),
                        weekdays(max(dataLines$datetime)+60))
        ## use the stringr package to shorten the names to 3 characters
        xAxisNames <- substr(xAxisNames, 1,3)
        axis(1, at = c(1, 1440, 2881), labels = xAxisNames)
        axis(2) ## set automatically the y axis
        ## it's the same as :
        ## axis(2, at = c(0, 2, 4, 6), labels = c(0, 2, 4, 6))
        
        ## close the connection
        dev.off()
}
cat("\n", "plotting the data ")
plot2()
cat(": done ")
cat("\n", "plot2.png is now in your working directory ")
