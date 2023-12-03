#A script to extract thalamus calbindin-parvalbumin gradient values for all connections. Takes in a "dataset" command line argument and generates a dataset-specific .csv file in long format with CPt extracted for all tracts across all participants  

import sys
import pandas as pd
from pathlib import Path
from tqdm import tqdm

#identify dataset from system argument
dataset = sys.argv[1]

#Identify all thalamocortical CPtvalue csv files (across all participants and tracts)
CPt_output_path = Path("/cbica/projects/thalamocortical_development/thalamocortical_structuralconnectivity/individual/{0}".format(dataset))
CPt_value_files = list(CPt_output_path.rglob("*CPtgradient.csv"))


#Function to extract rbcid, tract, and thalamus connection area  measures (volume, CPt) from each file
def stattxt_to_data(statfile):
    fname = statfile.stem
    with statfile.open("r") as statf:
        for line in statf:
            parts = line.strip().split()
            data = {"rbcid": [parts[0]], "tract": [parts[1]], "volume": parts[2], "CPt": parts[3]}
    return pd.DataFrame(data)

#Extract measures for all participants and save to concatenated csv
allmeasures = []
for file in tqdm(CPt_value_files):
    allmeasures.append(stattxt_to_data(file))

Tract_measures = pd.concat(allmeasures, axis=0, ignore_index=True)
Tract_measures.to_csv("/cbica/projects/thalamocortical_development/thalamocortical_structuralconnectivity/individual/{0}/{0}_thalamicconnection_CPt.csv".format(dataset), index=False)
