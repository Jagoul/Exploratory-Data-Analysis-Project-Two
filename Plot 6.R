# Setting working directory and Loading related libraries and Data into the Project Directory
library("ggplot2")
library("sqldf")
setwd("/home/jagoul/Coursera/Data-Science-Specialization/Exploratory Data Analysis/Week 3&4/Project/")

# reading PM2.5-PRI Emissions Dataset
NEI <- readRDS("summarySCC_PM25.rds")

# reading Summary file of pollution sources dataset
SCC <- readRDS("Source_Classification_Code.rds")

#Preparing Baltimore dataset
BaltimoreDataset <- subset(NEI,NEI$fips == "24510")
 
#Preparing Los Angeles dataset
LosAngelesDataset <- subset(NEI, NEI$fips == "06037")

# Subsetting SCC dataframe based on Motor vehicule related sources.
# Motor vehicule sources are defined as "Mobile - on road" sources, which we will base our query on
motorvehicleSCC <- SCC[grep("Mobile - On-Road",SCC$EI.Sector,ignore.case = TRUE),]

# Join the result table with "BaltimoreDataset" dataframe to pull out all Motor vehicule sources in the city
motor_Vehicle_SCC_Baltimore <- sqldf("SELECT *
                                  FROM BaltimoreDataset
                                  LEFT JOIN motorvehicleSCC USING(SCC)
                                  WHERE BaltimoreDataset.SCC == motorvehicleSCC.SCC")

# Join the result table with "LosAngeles" dataframe to pull out all Motor vehicule sources in the city
motor_Vehicle_SCC_LosAngeles <- sqldf("SELECT *
                                  FROM LosAngelesDataset
                                  LEFT JOIN motorvehicleSCC USING(SCC)
                                  WHERE LosAngelesDataset.SCC == motorvehicleSCC.SCC")

# Adding a column indicating the vehicule type of this dataset and trim the description for aesthetic purposes
motor_Vehicle_SCC_Baltimore[["Vehicle.Type"]] <- substring(text = motor_Vehicle_SCC_Baltimore$EI.Sector,18,last = nchar(as.character(motor_Vehicle_SCC_Baltimore$EI.Sector))-8)

# Adding a column indicating the vehicule type of this dataset and trim the description for aesthetic purposes
motor_Vehicle_SCC_LosAngeles[["Vehicle.Type"]] <- substring(text = motor_Vehicle_SCC_LosAngeles$EI.Sector,18,last = nchar(as.character(motor_Vehicle_SCC_LosAngeles$EI.Sector))-8)

# Merging the two datasets
Baltimore_LosAngeles_Dataset <- rbind(motor_Vehicle_SCC_Baltimore,motor_Vehicle_SCC_LosAngeles)

# Replacing Fips numbers by City name
Baltimore_LosAngeles_Dataset$fips <- c(ifelse(Baltimore_LosAngeles_Dataset$fips == "24510", "Baltimore", "Los Angeles"))

# Plotting the final result 
g <- ggplot(Baltimore_LosAngeles_Dataset, aes(as.factor(year), Emissions, fill=Vehicle.Type))
g +  geom_bar(stat ="identity", position = position_dodge())+facet_grid(.~fips)+
     theme_bw()+
     labs(x="Year", y= expression("PM"["2.5"]* " Emissions (in Tons)"))+
     ggtitle(expression(atop("Emissions of Motor Vehicle related Sources", atop(italic("Case study : Baltimore, MD and Los Angeles, CA"), ""))))  


# Exportng plot into png file
  dev.copy(png, filename = "Plot6.png", width=680, height=560)
  dev.off()
 