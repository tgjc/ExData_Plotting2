# load required packages
library(package = RMySQL)
library(package = ggplot2)

# Set working directory
setwd("~/Dropbox/Coursera/ExData_Plotting2/")

# Check if data directory exists and if not, create one
if(!file.exists("data")) {
        dir.create("data")
}

# Loading provided datasets - loading from local machine
NEI <- readRDS("./data/summarySCC_PM25.rds")
SCC <- readRDS("./data/Source_Classification_Code.rds")

# Coal combustion related sources
SCC.coal = SCC[grepl("coal", SCC$Short.Name, ignore.case=TRUE),]

# Merge two data sets
merge <- merge(x=NEI, y=SCC.coal, by='SCC')
merge.sum <- aggregate(merge[, 'Emissions'], by=list(merge$year), sum)
colnames(merge.sum) <- c('Year', 'Emissions')

# Across the United States, how have emissions from coal combustion-related sources 
# changed from 1999-2008?

# Construct initial plot then add layers
p <- ggplot(data=merge.sum, aes(x=Year, y=Emissions/1000)) 
p <- p + geom_line(aes(group=1, col=Emissions)) 
p <- p + geom_point(aes(size=2, col=Emissions)) 
p <- p + ggtitle(expression('Total Emissions of PM'[2.5])) 
p <- p + ylab(expression(paste('PM', ''[2.5], ' in kilotons'))) 
p <- p + geom_text(aes(label=round(Emissions/1000,digits=2), size=2, hjust=1.5, vjust=1.5)) 
p <- p + theme(legend.position='none') + scale_colour_gradient(low='black', high='red')

# Save output as .png
ggsave(filename = 'plot4.png', scale = 1)
