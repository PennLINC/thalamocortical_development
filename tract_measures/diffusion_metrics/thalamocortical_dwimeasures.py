#A script to extract all thalamocortical connection diffusion statistics from dsi studio *stat.txt files. Takes in a "dataset" command line argument and generates a dataset-specific .csv file in long format with all stat metrics extracted for all tracts across all participants  

import sys
import pandas as pd
from pathlib import Path
from tqdm import tqdm

#identify dataset from system argument
dataset = sys.argv[1]

#Identify all thalamocortical connection statistic files (across all participants and tracts)
autotrack_output_path = Path("/cbica/projects/thalamocortical_development/thalamocortical_structuralconnectivity/individual/{0}".format(dataset))
tract_statistic_files = list(autotrack_output_path.rglob("*stat.txt"))

#Function to extract rbcid, tract, and tract measures from each statistic file
def stattxt_to_data(statfile):
    fname = statfile.stem
    subid, connection, _ = fname.split(".")
    data = {"rbcid": subid, "tract": connection}
    with statfile.open("r") as statf:
        for line in statf:
            parts = line.strip().split()
            value = float(parts[-1])
            key = "_".join(parts[:-1]).replace("(", "_").replace("^", "").replace(")", "")
            data[key] = [value]
    return pd.DataFrame(data)

#Extract tract measures for all participants and save to concatenated csv
allmeasures = []
for file in tqdm(tract_statistic_files):
    allmeasures.append(stattxt_to_data(file))

Tract_measures = pd.concat(allmeasures, axis=0, ignore_index=True)
Tract_measures.to_csv("/cbica/projects/thalamocortical_development/thalamocortical_structuralconnectivity/individual/{0}/{0}_thalamocortical_measures.csv".format(dataset), index=False)   
