#A script to create a dataset-specific .csv file with qsiprep generated diffusion acquisition and quality control metrics

import numpy as np
import os, random
import pandas as pd
import glob
import fileinput

#List of study participants
subjects = np.loadtxt("/cbica/projects/thalamocortical_development/sample_info/HBN/HBN_NonVariantDWI_3T_participantlist.txt", delimiter=",", dtype=str, unpack=False)

#Initiate a dataframe for collating dwi qc metrics with header
dir = random.choice([x for x in os.listdir("/cbica/projects/thalamocortical_development/qsirecon_0.16.0RC3/HBN/") if "sub" in x])
qcfile = np.loadtxt(fileinput.input(glob.glob("/cbica/projects/thalamocortical_development/qsirecon_0.16.0RC3/HBN/{0}/ses-*/dwi/{0}_ses-*desc-ImageQC_dwi.csv".format(dir))), delimiter=",", dtype=str, unpack=False) 
header = qcfile[0]
QC_metrics = pd.DataFrame(columns = [header])

#Add each participant's qc metrics to the dataframe
for rbcid in subjects:
    qcfile = np.loadtxt(fileinput.input(glob.glob("/cbica/projects/thalamocortical_development/qsirecon_0.16.0RC3/HBN/{0}/ses-*/dwi/{0}_ses-*_desc-ImageQC_dwi.csv".format(rbcid))), delimiter=",", dtype=str, unpack=False) 
    QC_metrics.loc[len(QC_metrics)] = qcfile[1]

#Save QC metrics csv
QC_metrics.to_csv("/cbica/projects/thalamocortical_development/sample_info/HBN/HBN_DWI_QCmetrics.csv", index = False)
