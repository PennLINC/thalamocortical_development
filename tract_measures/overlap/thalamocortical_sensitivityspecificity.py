import os
import SimpleITK as sitk
import pandas as pd
from pathlib import Path
import nibabel as nib
import numpy as np
import glob
import sys
import subprocess

#Identify dataset from system argument
dataset = sys.argv[1]

#List of connections to compute overlap measures for 
tract_names_file = "/cbica/projects/thalamocortical_development/software/thalamocortical_autotrack_template/dsi-studio/atlas/ICBM152_adult/ICBM152_adult.tt.gz.txt" 
with open(tract_names_file, 'r') as f:
	tract_names = [line.strip() for line in f.readlines()]

#Function to compute sensitivity and specificity values for each subject-specific connection based on atlas connection
def compute_sensitivity_specificity(sub_mask, template_mask):
	pred_np = sitk.GetArrayFromImage(sub_mask)
	truth_np = sitk.GetArrayFromImage(template_mask)
	TP = np.sum((pred_np == 1) & (truth_np == 1))
	FP = np.sum((pred_np == 1) & (truth_np == 0))
	TN = np.sum((pred_np == 0) & (truth_np == 0))
	FN = np.sum((pred_np == 0) & (truth_np == 1))
	sensitivity = TP / (TP + FN) if (TP + FN) > 0 else np.nan
	specificity = TN / (TN + FP) if (TN + FP) > 0 else np.nan
	return sensitivity, specificity

#Output
overlap_results = []

#Identify all subject-specific tract masks in template space
subject_masks_path = Path("/cbica/projects/thalamocortical_development/thalamocortical_structuralconnectivity/individual/{0}".format(dataset))
niiresult = subprocess.run(
	["find", str(subject_masks_path), "-maxdepth", "3", "-name", "*template_mask.nii.gz"],
	stdout=subprocess.PIPE,
	text=True
	)
subject_masks_niftis = niiresult.stdout.strip().split("\n")

for tract_name in tract_names: 
	print(f"Computing overlap measures for {tract_name}")
	
	#Read in template (atlas) tract mask
	atlas_mask_path = Path("/cbica/projects/thalamocortical_development/thalamocortical_structuralconnectivity/template/thalamus_HCP-MMP_connections/{0}_mask.nii.gz".format(tract_name))
	atlas_mask = sitk.ReadImage(atlas_mask_path, sitk.sitkUInt8)

	#Find all subject-specific masks for this tract_name
	subject_masks_files = [str(file_name) for file_name in subject_masks_niftis if tract_name in str(file_name)]
	print(f"Found {len(subject_masks_files)} connections for {tract_name}")	
	subject_masks = [sitk.ReadImage(file_name, sitk.sitkUInt8) for file_name in subject_masks_files]
	
	#Commpute sensitivity and specificity measures
	for segmentation, mask_file in zip(subject_masks, subject_masks_files):
		sensitivity, specificity = compute_sensitivity_specificity(segmentation, atlas_mask)
		subject_id = os.path.basename(os.path.dirname(os.path.dirname(mask_file)))
		overlap_results.append({
			"rbcid": subject_id,
			"tract": tract_name,
			"sensitivity": sensitivity,
            		"specificity": specificity
		})

overlap_results_df = pd.DataFrame(overlap_results)
overlap_results_df.to_csv("/cbica/projects/thalamocortical_development/thalamocortical_structuralconnectivity/individual/{0}/{0}_thalamicconnection_overlap.csv".format(dataset), index=False)

