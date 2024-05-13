#!/bin/bash

#A script to datalad get qsiprep outputs for HCPD and extract QC csvs

cd /cbica/projects/thalamocortical_development/qsirecon_0.16.0RC3/HBN/datalad/inputs/data/qsiprep
datalad get -n .
for file in *zip ; do
id=${file%_*}
if ! [ -f /cbica/projects/thalamocortical_development/qsirecon_0.16.0RC3/HBN/${id}/ses-*/dwi/*QC*csv ] ; then
datalad get $file
unzip -j "$file" "qsiprep/${id}/ses-*/dwi/*csv" -d /cbica/projects/thalamocortical_development/qsirecon_0.16.0RC3/HBN/${id}/ses-*/dwi
datalad drop --nocheck $file
fi
done
