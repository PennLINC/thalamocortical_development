#A script to skeletonize thalamocortical atlas connections for use in autotrack by deleating repeat streamlines with a distance threshold of 3 voxels

while read line; do
singularity exec -B /cbica/projects/thalamocortical_development:/mnt /cbica/projects/thalamocortical_development/software/dsistudio-latest.simg dsi_studio --action=ana --source=/mnt/Templates/QSDRTemplate_HCP1065YA_ICBM1522009a/HCP1065.1.25mm.fib.gz --tract=/mnt/thalamocortical_structuralconnectivity/template/thalamus_HCP-MMP_connections/thalamus-${line}-edited.tt.gz --delete_repeat=3 --output=/mnt/thalamocortical_structuralconnectivity/template/thalamus_HCP-MMP_connections/thalamus-${line}-autotrack.tt.gz
done < /cbica/projects/thalamocortical_development/thalamocortical_structuralconnectivity/template/HCP-MMP-dsistudio-regionlist.txt
