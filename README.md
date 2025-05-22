# ukb_rap_workflows
This repository contains documentation on how to run analyses on UKB_RAP

1. General overview: [`UKB_RAP_overview.md`](https://github.com/tanyaphung/ukb_rap_workflows/blob/master/UKB_RAP_overview.md)
2. How to: **extract phenotypes data using dx**: https://github.com/tanyaphung/ukb_rap_workflows/blob/master/common_tasks/export_phenotypes.md
3. How to: **web scrape UKB Showcase**
    - Example script to scrape UKB Showcase to get the field-ids: [`codes/ukb_showcase_webscrape/ukb_showcase_webscrape.py`](https://github.com/tanyaphung/ukb_rap_workflows/blob/master/codes/ukb_showcase_webscrape/ukb_showcase_webscrape.py)
    - Note that the variables in this script are currently hard-coded. One needs to update some of the values to run for a field of interest
4. How to: **create the file to use as input for `dx extract_dataset`**: [`codes/export_phenotypes/subset_all_fields.py`](https://github.com/tanyaphung/ukb_rap_workflows/blob/master/codes/export_phenotypes/subset_all_fields.py)
5. How to: **run PHESANT**: [`run_phesant/run_phesant_readme.md`](https://github.com/tanyaphung/ukb_rap_workflows/blob/master/run_phesant/run_phesant_readme.md)
6. How to: **subset pVCF files for a region/gene of interest**: [`wes_analyses/wes_analyses_readme.md`](https://github.com/tanyaphung/ukb_rap_workflows/blob/master/wes_analyses/wes_analyses_readme.md)
7. How to: **Run GWAS using plink**: https://github.com/tanyaphung/ukb_rap_workflows/blob/master/gwas_analyses/gwas_readme.md