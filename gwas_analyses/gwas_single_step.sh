#!/bin/bash
# run GWAS in parallel across chromosomes with default settings + EUR ancestry
# QC and analysis per chr combined in a single job

for i in {1..22} X XY; 
do


run_plink_cmd="echo 'Convert bgen to pgen'; 
 
plink2 --bgen ukb22828_c${i}_b0_v3.bgen ref-first \
--sample ukb22828_c${i}_b0_v3.sample --make-pgen \
--keep unrel_EUR.ids --extract snplist_QCinclude_rsid.txt \
--memory 70000 --threads 36 \
--hard-call-threshold 0.1 --out ukb22828_c${i}_b0_v3_filtered;

echo 'Run analysis for chr ${i}'; 

plink2 --pfile ukb22828_c${i}_b0_v3_filtered \
--maf 0.0001 --geno 0.05 \
--covar-variance-standardize --glm \
--covar rap_test.covs --covar-name sex,age,array01,pop_pc1-pop_pc20 \
--pheno rap_test.pheno --pheno-name alcquant \
--memory 70000 --threads 36 \
--out c${i}_alcquant; 

echo 'clean up workspace';

rm ukb22828*psam; rm ukb22828*pgen; rm ukb22828*pvar; rm ukb22828*.bgen; rm ukb22828*.sample; rm snplist_QCinclude_rsid.txt; rm unrel_EUR.ids;

echo 'done' "



dx run app-swiss-army-knife \
-iin=project-GgbZPkjJ2JG1kB92GKyB7Zb5:/Bulk/Imputation/UKB\ imputation\ from\ genotype/ukb22828_c${i}_b0_v3.bgen \
-iin=project-GgbZPkjJ2JG1kB92GKyB7Zb5:/Bulk/Imputation/UKB\ imputation\ from\ genotype/ukb22828_c${i}_b0_v3.sample \
-iin=project-GgbZPkjJ2JG1kB92GKyB7Zb5:/benchmark/rap_test.covs \
-iin=project-GgbZPkjJ2JG1kB92GKyB7Zb5:/benchmark/rap_test.pheno \
-iin=project-GgbZPkjJ2JG1kB92GKyB7Zb5:/Subject\ Lists/unrel_EUR.ids \
-iin=project-GgbZPkjJ2JG1kB92GKyB7Zb5:/Variant\ Lists/snplist_QCinclude_rsid.txt \
-icmd="${run_plink_cmd}" \
--instance-type mem1_ssd1_v2_x36 \
--name gwas_chr${i} \
--cost-limit 2 --priority low -y \
--destination project-GgbZPkjJ2JG1kB92GKyB7Zb5:/benchmark/plink_workflow

done
