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

### Cubic Project Directory
/cbica/projects/thalamocortical_development

```
code: directory with the thalamocortical_development github repo
cortical_anatomy: PNC and HCPD freesurfer tabulate anatomical statistics
Maps: 
- 	surface parcellation files (parcellations/)
- 	S-A axis github repo (S-A_ArchetypalAxis/)
- 	fluctuation amplitude development maps (boldamplitude_development/)
- 	myelin development maps (myelin_development/)
-	E:I ratio development maps (EI_development/)
-	thalamic Cpt gradient (thalamusgradient_CPt_muller/)
sample_info: sample demographics, environment data, and final project participant lists
software: project software 
Templates: MNI template and HCP-1065 YA FIB templates
thalamocortical_results: GAM outputs for developmental and environmental effects
thalamocortical_structuralconnectivity/template: thalamocortical template tractography
thalamocortical_structuralconnectivity/individual: PNC and HCPD autotrack outputs 
qsirecon_0.16.0RC3: PNC and HCPD qsirecon clones with dsi-studio gqi and fib outputs
```

The thalamocortical autotrack atlas is located at `/cbica/projects/thalamocortical_development/software/thalamocortical_autotrack_template/dsi-studio/atlas/ICBM152_adult`, files ICBM152_adult.tt.gz and ICBM152_adult.tt.gz.txt contain tracts and tract names


<br>
<br>
# CODE DOCUMENTATION
The analytic and statistical workflow implemented for this project is described in full below, with links to corresponding code on github provided. This workflow includes creation of an atlas of human thalamocortical connections, preprocessing and reconstruction of PNC and HCPD diffusion MRI data, generation of individual-specific thalamocortical connections using dsi-studio's autotrack, quantification of thalamocortical connectivity metrics, PNC and HCPD sample construction, within-sample diffusion metric harmonization, an examination of group-level and individual-level thalamocortical anatomy, fitting of generalized additive models (GAMs) to study relationships between thalamocortical connectivity, age, and the environment, and analyses to characterize thalamocortical structural connectivity development and its influence on hierarchical cortical development and organization along the sensorimotor-association axis. 
<br>

### Creation of an Atlas of Human Thalamocortical Connections (HCP Young Adult)

### Diffusion MRI Preprocessing and Reconstruction (PNC and HCP Development)
Diffusion MRI dat 

### Delineation of Individual-Specific Thalamocortical Connections

### Thalamocortical Connectivity Measure Extraction

### Sample Construction 
