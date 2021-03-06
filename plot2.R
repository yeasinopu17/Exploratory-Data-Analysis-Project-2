#read data
NEI <- readRDS("data/summarySCC_PM25.rds")
SCC <- readRDS("data/Source_Classification_Code.rds")


library(dplyr)

#filter baltimore data
baltimore_data <- filter(NEI, fips == "24510") %>% group_by(year) %>%
  summarise(yearlyTotal = sum(Emissions ))

#draw the plot
with(baltimore_data, barplot(yearlyTotal, names.arg = year,
                             col = year,
                             main = "Yearly Emission in Baltimore",
                             xlab = "Years",
                             ylab = expression("Total PM"[2.5]*"Emission")))

#create png
dev.copy(png, file = "plot2.png")
dev.off()
