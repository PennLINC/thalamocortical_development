#!/bin/bash

#A script to calculate average b0 tSNR in every thalamocortical connection for all participants

#Get run-specific arguments from thalamocortical_SNR_jobs.sh
dataset=$1 #command line argument
id=$2 #command line argument
ses=$3 #command line argument

tract_file=/cbica/projects/thalamocortical_development/software/thalamocortical_autotrack_template/dsi-studio/atlas/ICBM152_adult/ICBM152_adult.tt.gz.txt #list of thalamocortical atlas tracts

for tract in $(cat $tract_file); do
	tractname=${tract%-*}
	if [ -f /cbica/projects/thalamocortical_development/thalamocortical_structuralconnectivity/individual/$dataset/$id/$tract/${id}.${tract}_mask.nii.gz ] && ! [ -f /cbica/projects/thalamocortical_development/thalamocortical_structuralconnectivity/individual/$dataset/$id/$tract/${id}.${tractname}-SNR.csv ] ; then

	#multiply the tract mask by this participant's SNR image, producing a connection-specific SNR map
	fslmaths /cbica/projects/thalamocortical_development/thalamocortical_structuralconnectivity/individual/$dataset/$id/$tract/${id}.${tract}_mask.nii.gz -mul /cbica/projects/thalamocortical_development/qsirecon_0.16.0RC3/$dataset/$id/$ses/dwi/${id}*-eddy_b0snr.nii.gz /cbica/projects/thalamocortical_development/thalamocortical_structuralconnectivity/individual/$dataset/$id/$tract/${id}.${tractname}-SNR.nii.gz

	#calculate average SNR in this tract mask
	SNR=$(fslstats /cbica/projects/thalamocortical_development/thalamocortical_structuralconnectivity/individual/$dataset/$id/$tract/${id}.${tractname}-SNR.nii.gz -M) 
	else
	SNR="NA"
	fi

	#save output metrics to subject and tract specific csv
	echo "$id	$tract	$SNR" >> /cbica/projects/thalamocortical_development/thalamocortical_structuralconnectivity/individual/$dataset/$id/$tract/${id}.${tractname}-SNR.csv 
done
