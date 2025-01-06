#!/bin/bash

#A script to datalad get qsiprep outputs for HCPD and extract eddy cnr maps

cd /cbica/projects/thalamocortical_development/qsirecon_0.16.0RC3/HCPD/datalad/inputs/data/qsiprep
for file in *zip ; do
id=${file%_*}
datalad get $file -J 4
unzip -j "$file" "qsiprep/${id}/ses-V1/dwi/*eddy_cnr.nii.gz" -d /cbica/projects/thalamocortical_development/qsirecon_0.16.0RC3/HCPD/${id}/ses-V1/dwi
fslroi /cbica/projects/thalamocortical_development/qsirecon_0.16.0RC3/HCPD/${id}/ses-V1/dwi/${id}_ses-V1_space-T1w_desc-eddy_cnr.nii.gz /cbica/projects/thalamocortical_development/qsirecon_0.16.0RC3/HCPD/${id}/ses-V1/dwi/${id}_ses-V1_space-T1w_desc-eddy_b0snr.nii.gz 0 1
datalad drop --nocheck $file -J 4
done
