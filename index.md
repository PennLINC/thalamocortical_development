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

The analytic and statistical workflow implemented in this research is described below and links to all corresponding code on github are provided. This workflow begins with creation of an atlas of human thalamocortical connections, preprocessing and reconstruction of PNC and HCPD diffusion MRI data, generation of individual-specific thalamocortical connections, quantification and harmonization of thalamocortical connectivity metrics, and examination of group-level and individual-level thalamocortical anatomy characteristics. The workflow continues with the fitting of generalized additive models to study relationships between thalamocortical connectivity, age, and the environment and analyses aimed at characterizing thalamocortical structural connectivity development and its influence on hierarchical cortical development and organization along the sensorimotor-association axis. 
<br>

### Creation of an Atlas of Human Thalamocortical Connections (HCP-Young Adult)
A novel thalamocortical structural connectivity tractography atlas was generated using a high quality diffusion template derived from HCPYA data (N = 1,065, multi-shell acquisition parameters: b-values = 1000, 2000, 3000, 90 directions per shell, 1.25mm isotropic voxels). This population-average template, downloaded from [here](https://brain.labsolver.org/hcp_template.html), is a 1.25 mm isotropic diffusion template in ICBM152 space generated with q-space diffeomorphic reconstruction (MNI-space version of generalized q-sampling imaging). 

The thalamocortical structural connectivity tractography atlas was generated in the following steps:

* **Generate thalamic tractography**: Thalamic tractography was reconstructed with [thalamocortical_structuralconnectivity/template/thalamic_tractography.sh](https://github.com/PennLINC/thalamocortical_development/blob/main/thalamocortical_structuralconnectivity/template/thalamic_tractography.sh) by tracking 2 million streamlines with endpoints in the left thalamus and 2 million streamlines with endpoints in the right thalamus, based on the HCPYA diffusion template.  Thalamic tractography was run with the following parameters:
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
* **Manually curate thalamocortical connections**: All regionally-specific thalamocortical connections were visualized and manually edited, if needed, to ensure that atlas connections were compact, robust, comparable across hemispheres, and anatomically correct (based on available primate tract tracing or human diffusion MRI data). Manual editing included the removal of clear false positive streamlines and facilitated identification of thalamocortical connections that were very sparse or unreliable for removal from the atlas.
* **Create skeletonized connections for autotracking**: In order to facilitate use of the thalamocortical structural connectivity atlas with dsi-studio's autotrack, each regionally-specific connection was skeletonized by deleting repeat streamlines with [thalamocortical_structuralconnectivity/template/sparsify_connections.sh](https://github.com/PennLINC/thalamocortical_development/blob/main/thalamocortical_structuralconnectivity/template/sparsify_connections.sh).  
* **Combine all regionally-specific thalamocortical connections into one tractography atlas**: After generating finalized, regionally-specific structural connections between the thalamus and individual cortical areas, all connections were combined into one .tt.gz file for use in this study and for public distribution. The final version of the atlas only includes connections that could be robustly and reliably delineated in both the high-resolution HCPYA diffusion template and in individual participant's data in the PNC (single-shell, b=1000) and HCPD (multi-shell, bs=1500,3000). This atlas is provided in [/results/thalamocortical_autotrack_template](https://github.com/PennLINC/thalamocortical_development/tree/main/results/thalamocortical_autotrack_template). 

> To use this atlas with dsi-studio's autotrack to generate thalamocortical connections in individual participant data, both the "ICBM152_adult.tt.gz" (autotrack tracts) and "ICBM152_adult.tt.gz.txt" (tract name list) files are required and must be located in the location expected by the dsi-studio software.   
>
> On a Mac, this location is `dsi_studio/dsi_studio.app/Contents/MacOs/atlas/ICBM152_adult`
>
> In a container, this location is `/opt/dsi-studio/atlas/ICBM152_adult`. To use these files with a dsi-studio container, bind a local directory containing the contents of atlas/ICBM152_adult with these thalamus-specific .tt.gz and .tt.gz.txt files to the container directory (e.g., -B /cbica/projects/thalamocortical_development/software/thalamocortical_autotrack_template/dsi-studio/atlas/ICBM152_adult/:/opt/dsi-studio/atlas/ICBM152_adult). Or, bind the individual thalamus-specific .tt.gz and .tt.gz.txt files to their corresponding original files in /opt/dsi-studio/atlas/ICBM152_adult. 

### Preprocessing and Reconstruction of Diffusion MRI Data (PNC and HCP-Development)
Diffusion MRI data were preprocessed with qsiprep (0.14.2 for PNC; 0.16.1 for HCPD) as follows:

```bash
$ singularity run --cleanenv -B ${PWD} pennlinc-containers/.datalad/environments/qsiprep-${version}/image inputs/data prep participant --stop-on-first-crash --fs-license-file code/license.txt --skip-bids-validation --participant-label "$subid" --unringing-method mrdegibbs --unringing-method mrdegibbs --output-resolution ${res} #res = 1.8 in PNC, 1.5 in HCPD
```

Diffusion MRI data were reconstructed using the dsi_studio_gqi reconstruction workflow with qsirecon (0.16.0RC3 for PNC and HCPD) as follows:

```bash
$ singularity run --cleanenv -B ${PWD} pennlinc-containers/.datalad/environments/qsiprep-0-16-0RC3/image inputs/data/qsiprep/qsiprep qsirecon participant --participant_label $subid -recon-input inputs/data/qsiprep/qsiprep --fs-license-file code/license.txt --stop-on-first-crash --recon-only --skip-odf-reports --freesurfer-input inputs/data/fmriprep/freesurfer --recon-spec ${PWD}/code/gqi_hsvs.json 
```

Preprocessing and reconstruction workflows were executed with datalad using the template scripts in /qsiprep, including [/PNC/qsiprep_call_PNC.sh](https://github.com/PennLINC/thalamocortical_development/blob/main/qsiprep/PNC/qsiprep_call_PNC.sh), [/HCPD/qsiprep_call_HCPD.sh](https://github.com/PennLINC/thalamocortical_development/blob/main/qsiprep/HCPD/qsiprep_call_HCPD.sh), [/PNC/qsirecon_call_PNC.sh](https://github.com/PennLINC/thalamocortical_development/blob/main/qsiprep/PNC/qsirecon_call_PNC.sh), [/HCPD/qsirecon_call_HCPD](https://github.com/PennLINC/thalamocortical_development/blob/main/qsiprep/HCPD/qsirecon_call_HCPD.sh). Datalad outputs were cloned for use in this project using the scripts in [/datalad](https://github.com/PennLINC/thalamocortical_development/tree/main/datalad).


### Delineation of Individual-Specific Thalamocortical Connections (PNC and HCP-Development)
Person-specific thalamocortical structural connections were delineated for PNC and HCPD participants using the thalamic tractography atlas and dsi-studio's autotrack. A relatively stringent Hausdorff distance threhold was used; the selected threshold balanced the recovery of person-specific anatomy with mitigation of false positive streamlines and regionally non-specific streamlines. The script [/thalamocortical_structuralconnectivity/individual/thalamocortical_autotrack.sh](https://github.com/PennLINC/thalamocortical_development/blob/main/thalamocortical_structuralconnectivity/individual/thalamocortical_autotrack.sh) was run twice for every participant, first to generate participant -> template registration files (gqi.fib.gz.icbm152_adult.map.gz) for use with autotrack and then to reconstruct all thalamocortical connections. 

For PNC, registration was accomplished with [/thalamocortical_structuralconnectivity/individual/PNC/autotrack_registration_PNC.sh](https://github.com/PennLINC/thalamocortical_development/blob/main/thalamocortical_structuralconnectivity/individual/PNC/autotrack_registration_PNC.sh) and autotrack tract generation was executed with [/thalamocortical_structuralconnectivity/individual/PNC
/run_autotrack_PNC.sh](https://github.com/PennLINC/thalamocortical_development/blob/main/thalamocortical_structuralconnectivity/individual/PNC/run_autotrack_PNC.sh).

For HCPD, registration was accomplished with [/thalamocortical_structuralconnectivity/individual/HCPD/autotrack_registration_HCPD.sh](https://github.com/PennLINC/thalamocortical_development/blob/main/thalamocortical_structuralconnectivity/individual/HCPD/autotrack_registration_HCPD.sh) and autotrack tract generation was executed with [/thalamocortical_structuralconnectivity/individual/HCPD/run_autotrack_HCPD.sh](https://github.com/PennLINC/thalamocortical_development/blob/main/thalamocortical_structuralconnectivity/individual/HCPD/run_autotrack_HCPD.sh).

* Autotrack was run with the following parameters:
```
--otsu_threshold=0.5  #Otsu's threshold for tracking 
--smoothing=1  #select a random smoothing amount between 0% to 95% for each streamline; smoothing uses previous propagation vector directional information 
--tolerance=10   #Hausdorff distance threhold
--tip_iteration=0  #no topology-informed pruning
--track_voxel_ratio=4  #the track-voxel ratio for the total number of streamline count. Increased from the default of 2 to facilitate better mapping (at the expense of greater computation time)
--check_ending=0  #don't remove tracts that terminate in high anisotropy areas
--export_stat=1  #write out connection statistics file
--export_trk=1  #write out the reconstructed connection as a tractography file 
--yield_rate=0.0000001  #yield rate that must be met before fiber tracking is terminated and no output is generated
--export_template_trk=1  #write out reconstructed connection in dsi-studio template space
``` 

### Quantification of Thalamocortical Connectivity Metrics
Diffusion MRI-derived connectivity metrics (FA, MD, streamline count) and gene expression-derived thalamic gradient values (thalamus calbindin-parvalbumin CPt gradient) were extracted for every participant's autotrack-generated thalamocortical connections, using the following code:

* **Diffusion-derived connectivity metrics**: Dataset-specific spreadsheets containing autotrack output statistics for every reconstructed thalamocortical connection were produced by running [/tract_measures/diffusion_metrics/thalamocortical_dwimeasures.py](https://github.com/PennLINC/thalamocortical_development/blob/main/tract_measures/diffusion_metrics/thalamocortical_dwimeasures.py) with a "dataset" command line argument of either "PNC" or "HCPD". This python script takes in the dataset argument and generates a dataset-specific .csv file in long format with all diffusion metrics extracted for all tracts across all participants. 
* **Thalamus calbindin-parvalbumin CPt gradient values**: A series of scripts were written in order to calculate each connection's thalamic termination area CPt value. The CPt value, i.e. the thalamic calbindin-parvalbumin value, represents a thalamocortical connection's core-matrix gradient positioning. First, thalamocortical connection labelmasks were registered to MNI space and CPt values were calculated in the connection's thalamic termination area with [/tract_measures/CPtgradient_values/thalamocortical_calculate_CPtvalues.sh](https://github.com/PennLINC/thalamocortical_development/blob/main/tract_measures/CPtgradient_values/thalamocortical_calculate_CPtvalues.sh); this script was called for every participant by executing [/tract_measures/CPtgradient_values/thalamocortical_CPtvalues_jobs.sh](https://github.com/PennLINC/thalamocortical_development/blob/main/tract_measures/CPtgradient_values/thalamocortical_CPtvalues_jobs.sh) with command line arguments of either "PNC" or "HCPD". Then [/tract_measures/CPtgradient_values/thalamocortical_CPtvalues.py](https://github.com/PennLINC/thalamocortical_development/blob/main/tract_measures/CPtgradient_values/thalamocortical_CPtvalues.py) was run with a "dataset" command line argument of either "PNC" or "HCPD". This python script takes in a dataset command line argument and generates a dataset-specific .csv file in long format with CPt extracted for all tracts across all participants.  


### Sample Construction 
1358 PNC participants and 640 (Lifespan 2.0 release) HCPD participants had dominant group diffusion MRI acquisitions (i.e., non-variant CuBIDS acquisitions) and were considered for inclusion in this research. The following exclusion criterion were then applied to generate the final samples of 1145 PNC participants and 572 HCPD participants:

> - health history exclusions, for example history of cancer, MS, seizures, or incidentally-encountered brain structure abnormalities  
> - T1 quality exclusion, based on visual QC  
> - diffusion acquisition exclusion for missing runs (HCPD only)  
> - diffusion quality exclusion, based on the T1 neighborhood correlation. Note, nc values differ by sampling scheme, thus different thresholds were used in PNC and HCPD. Thresholds were chosen based on nc histograms  
> - diffusion scan head motion exclusion, based on mean framewise displacement (threshold = 1). Note, ~6% of the presently retained sample was excluded for both PNC and HCPD following diffusion quality and head motion exclusions  
> - An age exclusion (< 8 years old) was also applied to HCPD in order to match ages across samples and directly assess reproducibility. This excluded only 2.4% of the final HCPD sample participants, and thus has the additional benefit of not biasing gam smooth fits to very few data points at the lower end of the age range

Final study samples were constructed following the criterion outlined above in [/sample_construction/PNC/finalsample_PNC.Rmd](https://github.com/PennLINC/thalamocortical_development/blob/main/sample_construction/PNC/finalsample_PNC.Rmd) and [/sample_construction/HCPD/finalsample_HCPD.Rmd](https://github.com/PennLINC/thalamocortical_development/blob/main/sample_construction/HCPD/finalsample_HCPD.Rmd). This sample construction procedure utilized diffusion scan acqusition, quality, and head motion information provided in qsiprep ImageQC_dwi.csvs, which were collated into dataset-specific diffusion QC metric .csvs with [/sample_construction/PNC/diffusion_qcmetrics_PNC.py](https://github.com/PennLINC/thalamocortical_development/blob/main/sample_construction/PNC/diffusion_qcmetrics_PNC.py) and [/sample_construction/HCPD/diffusion_qcmetrics_HCPD.py](https://github.com/PennLINC/thalamocortical_development/blob/main/sample_construction/HCPD/diffusion_qcmetrics_HCPD.py) 


### Generation of Dataset-Specific Analysis Dfs and Tract Lists
To facilitate analysis of participant-level thalamocortical connectivity data, dataset-specific demographics + diffusion dataframes and dataset-specific tract lists were generated.  

* **Dataset-specific demographics and diffusion dfs**: Analytic dataframes were created for PNC and HCPD that include demographics and thalamocortical structural connectivity metrics for the final study sample. In HCPD, final sample thalamocortical metrics were harmonized with comBat to mitigate site effects. In both datasets, thalamocortical connections with < 5 streamlines (primary analysis) were removed from final analytic dataframes at the participant-level; these connections were not included in further analyses. These steps (dataframe creation, harmonization, and streamline thresholding) were implemented with [/sample_construction/PNC/tractmeasures_dfs_PNC.R](https://github.com/PennLINC/thalamocortical_development/blob/main/sample_construction/PNC/tractmeasures_dfs_PNC.R) and [sample_construction/HCPD/tractmeasures_dfs_HCPD.R](https://github.com/PennLINC/thalamocortical_development/blob/main/sample_construction/HCPD/tractmeasures_dfs_HCPD.R). 
* **Dataset-specific tract lists**: Only connections that could be reliably and robustly delineated at the individual level were studied in this work. To identify thalamocortical connections to study in PNC and HCPD, [tract_measures/tractlists/thalamocortical_tractlists.R](https://github.com/PennLINC/thalamocortical_development/blob/main/tract_measures/tractlists/thalamocortical_tractlists.R) was run. For the primary analysis we implemented a connection-level streamline count threshold of >= 5 (as noted above) and a dataset-level connection inclusion threshold of >= 90% of participants. In PNC and HCPD, 6% and 3% of thalamocortical connections present in the atlas were excluded from analysis, respectively, as they were sparsely reconstructed in > 10% of participants. 

### Thalamocortical Connectivity: Atlas Characteristics and Anatomical Gradients
Thalamocortical connection anatomy was examined at the atlas and the group level to understand characteristics of reconstructed thalamic connections and to uncover cortical and thalamic anatomical gradients. This exploration included quantifying cortical surface coverage for the thalamocortical atlas (atlas-based); comparing the surface area and sulcal depth of cortical parcels with versus without thalamic connections represented in the atlas (atlas-based); surveying variation in thalamocortical connectivity strength across Mesulam cortical types and the S-A axis (group-based in PNC and HCPD); and testing whether thalamic endpoint core-matrix gradients values differed across Mesulam types and the S-A axis (group-based in PNC and HCPD). These analyses were conducted in [/results/tract_anatomy/thalamocortical_connection_anatomy.Rmd](https://github.com/PennLINC/thalamocortical_development/blob/main/results/tract_anatomy/thalamocortical_connection_anatomy.Rmd); a knit version of thalamocortical_connection_anatomy.html can be viewed [here](https://htmlpreview.github.io/?https://github.com/PennLINC/thalamocortical_development/blob/main/results/tract_anatomy/thalamocortical_connection_anatomy.html). 
* The total surface area and average sulcal depth of all glasser parcels was computed based on the fsaverage surface in [/results/tract_anatomy/parcel_anatomy/glasser_parcel_anatomy.sh](https://github.com/PennLINC/thalamocortical_development/blob/main/results/tract_anatomy/parcel_anatomy/glasser_parcel_anatomy.sh) and [/results/tract_anatomy/parcel_anatomy/glasser_parcel_anatomy.py](https://github.com/PennLINC/thalamocortical_development/blob/main/results/tract_anatomy/parcel_anatomy/glasser_parcel_anatomy.py). 


### Software Installation
The following external software was used in this project:
* qsiprep 0.18.1 container, installed via singularity with [/software_installation/build_qsiprep_image.sh](https://github.com/PennLINC/thalamocortical_development/blob/main/software_installation/build_qsiprep_image.sh)
* dsistudio container, installed via singularity with [/software_installation/build_dsistudio_image.sh](https://github.com/PennLINC/thalamocortical_development/blob/main/software_installation/build_dsistudio_image.sh)
* datalad version 0.18.1, installed via anaconda
* connectome workbench v.1.5.0, downloaded from [humanconnectome.org](https://www.humanconnectome.org/software/get-connectome-workbench#download) into /software/workbench
* rotate_parcellation algorithm for parcel-based spin testing, cloned from the [rotate_parcellation github](https://github.com/frantisekvasa/rotate_parcellation/tree/master) into /software/rotate_parcellation
* freesurfer version 6.0.0 (freesurfer-Darwin-OSX-stable-pub-v6.0.0-2beb96c), downloadable from [freesurfer's older releases archives](https://surfer.nmr.mgh.harvard.edu/pub/dist/freesurfer/6.0.0/)
* R version 4.2.3 
