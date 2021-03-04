#read data
NEI <- readRDS("data/summarySCC_PM25.rds")
SCC <- readRDS("data/Source_Classification_Code.rds")


library(dplyr)

#create yearly summation
yearlyData <- group_by(NEI,year) %>% summarise(yearlyTotal = sum(Emissions))

#draw the plot
with(yearlyData,barplot(yearlyTotal, names.arg = year,
                        col = year,
                        main = "Yearly Emission",
                        xlab = "Years", 
                        ylab = expression("Total PM"[2.5]*"Emission")))
#create png
dev.copy(png, file = "plot1.png")
dev.off()
