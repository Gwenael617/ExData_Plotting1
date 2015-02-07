#################################################.
## File: plot1.R
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
#### to make it work on MAC or LINUX, you may have to replace :
#### "shell" by "system" (2 lines) and "grep -E" by "grep" (1 line)
#### in the regular expression you may have to suppress the backlash "\"
#### or replace it by a forwardlash "/"

#### an alternate multi-platform reading function (readThisData2)
#### has been commented out below 
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

plot1 <- function(){
        # open an empty png file
        png(file = "plot1.png", width = 480, height = 480,
            type = "cairo", bg = "transparent")
        dataPlotted <- dataLines$Global_active_power
        hist(dataPlotted, col = "red", main = "Global Active Power",
             xlab = "Global Active Power (kilowatts)", cex.lab = 1)
        #### modify cex.lab to increase or reduce the axis labels size 
        #### (default = 1)
        ## close the connection
        dev.off()
}
cat("\n", "plotting the data ")
plot1()
cat(": done ")
cat("\n", "plot1.png is now in your working directory ")
