## General information
1. Create a project: https://dnanexus.gitbook.io/uk-biobank-rap/getting-started/quickstart/creating-a-project
2. Viewing and creating a cohort
- https://documentation.dnanexus.com/user/cohort-browser 
- https://community.ukbiobank.ac.uk/hc/en-gb/community/posts/16019569797021-Query-of-the-Week-1-Export-Phenotypic-Data-to-a-File 
- Looking up data field: https://biobank.ctsu.ox.ac.uk/crystal/search.cgi 
3. Command line interphase: 
- https://dnanexus.gitbook.io/uk-biobank-rap/working-on-the-research-analysis-platform/running-analysis-jobs/command-line-interface 
- How to install: https://documentation.dnanexus.com/downloads 
- Basic commands: 
```
#sign in and out
dx login
dx logout
dx whoami

# select project
dx select

# help
dx -h/--help

# run
dx run

# 
dx find
dx mv
dx download
dx pwd
dx ls
dx mkdir #creaet a directory
```
4. Swiss Army Knife: https://platform.dnanexus.com/app/swiss-army-knife
5. Other useful sites: 
- https://github.com/dnanexus/OpenBio/blob/master/UKB_notebooks/ukb-rap-pheno-basic.ipynb

## Files structure
- Explanation of the filename conventions: https://dnanexus.gitbook.io/uk-biobank-rap/getting-started/data-structure 
- Files that contain data on a cohort of participants (such as PLINK, BGEN or pVCF files) are named in this fashion: 
```
ukb<FIELD-ID>_c<CHROM>_b<BLOCK>_v<VERSION>.<SUFFIX>
```
    - 23157 is the data field: https://biobank.ctsu.ox.ac.uk/ukb/field.cgi?id=23157 
    - c1 is chromosome 1
    - b1 is block 1

## Example commands

### Example 1 with bcftools 

```
dx run app-swiss-army-knife \
-iin={projectID}:{path} \
-icmd="bcftools view -g het * -O z > cX_b0_v1-filtered.vcf.gz" \
--instance-type mem1_ssd1_v2_x2 \
--name bcftools_test
```

## FAQ

1. Environment snapshot: https://documentation.dnanexus.com/user/jupyter-notebooks#environment-snapshots
2. How to run Jupyter notebooks non-interactively: https://documentation.dnanexus.com/user/jupyter-notebooks/references#run-notebooks-non-interactively 
3. Check for cost: https://20779781.fs1.hubspotusercontent-na1.net/hubfs/20779781/Product Team Folder/Rate Cards/BiobankResearchAnalysisPlatform_Rate Card_Current.pdf