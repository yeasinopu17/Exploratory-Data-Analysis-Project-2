#read data
NEI <- readRDS("data/summarySCC_PM25.rds")
SCC <- readRDS("data/Source_Classification_Code.rds")


library(dplyr)
library(ggplot2)

#join two dataFame
NEISCC <- inner_join(NEI,SCC, by = c("SCC"="SCC"))


#filter baltimore and Los Angeles data
names(NEISCC)
data <- filter(NEISCC, fips == "24510"| fips == "06037") %>% 
  mutate(city = ifelse(fips == "24510","Baltimore", "Los Angeles"), 
         vehicle = grepl("vehicle",SCC.Level.Two, ignore.case = T)) %>%
  select(year,fips,city,Emissions,SCC.Level.Two,vehicle) %>%
  filter(vehicle == TRUE)

str(data)

#summarise data
yearlyData <- group_by(data, year,city) %>% summarise(yearlyTotal = sum(Emissions))
yearlyData$year <- factor(yearlyData$year)
yearlyData$city <- factor(yearlyData$city)
str(yearlyData)

#draw the plot
g <- ggplot(yearlyData, aes(year,yearlyTotal, fill = year))
g + geom_bar(stat = "identity") + 
  facet_grid(.~ city) +
  labs(title = expression("PM"[2.5]*" Motor Vehicle Source Emissions in Baltimore & LA, 1999-2008"),
       x = "Year", y = expression("Yearly Emission of PM"[2.5]))

#create png
dev.copy(png, file = "plot6.png")
dev.off()
