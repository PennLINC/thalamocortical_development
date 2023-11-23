#!/bin/bash
set -e -u -x

subid="$1"
qsiprep_zip="$2"
freesurfer_zip="$3"
wd=${PWD}

cd inputs/data/qsiprep
7z x `basename ${qsiprep_zip}`
cd ../fmriprep
7z x `basename ${freesurfer_zip}`
cd $wd

ompthreads=1
if [ ${NSLOTS} -gt 2 ]; then
    ompthreads=$(expr ${NSLOTS} - 1)
fi

mkdir -p ${PWD}/.git/tmp/wkdir
singularity run \
    --cleanenv -B ${PWD} \
    pennlinc-containers/.datalad/environments/qsiprep-0-16-0RC3/image \
    inputs/data/qsiprep/qsiprep qsirecon participant \
    --participant_label $subid \
    --recon-input inputs/data/qsiprep/qsiprep \
    --fs-license-file code/license.txt \
    --nthreads ${NSLOTS} \
    --omp-nthreads ${ompthreads} \
    --stop-on-first-crash \
    --recon-only \
    --skip-odf-reports \
    --freesurfer-input inputs/data/fmriprep/freesurfer \
    --recon-spec ${PWD}/code/gqi_hsvs.json  \
    -w ${PWD}/.git/tmp/wkdir

fib_file=$(find qsirecon -name '*gqi.fib.gz')
ref_img=$(find qsirecon -name '*md_gqiscalar.nii.gz')
mif=${fib_file/fib.gz/mif.gz}
singularity exec \
    --cleanenv -B ${PWD} \
    pennlinc-containers/.datalad/environments/qsiprep-0-16-0RC3/image \
    fib2mif \
    --fib ${fib_file} \
    --ref_image ${ref_img} \
    --mif ${mif}

stem=${mif/_gqi.mif.gz/_recon-gqi}
singularity exec \
    --cleanenv -B ${PWD} \
    pennlinc-containers/.datalad/environments/qsiprep-0-16-0RC3/image \
    python \
    code/calculate_steinhardt.py \
    ${mif} \
    8 \
    ${stem}

# remove collision-causing files
mv qsirecon/qsirecon/* qsirecon/

rm -rf \
   qsirecon/dataset_description.json \
   qsirecon/dwiqc.json \
   qsirecon/logs \
   qsirecon/qsirecon

rm -rf .git/tmp/wkdir
