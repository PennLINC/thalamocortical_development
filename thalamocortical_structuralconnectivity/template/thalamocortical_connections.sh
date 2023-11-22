#A script to delineate connections between the thalamus and ipsilaterial cortical regions defined by the HCP-MMP (glasser) atlas

while read line; do
singularity exec -B /cbica/projects/thalamocortical_development:/mnt /cbica/projects/thalamocortical_development/software/dsistudio-latest.simg dsi_studio --action=ana \
--source=/mnt/Templates/QSDRTemplate_HCP1065YA_ICBM1522009a/HCP1065.1.25mm.fib.gz \
--tract=/mnt/thalamocortical_structuralconnectivity/template/LH-thalamic-tractography.tt.gz \
--roi=HCP-MMP:${line} \
--output=/mnt/thalamocortical_structuralconnectivity/template/thalamus_HCP-MMP_connections/thalamus-${line}-original.tt.gz
done < /cbica/projects/thalamocortical_development/thalamocortical_structuralconnectivity/template/HCP-MMP-dsistudio-LHregions.txt 

while read line; do
singularity exec -B /cbica/projects/thalamocortical_development:/mnt /cbica/projects/thalamocortical_development/software/dsistudio-latest.simg dsi_studio --action=ana \
--source=/mnt/Templates/QSDRTemplate_HCP1065YA_ICBM1522009a/HCP1065.1.25mm.fib.gz \
--tract=/mnt/thalamocortical_structuralconnectivity/template/RH-thalamic-tractography.tt.gz \
--roi=HCP-MMP:${line} \
--output=/mnt/thalamocortical_structuralconnectivity/template/thalamus_HCP-MMP_connections/thalamus-${line}-original.tt.gz
done < /cbica/projects/thalamocortical_development/thalamocortical_structuralconnectivity/template/HCP-MMP-dsistudio-RHregions.txt
