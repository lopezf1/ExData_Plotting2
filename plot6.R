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

# Merge data and filter by the motor related sources and US County.
# Aggregated for graphing.

mergedData <- merge(NEI, SCC, by.x="SCC", by.y="SCC")

mobBalData <- filter(mergedData, grepl("motor", Short.Name, ignore.case=TRUE) &
                         fips=="24510")

mobLAData <- filter(mergedData, grepl("motor", Short.Name, ignore.case=TRUE) &
                         fips=="06037")

# Aggregate emissions results and then combine for both counties.

mobEmitBal <- aggregate(Emissions ~ year + fips, data=mobBalData, FUN=sum)
mobEmitLA <- aggregate(Emissions ~ year + fips, data=mobLAData, FUN=sum)
mobEmitPerYear <- rbind(mobEmitBal, mobEmitLA)

# Change fips number to county name.

mobEmitPerYear$fips[mobEmitPerYear$fips=="24510"] <- "Baltimore City"
mobEmitPerYear$fips[mobEmitPerYear$fips=="06037"] <- "Los Angeles County"
colnames(mobEmitPerYear) <- c("Year", "County", "Emissions")g <

# Plot

g <- ggplot(mobEmitPerYear, aes(Year, Emissions, color=County))
p <- g + geom_point() +
    geom_line() +
    ggtitle("Baltimore City vs Los Angeles County 
            PM2.5 Emissions from Motor Vehicle Sources") +
    ylab("Tons of PM2.5 Emissions")
p

# Copy file to *.png format and save to working directory.

dev.copy(png, "plot6.png", width=500, height=480)
dev.off()