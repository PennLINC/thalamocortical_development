#A script to quantify thalamic nuclei-specific representation of thalamocortical connection terminal zones
import os
import nibabel as nib
import numpy as np
import pandas as pd

#Directory with thalamic nuclei masks for the finalized thalamocortical tractography atlas
directory = "/cbica/projects/thalamocortical_development/thalamocortical_structuralconnectivity/template/thalamus_HCP-MMP_connections"

results = []

#Extract thalamic nuclei label counts for every atlas connection
for filename in os.listdir(directory):
	if filename.endswith("_mask_nuclei.nii.gz"): #read in connection-specific thalamic nuclei masks
	
		#Calculate label counts
		tract_name = filename.split('_mask_nuclei.nii.gz')[0] #extract tract name
		tract_img = nib.load(os.path.join(directory, filename))
		nifti_data = tract_img.get_fdata() #get the voxel data
		nifti_data_flat = nifti_data.flatten()
		unique_labels, counts = np.unique(nifti_data_flat, return_counts=True) #calculate the number of voxels which each label number
		#Format count data into long df with tract name
		all_labels = pd.DataFrame({'label': np.arange(1, 13)}) #include counts for labels 1-18, even if = to 0
		label_counts = pd.DataFrame({'label': unique_labels, 'count': counts})
		label_counts_full = pd.merge(all_labels, label_counts, on='label', how='left').fillna(0)
		label_counts_full['tract'] = tract_name #add tract_name column
		label_counts_full = label_counts_full[['tract', 'label', 'count']] #reorder cols
		results.append(label_counts_full)

#Combine results and save out wide formatted csv
thalamocortical_nuclei_counts = pd.concat(results, ignore_index=True)
thalamocortical_nuclei_counts = thalamocortical_nuclei_counts.pivot_table(index='tract', columns='label', values='count', fill_value=0)
thalamocortical_nuclei_counts.columns = [f'label{i}' for i in thalamocortical_nuclei_counts.columns]
thalamocortical_nuclei_counts.reset_index(inplace=True)
thalamocortical_nuclei_counts.to_csv('/cbica/projects/thalamocortical_development/thalamocortical_structuralconnectivity/template/HCP-MMP_thalamicnuclei_terminationzones.csv', index=False)
