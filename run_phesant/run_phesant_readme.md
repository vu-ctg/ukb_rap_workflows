# How to run PHESANT on UKB RAP

## TL;DR
Assuming that one wants to run a phenome scan pheWAS for a trait of interest (genotype count of a SNP)

1. Step 1: Extract phenotypes

```
dx extract_dataset {projectID}:{recordID} --fields "participant.eid,participant.p{XYZ}_i{XYZ},participant.p{XYZ}_i{XYZ},participant.p{XYZ}_i{XYZ},participant.p{XYZ}_i{XYZ},participant.p{XYZ}_i{XYZ}"
```
- Call output of this command `phenos_extracted`

2. Step 2: Prepare trait of interest
- Get the genotype count using plink
```
dx run app-swiss-army-knife \
-iin={path_to_bed} \
-iin={path_to_bim} \
-iin={path_to_fam} \
-iin={path_to_snps_to_extract} \
-icmd="plink --bfile {basename} --extract snps_to_extract.txt --recodeA --out rs1260326" --instance-type mem1_ssd1_v2_x2 --name plink_extract
```

where:
- {basename} is the basename of the *.bed, *.bim, *.fam files 
- content of the `snps_to_extract.txt` is:
```
cat snps_to_extract.txt
rs1260326
```

- Format for PHESANT
```
python run_phesant/create_phesant_input/format_traitofinterestfile.py --in_genocount {plink_out} --outfile {trait_of_interest_csv}  --in_phenotypes {pheno_extracted}
```

3. Step 3: Prepare pheno_csv

- Format for PHESANT input
```
python run_phesant/create_phesant_input/format_phenofile.py --in_phenotypes {phenos_extracted} --in_traitofinterest {trait_of_interest_csv} --outfile {phenotypes_csv}
```

4. Step 4: Upload to a directory on UKB RAP
Required inputs 
- trait_of_interest_csv
- phenotypes_csv
- https://github.com/MRCIEU/PHESANT/blob/master/variable-info/data-coding-ordinal-info.txt
- https://github.com/MRCIEU/PHESANT/blob/master/variable-info/outcome-info.tsv

5. Step 5: Run
```
dx run phesant \
-ipheno_csv={phenotypes_csv} \
-itrait_of_interest_csv={trait_of_interest_csv} \
-ivariable_list_tsv=outcome-info.tsv \
-idata_coding_csv=data-coding-ordinal-info.txt \
-itrait_of_interest="exposure" \
-iuser_id_col="userId" \
-inum_parts=1 \
--instance-type mem1_ssd1_v2_x2 \
-name phesant
```

## Run PHESANT on UKB RAP using the example files from the software
- Upload the example input files (found here: https://github.com/MRCIEU/PHESANT/tree/master/testWAS) to the RAP
```
dx upload testWAS/data/phenotypes.csv
dx upload testWAS/variable-lists/data-coding-ordinal-info.txt
dx upload testWAS/variable-lists/outcome-info.tsv
dx upload testWAS/data/exposure.csv
```

- Run the command
```
dx run phesant -ipheno_csv=phenotypes.csv \
-itrait_of_interest_csv=exposure.csv \
-ivariable_list_tsv=outcome-info.tsv \
-idata_coding_csv=data-coding-ordinal-info.txt \
-itrait_of_interest="exposure" \
-iuser_id_col="userId" \
-inum_parts=1 \
--instance-type mem1_ssd1_v2_x2 \
--name phesant_test
```

- Check results. Note that the files in this folder also contains the input files in addition to the result files
```
dx ls
data-coding-ordinal-info.txt
exposure.csv
forest-binary.pdf
forest-continuous.pdf
forest-ordered-logistic.pdf
modelfit-log-combined.txt
outcome-info.tsv
phenotypes.csv
qqplot.pdf
results-combined.txt
results-log-combined.txt
variable-flow-counts-combined.txt
```

## Run a new phenome scan in UKB
- Here, I am describing the process to run a new phenome scan in UKB using: 
    - trait of interest: is the genotype count of the SNP rs1260326
    - phenotypes: 30 phenotypes (https://biobank.ctsu.ox.ac.uk/showcase/label.cgi?id=220)
### Prepare required arguments

#### Extract phenotypes
- Extract phenotypes. See: `common_tasks\export_phenotypes.md`

#### trait_of_interest_csv
##### Information about this file
- a csv file containing the trait of interst (e.g. a snp, genetic risk score or observed phenotype)
- each row is a participant
- there should be 2 collumns - the userID and the trait of interest
- when this argument is not supplied, the trait of interest should be a column in the phenotype
- An example 
```
head exposure.csv
"userId","exposure"
1,-3.39606353457436
2,-3.23315213292314
3,-2.90667395407155
4,-2.87404249339871
5,-2.86434683706673
6,-2.85575865501923
7,-2.75704972232067
8,-2.73975424338714
9,-2.7322195229558
```
##### How to generate the trait of interest file
1. Get the geno count
```
dx run app-swiss-army-knife \
-iin={path_to_bed} \
-iin={path_to_bim} \
-iin={path_to_fam} \
-iin={path_to_snps_to_extract} \
-icmd="plink --bfile {basename} --extract snps_to_extract.txt --recodeA --out rs1260326" --instance-type mem1_ssd1_v2_x2 --name plink_extract
```
where:
- {basename} is the basename of the *.bed, *.bim, *.fam files 
- content of the `snps_to_extract.txt` is:
```
cat snps_to_extract.txt
rs1260326
```

- Output is `rs1260326.raw`

2. Format for PHESANT
- script: `run_phesant/create_phesant_input/format_traitofinterestfile.py`
- example command:
```
python run_phesant/create_phesant_input/format_traitofinterestfile.py --in_genocount {plink_out} --outfile {trait_of_interest_csv}  --in_phenotypes {pheno_extracted}
```

#### pheno_csv
##### Information about this file
- in `*.csv` format
- each row is a participant
- first column: participant id
- **required columns**: `participant.p21022` (Age at recruitment), `participant.p31` (Sex), `participant.p22000` (Genotype measurement batch)
    - I am only 100% sure that Age at recruitment is required because running PHESANT without this phenotype caused an error 
    ```
    Error: phenotype file doesn't contain required age colunn: x21022_0_0
    Execution halted
    ```
    - Just to be sure, I also included Sex and Genotype measurement batch in the phenotypes file. 
- remaining columns: phenotypes in `x<FIELD-ID>_<INSTANCE-ID>_<ARRAY-ID>` format. From the example: 
```
head testWAS/data/phenotypes.csv
"userId","x21022_0_0","x31_0_0","x22000_0_0","x1_0_0","x2_0_0","x3_0_0","x4_0_0","x5_0_0","x6_0_0","x21_0_0","x22_0_0","x23_0_0","x24_0_0","x25_0_0","x26_0_0","x27_0_0","x32_0_0","x33_0_0","x34_0_0","x35_0_0","x36_0_0","x37_0_0","x38_0_0","x39_0_0","x41_0_0","x41_0_1","x41_0_2","x42_0_0","x42_0_1","x42_0_2","x43_0_0","x43_0_1","x43_0_2","x44_0_0","x44_1_0","x44_2_0","x99_0_0"
1,41.154538734616,0,-1,12.8234564285245,,0,,,,,,,,,,,,,,,,,,,"A1","A2","A3","A1","A2","A3","A1","A2","A3","A1","A2","A3","1"
2,56.5483631318009,1,1,13.3580916624301,,0,,,,,,,,,,,,,,,,,,,"A1","A2","A3","A1","A2","A3","A1","A2","A3","A1","A2","A3","1"
3,38.7951998559006,0,-1,14.1985221558642,,0,,,,,,,,,,,,,,,,,,,"A1","A2","A3","A1","A2","A3","A1","A2","A3","A1","A2","A3","1"
4,60.6056222481387,1,0,14.1810880191213,,0,,,,,,,,,,,,,,,,,,,"A1","A2","A3","A1","A2","A3","A1","A2","A3","A1","A2","A3","1"
5,61.300824073418,0,-2,14.4177143341673,,0,,,,,,,,,,,,,,,,,,,"A1","A2","A3","A1","A2","A3","A1","A2","A3","A1","A2","A3","1"
6,35.2296540437881,1,-2,14.2250967792975,,0,,,,,,,,,,,,,,,,,,,"A2","A1",,"A2","A1",,"A2","A1",,"A2","A1",,"1"
7,63.875115050921,1,-1,14.2567869945,,0,,,,,,,,,,,,,,,,,,,"A2","A1",,"A2","A1",,"A2","A1",,"A2","A1",,"1"
8,52.2755704582678,1,0,14.3487492973354,,0,,,,,,,,,,,,,,,,,,,"A2","A1",,"A2","A1",,"A2","A1",,"A2","A1",,"1"
9,47.7973932002089,0,0,14.0589790164797,,0,,,,,,,,,,,,,,,,,,,"A2","A1",,"A2","A1",,"A2","A1",,"A2","A1",,"1"
```

##### How to generate the phenotypes file for a new set of phenotypes from UKB
- Format for PHESANT input:
    - Script: run_phesant/create_phesant_input/format_phenofile.py
    - Example command: 
    ```
    python run_phesant/create_phesant_input/format_phenofile.py --in_phenotypes {phenos_extracted} --in_traitofinterest {trait_of_interest_csv} --outfile {phenotypes_csv}
    ```

### Run
1. dx upload 

```
dx upload {trait_of_interest_csv}
dx upload {phenotypes_csv}
dx upload data-coding-ordinal-info.txt
dx upload outcome-info.tsv

```

2. Run

```
dx run phesant \
-ipheno_csv={phenotypes_csv} \
-itrait_of_interest_csv={trait_of_interest_csv} \
-ivariable_list_tsv=outcome-info.tsv \
-idata_coding_csv=data-coding-ordinal-info.txt \
-itrait_of_interest="exposure" \
-iuser_id_col="userId" \
-inum_parts=1 \
--instance-type mem1_ssd1_v2_x2 \
-name phesant
```

3. Download and examine output
```
dx download results-combined.txt -f
```