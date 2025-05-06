#!/bin/bash
# run a gwas using plink

projectid= #put in projectID
path= #put in the path to store outfiles
pheno= #put in the basename of the {phenotype}.pheno, example: gestational_diabetes. This assume that there is a file gestational_diabetes.pheno
covar= #put in the path to the covariates

for chr in {1..22}; 
do
run_plink_cmd="plink2 --bfile ukb22828_c${chr}_b0_v3_filtered_2 \
       --glm firth-fallback \
       --pheno ${pheno}.pheno \
       --covar ${covar} \
       --memory 28000000 --threads 16 --covar-variance-standardize --out c${chr}_${pheno}"


dx run app-swiss-army-knife \
-iin=${projectid}:${path}/ukb22828_c${chr}_b0_v3_filtered_2.bed \
-iin=${projectid}:${path}/ukb22828_c${chr}_b0_v3_filtered_2.bim \
-iin=${projectid}:${path}/ukb22828_c${chr}_b0_v3_filtered_2.fam \
-iin=${projectid}:${path}/${pheno}.pheno \
-iin=${projectid}:${path}/${covar} \
-icmd="${run_plink_cmd}" \
--instance-type mem1_ssd1_v2_x16 \
--name chr${chr}_gwas_plink \
--destination ${projectid}:${path} \
--priority normal \
--y

done;