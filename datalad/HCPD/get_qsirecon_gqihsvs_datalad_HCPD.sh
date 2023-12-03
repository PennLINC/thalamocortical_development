#A script to datalad clone and get qsirecon 'dsi_studio_gqi' outputs for HCPD

datalad clone ria+ssh://<userid>@<node>.<cluster>.<edu>.edu:/static/LINC_HCPD#~GQIHSVS_unzipped /cbica/projects/thalamocortical_development/qsirecon_0.16.0RC3/HCPD/datalad

cd /cbica/projects/thalamocortical_development/qsirecon_0.16.0RC3/HCPD/datalad/qsirecon
for sub in *html ; do
id=${sub%.*}
mkdir -p /cbica/projects/thalamocortical_development/qsirecon_0.16.0RC3/HCPD/$id/ses-V1/dwi
datalad get $id/ses-V1/dwi/*gqi* -J 4  #participant GQI outputs for autotrack
cp $id/ses-V1/dwi/*gqi* /cbica/projects/thalamocortical_development/qsirecon_0.16.0RC3/HCPD/$id/ses-V1/dwi
datalad drop --nocheck $id/ses-V1/dwi/*gqi*
done
