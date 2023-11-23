<br>
<br>
# Thalamocortical Structural Connectivity Organizes Cortical Developmental Timescales

### Project Lead
Valerie J. Sydnor

### Faculty Lead
Theodore D. Satterthwaite

### Analytic Replicator
Matthew Cieslak

### Collaborators 
Frank Yeh, Bart Larsen, Deanna Barch, Michael Arcaro, Sydney Covitz, Raquel E. Gur, Ruben C., Gur, Russell T. Shinohara, Allyson P. Mackey  
### Project Start Date
December 2022

### Current Project Status
Manuscript in preparation

### Datasets
RBC-PNC and RBC-HCPD

### Github Repository
https://github.com/PennLINC/thalamocortical_development

### Atlas of Human Thalamocortical Connections
https://github.com/PennLINC/thalamocortical_development/tree/main/thalamocortical_autotrack_template 
(see below for use instructions with dsi-studio's autotrack)

### Cubic Project Directory
/cbica/projects/thalamocortical_development

```
code: directory with the thalamocortical_development github repo
cortical_anatomy: PNC and HCPD freesurfer tabulate anatomical statistics
Maps: surface parcellation files (parcellations/), S-A axis github repo (S-A_ArchetypalAxis/), fluctuation amplitude development maps (boldamplitude_development/), myelin development maps (myelin_development/), E:I ratio development maps (EI_development/), thalamic Cpt gradient (thalamusgradient_CPt_muller/)
sample_info: sample demographics, environment data, and final project participant lists
software: project software 
Templates: MNI template and HCP-1065 YA FIB templates
thalamocortical_results: GAM outputs for developmental and environmental effects
thalamocortical_structuralconnectivity/template: thalamocortical template tractography
thalamocortical_structuralconnectivity/individual: PNC and HCPD autotrack outputs 
qsirecon_0.16.0RC3: PNC and HCPD qsirecon clones with dsi-studio gqi and fib outputs
```


<br>
<br>
# CODE DOCUMENTATION

The analytic and statistical workflow implemented for this project is described in full below, with links to corresponding code on github provided. This workflow includes creation of an atlas of human thalamocortical connections, preprocessing and reconstruction of PNC and HCPD diffusion MRI data, generation of individual-specific thalamocortical connections using dsi-studio's autotrack, quantification of thalamocortical connectivity metrics, PNC and HCPD sample construction, within-sample diffusion metric harmonization, an examination of group-level and individual-level thalamocortical anatomy, fitting of generalized additive models (GAMs) to study relationships between thalamocortical connectivity, age, and the environment, and analyses to characterize thalamocortical structural connectivity development and its influence on hierarchical cortical development and organization along the sensorimotor-association axis. 
<br>

### Creation of an Atlas of Human Thalamocortical Connections (HCP Young Adult)
A novel thalamocortical structural connectivity tractography atlas was generated using a high quality diffusion template derived from HCPYA data (N = 1,065, multi-shell acquisition parameters: b-values = 1000, 2000, 3000, 90 directions per shell, 1.25mm isotropic voxels). This population-average template, downloaded from [here](https://brain.labsolver.org/hcp_template.html), is a 1.25 mm isotropic diffusion template in ICBM152 space generated with q-space diffeomorphic reconstruction (MNI-space version of generalized q-sampling imaging). 

The thalamocortical structural connectivity tractography atlas was generated in the following steps:

* **Generate thalamic tractography**: Thalamic tractography was generated with [thalamocortical_structuralconnectivity/template/thalamic_tractography.sh](https://github.com/PennLINC/thalamocortical_development/blob/main/thalamocortical_structuralconnectivity/template/thalamic_tractography.sh) by tracking 2 million streamlines with endpoints in the left thalamus and 2 million streamlines with endpoints in the right thalamus, based on the HCPYA diffusion template.  Thalamic tractography was run with the following parameters:
```
--threshold_index=qa #use qa for thresholding fiber tracking 
--fa_threshold=0  #select a random qa value threshold as termination criterion for each streamline
--turning_angle=0  #select a random turning angle threshold between 15-90 degrees as termination criterion for each streamline 
--step_size=0  #select a random step size from 0.5 to 1.5 voxels for each streamline
--min_length=10  #minimum required length of streamlines
--max_length=300  #maximum allowed length of streamlines
--method=0  #streamline tracking 
--otsu_threshold=0.45  #Otsu's threshold
--smoothing=1  #select a random smoothing amount between 0% to 95% for each streamline; smoothing uses previous propagation vector directional information 
--tip_iteration=0  #turn off topology-informed pruning 
--random_seed=1  #set the random seed for fiber tracking
```

* **Delineate regionally-specific thalamus-to-cortex connections**: Structural connections between the thalamus and ipsilateral cortical regions were extracted from the thalamic tractography with [thalamocortical_structuralconnectivity/template/thalamocortical_connectoms.sh](https://github.com/PennLINC/thalamocortical_development/blob/main/thalamocortical_structuralconnectivity/template/thalamocortical_connections.sh) using the HCP-MMP (glasser) atlas.  
* **Manually curate thalamocortical connections**: All regionally-specific thalamocortical connections were visualized and manually edited, if needed, to ensure that atlas connections were compact, robust, comparable across hemispheres, and anatomically correct (based on available primate tract tracing or human diffusion MRI data). Manual editing was conducted to remove false positive streamlines, to ensure streamline terminated in the cortical region of interest, and to identify and eliminate any sparse or unreliable connections (i.e., those with very few streamlines).   
* **Create skeletonized connections for autotracking**: In order to facilitate use of the thalamocortical structural connectivity atlas with dsi-studio's autotrack, each regionally-specific connection was skeletonized by deleting repeat streamlines with [thalamocortical_structuralconnectivity/template/sparsify_connections.sh](https://github.com/PennLINC/thalamocortical_development/blob/main/thalamocortical_structuralconnectivity/template/sparsify_connections.sh).  
* **Combine all regionally-specific thalamocortical connections into one tractography atlas**: After generating finalized, regionally-specific structural connections between the thalamus and individual cortical areas, all connections were combined into one .tt.gz file for use in this study and for public distribution. The final version of the atlas only includes connections that could be robustly and reliably delineated in both the high-resolution HCPYA diffusion template and in individual participant's data in the PNC (single-shell, b=1000) and HCPD (multi-shell, bs=1500,3000). This atlas is provided in [/thalamocortical_autotrack_template](https://github.com/PennLINC/thalamocortical_development/tree/main/thalamocortical_autotrack_template).   

> To use this atlas with dsi-studio's autotrack to generate thalamocortical connections in individual participant data, both the "ICBM152_adult.tt.gz" (autotrack tracts) and "ICBM152_adult.tt.gz.txt" (tract name list) files are required and must be located in the location expected by the dsi-studio software.   
>
> On a Mac, this location is `dsi_studio/dsi_studio.app/Contents/MacOs/atlas/ICBM152_adult`
>
> In a container, this location is `/opt/dsi-studio/atlas/ICBM152_adult`. To use these files with a dsi-studio container, bind a local directory containing the contents of atlas/ICBM152_adult with these thalamus-specific .tt.gz and .tt.gz.txt files to the container directory (e.g., -B /cbica/projects/thalamocortical_development/software/thalamocortical_autotrack_template/dsi-studio/atlas/ICBM152_adult/:/opt/dsi-studio/atlas/ICBM152_adult). Or, bind the individual thalamus-specific .tt.gz and .tt.gz.txt files to their corresponding original files in /opt/dsi-studio/atlas/ICBM152_adult. 

### Diffusion MRI Preprocessing and Reconstruction (PNC and HCP Development)
Diffusion MRI data were preprocessed with qsiprep (0.14.2 for PNC; 0.16.1 for HCPD) as follows:

```bash
$ singularity run --cleanenv -B ${PWD} pennlinc-containers/.datalad/environments/qsiprep-${version}/image inputs/data prep participant --stop-on-first-crash --fs-license-file code/license.txt --skip-bids-validation --participant-label "$subid" --unringing-method mrdegibbs --unringing-method mrdegibbs --output-resolution ${res} #res = 1.8 in PNC, 1.5 in HCPD
```

Diffusion MRI data were reconstructed using the dsi_studio_gqi reconstruction workflow with qsirecon (0.16.0RC3 for PNC and HCPD) as follows:

```bash
$ singularity run --cleanenv -B ${PWD} pennlinc-containers/.datalad/environments/qsiprep-0-16-0RC3/image inputs/data/qsiprep/qsiprep qsirecon participant --participant_label $subid -recon-input inputs/data/qsiprep/qsiprep --fs-license-file code/license.txt --stop-on-first-crash --recon-only --skip-odf-reports --freesurfer-input inputs/data/fmriprep/freesurfer --recon-spec ${PWD}/code/gqi_hsvs.json 
```

Preprocessing and reconstruction workflows were executed with datalad using the template scripts in /qsiprep, including [qsiprep_call_PNC.sh](https://github.com/PennLINC/thalamocortical_development/blob/main/qsiprep/qsiprep_call_PNC.sh), [qsiprep_call_HCPD.sh](https://github.com/PennLINC/thalamocortical_development/blob/main/qsiprep/qsiprep_call_HCPD.sh), [qsirecon_call_PNC.sh](https://github.com/PennLINC/thalamocortical_development/blob/main/qsiprep/qsirecon_call_PNC.sh), and [qsirecon_call_HCPD.sh](https://github.com/PennLINC/thalamocortical_development/blob/main/qsiprep/qsirecon_call_PNC.sh). Datalad outputs were cloned for use in this project. 



### Delineation of Individual-Specific Thalamocortical Connections

### Thalamocortical Connectivity Measure Extraction

### Sample Construction 

### Software Installation
The following external software was used in this project:
* qsiprep 0.18.1 container, installed via singularity with [/software_installation/build_qsiprep_image.sh](https://github.com/PennLINC/thalamocortical_development/blob/main/software_installation/build_qsiprep_image.sh)
* dsistudio container, installed via singularity with [/software_installation/build_dsistudio_image.sh](https://github.com/PennLINC/thalamocortical_development/blob/main/software_installation/build_dsistudio_image.sh)
* connectome workbench v.1.5.0, downloaded from [humanconnectome.org](https://www.humanconnectome.org/software/get-connectome-workbench#download) into /software/workbench
* rotate_parcellation algorithm for parcel-based spin testing, cloned from the [rotate_parcellation github](https://github.com/frantisekvasa/rotate_parcellation/tree/master) into /software/rotate_parcellation

