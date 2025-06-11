#!/bin/bash
#Convert bgen to pgen
#For CTG pipeline, we keep individuals that are defined in the file `unrel_EUR.ids` and SNPs in the file `snplist_QCinclude_rsid.txt`

projectid= #put in projectID
ctgprojectid=project-GgbZPkjJ2JG1kB92GKyB7Zb5 #assumems membership in CTG shared project
path= #put in the path in user's project to store output files
ancestry="EUR" #specify ancesty group for analysis, one of AFR,AMR,EAS,EUR,SAS

for chr in {1..22}
do

run_plink_cmd="plink2 --bgen ukb22828_c${chr}_b0_v3.bgen ref-first \
        --sample ukb22828_c${chr}_b0_v3.sample \
        --make-pgen \
        --keep unrel_${ancestry}.ids \
        --extract snplist_QCinclude_rsid.txt \
        --hard-call-threshold 0.1 \
        --out ukb22828_c${chr}_b0_v3_filtered"

dx run app-swiss-army-knife \
-iin=${ctgprojectid}:/Bulk/Imputation/UKB\ imputation\ from\ genotype/ukb22828_c${chr}_b0_v3.bgen \
-iin=${ctgprojectid}:/Bulk/Imputation/UKB\ imputation\ from\ genotype/ukb22828_c${chr}_b0_v3.sample \
-iin=${ctgprojectid}:/Subject\ Lists/unrel_${ancestry}.ids \
-iin=${ctgprojectid}:/Variant\ Lists/snplist_QCinclude_rsid.txt \
-icmd="${run_plink_cmd}" \
--instance-type mem2_ssd1_v2_x8 \
--name chr${chr}_bgen_pgen \
--destination ${projectid}:${path} \
--priority normal \
--y 
done
