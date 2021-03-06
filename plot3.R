#read data
NEI <- readRDS("data/summarySCC_PM25.rds")
SCC <- readRDS("data/Source_Classification_Code.rds")


library(dplyr)
library(ggplot2)

#filter baltimore data
baltimore_data <- filter(NEI, fips == "24510") %>% group_by(type,year) %>%
  summarise(yearlyTotal = sum(Emissions )) %>% 
  arrange(type,year)

baltimore_data$type <- factor(baltimore_data$type)
baltimore_data$year <- factor(baltimore_data$year)

#draw the plot
g <- ggplot(baltimore_data, aes(year, yearlyTotal, fill = year))
g + geom_bar(stat = "identity") + facet_grid(.~type) +
  labs(x = "Year", y = expression("Total Tons of PM"[2.5]*" Emissions")) +
  theme_bw()

#create png
dev.copy(png, file = "plot3.png")
dev.off()
