# Document analysis of Whole Exome Sequencing (WES)

## Description of WES data structure on UKB-RAP
- pVCF path: `/Bulk/Exome sequences/Population level exome OQFE variants, pVCF format - final release/`
- Example file name: `ukb23157_cX_b0_v1.vcf.gz` where
    - c{1..22 X} is the name of the chromosome
    - b* is the block number

## How to subset pVCF file for a specific chromosome
- Rationale: 
    - Typically I would use VCFtools to subset the VCFs for a region of a chromosome. However, the problem here is that because all of the UKB VCFs are split into blocks, I don't know which block would have the coordinates for my region of interest. 
    - I'm not sure if there is an efficient way of doing this. Searching yields a couple of posts on this (https://community.ukbiobank.ac.uk/hc/en-gb/community/posts/16019643229341-Subset-WGS-pVCF) but does not provide an actual solution. Therefore, here I described my own solution to this. 
- Outline of steps: 
    1. List all of the blocks per chromosome (credit: https://github.com/pjgreer/ukb-rap-tools/blob/main/ukb-vcf-list.sh)
    ```
    dx ls Bulk/Exome\ sequences/Population\ level\ exome\ OQFE\ variants,\ pVCF\ format\ -\ final\ release/*.vcf.gz | grep cX
    ```
    2. For each block, print out all positions per block using bcftools 
    3. For chr 1-22, X, and Y, create a file per chromosome with 3 columns: 
        - Column 1: block #
        - Column 2: start position of that block
        - Column 3: end position of that block
    4. For each region or gene of interest
        - find which block
        - use vcftools or bcftools to subset for a specific region or gene of interest

#### Documentation on generating start-end per block for each chromosome
- For each chromosome, generate a file with 3 columns (block#, start, end). This file is generated once and is used in subsequent steps to subset a region from the VCF
- Step 1: List all of the blocks per chromosome
```
for i in {1..22} X Y
do
echo chr${i} 
dx ls {PATH}/*.vcf.gz | grep c${i}_b > chr${i}_blocks.txt
done
```

- Step 2: Print out all positions per block using bcftools
    - For each of the block in the file `chr${i}_blocks.txt`, run this command. Example (note that the block id here is made up)
    ```
    for block in ukb23157_cX_b0_v1
    do
    dx run app-swiss-army-knife -iin={projectID}:{PATH}/${block}.vcf.gz -icmd="bcftools query -f '%POS\n' ${block}.vcf.gz > ${block}.txt" --instance-type mem1_ssd1_v2_x2 --name bcftools_${block} --destination {PATH}
    ```
    - The above command outputs a file `${block}.txt` per block where each line is a position in the VCF 
    - Download `${block}.txt` files to local directory
    - Sort: 
    ```
    sort -n -k 1,1 ${block}.txt > ${block}_sorted.txt
    ```
- Step 3: Extract ranges per block
    - The idea is that we want to create a sort of bed file for each chromosome with 3 columns (see above).
    - Use python script `wes_analyses/extract_block_ranges.py`. Example of how to run this
    ```
    python wes_analyses/extract_block_ranges.py --block_pos ${block}_sorted.txt --outfile chr${chr}_block_ranges_tmp.txt
    ```
    - The output file `chr${chr}_block_ranges_tmp.txt` contains the start and end position of all the blocks belonging to that specific chromsome. Sort this file:
    ```
    sort -n -k 2,2 chr${chr}_block_ranges_tmp.txt > chr${chr}_block_ranges.txt
    ```
    - Now at the end, what we have is 24 files of the format `chr${chr}_block_ranges.txt` for chromosome 1 to 22 and X and Y chromosomes

#### To extract a specific region/gene from the pVCFs
For example, I am interested in the gene ABCD1
- Find position on this gene on ensemble (https://www.ensembl.org/Homo_sapiens/Gene/Summary?db=core;g=ENSG00000101986;r=X:153724856-153744755)
- Step 1: Find which block
    - Use `wes_analyses/find_blocks_for_subset_vcfs.py`. Example:
    ```
    python find_blocks_for_subset_vcfs.py --chrom X --start 152168700 --end 153788225
    Start block: ukb23157_cX_b22_v1
    End block: ukb23157_cX_b22_v1
    For region of interest X:152168700-153788225, subset the VCF from block ukb23157_cX_b22_v1.
    ```
- Step 2: run dx run vcftools via swiss-army-knife
Example command to get the freq of all variants in ABCD1
```
dx run app-swiss-army-knife -iin={projectID}:{recordID} -icmd="vcftools --gzvcf ukb23157_cX_b22_v1.vcf.gz --from-bp 152168700 --to-bp 153788225 --freq --out ABCD1_freq.txt" --instance-type mem1_ssd1_v2_x2 --name ABCD1_freq
```