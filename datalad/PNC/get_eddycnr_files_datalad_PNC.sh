#!/bin/bash

#A script to datalad get qsiprep outputs for PNC and extract eddy SNR maps  

cd /cbica/projects/thalamocortical_development/qsirecon_0.16.0RC3/PNC/datalad/inputs/data/qsiprep
for file in *zip ; do
id=${file%_*}
if ! [ -f /cbica/projects/thalamocortical_development/qsirecon_0.16.0RC3/PNC/${id}/ses-PNC1/dwi/${id}_ses-PNC1_space-T1w_desc-eddy_cnr.nii.gz ]; then
	datalad get $file -J 4
	unzip -j "$file" "qsiprep/${id}/ses-PNC1/dwi/*eddy_cnr.nii.gz" -d /cbica/projects/thalamocortical_development/qsirecon_0.16.0RC3/PNC/${id}/ses-PNC1/dwi
	fslroi /cbica/projects/thalamocortical_development/qsirecon_0.16.0RC3/PNC/${id}/ses-PNC1/dwi/${id}_ses-PNC1_space-T1w_desc-eddy_cnr.nii.gz /cbica/projects/thalamocortical_development/qsirecon_0.16.0RC3/PNC/${id}/ses-PNC1/dwi/${id}_ses-PNC1_space-T1w_desc-eddy_b0snr.nii.gz 0 1	
	datalad drop --nocheck $file
fi
done
