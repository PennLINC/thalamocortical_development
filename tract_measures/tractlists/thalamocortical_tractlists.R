#### Thalamocortical Tract Lists: Primary and Sensitivity Analyses ####
library(dplyr)
library(tidyverse)
library(purrr)
library(tibble)

# Read in streamline count spreadsheets for all tracts for final study samples
streamlinecounts.glasser.pnc <- read.csv("/cbica/projects/thalamocortical_development/thalamocortical_structuralconnectivity/individual/PNC/PNC_streamlinecount_finalsample.csv")
streamlinecounts.glasser.pnc <- streamlinecounts.glasser.pnc %>% select(contains("autotrack")) #select just tract columns
streamlinecounts.glasser.hcpd <- read.csv("/cbica/projects/thalamocortical_development/thalamocortical_structuralconnectivity/individual/HCPD/HCPD_streamlinecount_finalsample.csv")
streamlinecounts.glasser.hcpd <- streamlinecounts.glasser.hcpd %>% select(contains("autotrack")) #select just tract columns

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
tractlist.pnc.primary <- tract_inclusion(input.df = "streamlinecounts.glasser.pnc", streamline.threshold = 5, inclusion.threshold = 90) #exclude 6.30% (n = 15) tracts
write.csv(tractlist.pnc.primary, "/cbica/projects/thalamocortical_development/thalamocortical_structuralconnectivity/individual/PNC/PNC_tractlist_primary.csv", quote = F, row.names = F)

tractlist.hcpd.primary <- tract_inclusion(input.df = "streamlinecounts.glasser.hcpd", streamline.threshold = 5, inclusion.threshold = 90) #exclude 3.36% (n = 8) tracts
write.csv(tractlist.hcpd.primary, "/cbica/projects/thalamocortical_development/thalamocortical_structuralconnectivity/individual/HCPD/HCPD_tractlist_primary.csv", quote = F, row.names = F)

# Identify thalamocortical tracts to include in the sensitivity analysis
## First, only consider connections with >= 10 streamlines at the participant level
## Then, only include tracts where >= 90% of the study sample has a valid connection
tractlist.pnc.sensitivity <- tract_inclusion(input.df = "streamlinecounts.glasser.pnc", streamline.threshold = 10, inclusion.threshold = 90) #exclude 7.56% (n = 18) tracts
write.csv(tractlist.pnc.sensitivity, "/cbica/projects/thalamocortical_development/thalamocortical_structuralconnectivity/individual/PNC/PNC_tractlist_sensitivity.csv", quote = F, row.names = F)

tractlist.hcpd.sensitivity <- tract_inclusion(input.df = "streamlinecounts.glasser.hcpd", streamline.threshold = 10, inclusion.threshold = 90) #exclude 5.04% (n = 12) tracts
write.csv(tractlist.hcpd.sensitivity, "/cbica/projects/thalamocortical_development/thalamocortical_structuralconnectivity/individual/HCPD/HCPD_tractlist_sensitivity.csv", quote = F, row.names = F)
