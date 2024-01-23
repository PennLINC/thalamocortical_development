library(colorRamps)
library(cifti)
library(dplyr)
library(purrr)

##################################################################################################################
                                          # DSI studio visualization #
##################################################################################################################


##################################################################################################################
# Thalamocortical atlas connection colors: S-A axis full color gradient 

## Produce RGB colors to assign to tracts, based on tract S-A axis rank
values <- c(1:360) #get color hexes for 360 values
values.factor <- cut(values, breaks = seq(min(values), max(values), len = 360), 
          include.lowest = TRUE)

colors.hex <- colorRampPalette(c("#FEC22F", "#F59A72", "#AC6AA3","#AF4390","#712A81","#2F2F85"))(360)[values.factor] %>% as.data.frame() %>% set_names("colorhex")
colors.hex$rank <- c(1:360)

colors.rgb <- lapply(colors.hex$colorhex, function(x) col2rgb(x)) %>% as.data.frame() %>% t() #convert hexes to rgb
rownames(colors.rgb) <- NULL
colors.rgb <- cbind(colors.hex, colors.rgb)

S.A.axis.cifti <- read_cifti("/cbica/projects/thalamocortical_development/Maps/S-A_ArchetypalAxis/FSLRVertex/SensorimotorAssociation_Axis_parcellated/SensorimotorAssociation.Axis.Glasser360.pscalar.nii") 
S.A.axis <- data.frame(SA.axis = rank(S.A.axis.cifti$data), orig_parcelname = names(S.A.axis.cifti$Parcel))
S.A.axis$tract <- paste0("thalamus-", S.A.axis$orig_parcelname) %>% gsub("_ROI", "-autotrack", .) 
S.A.axis <- merge(S.A.axis, colors.rgb, by.x = "SA.axis", by.y = "rank", sort = F)

thalamocortical.atlas.tractlist <- read.table("/cbica/projects/thalamocortical_development/software/thalamocortical_autotrack_template/dsi-studio/atlas/ICBM152_adult/ICBM152_adult.tt.gz.txt")
colnames(thalamocortical.atlas.tractlist) <- "tract"
thalamocortical.atlas.tractlist <- left_join(thalamocortical.atlas.tractlist, S.A.axis)
thalamocortical.atlas.rgb <- thalamocortical.atlas.tractlist %>% select(red, green, blue)
write.table(thalamocortical.atlas.rgb, "/Users/valeriesydnor/Software/dsi_studio/dsi_studio.app/Contents/MacOS/atlas/ICBM152_adult/thalamocortical_atlas_colorgradient_rgb.txt", col.names = F, row.names = F, quote = F)


##################################################################################################################3
# Thalamocortical atlas connection colors: mean FA 

# Produce RGB colors to assign to tracts, based on tract mean FA (PNC) and scale_fill_gradient2 color bar fit to these data 
tract.meanFA.pnc <- read.csv("/cbica/projects/thalamocortical_development/thalamocortical_structuralconnectivity/individual/PNC/PNC_tractaverage_FA_primary.csv")

meanFA_colorbar_plot <- ggplot(tract.meanFA.pnc, aes(x = SA.axis, y = mean_FA)) +
  geom_point(aes(color = mean_FA)) +
  scale_fill_gradient2(high = "goldenrod1", mid = "seashell", low = "#6f1282", guide = "colourbar", aesthetics = "color", name = NULL, limits = c(0.35, 0.45), oob = squish, midpoint = 0.4, na.value="white") 

meanFA_colorbar_layerdata <- layer_data(last_plot()) %>% select(y, colour) %>% set_names("mean_FA", "colorhex")
meanFA_colorbar_layerdata <- merge(meanFA_colorbar_layerdata, tract.meanFA.pnc, by = "mean_FA") %>% select(tract, colorhex)

colors.rgb  <- lapply(meanFA_colorbar_layerdata$colorhex, function(x) col2rgb(x)) %>% as.data.frame() %>% t() #convert hexes to rgb
rownames(colors.rgb) <- NULL
thalamocortical.meanFA.rgb <- cbind(meanFA_colorbar_layerdata, colors.rgb)

thalamocortical.atlas.tractlist <- read.table("/cbica/projects/thalamocortical_development/software/thalamocortical_autotrack_template/dsi-studio/atlas/ICBM152_adult/ICBM152_adult.tt.gz.txt")
colnames(thalamocortical.atlas.tractlist) <- "tract"
thalamocortical.atlas.tractlist$tract <- gsub("-", "_", thalamocortical.atlas.tractlist$tract)
thalamocortical.meanFA.rgb <- left_join(thalamocortical.atlas.tractlist, thalamocortical.meanFA.rgb, by = "tract")
thalamocortical.meanFA.rgb <- thalamocortical.meanFA.rgb %>% select(red, green, blue)
thalamocortical.meanFA.rgb <- na.omit(thalamocortical.meanFA.rgb)
write.table(thalamocortical.meanFA.rgb, "/Users/valeriesydnor/Software/dsi_studio/dsi_studio.app/Contents/MacOS/atlas/ICBM152_adult/thalamocortical_meanFA_colorbar_rgb.txt", col.names = F, row.names = F, quote = F)

##################################################################################################################
# Thalamocortical atlas connection colors: mean CPt 

# Produce RGB colors to assign to tracts, based on tract mean CPt (PNC) and scale_fill_gradient2 color bar fit to these data 
tract.meanCPt.pnc <- read.csv("/cbica/projects/thalamocortical_development/thalamocortical_structuralconnectivity/individual/PNC/PNC_tractaverage_CPt_primary.csv")

meanCPt_colorbar_plot <- ggplot(tract.meanCPt.pnc, aes(x = SA.axis, y = mean_CPt)) +
  geom_point(aes(color = mean_CPt)) +
  scale_fill_gradient2(low = "goldenrod1", mid = "seashell", high = "#6f1282", guide = "colourbar", aesthetics = "color", name = NULL, limits = c(-.25, 0.0), oob = squish, midpoint = -.125, na.value="white") 

meanCPt_colorbar_layerdata <- layer_data(last_plot()) %>% select(y, colour) %>% set_names("mean_CPt", "colorhex")
meanCPt_colorbar_layerdata <- merge(meanCPt_colorbar_layerdata, tract.meanCPt.pnc, by = "mean_CPt") %>% select(tract, colorhex)

colors.rgb  <- lapply(meanCPt_colorbar_layerdata$colorhex, function(x) col2rgb(x)) %>% as.data.frame() %>% t() #convert hexes to rgb
rownames(colors.rgb) <- NULL
thalamocortical.meanCPt.rgb <- cbind(meanCPt_colorbar_layerdata, colors.rgb)

thalamocortical.atlas.tractlist <- read.table("/cbica/projects/thalamocortical_development/software/thalamocortical_autotrack_template/dsi-studio/atlas/ICBM152_adult/ICBM152_adult.tt.gz.txt")
colnames(thalamocortical.atlas.tractlist) <- "tract"
thalamocortical.atlas.tractlist$tract <- gsub("-", "_", thalamocortical.atlas.tractlist$tract)
thalamocortical.meanCPt.rgb <- left_join(thalamocortical.atlas.tractlist, thalamocortical.meanCPt.rgb, by = "tract")
thalamocortical.meanCPt.rgb <- thalamocortical.meanCPt.rgb %>% select(red, green, blue)
thalamocortical.meanCPt.rgb <- na.omit(thalamocortical.meanCPt.rgb)
write.table(thalamocortical.meanCPt.rgb, "/Users/valeriesydnor/Software/dsi_studio/dsi_studio.app/Contents/MacOS/atlas/ICBM152_adult/thalamocortical_meanCPt_colorbar_rgb.txt", col.names = F, row.names = F, quote = F)


##################################################################################################################
# Thalamocortical atlas connection colors: Age Effects 

# Produce RGB colors to assign to tracts, based on FA age effects (PNC) and scale_fill_gradientn color bar fit to these data 
tract.ageeffect.pnc <- read.csv("/cbica/projects/thalamocortical_development/thalamocortical_results/development_results/development_gameffects_FA_glasser_pnc.csv")

ageeffect_colorbar_plot <- ggplot(tract.ageeffect.pnc, aes(x = GAM.smooth.partialR2, y = GAM.smooth.partialR2)) +
  geom_point(aes(color = GAM.smooth.partialR2)) +
  scale_color_gradientn(colors = c("#FEC22F", "#F59A72", "#9c3a80", "#672975","#323280"), limits = c(0.018, 0.1), oob = squish, na.value = "white")

ageeffect_colorbar_layerdata <- layer_data(last_plot()) %>% select(y, colour) %>% set_names("GAM.smooth.partialR2", "colorhex")
ageeffect_colorbar_layerdata <- merge(ageeffect_colorbar_layerdata, tract.ageeffect.pnc, by = "GAM.smooth.partialR2") %>% select(tract, colorhex)

colors.rgb  <- lapply(ageeffect_colorbar_layerdata$colorhex, function(x) col2rgb(x)) %>% as.data.frame() %>% t() #convert hexes to rgb
rownames(colors.rgb) <- NULL
thalamocortical.ageeffect.rgb <- cbind(ageeffect_colorbar_layerdata, colors.rgb)

thalamocortical.atlas.tractlist <- read.table("/cbica/projects/thalamocortical_development/software/thalamocortical_autotrack_template/dsi-studio/atlas/ICBM152_adult/ICBM152_adult.tt.gz.txt")
colnames(thalamocortical.atlas.tractlist) <- "tract"
thalamocortical.atlas.tractlist$tract <- gsub("-", "_", thalamocortical.atlas.tractlist$tract)
thalamocortical.ageeffect.rgb <- left_join(thalamocortical.atlas.tractlist, thalamocortical.ageeffect.rgb, by = "tract")
thalamocortical.ageeffect.rgb <- thalamocortical.ageeffect.rgb %>% select(red, green, blue)
thalamocortical.ageeffect.rgb <- na.omit(thalamocortical.ageeffect.rgb)
write.table(thalamocortical.ageeffect.rgb, "/Users/valeriesydnor/Software/dsi_studio/dsi_studio.app/Contents/MacOS/atlas/ICBM152_adult/thalamocortical_ageeffect_colorbar_rgb.txt", col.names = F, row.names = F, quote = F)


##################################################################################################################
# Thalamocortical atlas connection colors: Age of Maturation 

# Produce RGB colors to assign to tracts, based on FA age of maturation (PNC) and scale_fill_gradient2 color bar fit to these data 
tract.agemat.pnc <- read.csv("/cbica/projects/thalamocortical_development/thalamocortical_results/development_results/development_gameffects_FA_glasser_pnc.csv")

agemat_colorbar_plot <- ggplot(tract.agemat.pnc, aes(x = smooth.increase.offset, y = smooth.increase.offset)) +
  geom_point(aes(color = smooth.increase.offset)) +
  scale_color_gradient2(low = "goldenrod1", mid = "#ede4f5", high = "#6f1282", guide = "colorbar", aesthetics = "color", na.value = "white", midpoint =  17.5,  limits = c(16, 19), oob = squish) 
  
agemat_colorbar_layerdata <- layer_data(last_plot()) %>% select(y, colour) %>% set_names("smooth.increase.offset", "colorhex")
agemat_colorbar_layerdata$tract <- tract.agemat.pnc$tract 
agemat_colorbar_layerdata %>% select(tract, colorhex)

colors.rgb  <- lapply(agemat_colorbar_layerdata$colorhex, function(x) col2rgb(x)) %>% as.data.frame() %>% t() #convert hexes to rgb
rownames(colors.rgb) <- NULL
thalamocortical.agemat.rgb <- cbind(agemat_colorbar_layerdata, colors.rgb)

thalamocortical.atlas.tractlist <- read.table("/cbica/projects/thalamocortical_development/software/thalamocortical_autotrack_template/dsi-studio/atlas/ICBM152_adult/ICBM152_adult.tt.gz.txt")
colnames(thalamocortical.atlas.tractlist) <- "tract"
thalamocortical.atlas.tractlist$tract <- gsub("-", "_", thalamocortical.atlas.tractlist$tract)
thalamocortical.agemat.rgb <- left_join(thalamocortical.atlas.tractlist, thalamocortical.agemat.rgb, by = "tract")
thalamocortical.agemat.rgb <- thalamocortical.agemat.rgb %>% select(red, green, blue)
thalamocortical.agemat.rgb <- na.omit(thalamocortical.agemat.rgb)
write.table(thalamocortical.agemat.rgb, "/Users/valeriesydnor/Software/dsi_studio/dsi_studio.app/Contents/MacOS/atlas/ICBM152_adult/thalamocortical_agematuration_colorbar_rgb.txt", col.names = F, row.names = F, quote = F)

##################################################################################################################
# Thalamocortical atlas connection colors: Neighborhood Environment Effects

# Produce RGB colors to assign to tracts, based on FA age of maturation (PNC) and scale_fill_gradient2 color bar fit to these data 
tract.enveffect.pnc <- read.csv("/cbica/projects/thalamocortical_development/thalamocortical_results/environment_results/envSES_maineffects_FA_glasser_pnc.csv")
tract.enveffect.pnc <- tract.enveffect.pnc %>% mutate(significant = p.adjust(GAM.cov.pvalue, method = c("fdr")) < 0.05) %>% filter(significant == TRUE) %>% filter(GAM.cov.tvalue > 0)

enveffect_colorbar_plot <- ggplot(tract.enveffect.pnc, aes(x = GAM.cov.tvalue, y = GAM.cov.tvalue)) +
  geom_point(aes(color = GAM.cov.tvalue)) +
  scale_color_gradientn(colours = c("#9898C0", "#672975"), limits = c(2, 5), oob = squish, na.value = "white")

enveffect_colorbar_layerdata <- layer_data(last_plot()) %>% select(y, colour) %>% set_names("GAM.cov.tvalue", "colorhex")
enveffect_colorbar_layerdata$tract <- tract.enveffect.pnc$tract 
enveffect_colorbar_layerdata <- enveffect_colorbar_layerdata %>% select(tract, colorhex)

colors.rgb  <- lapply(enveffect_colorbar_layerdata$colorhex, function(x) col2rgb(x)) %>% as.data.frame() %>% t() #convert hexes to rgb
rownames(colors.rgb) <- NULL
thalamocortical.enveffect.rgb <- cbind(enveffect_colorbar_layerdata, colors.rgb)

thalamocortical.atlas.tractlist <- read.table("/cbica/projects/thalamocortical_development/software/thalamocortical_autotrack_template/dsi-studio/atlas/ICBM152_adult/ICBM152_adult.tt.gz.txt")
colnames(thalamocortical.atlas.tractlist) <- "tract"
thalamocortical.atlas.tractlist$tract <- gsub("-", "_", thalamocortical.atlas.tractlist$tract)
thalamocortical.enveffect.rgb <- left_join(thalamocortical.atlas.tractlist, thalamocortical.enveffect.rgb, by = "tract")
thalamocortical.enveffect.rgb <- thalamocortical.enveffect.rgb %>% select(red, green, blue)
thalamocortical.enveffect.rgb <- na.omit(thalamocortical.enveffect.rgb)
write.table(thalamocortical.enveffect.rgb, "/Users/valeriesydnor/Software/dsi_studio/dsi_studio.app/Contents/MacOS/atlas/ICBM152_adult/thalamocortical_enveffect_colorbar_rgb.txt", col.names = F, row.names = F, quote = F)


