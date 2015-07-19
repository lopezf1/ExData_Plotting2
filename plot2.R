# Download files using CRAN library "downloader".  Unzip and place in folder
# titled, "Project2", which is the working directory.

library(downloader)
setwd("~/Coursera/Exploratory/Project2")
download("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",
         dest="dataset.zip", mode="wb")
unzip("dataset.zip", exdir="./")

# Read in files from download.

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Subset NEI data for only Baltimore City (fips="24510)

BaltimoreNEI <- NEI[which(fips=="24510"), ]

# Use aggregate function to apply function "sum" to Emissions and split
# according to year.

emitPerYear <- aggregate(Emissions ~ year, data=BaltimoreNEI, FUN=sum)

# Graph using R base plotting system.

with(emitPerYear, plot(year, Emissions, pch=16, col="red",
                       main="Baltimore City Tons of PM2.5 Emissions Per Year",
                       xlab="Year",
                       ylab="Tons of PM2.5 Emissions"))
with(emitPerYear, lines(year, Emissions, col="red"))

# Copy file to *.png format and save to working directory.

dev.copy(png, "plot2.png")
dev.off()