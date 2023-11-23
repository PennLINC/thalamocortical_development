#!/bin/bash
set -e -u -x

subid="$1"

mkdir -p ${PWD}/.git/tmp/wdir
singularity run --cleanenv -B ${PWD} \
    pennlinc-containers/.datalad/environments/qsiprep-0-14-2/image \
    inputs/data \
    prep \
    participant \
    -w ${PWD}/.git/wkdir \
    --n_cpus $NSLOTS \
    --stop-on-first-crash \
    --fs-license-file code/license.txt \
    --skip-bids-validation \
    --participant-label "$subid" \
    --unringing-method mrdegibbs \
    --output-resolution 1.8

cd prep
7z a ../${subid}_qsiprep-0.13.1.zip qsiprep
rm -rf prep .git/tmp/wkdir

