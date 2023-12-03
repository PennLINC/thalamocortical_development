#A script to datalad clone and get qsirecon 'dsi_studio_gqi' outputs for PNC 

datalad clone ria+ssh://<userid>@.<node>.<cluster>.<edu>.edu:/static/LINC_PNC#~GQIHSVS /cbica/projects/thalamocortical_development/qsirecon_0.16.0RC3/PNC/datalad  #user and cluster info scrubbed

cd /cbica/projects/thalamocortical_development/qsirecon_0.16.0RC3/PNC/datalad/qsirecon
for sub in *html ; do
id=${sub%.*}
mkdir -p /cbica/projects/thalamocortical_development/qsirecon_0.16.0RC3/PNC/$id/ses-PNC1/dwi
datalad get $id/ses-PNC1/dwi/*gqi* -J 4  #participant GQI outputs for autotrack 
cp $id/ses-PNC1/dwi/*gqi* /cbica/projects/thalamocortical_development/qsirecon_0.16.0RC3/PNC/$id/ses-PNC1/dwi
datalad drop --nocheck $id/ses-PNC1/dwi/*gqi*
done
