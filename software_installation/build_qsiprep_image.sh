#build a singularity image for qsiprep

#docker: https://hub.docker.com/r/pennbbl/qsiprep
#tag: https://hub.docker.com/layers/pennbbl/qsiprep/0.18.1/images/sha256-7699702ae06f82ec268166bcaca0f2f965f1ebe2c034fa7bc5f96e411ca00322?context=explore

singularity build /cbica/projects/thalamocortical_development/software/qsiprep-0.18.1.simg docker://pennbbl/qsiprep:0.18.1
