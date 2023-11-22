#build a singularity image for dsi-studio

#docker: https://hub.docker.com/r/dsistudio/dsistudio
#built on 02/18/2023, https://hub.docker.com/layers/dsistudio/dsistudio/chen-2023-02-17/images/sha256-fa4b86442032f1cf993e5ab975068aaf10f5c87679406544d1820ce3ec1f461a?context=explore

singularity build /cbica/projects/thalamocortical_development/software/dsistudio-latest.simg docker://dsistudio/dsistudio:latest
