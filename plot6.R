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

NEI$year <- factor(NEI$year, levels=c('1999', '2002', '2005', '2008'))

# Baltimore City, Maryland
# Los Angeles County, California
MD.onroad <- subset(NEI, fips == '24510' & type == 'ON-ROAD')
CA.onroad <- subset(NEI, fips == '06037' & type == 'ON-ROAD')

# Aggregate
MD.DF <- aggregate(MD.onroad[, 'Emissions'], by=list(MD.onroad$year), sum)
colnames(MD.DF) <- c('year', 'Emissions')
MD.DF$City <- paste(rep('MD', 4))

CA.DF <- aggregate(CA.onroad[, 'Emissions'], by=list(CA.onroad$year), sum)
colnames(CA.DF) <- c('year', 'Emissions')
CA.DF$City <- paste(rep('CA', 4))

DF <- as.data.frame(rbind(MD.DF, CA.DF))

# Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources 
# in Los Angeles County, California (fips == 06037). Which city has seen greater changes over time 
# in motor vehicle emissions?

# Construct initial plot then add layers
plot <- ggplot(data=DF, aes(x=year, y=Emissions)) 
plot <- plot + geom_bar(aes(fill=year), stat="identity") + guides(fill=F) 
plot <- plot + ggtitle('Total Emissions of Motor Vehicle Sources\nLos Angeles County, California vs. Baltimore City, Maryland') 
plot <- plot + ylab(expression('PM'[2.5])) + xlab('Year')
plot <- plot + theme(legend.position='none') 
plot <- plot + facet_grid(. ~ City) 
plot <- plot + geom_text(aes(label=round(Emissions,0), size=1, hjust=0.5, vjust=-1))

# Save output as .png and turn off graphics device
ggsave(filename = 'plot6.png', scale = 1)
dev.off()