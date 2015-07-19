# Download files using CRAN library "downloader".  Unzip and place in folder
# titled, "Project2", which is the working directory.  Use ggplot2 for
# graphing.

library(downloader)
library(ggplot2)
library(dplyr)
setwd("~/Coursera/Exploratory/Project2")
download("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",
         dest="dataset.zip", mode="wb")
unzip("dataset.zip", exdir="./")

# Read in files from download.

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Merge data and filter by the coal combustion related sources.  Data was then 
# aggregated for graphing.

mergedData <- merge(NEI, SCC, by.x="SCC", by.y="SCC")

mobBalData <- filter(mergedData, grepl("motor", Short.Name, ignore.case=TRUE) & fips=="24510")

mobEmitPerYear <- aggregate(Emissions ~ year, data=mobBalData, FUN=sum)

# Plot

g <- ggplot(mobEmitPerYear, aes(year, Emissions))
p <- g + geom_point(pch=16, col="red") +
    geom_line(col="red") +
    ggtitle("Baltimore City PM2.5 Emissions from Motor Vehicle Sources") +
    ylab("Tons of PM2.5 Emissions") +
    xlab("Year")
p

# Copy file to *.png format and save to working directory.

dev.copy(png, "plot5.png", width=480, height=480)
dev.off()
