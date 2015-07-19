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

# Merge data and filter by the coal combustion related sources.

mergedData <- merge(NEI, SCC, by.x="SCC", by.y="SCC")

coalData <- filter(mergedData, EI.Sector=="Fuel Comb - Electric Generation - Coal" |
                   EI.Sector=="Fuel Comb - Industrial Boilers, ICEs - Coal" |
                   EI.Sector=="Fuel Comb - Comm/Institutional - Coal")

# Calculate the aggregate emissions per year per EI Sector = Coal

coalEmitPerYear <- aggregate(Emissions ~ year + EI.Sector, data=coalData, FUN=sum)

# Plot

g <- ggplot(coalEmitPerYear, aes(year, Emissions))
p <- g + geom_point(pch=16, col="red") +
    geom_line(col="red") +
    facet_grid(.~EI.Sector) +
    ggtitle("US PM2.5 Emissions from Coal Combustion Sources") +
    ylab("Tons of PM2.5 Emissions") +
    xlab("Year")
p

# Copy file to *.png format and save to working directory.

dev.copy(png, "plot4.png", width=680, height=480)
dev.off()
