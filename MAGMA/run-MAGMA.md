# Workflow for running MAGMA on rare variants using UK Biobank data

This requires individual-level genotype data and must be carried out on the UKB-RAP. Use `dx` to log in to your account, navigate to your project, and run MAGMA using the example command below. This assumes you have already created QC'd, plink-formatted, hard-called genotype files.
This is to run MAGMA ONLY for rare variants with a minor allele frequency < 5%

```
projectid= # put in user's projectID
path= # put in the path in user's project to store output files

for i in {1...22}; do
  dx run swiss-army-knife \
    -iin="project-${projectid}:/${path}/ukb23158_c${i}_b0_v1.bim"\
    -iin="project-${projectid}:/${path}/ukb23158_c${i}_b0_v1.bed"\
    -iin="project-${projectid}:/${path}/ukb23158_c${i}_b0_v1.fam"\
    -iin="project-${projectid}:/${path}/magma" \
    -iin="project-${projectid}:/${path}/ukb_RAP_chr${i}.genes.annot" \ 
    -iin="project-${projectid}:/${path}/[your covariate file].txt" \ 
    -iin="project-${projectid}:/${path}/[phenotype file].txt" \
    -iin="project-${projectid}:/${path}/[participant IID file]" \
    -icmd="chmod +x magma && ./magma --bfile ukb23158_c${i}_b0_v1 --gene-annot ukb_RAP_chr${i}..genes.annot --pheno file=[phenotype].txt use=[column name phenotype] --covar file=[file].txt --gene-model linreg --out [name of files]${i} --gene-settings indiv-exclude=[participants file]  --burden 0.05 rare-only" \
    --instance-type="mem1_ssd1_x8" \
    --name [name of job]${i}\
    --priority low -y\
    --destination="project-${projectid}:/${path}/[preffered location]"
done
```
