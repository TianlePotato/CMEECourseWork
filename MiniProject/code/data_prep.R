##################################### PACKAGES #################################
# PACKAGES
library(tidyverse)
library(minpack.lm)

#################################### DATA WRANGLING ############################
# Read in data
data <- read.csv("../data/LogisticGrowthData.csv")
# Create new column of unique citation IDs
data$Citation_IDs <- as.numeric(factor(data$Citation, levels = unique(data$Citation)))
# Create new column of IDs
data$ID <- paste(data$Species, data$Temp, data$Medium, data$Citation_IDs, sep = "_")
# Remove rows with negative PopBio values
data_modified <- data %>% filter(PopBio > 0)
# Create column of logged PopBio values
data_modified$log.PopBio <- log(data_modified$PopBio)

write.csv(data_modified, "../data/data_modified.csv")