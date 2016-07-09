# Setting working directory and Loading Data into the Project Directory
setwd("/home/jagoul/Coursera/Data-Science-Specialization/Exploratory Data Analysis/Week 3&4/Project/")

# reading PM2.5-PRI Emissions Dataset
NEI <- readRDS("summarySCC_PM25.rds")

# reading Summary file of pollution sources dataset
SCC <- readRDS("Source_Classification_Code.rds")

# To plot Emissions per year, we need to sum-up all Emissions entries captured by all sources under the same year
totalEmissionsPerYear <- with(NEI,aggregate(x= Emissions ,by = list(year), FUN= sum, na.rm=TRUE))
names(totalEmissionsPerYear) <- c("year", "Emissions")

#Emissions are aggregated by year now , plotting Emissions values
#par(mar=c(5,4,2,1))
with(totalEmissionsPerYear,barplot(Emissions /10^6, names.arg = year,col=Emissions, main = "PM2.5 Emissions in the United States", xlab = "Year", ylab= "PM2.5 Emissions (in Tons)"))

# Exportng plot as a png file
dev.copy(png, filename = "Plot1.png", width=680, height=480)
dev.off()