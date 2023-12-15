#!/bin/bash

#A script to calculate total surface area and average sulcal depth of individual glasser parcels, based on the fsaverage surface

#Set up freesurfer
export FREESURFER_HOME=/Users/valeriesydnor/Software/freesurfer
source /Users/valeriesydnor/Software/freesurfer/SetUpFreeSurfer.sh
export SUBJECTS_DIR=/cbica/projects/thalamocortical_development/Templates

#Use fsaverage sulc files and glasser atlas annots to calculate regional area and sulcal depth 
for hemi in lh rh; do
	mri_segstats --in ${SUBJECTS_DIR}/fsaverage/surf/$hemi.sulc --annot fsaverage $hemi glasser --sum $SUBJECTS_DIR/fsaverage/stats/$hemi.glasseranatomy.stats.csv
done
