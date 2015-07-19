# Download files using CRAN library "downloader".  Unzip and place in folder
# titled, "Project2", which is the working directory.  Use ggplot2 for
# graphing.

library(downloader)
library(ggplot2)
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
# according to year and type.

emitPerYear <- aggregate(Emissions ~ year + type, data=BaltimoreNEI, FUN=sum)

# Graph using ggplot2.

g <- ggplot(emitPerYear, aes(year, Emissions))
p <- g + geom_line(col="red") +
    geom_point(pch=16, col="red") +
    facet_grid(.~type) +
    ggtitle("Baltimore City Tons of PM2.5 Emissions Per Year by Source") +
    ylab("Tons of PM2.5 Emissions") +
    xlab("Year")
print(p)

# Copy file to *.png format and save to working directory.

dev.copy(png, "plot3.png", width=600, height=480)
dev.off()

