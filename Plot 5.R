# Setting working directory and Loading related libraries and Data into the Project Directory
library("ggplot2")
library("sqldf")
setwd("/home/jagoul/Coursera/Data-Science-Specialization/Exploratory Data Analysis/Week 3&4/Project/")

# reading PM2.5-PRI Emissions Dataset
NEI <- readRDS("summarySCC_PM25.rds")

# reading Summary file of pollution sources dataset
SCC <- readRDS("Source_Classification_Code.rds")

#Preparing Baltimore dataset
datasetBaltimore <- subset(NEI,fips == "24510")

# Subsetting SCC dataframe based on Motor vehicule related sources.
# Motor vehicule sources are defined as "Mobile - on road" sources, which will base our query on it
motorvehicleSCC <- SCC[grep("Mobile - On-Road",SCC$EI.Sector,ignore.case = TRUE),]

# Join the result table with "dataset_Baltimore" dataframe to pull out all Motor vehicule sources in the city
motor_Vehicle_SCC_Baltimore <- sqldf("SELECT *
                                  FROM datasetBaltimore
                                  LEFT JOIN motorvehicleSCC USING(SCC)
                                  WHERE datasetBaltimore.SCC == motorvehicleSCC.SCC")

# adding a column indicating the vehicule type of this dataset and trim the description for aesthetic purposes
  motor_Vehicle_SCC_Baltimore[["Vehicle.Type"]] <- substring(text = motor_Vehicle_SCC_Baltimore$EI.Sector,18,last = nchar(as.character(motor_Vehicle_SCC_Baltimore$EI.Sector))-8)
  
# plotting the final result 
  g <- ggplot(motor_Vehicle_SCC_Baltimore, aes(as.factor(year), Emissions), col=Vehicle.Type)
  g +  geom_bar(stat ="identity", position = position_identity(),aes(fill=Vehicle.Type))+facet_grid(facets =.~ Vehicle.Type,space = "fixed")+
       theme_bw()+
       labs(x="Year", y= expression("PM"["2.5"]* " Emissions (in Tons)"), title="Emissions of Motor Vehicle related Sources in Baltimore City")

# Exportng plot into png file
  dev.copy(png, filename = "Plot5.png", width=680, height=480)
  dev.off()