atlas.enrichment <- function(measure, enrichment_type){

## inputs to spatially permute (i.e., spin) with the pre-computed spatial permutation matrix 
spin.parcels <- glasser.regions
spin.data <- left_join(spin.parcels, (glasserparcel.anatomy %>% select(orig_parcelname, label, tract, all_of(measure), reconstructed)), by = c("orig_parcelname", "label", "tract"))
x <- spin.data$reconstructed #cortical map 1 with absent/present designation
y <- spin.data[,measure] #cortical map 2 to spatially permute
perm.id <- perm.id.full

## spin the empirical data 
nroi = dim(perm.id)[1]  #number of regions
nperm = dim(perm.id)[2] #number of permutations
x.perm = y.perm = array(NA,dim=c(nroi,nperm)) #initialize
for (r in 1:nperm) {
  for (i in 1:nroi) {
    x.perm[i,r] = x[perm.id[i,r]] #spinning x, spatially permuted atlas assignments
    y.perm[i,r] = y[perm.id[i,r]] #spinning y, spatially permuted anatomical measure
  }
}

## compute the mean of the anatomical measure for present v absent regions using spatially permuted data
### set up spun (y) and empirical (x) df
y.spatialperm <- as.data.frame(y.perm) %>% set_names(sprintf("perm%s", seq(from = 1, to = ncol(y.perm))))
y.spatialperm.empiricalx <- cbind(x, y.spatialperm) %>% as.data.frame()
colnames(y.spatialperm.empiricalx)[1] <- c("empirical.x")

### compute mean measure for all spins
atlas.permuted.measure <- y.spatialperm.empiricalx %>% group_by(empirical.x) %>% 
  dplyr::summarize(across(everything(), \(x) mean(x, na.rm = TRUE))) %>% #calculate mean for permuted data
  select(-empirical.x) %>% t() %>% as.data.frame() %>%
  set_names(c("Present","Absent"))
atlas.permuted.measure$Present <- as.numeric(atlas.permuted.measure$Present) #confirm numeric
atlas.permuted.measure$Absent <- as.numeric(atlas.permuted.measure$Absent) #confirm numeric

## compute mean measure for present v absent from empirical data
atlas.empirical.measure <- glasserparcel.anatomy %>% group_by(reconstructed) %>%
  do(mean_measure = mean(get(measure, .), na.rm = T)) %>% unnest(mean_measure)

## calculate permutation-based p
if(enrichment_type == "smaller"){
  empirical <- (atlas.empirical.measure %>% filter(reconstructed == "Absent") %>% select("mean_measure"))$mean_measure
  p.perm <- sum(atlas.permuted.measure$Absent < empirical)/nperm
}

if(enrichment_type == "larger"){
  empirical <- (atlas.empirical.measure %>% filter(reconstructed == "Absent") %>% select("mean_measure"))$mean_measure
  p.perm <- sum(atlas.permuted.measure$Absent > empirical)/nperm
}

return(p.perm)
}

