#!/bin/bash
# run a gwas using plink

projectid= #put in user's projectID
ctgprojectid=project-GgbZPkjJ2JG1kB92GKyB7Zb5 #assumems membership in CTG shared project
path= #put in the path in user's project to store output files
ancestry="EUR" #specify ancesty group for analysis, one of AFR,AMR,EAS,EUR,SAS
pheno= #put in the basename of the {phenotype}.pheno, example: gestational_diabetes. This assume that there is a file gestational_diabetes.pheno
covar="gwa_covs.txt" #put in the path to the covariate file; default is CTG shared file 

for chr in {1..22}; 
do


run_plink_cmd="plink2 --pfile ukb22828_c${chr}_b0_v3_filtered \
      --maf 0.0001 --geno 0.05 \
      --glm firth-fallback no-x-sex hide-covar \
      --pheno ${pheno}.pheno \
      --covar ${covar} \
      --covar-name sex,age,array01,pop_pc1-pop_pc20 \
      --covar-variance-standardize \
      --memory 64000 --threads 16 \    
      --out c${chr}_${pheno}_${ancestry}"


dx run app-swiss-army-knife \
-iin=${projectid}:${path}/ukb22828_c${chr}_b0_v3_filtered.pgen \
-iin=${projectid}:${path}/ukb22828_c${chr}_b0_v3_filtered.psam \
-iin=${projectid}:${path}/ukb22828_c${chr}_b0_v3_filtered.pvar \
-iin=${projectid}:${path}/${pheno}.pheno \
-iin=${projectid}:${path}/${covar} \
-icmd="${run_plink_cmd}" \
--instance-type mem1_ssd1_v2_x16 \
--name chr${chr}_gwas_plink \
--destination ${projectid}:${path} \
--priority low \
--y

done
