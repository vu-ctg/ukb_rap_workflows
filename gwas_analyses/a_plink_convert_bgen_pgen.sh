#!/bin/bash
#Convert bgen to pgen
#For CTG pipeline, we keep individuals that are defined in the file `unrel_EUR.ids` and SNPs in the file `snplist_QCinclude_rsid.txt`

projectid= #put in projectID
shared_files_path= #put in the path for shared files
path= #put in the path to store outfiles

for chr in {1..22}
do

run_plink_cmd="plink2 --bgen ukb22828_c${chr}_b0_v3.bgen ref-first \
        --sample ukb22828_c${chr}_b0_v3.sample \
        --make-pgen \
        --keep unrel_EUR.ids \
        --extract snplist_QCinclude_rsid.txt \
        --hard-call-threshold 0.1 \
        --out ukb22828_c${chr}_b0_v3_filtered"

dx run app-swiss-army-knife \
-iin=${projectid}:/Bulk/Imputation/UKB\ imputation\ from\ genotype/ukb22828_c${chr}_b0_v3.bgen \
-iin=${projectid}:/Bulk/Imputation/UKB\ imputation\ from\ genotype/ukb22828_c${chr}_b0_v3.sample \
-iin=${projectid}:${shared_files_path}/unrel_EUR.ids \
-iin=${projectid}:${shared_files_path}/snplist_QCinclude_rsid.txt \
-icmd="${run_plink_cmd}" \
--instance-type mem1_ssd1_v2_x8 \
--name chr${chr}_bgen_pgen \
--destination ${projectid}:${path} \
--priority normal \
--y 
done