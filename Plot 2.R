# Setting working directory and Loading Data into the Project Directory
setwd("/home/jagoul/Coursera/Data-Science-Specialization/Exploratory Data Analysis/Week 3&4/Project/")

# reading PM2.5-PRI Emissions Dataset
NEI <- readRDS("summarySCC_PM25.rds")

# reading Summary file of pollution sources dataset
SCC <- readRDS("Source_Classification_Code.rds")

# To plot Baltimore City Emissions from 1999 until 2008, we need to subset NEI dataset of Baltimore city then
# sum-up all Emissions entries captured by all sources under each year

datasetBaltimore <- subset(NEI,fips == "24510")
datasetBaltimoreAggregated <- with(datasetBaltimore,aggregate(x= Emissions ,by = list(year), FUN= sum, na.rm=TRUE))
names(datasetBaltimoreAggregated) <- c("year", "Emissions")

#Emissions are aggregated by year now for Baltimore city , plotting Emissions values
with(datasetBaltimoreAggregated,barplot(Emissions /10^6, names.arg = year,col = "cyan", main = "PM2.5 Emissions in Baltimore city", xlab = "Year", ylab= "PM2.5 Emissions (in Tons)"))
dev.copy(png, filename = "Plot2.png",width = 680, height = 480)
dev.off()