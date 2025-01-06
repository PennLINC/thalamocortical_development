#!/bin/bash

#A script to launch thalamocortical_templatetract_masks.sh on every participant from a dataset

dataset=$1 #command line argument

if [ "$1" == "PNC" ] ; then
        ses="ses-PNC1"
        participant_file=/cbica/projects/thalamocortical_development/sample_info/PNC/PNC_NonVariantDWI_participantlist.txt
fi
if [ "$1" == "HCPD" ] ; then
        ses="ses-V1"
        participant_file=/cbica/projects/thalamocortical_development/sample_info/HCPD/HCPD_NonVariantDWI_participantlist.txt
fi

for id in $(cat $participant_file); do
qsub -l h_vmem=8G -pe threaded 1 ./thalamocortical_templatetract_masks.sh $dataset $id $ses 
done
