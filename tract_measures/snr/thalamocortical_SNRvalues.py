#A script to extract diffusion b0 temporal SNR in all connections. Takes in a "dataset" command line argument and generates a dataset-specific .csv file in long format with SNR in all tracts across all participants  

import sys
import pandas as pd
from pathlib import Path
from tqdm import tqdm

#identify dataset from system argument
dataset = sys.argv[1]

#Identify all thalamocortical SNR csv files (across all participants and tracts)
SNR_output_path = Path("/cbica/projects/thalamocortical_development/thalamocortical_structuralconnectivity/individual/{0}".format(dataset))
SNR_value_files = list(SNR_output_path.rglob("*SNR.csv"))

#Function to extract rbcid, tract, and thalamus connection SNR from each file
def stattxt_to_data(statfile):
    fname = statfile.stem
    with statfile.open("r") as statf:
        for line in statf:
            parts = line.strip().split()
            data = {"rbcid": [parts[0]], "tract": [parts[1]], "SNR": parts[2]}
    return pd.DataFrame(data)

#Extract measures for all participants and save to concatenated csv
allmeasures = []
for file in tqdm(SNR_value_files):
    allmeasures.append(stattxt_to_data(file))

Tract_measures = pd.concat(allmeasures, axis=0, ignore_index=True)
Tract_measures.to_csv("/cbica/projects/thalamocortical_development/thalamocortical_structuralconnectivity/individual/{0}/{0}_thalamicconnection_SNR.csv".format(dataset), index=False)
