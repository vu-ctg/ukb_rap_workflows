# Workflow for using PRScs to generate polygenic scores in UKB based on external GWAS summary statistics

The first part of this workflow involves creating a file with SNP weights to use in the polygenic scores. Since this only involves summary statistics and SNP IDs, we can run this more efficiently on Snellius.

```
## ON SNELLIUS ##
# ----------------------------------------------------
# For setup PRScs 
# N.B.: Program and reference files are also stored on the ctgukbio account in the programs/PRScs folder
# Commands below to download if needed
# ----------------------------------------------------

#cd ~/
#git clone https://github.com/getian107/PRScs.git
## Download LD reference files locally on Snellius
#cd PRScs
#wget https://www.dropbox.com/s/t9opx2ty6ucrpib/ldblk_ukbb_eur.tar.gz
#tar -zxvf ldblk_ukbb_eur.tar.gz


# ----------------------------------------------------
# Setup and format PRScs sumstat files
# Check if your PRScs sumstat file contains correct
# header for PRS weight calculation
# ----------------------------------------------------

# grab necessary columns from your sumstats file: SNP, A1 (effect), A2 (ref), OR/BETA, P
cat [GWAS sumstat file].txt | awk '{print $2"\t"$6"\t"$4"\t"$11"\t"$16}' > [name PRScs sumstat file].txt

head [PRScs sumstat file].txt
tail [PRScs sumstat file].txt
wc -l [PRScs sumstat file].txt

sed -i '1d' [PRScs sumstat file].txt
sed -i '1i SNP\tA1\tA2\tOR\tP' [PRScs sumstat file].txt


# -------------------------------------------------------------
# Calculation of SNP weights using PRScs python script
# 
# Calculate effective sample size for binary traits using formula 
# n_eff = 4 / ( (1 / N_case) + (1 / N_control))
#
# Replace n_gwas argument with this n_eff calculated
# Replace all file paths as needed
# Run below commands as a batch script using sbatch on Snellius
# --------------------------------------------------------------


####
!/bin/bash
SBATCH -t 10:00:00

# directory of PRScs program
CSDIR=/projects/0/ctgukbio/programs/PRScs
# bim file with UKB SNPs in RSID format
BIMFILE=/projects/0/ctgukbio/datasets/ukbio/applicationID1640/qc/final/genotypes/release2b/meta_info/ukbids_rsids
OUTNAME=myphenotypename

module load 2022
module load Python/2.7.18-GCCcore-11.3.0-bare

python ${CSDIR}/PRScs.py \
--ref_dir=${CSDIR}/ldblk_ukbb_eur --bim_prefix=${BIMFILE} \
--sst_file=[path to file with PRScs sumstats] \
--n_gwas=[n_eff calculated] \
--out_dir=[directory name for output]/myphenotypename
####

# ----------------------------------------------------
# Output files are calculated per chromosome
# Concatenate PRScs SNPs effect weights 
# ----------------------------------------------------

cat myphenotypename_pst_eff_a1_b0.5_phiauto_chr* > [file name]_weights.txt
```

After the SNP weight file is created, upload this to your RAP project. The second step requires individual-level genotype data and must be carried out on the RAP. Use `dx` to log in to your account, navigate to your project, and run the polygenic score creation step using the example command below. This assumes you have already created QC'd, plink-formatted, hard-called genotype files, as in step 1 of the [`gwas pipeline`](../gwas_analyses/README_gwas.md). If not, create these first or use an alternative input file such as the WGS plink dataset. 

```
## ON UKB-RAP ##
# ----------------------------------------------------
# Create PRScs in UKB-RAP commandline
# Use PLINK to create scores based on the calculated SNP weights
# !IMPORTANT! double-check instance type and priority
# If run fails due to storage increase instance type
# ----------------------------------------------------

projectid= #put in user's projectID
path= #put in the path in user's project to store output files

for i in {1..22}; do
dx run swiss-army-knife \
	-iin="${projectid}:${path}/[file name]_weights.txt"\
	-iin="${projectid}:${path}/ukb22828_c${i}_b0_v3_filtered.pgen"\
	-iin="${projectid}:${path}/ukb22828_c${i}_b0_v3_filtered.psam"\
	-iin="${projectid}:${path}/ukb22828_c${i}_b0_v3_filtered.pvar"\
	-icmd="plink2 --bfile ukb22828_c${i}_b0_v3_filtered --score [file name]_weights.txt 2 4 6 --out [name]chr${i}"\
	--instance-type="mem1_ssd1_v2_x2" \ 
	--name="[name of run]chr${i}" \ 
	--priority low -y \
	--destination="[filepath to directory]"
done
```
