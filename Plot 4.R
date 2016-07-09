# Setting working directory and Loading related libraries and Data into the Project Directory
library("ggplot2")
library("sqldf")
setwd("/home/jagoul/Coursera/Data-Science-Specialization/Exploratory Data Analysis/Week 3&4/Project/")

# reading PM2.5-PRI Emissions Dataset
NEI <- readRDS("summarySCC_PM25.rds")

# reading Summary file of pollution sources dataset
SCC <- readRDS("Source_Classification_Code.rds")

# After a quick overview of the "Source classification data set" we will play around with the dataset. 
# 1- We will subset the data according to combustion at level one
# 2- we will also subset Coal source pollutant at level four.
Comb_SCC <- SCC[grep("comb",SCC$SCC.Level.One,ignore.case = TRUE),]
Coal_Comb_SCC <- SCC[grep("coal",Comb_SCC$SCC.Level.Four,ignore.case = TRUE),]

# joining the new table with the original NEI table to extract all coal combustion sources
# we have 4576 observations ec=xtracted from the NEI dataframe
Coal_Comb_SCC_NEI <- sqldf("SELECT fips,SCC,Pollutant,Emissions,type,year 
                                  FROM NEI
                                  LEFT JOIN Coal_Comb_SCC USING(SCC)
                                  WHERE NEI.SCC==Coal_Comb_SCC.SCC")

# Now back to our exercise and subsetting the original SCC by EI.sector that contains "coal" pattern
# and overwritting the previous one
Coal_Comb_SCC <- SCC[grep("coal",SCC$EI.Sector,ignore.case = TRUE),]

# Also overwritting Coal_Comb_SCC_NEI by joining results of Coal_Comb_SCC with NEI
Coal_Comb_SCC_NEI <- sqldf("SELECT fips,SCC,Pollutant,Emissions,type,year 
                                  FROM NEI
                                  LEFT JOIN Coal_Comb_SCC USING(SCC)
                                  WHERE NEI.SCC==Coal_Comb_SCC.SCC")
# renaming columns dataset for easthetic reaons 
names(Coal_Comb_SCC_NEI) <- c("Fips","SCC","Pollutant","Emissions","Type","Year")

# plotting the result using ggplot2
par(mar=c(5,4,2,1))
g <- ggplot(Coal_Comb_SCC_NEI,aes(factor(Year), Emissions, fill=Type))
g+ geom_bar(stat ="identity", position = position_identity())+
   facet_grid(facets = .~Type, space = "fixed")+
   labs(x="Year", y= expression("PM"["2.5"]* " Emissions (in Tons)"), title= expression("Coal Combustion-Related Sources Emissions in the United States"))

# Exportng plot into png file
dev.copy(png, filename = "Plot4.png", width=680, height=480)
dev.off()