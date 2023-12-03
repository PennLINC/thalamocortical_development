#!/bin/bash

#A script to datalad get qsiprep outputs for PNC and extract QC csvs and registration h5 files

cd /cbica/projects/thalamocortical_development/qsirecon_0.16.0RC3/PNC/datalad/inputs/data/qsiprep
datalad get -n .
for file in *zip ; do
id=${file%_*}
datalad get $file -J 8
unzip -j "$file" "qsiprep/${id}/ses-PNC1/dwi/*csv" -d /cbica/projects/thalamocortical_development/qsirecon_0.16.0RC3/PNC/${id}/ses-PNC1/dwi
unzip -j "$file" "qsiprep/${id}/anat/*xfm.h5" -d /cbica/projects/thalamocortical_development/qsirecon_0.16.0RC3/PNC/${id}/ses-PNC1/dwi
datalad drop --nocheck $file
done
