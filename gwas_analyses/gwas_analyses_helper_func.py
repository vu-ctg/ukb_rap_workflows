import pandas as pd
import numpy as np

def subset_all_fields(fields_interest_fp, all_fields, outfile):
    """ """
    fields_interest = set()
    with open(fields_interest_fp, "r") as f:
        for line in f:
            if line.startswith("Field ID"):
                continue
            fields_interest.add(line.rstrip("\n"))
            

    with open(all_fields, "r") as f:
        for line in f:
            if line.startswith("participant.eid"):
                continue
            items = line.rstrip("\n").split("\t")
            if items[0].split("participant.p")[1].split("_")[0] in fields_interest:
                print(items[0], file=outfile)

def calc_phenotype_missing(col_list):
    """ For each phenotype, return the percentage of missingness """
    return np.isnan(col_list).sum()/len(col_list)

def filter_pheno_by_samples(phenotype_df, kept_samples_df): 
    """
    Filter the phenotype by samples by merging the 2 dataframes
    Assuming the following format: 
    - phenotype_df: IID phenotype
    - kept_sampels_df: FID IID
    """
    phenotype_samples_filtered = phenotype_df.merge(kept_samples_df, on="IID") #this will fail if the column names do not match
    print(f"Before filtering, there are {phenotype_df.shape[0]} samples in the phenotype file.")
    print(f"There are {kept_samples_df.shape[0]} samples in the kept file.")
    print(f"After filtering, there are {phenotype_samples_filtered.shape[0]} samples that are kept after merging.")
    return phenotype_samples_filtered

def get_phenotype_missing(phenotype_fp, missing_summary_out, missing_threshold, phenotype_filter_out, 
                          sample_colname, kept_samples_fp):
    #TODO: finalize the format of the input files 
    """ 
    Filter the phenotype data by samples indicated by kept_samples_fp if this file exists
    Filter the phenotype data by threshold
    File format: 
    - phenotype_fp: expected format: first column is sample id and is labelled IID, second column and beyond: phenotypes
    - kept_samples_fp: default in None. expected format: first column is the sample ID that you want to keep. No header. Only the first column is used. The rest of the columns are ignored. 
    """

    if not kept_samples_fp:
        data = pd.read_csv(phenotype_fp, sep="\t")
        print(f"The phenotype data contains {data.shape[0]} samples and {data.shape[1]-1} phenotypes.")
        
    else: 
        temp_data = pd.read_csv(phenotype_fp, sep="\t")
        kept_samples_df = pd.read_csv(kept_samples_fp, sep=" ", header=None, usecols=[1], names=["IID"])
        
        data = filter_pheno_by_samples(temp_data, kept_samples_df)
    
    filtered_data = pd.DataFrame(data, columns=[sample_colname]) #initialize the filtered data based on perc phenotype missing
    filtered_data['FID'] = filtered_data.loc[:, sample_colname]

    for (columnName, columnData) in data.items():
        if columnName == sample_colname:
            continue
        phenotype_missing_prop = calc_phenotype_missing(columnData.values)
        print("\t".join([str(data.shape[0]), columnName, str(phenotype_missing_prop*100)]), file=missing_summary_out)
        if phenotype_missing_prop <= float(missing_threshold):
            filtered_data[columnName] = columnData
            
    
    filtered_data.rename(columns={sample_colname: "FID", "FID": "IID"}, inplace=True) #can also change the phenotypes here too if desired
    filtered_data.to_csv(phenotype_filter_out, sep="\t", index=False, na_rep='NA')