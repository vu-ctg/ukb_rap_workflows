# SNP extraction and burden scoring using UK Biobank data

This requires individual-level genotype data and must be carried out on the UKB-RAP. Use `dx` to log in to your account, navigate to your project, and run MAGMA step using the example command below. 
This is to extract SNPs for your chosen genes for all individuals burden scores need to be calculated for.


First execute SNP extraction for all individuals of interest. 

```
projectid= # put in user's projectID
path= # put in the path in user's project to obtain files

for i in {1..22}; do
 dx run swiss-army-knife \
  -iin="project-${projectid}:/${path}/ukb23158_c${i}_b0_v1.bim" \
  -iin="project-${projectid}:/${path}/ukb23158_c${i}_b0_v1.bed" \
  -iin="project-${projectid}:/${path}/ukb23158_c${i}_b0_v1.fam" \
  -iin="project-${projectid}:/${path}/[participant IIDs].txt" \
  -iin="project-${projectid}:/${path}/[your SNPs for genes of interest].txt" \
  -icmd="plink2 --bfile ukb23158_c${i}_b0_v1 --extract [SNP file}.txt --keep [participants] --make-bed --no-pheno --out [output filename]${i}" \
  --instance-type="mem1_ssd1_v2_x8" \
  --name [job name]${i} \
  --priority low -y \
  --destination="project-${projectid}:/${path}/[extraction location]"
done
```
Second, execute burden scoring for each gene of choice. You need your extraction files, your scoring files for each gene (best to store in .tar files per chromosome), and a file with list of genes by chromosome.
Output is your .sscore files per gene including all burden scores that you can concatenate. Be aware with large gene list and thus lots of SNPs this can take a long time to run.

```
for i in {1..22}; do
 dx run swiss-army-knife \
  -iin="project-${projectid}:/${path}/[your extraction file].bim" \
  -iin="project-${projectid}:/${path}/[your extraction file].bed" \
  -iin="project-${projectid}:/${path}/[your extraction file].fam" \
  -iin="project-${projectid}:/${path}/chr${chr}_genes.txt" \ # list of genes of interest stored in .txt file by chromosome
  -iin="project-${projectid}:/${path}/chr${chr}.tar" \
  -icmd='tar -xf chr'${chr}'_.tar && while read gene; do plink2 --bfile [your extraction files]'${chr}' --score gene_${gene}.score 1 2 3 --out [outputname]${gene}_chr'${chr}';
  done < chr'${chr}'_rare_genes.txt' \
 --instance-type="mem1_ssd1_v2_x8" \
 --name [job name]${chr}_finalscore \
 --priority low -y \
 --destination="project-${projectid}:/${path}/[your destination file]"
done
``` 
