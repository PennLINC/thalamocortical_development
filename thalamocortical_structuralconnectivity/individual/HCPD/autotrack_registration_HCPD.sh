#!/bin/bash

participant_file=/cbica/projects/thalamocortical_development/sample_info/HCPD/HCPD_NonVariantDWI_participantlist.txt
QSIRECON_DIR=/cbica/projects/thalamocortical_development/qsirecon_0.16.0RC3/HCPD
BUNDLES_DIR=/cbica/projects/thalamocortical_development/thalamocortical_structuralconnectivity/individual/HCPD

for id in $(cat $participant_file); do
   FIB_FILE=${QSIRECON_DIR}/${id}/ses-V1/dwi/${id}_ses-V1_space-T1w_desc-preproc_gqi.fib.gz
   GFA_FILE=${QSIRECON_DIR}/${id}/ses-V1/dwi/${id}_ses-V1_space-T1w_desc-preproc_desc-gfa_gqiscalar.nii.gz
   OUTPUT_DIR=${BUNDLES_DIR}/${id}   
   mkdir -p ${OUTPUT_DIR}
   if ! [ -f ${BUNDLES_DIR}/${id}/${id}_ses-V1_space-T1w_desc-preproc_gqi.fib.gz.icbm152_adult.map.gz ]
   then     
   qsub -pe threaded 1 -o /cbica/projects/thalamocortical_development/code/thalamocortical_development/thalamocortical_structuralconnectivity/individual/HCPD/autotrack_logs/${id}-HCPD-autotrack-registration.o -e /cbica/projects/thalamocortical_development/code/thalamocortical_development/thalamocortical_structuralconnectivity/individual/HCPD/autotrack_logs/${id}-HCPD-autotrack-registration.e /cbica/projects/thalamocortical_development/code/thalamocortical_development/thalamocortical_structuralconnectivity/individual/thalamocortical_autotrack.sh ${FIB_FILE} ${OUTPUT_DIR} ${GFA_FILE} 1   
   fi
done

