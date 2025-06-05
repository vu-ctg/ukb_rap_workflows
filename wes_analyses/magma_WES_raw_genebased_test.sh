#!/bin/bash
# run magma analysis on raw WES data with default settings (for sumstats, use Snellius pipeline)
#!#!#! still need to create annotation file using RAP WGS/WES data files and ID formats!


for i in {1..22} X XY; 
do


run_cmd="chmod +x magma; 

./magma --bfile ukb23158_c${i}_b0_v1 --gene-annot #!#!#ukb_GRCh38.genes.annot#!#!#! --pheno file=rap_test.pheno --covar file=rap_test.covs --gene-model linreg --out magmatest --gene-settings indiv-include=unrel_EUR.ids snp-include=snplist_QCinclude_rsid.txt"



dx run app-swiss-army-knife \
-iin=project-GgbZPkjJ2JG1kB92GKyB7Zb5:/Bulk/Exome sequences/Population level exome OQFE variants, PLINK format - final release/ukb23158_c${i}_b0_v1.bim \
-iin=project-GgbZPkjJ2JG1kB92GKyB7Zb5:/Bulk/Exome sequences/Population level exome OQFE variants, PLINK format - final release/ukb23158_c${i}_b0_v1.bed \
-iin=project-GgbZPkjJ2JG1kB92GKyB7Zb5:/Bulk/Exome sequences/Population level exome OQFE variants, PLINK format - final release/ukb23158_c${i}_b0_v1.fam \
-iin=project-GgbZPkjJ2JG1kB92GKyB7Zb5:/programs/magma/magma\
#!#!#!#!#-iin=project-GgbZPkjJ2JG1kB92GKyB7Zb5:/programs/magma/ukb_GRCh38.genes.annot!#!#!#!#!# \
-iin=project-GgbZPkjJ2JG1kB92GKyB7Zb5:/benchmark/rap_test.covs \
-iin=project-GgbZPkjJ2JG1kB92GKyB7Zb5:/benchmark/rap_test.pheno \
-iin=project-GgbZPkjJ2JG1kB92GKyB7Zb5:/Subject\ Lists/unrel_EUR.ids \
-iin=project-GgbZPkjJ2JG1kB92GKyB7Zb5:/Variant\ Lists/snplist_QCinclude_rsid.txt \
-icmd="${run_cmd}" \
--instance-type mem1_ssd1_v2_x16 \
--name gwas_chr${i} \
--cost-limit 2 --priority low -y \
--destination project-GgbZPkjJ2JG1kB92GKyB7Zb5:/benchmark/magma/

done



# after per-chr jobs have finished running, merge output files (on RAP or Snellius), e.g.:

#${MAGMA_PATH} --merge ${OUTPUT_FILE}_${POP} --out ${OUTPUT_FILE}_${POP}
