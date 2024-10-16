#build a singularity image for dsi-studio

#docker: https://hub.docker.com/r/dsistudio/dsistudio
#org.label-schema.build-date: Monday_27_February_2023_14:21:12_EST
#org.label-schema.usage.singularity.version: 3.8.5-2.el7

singularity build /cbica/projects/thalamocortical_development/software/dsistudio-latest.simg docker://dsistudio/dsistudio:latest
