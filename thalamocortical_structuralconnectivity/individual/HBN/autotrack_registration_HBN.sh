#!/bin/bash

participant_file=/cbica/projects/thalamocortical_development/sample_info/HBN/HBN_NonVariantDWI_3T_participantlist.txt
QSIRECON_DIR=/cbica/projects/thalamocortical_development/qsirecon_0.16.0RC3/HBN
BUNDLES_DIR=/cbica/projects/thalamocortical_development/thalamocortical_structuralconnectivity/individual/HBN

for id in $(cat $participant_file); do
   FIB_FILE=${QSIRECON_DIR}/${id}/ses-*/dwi/${id}_ses*_acq-64dir_space-T1w_desc-preproc_gqi.fib.gz
   GFA_FILE=${QSIRECON_DIR}/${id}/ses-*/dwi/${id}_ses*_acq-64dir_space-T1w_desc-preproc_desc-gfa_gqiscalar.nii.gz
   OUTPUT_DIR=${BUNDLES_DIR}/${id}   
   mkdir -p ${OUTPUT_DIR}
   if ! [ -f ${BUNDLES_DIR}/${id}/${id}_ses-*acq-64dir_space-T1w_desc-preproc_gqi.fib.gz.idx ]
   then     
   qsub -pe threaded 1 -o /cbica/projects/thalamocortical_development/code/thalamocortical_development/thalamocortical_structuralconnectivity/individual/HBN/autotrack_logs/${id}-HBN-autotrack-registration.o -e /cbica/projects/thalamocortical_development/code/thalamocortical_development/thalamocortical_structuralconnectivity/individual/HBN/autotrack_logs/${id}-HBN-autotrack-registration.e /cbica/projects/thalamocortical_development/code/thalamocortical_development/thalamocortical_structuralconnectivity/individual/thalamocortical_autotrack.sh ${FIB_FILE} ${OUTPUT_DIR} ${GFA_FILE} 1   
   fi
done

