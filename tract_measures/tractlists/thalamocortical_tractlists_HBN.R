#### Thalamocortical Tract Lists: Primary and Sensitivity Analyses ####
library(dplyr)
library(tidyverse)
library(purrr)
library(tibble)

# Read in streamline count spreadsheets for all tracts for final study sample
streamlinecounts.glasser.hbn <- read.csv("/cbica/projects/thalamocortical_development/thalamocortical_structuralconnectivity/individual/HBN/HBN_streamlinecount_finalsample.csv")
streamlinecounts.glasser.hbn <- streamlinecounts.glasser.hbn %>% select(contains("autotrack")) #select just tract columns

# Function to create a thalamocortical tract list based on a connection-level streamline count threshold and sample-level participant inclusion threshold
tract_inclusion <- function(input.df, streamline.threshold, inclusion.threshold){
  tractcount.df <- get(input.df)
  tractcount.df[tractcount.df < streamline.threshold] = NA #NA out connections with fewer streamlines than the streamline threshold
  tracts.percentvalid <- sapply(tractcount.df, function(x){(sum(!is.na(x))/nrow(tractcount.df))*100}) %>% as.data.frame() %>% set_names("percent.valid") %>% rownames_to_column("tract") #calculate the percent of participants that have each tract
  tracts.percentvalid$percent.valid <- round(tracts.percentvalid$percent.valid, 0) #merry-go-round
  tracts.to.include <- tracts.percentvalid %>% filter(percent.valid >= inclusion.threshold) %>% select(tract) #inclusion tract list
  return(tracts.to.include)
}

# Identify thalamocortical tracts to include in the primary analysis
## First, only consider connections with >= 5 streamlines at the participant level
## Then, only include tracts where >= 90% of the study sample has a valid connection
tractlist.hbn.primary <- tract_inclusion(input.df = "streamlinecounts.glasser.hbn", streamline.threshold = 5, inclusion.threshold = 90) #exclude 13 tracts
write.csv(tractlist.hbn.primary, "/cbica/projects/thalamocortical_development/thalamocortical_structuralconnectivity/individual/HBN/HBN_tractlist_primary.csv", quote = F, row.names = F)

# Identify thalamocortical tracts to include in the sensitivity analysis
## First, only consider connections with >= 10 streamlines at the participant level
## Then, only include tracts where >= 90% of the study sample has a valid connection
tractlist.hbn.sensitivity <- tract_inclusion(input.df = "streamlinecounts.glasser.hbn", streamline.threshold = 10, inclusion.threshold = 90) #exclude 19 tracts
write.csv(tractlist.hbn.sensitivity, "/cbica/projects/thalamocortical_development/thalamocortical_structuralconnectivity/individual/HBN/HBN_tractlist_sensitivity.csv", quote = F, row.names = F)
