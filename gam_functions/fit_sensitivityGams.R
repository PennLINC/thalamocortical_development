#### Fit Developmental Sensitivity GAMs ####
library(dplyr)
library(tidyverse)
library(cifti)
source("/cbica/projects/thalamocortical_development/code/thalamocortical_development/gam_functions/GAM_functions_thalamocortical.R")
set.seed(1)

############################################################################################################
#### Prepare Data ####

#Glasser regions with corresponding labels and tract names
glasser.regions <- read.csv("/cbica/projects/thalamocortical_development/Maps/parcellations/surface/glasser360_regionlist.csv") #parcel name, label name 
glasser.regions$tract <- paste0("thalamus_", glasser.regions$orig_parcelname) %>% gsub("_ROI", "_autotrack", .) %>% gsub("-", "_", .) #create tract variable with format thalamus_$hemi_$region_autotrack, no dashes -

#S-A axis
S.A.axis.cifti <- read_cifti("/cbica/projects/thalamocortical_development//Maps/S-A_ArchetypalAxis/FSLRVertex/SensorimotorAssociation_Axis_parcellated/SensorimotorAssociation.Axis.Glasser360.pscalar.nii") #S-A_ArchetypalAxis repo
S.A.axis <- data.frame(SA.axis = rank(S.A.axis.cifti$data), orig_parcelname = names(S.A.axis.cifti$Parcel))
S.A.axis <- merge(S.A.axis, glasser.regions, by="orig_parcelname", sort = F)

#Dataset-specific tract lists for analysis
tractlist.pnc <- read.csv("/cbica/projects/thalamocortical_development/thalamocortical_structuralconnectivity/individual/PNC/PNC_tractlist_primary.csv") #generated by tract_measures/tractlists/thalamocortical_tractlists.R
tractlist.hcpd <- read.csv("/cbica/projects/thalamocortical_development/thalamocortical_structuralconnectivity/individual/HCPD/HCPD_tractlist_primary.csv") #generated by tract_measures/tractlists/thalamocortical_tractlists.R

#Dataset-specific tract diffusion measures
FA.glasser.pnc <- read.csv("/cbica/projects/thalamocortical_development/thalamocortical_structuralconnectivity/individual/PNC/PNC_FA_finalsample_primary.csv")
FA.glasser.pnc$sex <- as.factor(FA.glasser.pnc$sex)

FA.glasser.hcpd <- read.csv("/cbica/projects/thalamocortical_development/thalamocortical_structuralconnectivity/individual/HCPD/HCPD_FA_finalsample_primary.csv")
FA.glasser.hcpd$sex <- as.factor(FA.glasser.hcpd$sex)

#Surface area sensitivity analysis dfs
area.glasser.pnc <- read.csv("/cbica/projects/thalamocortical_development/cortical_anatomy/individual/PNC/PNC_surfacearea_finalsample.csv")
colnames(area.glasser.pnc)[2:239] <- sprintf("%s_area", colnames(area.glasser.pnc[2:239]))
area.glasser.hcpd <- read.csv("/cbica/projects/thalamocortical_development/cortical_anatomy/individual/HCPD/HCPD_surfacearea_finalsample.csv")
colnames(area.glasser.hcpd)[2:239] <- sprintf("%s_area", colnames(area.glasser.hcpd[2:239]))

#SNR sensitivity analysis dfs
snr.glasser.pnc <- read.csv("/cbica/projects/thalamocortical_development/thalamocortical_structuralconnectivity/individual/PNC/PNC_SNR_finalsample.csv")
colnames(snr.glasser.pnc)[2:239] <- sprintf("%s_SNR", colnames(snr.glasser.pnc[2:239]))
snr.glasser.hcpd <- read.csv("/cbica/projects/thalamocortical_development/thalamocortical_structuralconnectivity/individual/HCPD/HCPD_SNR_finalsample.csv") 
colnames(snr.glasser.hcpd)[2:239] <- sprintf("%s_SNR", colnames(snr.glasser.hcpd[2:239]))

#Overlap measures sensitivity analysis dfs
sensitivity.glasser.pnc <- read.csv("/cbica/projects/thalamocortical_development/thalamocortical_structuralconnectivity/individual/PNC/PNC_overlapsensitivity_finalsample.csv")
colnames(sensitivity.glasser.pnc)[2:239] <- sprintf("%s_sensitivity", colnames(sensitivity.glasser.pnc[2:239]))
sensitivity.glasser.hcpd <- read.csv("/cbica/projects/thalamocortical_development/thalamocortical_structuralconnectivity/individual/HCPD/HCPD_overlapsensitivity_finalsample.csv")
colnames(sensitivity.glasser.hcpd)[2:239] <- sprintf("%s_sensitivity", colnames(sensitivity.glasser.hcpd[2:239]))

#Combine diffusion and sensitivity measures
df.list.pnc <- list(FA.glasser.pnc, area.glasser.pnc, snr.glasser.pnc, sensitivity.glasser.pnc) #dfs to merge
FA.sensitivity.pnc <- Reduce(function(x,y) merge(x,y, all=TRUE, sort=F), df.list.pnc) 

df.list.hcpd <- list(FA.glasser.hcpd, area.glasser.hcpd, snr.glasser.hcpd, sensitivity.glasser.hcpd) 
FA.sensitivity.hcpd <- Reduce(function(x,y) merge(x,y, all=TRUE, sort=F), df.list.hcpd) 

############################################################################################################
#### Region-wise GAM Statistics and Derivative-based Temporal Developmental Properties ####

run_gam.fit.smooth <- function(dwi.measure, dwi.atlas, dwi.dataset, smooth.var, sensitivity.var, k, fixed_edf){
  if(dwi.dataset == "hcpd"){
    tractlist <- tractlist.hcpd
  }
  if(dwi.dataset == "pnc"){
    tractlist <- tractlist.pnc
  }
  smooth.characteristics <- map_dfr(tractlist$tract, 
                                    function(x){as.data.frame(gam.fit.smooth(measure = dwi.measure, atlas = dwi.atlas, dataset = dwi.dataset, 
                                                                             region = as.character(x), smooth_var = smooth.var, covariates = sprintf("sex + mean_fd + %s_%s", as.character(x), sensitivity.var), 
                                                                             knots = k, set_fx = fixed_edf))}) 
  write.csv(smooth.characteristics, sprintf("/cbica/projects/thalamocortical_development/thalamocortical_results/sensitivity_results/development_gameffects_%s_%s_%s.csv", dwi.measure, sensitivity.var, dwi.dataset), quote = F, row.names =F)
}

#PNC
run_gam.fit.smooth(dwi.measure = "FA", dwi.atlas = "sensitivity", dwi.dataset = "pnc", smooth.var = "age", sensitivity.var = "area", k = 3, fixed_edf = TRUE)
run_gam.fit.smooth(dwi.measure = "FA", dwi.atlas = "sensitivity", dwi.dataset = "pnc", smooth.var = "age", sensitivity.var = "SNR", k = 3, fixed_edf = TRUE)
run_gam.fit.smooth(dwi.measure = "FA", dwi.atlas = "sensitivity", dwi.dataset = "pnc", smooth.var = "age", sensitivity.var = "sensitivity", k = 3, fixed_edf = TRUE)

#HCPD
run_gam.fit.smooth(dwi.measure = "FA", dwi.atlas = "sensitivity", dwi.dataset = "hcpd", smooth.var = "age", sensitivity.var = "area", k = 3, fixed_edf = TRUE)
run_gam.fit.smooth(dwi.measure = "FA", dwi.atlas = "sensitivity", dwi.dataset = "hcpd", smooth.var = "age", sensitivity.var = "SNR", k = 3, fixed_edf = TRUE)
run_gam.fit.smooth(dwi.measure = "FA", dwi.atlas = "sensitivity", dwi.dataset = "hcpd", smooth.var = "age", sensitivity.var = "sensitivity", k = 3, fixed_edf = TRUE)

############################################################################################################
#### Region-wise GAM Smooth Estimates ####

run_gam.estimate.smooth <- function(dwi.measure, dwi.atlas, dwi.dataset, smooth.var, sensitivity.var, k, fixed_edf, num.pred){
  if(dwi.dataset == "hcpd"){
    tractlist <- tractlist.hcpd
  }
  if(dwi.dataset == "pnc"){
    tractlist <- tractlist.pnc
  }
  
  smooth.centered <- map_dfr(tractlist$tract, 
                             function(x){as.data.frame(gam.estimate.smooth(measure = dwi.measure, atlas = dwi.atlas, dataset = dwi.dataset, 
                                                                           region = as.character(x), smooth_var = smooth.var, covariates = sprintf("sex + mean_fd + %s_%s", as.character(x), sensitivity.var), 
                                                                           knots = k, set_fx = fixed_edf, increments = num.pred)) %>% mutate(tract = x)})
  write.csv(smooth.centered, sprintf("/cbica/projects/thalamocortical_development/thalamocortical_results/sensitivity_results/development_smoothcentered_%s_%s_%s.csv", dwi.measure, sensitivity.var, dwi.dataset), quote = F, row.names =F)
}

#PNC
run_gam.estimate.smooth(dwi.measure = "FA", dwi.atlas = "sensitivity", dwi.dataset = "pnc", smooth.var = "age", sensitivity.var = "area", k = 3, fixed_edf = TRUE, num.pred = 200)
run_gam.estimate.smooth(dwi.measure = "FA", dwi.atlas = "sensitivity", dwi.dataset = "pnc", smooth.var = "age", sensitivity.var = "SNR", k = 3, fixed_edf = TRUE, num.pred = 200)
run_gam.estimate.smooth(dwi.measure = "FA", dwi.atlas = "sensitivity", dwi.dataset = "pnc", smooth.var = "age", sensitivity.var = "sensitivity", k = 3, fixed_edf = TRUE, num.pred = 200)

#HCPD
run_gam.estimate.smooth(dwi.measure = "FA", dwi.atlas = "sensitivity", dwi.dataset = "hcpd", smooth.var = "age", sensitivity.var = "area", k = 3, fixed_edf = TRUE, num.pred = 200)
run_gam.estimate.smooth(dwi.measure = "FA", dwi.atlas = "sensitivity", dwi.dataset = "hcpd", smooth.var = "age", sensitivity.var = "SNR", k = 3, fixed_edf = TRUE, num.pred = 200)
run_gam.estimate.smooth(dwi.measure = "FA", dwi.atlas = "sensitivity", dwi.dataset = "hcpd", smooth.var = "age", sensitivity.var = "sensitivity", k = 3, fixed_edf = TRUE, num.pred = 200)

