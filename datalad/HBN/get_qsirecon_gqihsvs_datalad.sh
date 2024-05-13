#A script to datalad clone and get qsirecon 'dsi_studio_gqi' outputs for HBN

datalad clone ria+ssh://<useid>@<node>.<cluster>.<edu>.edu:/static/LINC_HBN#~GQIHSVS /cbica/projects/thalamocortical_development/qsirecon_0.16.0RC3/HBN/datalad

cd /cbica/projects/thalamocortical_development/qsirecon_0.16.0RC3/HBN/datalad/qsirecon
for sub in *html ; do
id=${sub%.*}
file=$(ls /cbica/projects/thalamocortical_development/qsirecon_0.16.0RC3/HBN/datalad/qsirecon/${id}/ses*/dwi/*fib.gz)
base=$(basename $file)
info=${base#*_}
session=${info%%_*}
mkdir -p /cbica/projects/thalamocortical_development/qsirecon_0.16.0RC3/HBN/$id/$session/dwi
datalad get $id/$session/dwi/*gqi* -J 4
cp $id/$session/dwi/*gqi* /cbica/projects/thalamocortical_development/qsirecon_0.16.0RC3/HBN/$id/$session/dwi
datalad drop --nocheck $id/$session/dwi/*gqi*
done
