#A script to take the regional anatomical stats output by /thalamocortical_development/surface_anatomy/glasser_parcel_anatomy.sh (based on freesurfer's mri_segstats) and format it into a typical readable csv. This code is adopted from https://github.com/PennLINC/freesurfer_tabulate/tree/main (thanks Matt C!)

import pandas as pd

def statsfile_to_df(stats_fname, hemi, atlas, column_suffix=""):
    with open(stats_fname, "r") as fo:
        data = fo.readlines()

    idx = [i for i, l in enumerate(data) if l.startswith("# ColHeaders ")]
    assert len(idx) == 1
    idx = idx[0]

    columns_row = data[idx]
    actual_data = data[idx + 1:]
    actual_data = [line.split() for line in actual_data]
    columns = columns_row.replace("# ColHeaders ", "").split()

    df = pd.DataFrame(columns=[col for col in columns],
                      data=actual_data)
    df.insert(0, "hemisphere", hemi)
    df.insert(0, "atlas", atlas)
    return df

lh_anat_file = "/cbica/projects/thalamocortical_development/Templates/fsaverage/stats/lh.glasseranatomy.stats.csv"
lh_anat_df_ = statsfile_to_df(lh_anat_file, "lh", "glasser", column_suffix="_sulc")
rh_anat_file = "/cbica/projects/thalamocortical_development/Templates/fsaverage/stats/rh.glasseranatomy.stats.csv"
rh_anat_df_ = statsfile_to_df(rh_anat_file, "rh", "glasser", column_suffix="_sulc")
anatomy_df = pd.concat([rh_anat_df_, lh_anat_df_], ignore_index=True)

anatomy_df.to_csv("/cbica/projects/thalamocortical_development/Templates/fsaverage/stats/glasserparcel_anatomy.csv")
