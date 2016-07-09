# Setting working directory and Loading libraries and Data into the Project Directory
library("ggplot2")
setwd("/home/jagoul/Coursera/Data-Science-Specialization/Exploratory Data Analysis/Week 3&4/Project/")

# reading PM2.5-PRI Emissions Dataset
NEI <- readRDS("summarySCC_PM25.rds")

# reading Summary file of pollution sources dataset
SCC <- readRDS("Source_Classification_Code.rds")

# To plot All emissions sources in Baltimore City from 1999 until 2008, we need to subset NEI dataset of Baltimore city then
# sum-up all Emissions entries and seggregate it by source type under each given year.
datasetBaltimore <- subset(NEI,fips == "24510")
datasetBaltimoreAggregatedbyType <- with(datasetBaltimore,aggregate(x= Emissions ,by = list(year,type), FUN= sum, na.rm=TRUE))
names(datasetBaltimoreAggregatedbyType) <- c("Year", "Type","Emissions")

# Emissions are aggregated by type for Baltimore city and distributed over the year between 1999-2008
# Plotting the schema of all sources
par(mar=c(5,4,2,1))
g <- ggplot(datasetBaltimoreAggregatedbyType,aes(factor(Year), Emissions, fill=Type))
g+ geom_bar(stat ="identity")+
   facet_grid(facets = .~Type,space = "fixed")+
   labs(x="Year", y= expression("PM"["2.5"]* " Emissions (in Tons)"), title= expression("PM"["2.5"]* " Emissions By Source Type in Baltimore City"))

# Exportng plot into png file
dev.copy(png, filename = "Plot3.png", width=680, height=480)
dev.off()



