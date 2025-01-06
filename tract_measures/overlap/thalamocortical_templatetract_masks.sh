#!/bin/bash

#A script to generate binary autotrack masks in template space for each participant and all their thalamocortical connections 

#Get run-specific arguments from thalamocortical_templatemasks_jobs.sh
dataset=$1 #command line argument
id=$2 #command line argument
ses=$3 #command line argument

tract_file=/cbica/projects/thalamocortical_development/software/thalamocortical_autotrack_template/dsi-studio/atlas/ICBM152_adult/ICBM152_adult.tt.gz.txt #list of thalamocortical atlas tracts

for tract in $(cat $tract_file); do
	tractname=${tract%-*}
	if [ -f /cbica/projects/thalamocortical_development/thalamocortical_structuralconnectivity/individual/$dataset/$id/$tract/${id}.${tract}-template.tt.gz ] ; then #if this tract was generated

	#generate a template-space tract mask for this subject that aligns with the atlas tract masks
	singularity exec -B /cbica/projects/thalamocortical_development:/mnt /cbica/projects/thalamocortical_development/software/dsistudio-latest.simg dsi_studio --action=ana --source=/mnt/qsirecon_0.16.0RC3/$dataset/$id/$ses/dwi/${id}*preproc_gqi.fib.gz --tract=/mnt/thalamocortical_structuralconnectivity/individual/$dataset/$id/$tract/${id}.${tract}-template.tt.gz --output=/mnt/thalamocortical_structuralconnectivity/individual/$dataset/$id/$tract/${id}.${tract}-template_masktmp.nii.gz
	3dresample -inset /cbica/projects/thalamocortical_development/thalamocortical_structuralconnectivity/individual/$dataset/$id/$tract/${id}.${tract}-template_masktmp.nii.gz -master /cbica/projects/thalamocortical_development/thalamocortical_structuralconnectivity/template/thalamus_HCP-MMP_connections/${tractname}-autotrack_mask.nii.gz -prefix /cbica/projects/thalamocortical_development/thalamocortical_structuralconnectivity/individual/$dataset/$id/$tract/${id}.${tract}-template_mask.nii.gz
	rm /cbica/projects/thalamocortical_development/thalamocortical_structuralconnectivity/individual/$dataset/$id/$tract/${id}.${tract}-template_masktmp.nii.gz
	
	fi
done
