# load required packages
packages <- c("RMySQL", "ggplot2")
sapply(packages, require, character.only = TRUE, quietly = TRUE)

# Set working directory
setwd("~/Dropbox/Coursera/ExData_Plotting2/")

# Check if data directory exists and if not, create one
if(!file.exists("data")) {
        dir.create("data")
}

# Loading provided datasets - loading from local machine
NEI <- readRDS("./data/summarySCC_PM25.rds")
SCC <- readRDS("./data/Source_Classification_Code.rds")

# Convert year to factor (faceting)
NEI$year <- factor(NEI$year, levels=c('1999', '2002', '2005', '2008'))

# Baltimore City, Maryland == fips
MD.onroad <- subset(NEI, fips == 24510 & type == 'ON-ROAD')

# Aggregate
MD.df <- aggregate(MD.onroad[, 'Emissions'], by=list(MD.onroad$year), sum)
colnames(MD.df) <- c('year', 'Emissions')

# How have emissions from motor vehicle sources changed from 1999-2008 in Baltimore City? 

# Construct initial plot then add layers
p <- ggplot(data=MD.df, aes(x=year, y=Emissions)) 
p <- p + geom_bar(aes(stat=identity)) + guides(fill=F) 
p <- p + ggtitle('Total Emissions of Motor Vehicle Sources in Baltimore City, Maryland')
p <- p + ylab(expression('PM'[2.5])) + xlab('Year') + theme(legend.position='none') 
p <- p + geom_text(aes(label=round(Emissions,0), size=1, hjust=0.5, vjust=2))

# Save output as .png and turn off graphics device
ggsave(filename = 'plot5.png', scale = 1)
dev.off()