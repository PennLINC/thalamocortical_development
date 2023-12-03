#!/bin/bash
#A script to extract thalamus calbindin-parvalbumin (CPt) gradient values for thalamic connection areas, using the calb_minus_pvalb.nii mask from Muller et al., 2020 https://github.com/macshine/corematrix 

#Get run-specific arguments from thalamocortical_CPtvalues_jobs.sh
dataset=$1 #command line argument
id=$2 #command line argument
ses=$3 #command line argument

#Register subject-space thalamocortical tract masks (output by thalamocortical_autotrack.sh) to MNI T1 2mm template and calculate total volume and average CPt value
##This registration uses T1w_to-MNI152NLin2009cAsym_mode-image_xfm.h5 files output by qsiprep

tract_file=/cbica/projects/thalamocortical_development/software/thalamocortical_autotrack_template/dsi-studio/atlas/ICBM152_adult/ICBM152_adult.tt.gz.txt #list of thalamocortical atlas tracts

for tract in $(cat $tract_file); do
	tractname=${tract%-*}
	if [ -f /cbica/projects/thalamocortical_development/thalamocortical_structuralconnectivity/individual/$dataset/$id/$tract/${id}.${tract}_mask.nii.gz ] && ! [ -f /cbica/projects/thalamocortical_development/thalamocortical_structuralconnectivity/individual/$dataset/$id/$tract/${id}.${tractname}-CPtgradient.csv ] ; then

	#register the tract mask to MNI T1 2mm template
	singularity exec -B /cbica/projects/thalamocortical_development:/mnt /cbica/projects/thalamocortical_development/software/qsiprep-0.18.1.simg antsApplyTransforms -d 3 -i /mnt/thalamocortical_structuralconnectivity/individual/$dataset/$id/$tract/${id}.${tract}_mask.nii.gz -r /mnt/Templates/MNI152_T1_2mm_brain.nii.gz -n NearestNeighbor -t /mnt/qsirecon_0.16.0RC3/$dataset/$id/$ses/dwi/${id}_from-T1w_to-MNI152NLin2009cAsym_mode-image_xfm.h5 -o /mnt/thalamocortical_structuralconnectivity/individual/$dataset/$id/$tract/${id}.${tract}_mask_inMNI2mm.nii.gz

	#multiply the MNI-space tract mask with the thalamus CPt gradient, producing CPt values in tract-specific thalamic connection areas (non-thalamic tract voxels --> 0; thalamic tract voxels --> CPt value)
	fslmaths /cbica/projects/thalamocortical_development/thalamocortical_structuralconnectivity/individual/$dataset/$id/$tract/${id}.${tract}_mask_inMNI2mm.nii.gz -mul /cbica/projects/thalamocortical_development/Maps/thalamusgradient_CPt_muller/calb_minus_pvalb.nii /cbica/projects/thalamocortical_development/thalamocortical_structuralconnectivity/individual/$dataset/$id/$tract/${id}.${tractname}-CPtgradient.nii.gz

	#get thalamic connection area volume and mean CPt value
	vol=$(fslstats /cbica/projects/thalamocortical_development/thalamocortical_structuralconnectivity/individual/$dataset/$id/$tract/${id}.${tractname}-CPtgradient.nii.gz -V)
	volume=${vol#* }
	CPt=$(fslstats /cbica/projects/thalamocortical_development/thalamocortical_structuralconnectivity/individual/$dataset/$id/$tract/${id}.${tractname}-CPtgradient.nii.gz -M)
	else
	volume="NA"
	CPt="NA"
	fi

	#save output metrics to subject and tract specific csv
	echo "$id	$tract	$volume	$CPt" >> /cbica/projects/thalamocortical_development/thalamocortical_structuralconnectivity/individual/$dataset/$id/$tract/${id}.${tractname}-CPtgradient.csv 
done
