#A script to get thalamic nuclei termination zones for finalized thalamocortical atlas connections, based on the (Morel guided) atlas from Saranathan et al., 2021, Scientific Data

atlasdir=/cbica/projects/thalamocortical_development/thalamocortical_structuralconnectivity/template/thalamus_HCP-MMP_connections

while read line; do
	3dresample -input $atlasdir/${line}_mask.nii.gz -master /cbica/projects/thalamocortical_development/Maps/thalamicnuclei_atlas_saranathan/Atlas-Thalamus_space-MNI_label-AllNuclei_desc-MaxProb.nii.gz -prefix $atlasdir/${line}_mask_nuclei.nii.gz
	fslmaths $atlasdir/${line}_mask_nuclei.nii.gz -mul /cbica/projects/thalamocortical_development/Maps/thalamicnuclei_atlas_saranathan/Atlas-Thalamus_space-MNI_label-AllNuclei_desc-MaxProb.nii.gz $atlasdir/${line}_mask_nuclei.nii.gz
done < /cbica/projects/thalamocortical_development/code/thalamocortical_development/results/thalamocortical_autotrack_template/ICBM152_adult.tt.gz.txt 

