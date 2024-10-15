#A script to create label masks for finalized thalamocortical atlas connections 

while read line; do
singularity exec -B /cbica/projects/thalamocortical_development:/mnt /cbica/projects/thalamocortical_development/software/dsistudio-latest.simg dsi_studio --action=ana --source=/mnt/Templates/QSDRTemplate_HCP1065YA_ICBM1522009a/HCP1065.1.25mm.fib.gz --tract=/mnt/thalamocortical_structuralconnectivity/template/thalamus_HCP-MMP_connections/${line}.tt.gz --output=/mnt/thalamocortical_structuralconnectivity/template/thalamus_HCP-MMP_connections/${line}_mask.nii.gz
done < /cbica/projects/thalamocortical_development/code/thalamocortical_development/results/thalamocortical_autotrack_template/ICBM152_adult.tt.gz.txt
