#!/bin/bash
# run a gwas using plink

projectid= #put in projectID
path= #put in the path to store outfiles

for chr in {1..22}; 
do
run_plink_cmd="plink2 --pfile ukb22828_c${chr}_b0_v3_filtered \
      --maf 0.0001 --geno 0.05 \
      --make-bed --out ukb22828_c${chr}_b0_v3_filtered_2"


dx run app-swiss-army-knife \
-iin=${projectid}:${path}/ukb22828_c${chr}_b0_v3_filtered.pgen \
-iin=${projectid}:${path}/ukb22828_c${chr}_b0_v3_filtered.psam \
-iin=${projectid}:${path}/ukb22828_c${chr}_b0_v3_filtered.pvar \
-icmd="${run_plink_cmd}" \
--instance-type mem1_ssd1_v2_x2 \
--name chr${chr}_plink_qc_imputed \
--destination ${projectid}:${path} \
--priority normal \
--y

done;