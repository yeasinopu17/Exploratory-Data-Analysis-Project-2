#read data
NEI <- readRDS("data/summarySCC_PM25.rds")
SCC <- readRDS("data/Source_Classification_Code.rds")


library(dplyr)
library(ggplot2)

#join two dataFame
NEISCC <- inner_join(NEI,SCC, by = c("SCC"="SCC"))


#filter baltimore data
baltimore_df <- filter(NEISCC, fips == "24510")

#filter motor vehicle data
matchedRows <- grepl("vehicle",baltimore_df$SCC.Level.Two, ignore.case = T)
vehicleData <- baltimore_df[matchedRows,]
dim(vehicleData)

#summarise data
yearlyData <- group_by(vehicleData, year) %>% summarise(yearlyTotal = sum(Emissions))
yearlyData$year <- factor(yearlyData$year)

#draw the plot
g <- ggplot(yearlyData, aes(year,yearlyTotal, fill = year))
g + geom_bar(stat = "identity") + labs(title = "Baltimore's Motor vehicle Emission of PM 2.5",x = "Year", y = expression("Yearly Emission of PM"[2.5]))

#create png
dev.copy(png, file = "plot5.png")
dev.off()
