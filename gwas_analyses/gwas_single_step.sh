#!/bin/bash
# run GWAS in a single step (QC+analysis), in parallel across chromosomes 
#For CTG pipeline, we keep individuals that are defined in the file `unrel_EUR.ids` and SNPs in the file `snplist_QCinclude_rsid.txt`

projectid= #put in user's projectID
ctgprojectid=project-GgbZPkjJ2JG1kB92GKyB7Zb5 #assumems membership in CTG shared project
path= #put in the path in user's project to store output files
ancestry="EUR" #specify ancesty group for analysis, one of AFR,AMR,EAS,EUR,SAS
pheno= #put in the basename of the {phenotype}.pheno, example: gestational_diabetes. This assume that there is a file gestational_diabetes.pheno
covar="gwa_covs.txt" #put in the path to the covariate file; default is CTG shared file 



for i in {1..22} X XY; 
do


run_plink_cmd="echo 'Convert bgen to pgen'; 
 
plink2 --bgen ukb22828_c${i}_b0_v3.bgen ref-first \
--sample ukb22828_c${i}_b0_v3.sample \
--make-pgen \
--keep unrel_${ancestry}.ids \
--extract snplist_QCinclude_rsid.txt \
--memory 64000 --threads 16 \
--hard-call-threshold 0.1 \
--out ukb22828_c${i}_b0_v3_filtered;

echo 'Run analysis for chr ${i}'; 

plink2 --pfile ukb22828_c${i}_b0_v3_filtered \
--maf 0.0001 --geno 0.05 \
--glm firth-fallback no-x-sex hide-covar \
--covar ${covar} \
--covar-name sex,age,array01,pop_pc1-pop_pc20 \
--covar-variance-standardize \
--pheno ${pheno}.pheno \
--memory 64000 --threads 16 \
--out c${chr}_${pheno}_${ancestry}; 

echo 'clean up workspace';

rm ukb22828*psam; rm ukb22828*pgen; rm ukb22828*pvar; rm ukb22828*.bgen; rm ukb22828*.sample; rm snplist_QCinclude_rsid.txt; rm unrel_EUR.ids;

echo 'done' "



dx run app-swiss-army-knife \
-iin=${ctgprojectid}:/Bulk/Imputation/UKB\ imputation\ from\ genotype/ukb22828_c${chr}_b0_v3.bgen \
-iin=${ctgprojectid}:/Bulk/Imputation/UKB\ imputation\ from\ genotype/ukb22828_c${chr}_b0_v3.sample \
-iin=${ctgprojectid}:/Subject\ Lists/unrel_${ancestry}.ids \
-iin=${ctgprojectid}:/Variant\ Lists/snplist_QCinclude_rsid.txt \
-iin=${projectid}:${path}/${pheno}.pheno \
-iin=${ctgprojectid}:${path}/${covar} \
-icmd="${run_plink_cmd}" \
--instance-type mem2_ssd1_v2_x16 \
--name gwas_${pheno}_${ancestry}_chr${i} \
--destination ${projectid}:${path} \
--cost-limit 1 \
--priority low \
-y 

done
