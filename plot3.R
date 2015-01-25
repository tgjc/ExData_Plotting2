# load required packages
library(package = RMySQL)
library(package = ggplot2)

# Set working directory
setwd("~/Dropbox/Coursera/ExData_Plotting2/")

# Check if data directory exists and if not, create one
if(!file.exists("data")){
        dir.create("data")
}

# Loading provided datasets - loading from local machine
NEI <- readRDS("./data/summarySCC_PM25.rds")
SCC <- readRDS("./data/Source_Classification_Code.rds")

# Sampling
NEI_sampling <- NEI[sample(nrow(NEI), size=5000, replace=F), ]

# Baltimore City, Maryland == fips
MD <- subset(NEI, fips == 24510)
MD$year <- factor(MD$year, levels=c('1999', '2002', '2005', '2008'))

# Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, 
# which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City? 
# Which have seen increases in emissions from 1999–2008? 
# Use the ggplot2 plotting system to make a plot answer this question.

# Construct initial plot then add layers
p <- ggplot(data=MD, aes(x=year, y=log(Emissions))) 

p <- p + facet_grid(. ~ type) + guides(fill=F) 
p <- p + geom_boxplot(aes(fill=type)) + stat_boxplot(geom ='errorbar') 
p <- p + ylab(expression(paste('Log', ' of PM'[2.5], ' Emissions'))) 
p <- p + xlab('Year') 
p <- p + ggtitle('Emissions per Type in Baltimore City, Maryland') 
p <- p + geom_jitter(alpha=0.10)

# Save output as .png
ggsave(filename = 'plot3.png', scale = 1)