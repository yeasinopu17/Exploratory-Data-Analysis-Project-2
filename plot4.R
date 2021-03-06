#read data
NEI <- readRDS("data/summarySCC_PM25.rds")
SCC <- readRDS("data/Source_Classification_Code.rds")


library(dplyr)
library(ggplot2)

#join two dataFame
NEISCC <- inner_join(NEI,SCC, by = c("SCC"="SCC"))

#fetch all NEISCC records with Short.Name (SCC) Coal
matchedRows <- grepl("coal",NEISCC$Short.Name, ignore.case = T)
subsetNEISCC <- NEISCC[matchedRows,]
yearlyData <- group_by(subsetNEISCC,year) %>% summarise(yearlyTotal = sum(Emissions))
yearlyData$year <- factor(yearlyData$year)

#draw the plot
g <- ggplot(yearlyData, aes(year,yearlyTotal, fill = year))
g + geom_bar(stat = "identity") + labs(x = "Year", y = expression("Total Emission of PM"[2.5]))

#create png
dev.copy(png, file = "plot4.png")
dev.off()
