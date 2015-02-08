## Exploratory Data Analysis - Course Project 1


This repository contains my work for the Coursera Exploratory Data Analysis' course project.

#### Introduction

You can find the original README [here][i1] or in the [original repo][i2]

[i1]: https://github.com/Gwenael617/ExData_Plotting1/blob/master/oldREADME.md
[i2]: https://github.com/rdpeng/ExData_Plotting1

I've chosen to modify the README in order to integrate information on how to use the codes in this repository and to cite my references.
However, all the informations concerning where the data come from and describing the variables can be found in the [oldREADME][i1] and therefore won't be reproduced here.

The purpose of this project is to demonstrate our ability **to plot** a smaller dataset extracted from a bigger one (2,075,259 rows and 9 columns) **using the base plotting system**.


#### Content

This repository contains thirteen files and one folder :
* This README,
* the oldREADME
* __the eight files required__ for this project : one .R file (the code) and one .png file (the plot) for each of the four plots drew
* the figure folder (containing four files) was kept from the original repository in order to facilitate some comparison, however those original files are bigger in size and lower in resolution.

_There won't be any CodeBook as the variables are described in the [oldREADME][i1]_


#### Prerequisites
_(or how to run this code)_

* The data should be [downloaded][p1], unzipped and placed into your working directory. However the codes will check if the data are available and will download and/or unzip it for you if needed.
* The plot(1 to 4).R  scripts go __in the same working directory__.
* The codes don't require any package.

* Note : The original unzipped file (household_power_consumption.txt) can be heavy to read in a simple text editor (126MB). If you want to look at it on a text editor, use a superior one like (notepad++ or wrangler). The scripts provide a fast, safe way to read this data and will write a much smaller subsetted .txt file (hpc_subset.txt, 176kb).

[p1]: https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip

#### Steps (each of the codes are constructed on the same structure)
_(what the code does, the explanations of the data are in the oldREADME)_

1. Check if the household_power_consumption.txt exists and download it and/or unzip it depending of the case.
2. Subtract the observations recorded on the 1st and 2nd of February 2007. 
3. Melt the date and time in one single column.
4. Plot the data (line 99 ff.) according to the examples shown in the [original README][i1] or in the figure folder. 
5. Inform the user when all is done.

_Note 1 : The code will check which operating system it is run on. It'll use the shell() function on Windows and the system() function on other OS (mac, Linux,...). Those functions have been chosen because of their efficiency (only a few seconds to read, subset and plot from the original dataset)._

_Note 2 : I've chosen the transparent background for plotting as this is the background used in the examples in the figure folder of the instructor, however depending of the device used the transparent background may cause some minor variations (see this [discussion][Ref07])._

#### References :
* The png() function's [documentation][Ref01]
* David Smith's [10 tips][Ref02] for making your R graphics look their best
* Christoffer Rasmussen's [idea][Ref03] concerning the system() function.
* The system() function's [documentation][Ref04]
* Henrik Bengtsson-3's [recommendation][Ref05] on the shell() function
* The [escape sequences][Ref06] in Regular expressions
* The [discussion][Ref07] about the transparent background.
* Further [discussion][Ref08] about the transparent background.

_Note : The third, seventh, and eigth references are only accessible to participants of the 11th edition of this course._

[Ref01]: http://stat.ethz.ch/R-manual/R-devel/library/grDevices/html/png.html
[Ref02]: http://blog.revolutionanalytics.com/2009/01/10-tips-for-making-your-r-graphics-look-their-best.html
[Ref03]: https://class.coursera.org/exdata-011/forum/thread?thread_id=21#comment-50
[Ref04]: http://stat.ethz.ch/R-manual/R-devel/library/base/html/system.html
[Ref05]: http://r.789695.n4.nabble.com/how-to-run-system-command-tp4449597p4451758.html
[Ref06]: http://stat545-ubc.github.io/block022_regular-expression.html
[Ref07]: https://class.coursera.org/exdata-011/forum/thread?thread_id=24
[Ref08]: https://class.coursera.org/exdata-011/forum/thread?thread_id=59#post-515
