#!/bin/bash
# run a gwas using plink

projectid= #put in user's projectID
outputdir= #put in the directory in user's project to store output files (excluding the leading "/" )
ctgprojectid=project-GgbZPkjJ2JG1kB92GKyB7Zb5 #assumes membership in CTG shared project
genofilepath=project-GgbZPkjJ2JG1kB92GKyB7Zb5:/imputed_genos_cleaned #put in full path to QC'd genotype files from step 1
ancestry="EUR" #specify ancesty group for analysis, one of AFR,AMR,EAS,EUR,SAS
pheno= #put in the basename of the {phenotype}.pheno input file, e.g.: "pheno=gestational_diabetes" 
      ## where a file "gestational_diabetes.pheno" exists in the users's project directory
covar="gwa_covs.txt" #put in the path to the covariate file; default is CTG shared file 

for chr in {1..22} 
do

run_plink_cmd="plink2 --pfile ukb22828_c${chr}_b0_v3_filtered \
      --maf 0.0001 \
      --geno 0.05 \
      --glm firth-fallback no-x-sex hide-covar \
      --pheno ${pheno}.pheno \
      --covar ${covar} \
      --covar-name sex,f.21022.0.0,array01,pop_pc1-pop_pc20 \
      --covar-variance-standardize \
      --memory 64000 \
      --out c${chr}_${pheno}_${ancestry}"

dx run app-swiss-army-knife \
-iin=${genofilepath}/ukb22828_c${chr}_b0_v3_filtered.pgen \
-iin=${genofilepath}/ukb22828_c${chr}_b0_v3_filtered.psam \
-iin=${genofilepath}/ukb22828_c${chr}_b0_v3_filtered.pvar \
-iin=${projectid}:/${outputdir}/${pheno}.pheno \
-iin=${ctgprojectid}:/${covar} \
-icmd="${run_plink_cmd}" \
--instance-type mem1_ssd1_v2_x16 \
--name chr${chr}_gwas_plink \
--destination ${projectid}:/${outputdir} \
--priority low \
--cost-limit 0.5 \
--y

done
