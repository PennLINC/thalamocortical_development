#!/bin/bash
#$ -S /bin/bash
#$ -cwd
#$ -l tmpfree=120G
#$ -l h_vmem=64G 
#$ -l h_stack=8m
#$ -l hostname=!*ga00*

# Command line arguments
FIB_FILE=$1
OUTPUT_DIR=$2
GFA_FILE=$3

# Log job information into the output log 
if [ -z "$FIB_FILE" ]; then
    echo Requires positional argument FIB_FILE
    exit 100
fi

if [ ! -d ${OUTPUT_DIR} ]; then
    echo Requires positional argument OUTPUT_DIR
    exit 101
fi

if [ ! -f ${GFA_FILE} ]; then
    echo Requires positional argument GFA_FILE
    exit 102
fi

echo Processing : ${FIB_FILE}
echo Started at `date`
echo Running on $HOSTNAME
echo USER: $USER
echo NSLOTS: $NSLOTS
echo JOB_NAME: $JOB_NAME
echo JOB_ID: $JOB_ID
echo JOB_SCRIPT: $JOB_SCRIPT

set -eux

DSI_STUDIO_THREADS=$NSLOTS
if [ ${NSLOTS} -gt 1 ]; then
    DSI_STUDIO_THREADS=$(expr ${NSLOTS} - 1)
fi

# dsi_studio singularity image
SIF_FILE=/cbica/projects/thalamocortical_development/software/dsistudio-latest.simg

# Set up to run autotrack in the temp directory (copy over .fib file and singularity image)
echo Temp at: 
DATA_DIR=${CBICA_TMPDIR}/data
mkdir -p ${DATA_DIR}
LOCAL_FIB=${DATA_DIR}/$(basename $FIB_FILE)
LOCAL_SIF=${CBICA_TMPDIR}/$(basename $SIF_FILE)
FIB_BASE=$(basename $LOCAL_FIB | sed 's/\.fib[.][gz]*//')
SUBJ_BASE=${FIB_BASE%%_*}
MAP_FILE=${OUTPUT_DIR}/${FIB_BASE}.fib.gz.icbm152_adult.map.gz
IDX_FILE=${OUTPUT_DIR}/${FIB_BASE}.fib.gz.idx
LOCAL_MAP_FILE=${DATA_DIR}/${FIB_BASE}.fib.gz.icbm152_adult.map.gz
LOCAL_IDX_FILE=${DATA_DIR}/${FIB_BASE}.fib.gz.idx

if [ ! -f ${LOCAL_SIF} ]; then
    cp $SIF_FILE ${LOCAL_SIF}
fi

cp $FIB_FILE ${LOCAL_FIB}

# If a registration has already been run, copy the map and idx to the working dir
if [ -f ${MAP_FILE} ]; then
    cp ${MAP_FILE} ${LOCAL_MAP_FILE}
    cp ${IDX_FILE} ${LOCAL_IDX_FILE}
fi

# Call to the singularity image; bind thalamocortical autotrack atlas dir to dsi_studio atlas folder
sing="singularity exec --cleanenv --containall -B ${DATA_DIR} -B /cbica/projects/thalamocortical_development/software/thalamocortical_autotrack_template/dsi-studio/atlas/ICBM152_adult/:/opt/dsi-studio/atlas/ICBM152_adult ${LOCAL_SIF} "

# Autrotrack tract list; its a thalamus party
BUNDLES="\
thalamus-L_1-autotrack
thalamus-L_2-autotrack
thalamus-L_3a-autotrack
thalamus-L_3b-autotrack
thalamus-L_4-autotrack
thalamus-L_5L-autotrack
thalamus-L_5m-autotrack
thalamus-L_5mv-autotrack
thalamus-L_6a-autotrack
thalamus-L_6d-autotrack
thalamus-L_6ma-autotrack
thalamus-L_6mp-autotrack
thalamus-L_6r-autotrack
thalamus-L_6v-autotrack
thalamus-L_7AL-autotrack
thalamus-L_7Am-autotrack
thalamus-L_7PC-autotrack
thalamus-L_7PL-autotrack
thalamus-L_7Pm-autotrack
thalamus-L_8Ad-autotrack
thalamus-L_8Av-autotrack
thalamus-L_8BL-autotrack
thalamus-L_8BM-autotrack
thalamus-L_8C-autotrack
thalamus-L_9-46d-autotrack
thalamus-L_9a-autotrack
thalamus-L_9m-autotrack
thalamus-L_9p-autotrack
thalamus-L_10d-autotrack
thalamus-L_10pp-autotrack
thalamus-L_10r-autotrack
thalamus-L_24dd-autotrack
thalamus-L_25-autotrack
thalamus-L_43-autotrack
thalamus-L_44-autotrack
thalamus-L_45-autotrack
thalamus-L_46-autotrack
thalamus-L_47l-autotrack
thalamus-L_55b-autotrack
thalamus-L_A1-autotrack
thalamus-L_A4-autotrack
thalamus-L_a9-46v-autotrack
thalamus-L_a10p-autotrack
thalamus-L_a32pr-autotrack
thalamus-L_a47r-autotrack
thalamus-L_AIP-autotrack
thalamus-L_d32-autotrack
thalamus-L_DVT-autotrack
thalamus-L_EC-autotrack
thalamus-L_FEF-autotrack
thalamus-L_FOP2-autotrack
thalamus-L_FOP4-autotrack
thalamus-L_FOP5-autotrack
thalamus-L_FST-autotrack
thalamus-L_H-autotrack
thalamus-L_i6-8-autotrack
thalamus-L_IFJa-autotrack
thalamus-L_IFJp-autotrack
thalamus-L_IFSa-autotrack
thalamus-L_IFSp-autotrack
thalamus-L_IP0-autotrack
thalamus-L_IP1-autotrack
thalamus-L_IPS1-autotrack
thalamus-L_LBelt-autotrack
thalamus-L_LIPv-autotrack
thalamus-L_MIP-autotrack
thalamus-L_OP1-autotrack
thalamus-L_OP2-3-autotrack
thalamus-L_OP4-autotrack
thalamus-L_p9-46v-autotrack
thalamus-L_p10p-autotrack
thalamus-L_p47r-autotrack
thalamus-L_PBelt-autotrack
thalamus-L_PeEc-autotrack
thalamus-L_PEF-autotrack
thalamus-L_PF-autotrack
thalamus-L_PFcm-autotrack
thalamus-L_PFm-autotrack
thalamus-L_PFop-autotrack
thalamus-L_PFt-autotrack
thalamus-L_PGi-autotrack
thalamus-L_PGp-autotrack
thalamus-L_PGs-autotrack
thalamus-L_PHT-autotrack
thalamus-L_PI-autotrack
thalamus-L_Pir-autotrack
thalamus-L_pOFC-autotrack
thalamus-L_PoI1-autotrack
thalamus-L_PoI2-autotrack
thalamus-L_POS1-autotrack
thalamus-L_POS2-autotrack
thalamus-L_ProS-autotrack
thalamus-L_PSL-autotrack
thalamus-L_RI-autotrack
thalamus-L_RSC-autotrack
thalamus-L_s6-8-autotrack
thalamus-L_SCEF-autotrack
thalamus-L_SFL-autotrack
thalamus-L_STGa-autotrack
thalamus-L_STSda-autotrack
thalamus-L_STSdp-autotrack
thalamus-L_STSva-autotrack
thalamus-L_STV-autotrack
thalamus-L_TE1m-autotrack
thalamus-L_TE1p-autotrack
thalamus-L_TE2a-autotrack
thalamus-L_TGd-autotrack
thalamus-L_TGv-autotrack
thalamus-L_TPOJ1-autotrack
thalamus-L_V1-autotrack
thalamus-L_V2-autotrack
thalamus-L_V3-autotrack
thalamus-L_V3A-autotrack
thalamus-L_V3B-autotrack
thalamus-L_V3CD-autotrack
thalamus-L_V6-autotrack
thalamus-L_V6A-autotrack
thalamus-L_V7-autotrack
thalamus-L_VIP-autotrack
thalamus-R_1-autotrack
thalamus-R_2-autotrack
thalamus-R_3a-autotrack
thalamus-R_3b-autotrack
thalamus-R_4-autotrack
thalamus-R_5L-autotrack
thalamus-R_5m-autotrack
thalamus-R_5mv-autotrack
thalamus-R_6a-autotrack
thalamus-R_6d-autotrack
thalamus-R_6ma-autotrack
thalamus-R_6mp-autotrack
thalamus-R_6r-autotrack
thalamus-R_6v-autotrack
thalamus-R_7AL-autotrack
thalamus-R_7Am-autotrack
thalamus-R_7PC-autotrack
thalamus-R_7PL-autotrack
thalamus-R_7Pm-autotrack
thalamus-R_8Ad-autotrack
thalamus-R_8Av-autotrack
thalamus-R_8BL-autotrack
thalamus-R_8BM-autotrack
thalamus-R_8C-autotrack
thalamus-R_9-46d-autotrack
thalamus-R_9a-autotrack
thalamus-R_9m-autotrack
thalamus-R_9p-autotrack
thalamus-R_10d-autotrack
thalamus-R_10pp-autotrack
thalamus-R_10r-autotrack
thalamus-R_24dd-autotrack
thalamus-R_25-autotrack
thalamus-R_43-autotrack
thalamus-R_44-autotrack
thalamus-R_45-autotrack
thalamus-R_46-autotrack
thalamus-R_47l-autotrack
thalamus-R_55b-autotrack
thalamus-R_A1-autotrack
thalamus-R_A4-autotrack
thalamus-R_a9-46v-autotrack
thalamus-R_a10p-autotrack
thalamus-R_a32pr-autotrack
thalamus-R_a47r-autotrack
thalamus-R_AIP-autotrack
thalamus-R_d32-autotrack
thalamus-R_DVT-autotrack
thalamus-R_EC-autotrack
thalamus-R_FEF-autotrack
thalamus-R_FOP2-autotrack
thalamus-R_FOP4-autotrack
thalamus-R_FOP5-autotrack
thalamus-R_FST-autotrack
thalamus-R_H-autotrack
thalamus-R_i6-8-autotrack
thalamus-R_IFJa-autotrack
thalamus-R_IFJp-autotrack
thalamus-R_IFSa-autotrack
thalamus-R_IFSp-autotrack
thalamus-R_IP0-autotrack
thalamus-R_IP1-autotrack
thalamus-R_IPS1-autotrack
thalamus-R_LBelt-autotrack
thalamus-R_LIPv-autotrack
thalamus-R_MIP-autotrack
thalamus-R_OP1-autotrack
thalamus-R_OP2-3-autotrack
thalamus-R_OP4-autotrack
thalamus-R_p9-46v-autotrack
thalamus-R_p10p-autotrack
thalamus-R_p47r-autotrack
thalamus-R_PBelt-autotrack
thalamus-R_PeEc-autotrack
thalamus-R_PEF-autotrack
thalamus-R_PF-autotrack
thalamus-R_PFcm-autotrack
thalamus-R_PFm-autotrack
thalamus-R_PFop-autotrack
thalamus-R_PFt-autotrack
thalamus-R_PGi-autotrack
thalamus-R_PGp-autotrack
thalamus-R_PGs-autotrack
thalamus-R_PHT-autotrack
thalamus-R_PI-autotrack
thalamus-R_Pir-autotrack
thalamus-R_pOFC-autotrack
thalamus-R_PoI1-autotrack
thalamus-R_PoI2-autotrack
thalamus-R_POS1-autotrack
thalamus-R_POS2-autotrack
thalamus-R_ProS-autotrack
thalamus-R_PSL-autotrack
thalamus-R_RI-autotrack
thalamus-R_RSC-autotrack
thalamus-R_s6-8-autotrack
thalamus-R_SCEF-autotrack
thalamus-R_SFL-autotrack
thalamus-R_STGa-autotrack
thalamus-R_STSda-autotrack
thalamus-R_STSdp-autotrack
thalamus-R_STSva-autotrack
thalamus-R_STV-autotrack
thalamus-R_TE1m-autotrack
thalamus-R_TE1p-autotrack
thalamus-R_TE2a-autotrack
thalamus-R_TGd-autotrack
thalamus-R_TGv-autotrack
thalamus-R_TPOJ1-autotrack
thalamus-R_V1-autotrack
thalamus-R_V2-autotrack
thalamus-R_V3-autotrack
thalamus-R_V3A-autotrack
thalamus-R_V3B-autotrack
thalamus-R_V3CD-autotrack
thalamus-R_V6-autotrack
thalamus-R_V6A-autotrack
thalamus-R_V7-autotrack
thalamus-R_VIP-autotrack"

#Run autotrack
if [ "$4" == "1" ]; then #if registration only mode is enabled, only run first bundle. Otherwise, run all
    echo ${SUBJ_BASE} >> ${OUTPUT_DIR}/missing_bundle_list.txt
    echo ${SUBJ_BASE} >> ${OUTPUT_DIR}/reconstructed_bundle_list.txt
    echo Using abbreviated mode and exiting after one bundle
    BUNDLES=thalamus-L_1-autotrack
    DSI_STUDIO_THREADS=1
fi

for bundle in ${BUNDLES}; do 
    bundle_out_dir=${OUTPUT_DIR}/${bundle}
    mkdir -p ${bundle_out_dir}
    output_tt=${bundle_out_dir}/${SUBJ_BASE}.${bundle}.tt.gz 
    output_tt_template=${bundle_out_dir}/${SUBJ_BASE}.${bundle}-template.tt.gz
    output_stats=${bundle_out_dir}/${SUBJ_BASE}.${bundle}.stat.txt
    output_tt_mask=${bundle_out_dir}/${SUBJ_BASE}.${bundle}_mask.nii.gz
    local_tt=${DATA_DIR}/${bundle}/${FIB_BASE}.${bundle}.tt.gz
    local_tt_template=${DATA_DIR}/${bundle}/T_${FIB_BASE}.${bundle}.tt.gz
    local_stats=${DATA_DIR}/${bundle}/${FIB_BASE}.${bundle}.stat.txt
    local_tt_mask=${DATA_DIR}/${bundle}/${FIB_BASE}.${bundle}_mask.nii.gz

    if [ -f ${output_tt} ]; then
        echo Skipping $bundle as it already exists in the outputs
        continue
    fi

    # Automated fiber tracking:
    $sing dsi_studio \
        --action=atk \
        --source=${LOCAL_FIB} \
	--otsu_threshold=0.5 \
	--smoothing=1 \
	--tolerance=10 \
	--tip_iteration=0 \
	--track_voxel_ratio=4 \
        --check_ending=0 \
        --track_id=$bundle \
	--export_stat=1 \
	--export_trk=1 \
	--yield_rate=0.0000001 \
	--export_template_trk=1 \
	--overwrite=1 \
        --thread_count=${DSI_STUDIO_THREADS}

    if [ ! -f ${local_tt} ]; then
       echo ERROR: $bundle bundle making failed.
       echo ${bundle} >> ${OUTPUT_DIR}/missing_bundle_list.txt
       continue
    fi

    # Convert bundle to binary mask:
    $sing dsi_studio \
        --action=ana \
        --source=${LOCAL_FIB} \
        --tract=${local_tt} \
        --output=${local_tt_mask}

    # Copy local output to participant output directory
    cp ${local_tt} ${output_tt}
    cp ${local_tt_template} ${output_tt_template}
    cp ${local_stats} ${output_stats}

    if [ -f ${output_tt} ]; then
       echo ${bundle} >> ${OUTPUT_DIR}/reconstructed_bundle_list.txt	
    fi

    # Correct the header of the mask image
    CopyImageHeaderInformation \
	${GFA_FILE} \
        ${local_tt_mask} \
        ${output_tt_mask} \
	1 1 1 0

done

# Copy the map and idx file to the participant autotrack directory
if [ ! -f ${MAP_FILE} ]; then
    cp ${LOCAL_MAP_FILE} ${MAP_FILE}
    cp ${LOCAL_IDX_FILE} ${IDX_FILE}
fi


echo Ended at `date`
