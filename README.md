# ukb_rap_workflows
This repository contains documentation for VU-CTG lab members on how to run analyses on the UK Biobank Research Analysis Platform (UKB-RAP). The scripts contained here are meant to follow pipelines developed within the VU-CTG lab and may not be suitable for other applications. For more  information about the platform, please consult the [`UKB-RAP website`](https://ukbiobank.dnanexus.com/landing), its documentation [`site`](https://dnanexus.gitbook.io/uk-biobank-rap), or the UKB online [`community help pages`](https://community.ukbiobank.ac.uk/hc/en-gb).

Before working with the RAP, make sure you have completed your [`Researcher Training Courses`](https://community.ukbiobank.ac.uk/hc/en-gb/articles/22145292393757-Researcher-Training-Courses) - mandatory for accessing the system. It is also a good idea to review the [`series of webinar tutorials`](https://www.youtube.com/watch?v=762PVlyZJ-U&list=PLRkZ0Fz-n3Z7Jg0Vz4vudLYnBza4EUGLM) to get familiar with the platform. 

1. General overview and resources for getting started on the RAP system: [`UKB_RAP_overview.md`](https://github.com/vu-ctg/ukb_rap_workflows/blob/master/UKB_RAP_overview.md)
2. How to: **extract phenotype data using dx**: [`common_tasks/export_phenotypes.md`](https://github.com/vu-ctg/ukb_rap_workflows/blob/master/common_tasks/export_phenotypes.md)
3. How to: **web scrape UKB Showcase**: [`codes/ukb_showcase_webscrape/ukb_showcase_webscrape.py`](https://github.com/vu-ctg/ukb_rap_workflows/blob/master/codes/ukb_showcase_webscrape/ukb_showcase_webscrape.py)
4. How to: **create the file to use as input for `dx extract_dataset`**: [`codes/export_phenotypes/subset_all_fields.py`](https://github.com/vu-ctg/ukb_rap_workflows/blob/master/codes/export_phenotypes/subset_all_fields.py)
5. How to: **run PHESANT**: [`run_phesant/run_phesant_readme.md`](https://github.com/vu-ctg/ukb_rap_workflows/blob/master/run_phesant/run_phesant_readme.md)
6. How to: **subset pVCF files for a region/gene of interest**: [`wes_analyses/wes_analyses_readme.md`](https://github.com/vu-ctg/ukb_rap_workflows/blob/master/wes_analyses/wes_analyses_readme.md)
7. How to: **Run GWAS in plink using (local) CTG pipeline settings**: [`gwas_analyses/gwas_readme.md`](https://github.com/vu-ctg/ukb_rap_workflows/blob/master/gwas_analyses/gwas_readme.md)
8. How to **work with data and files interactively**: [`interactive_workspaces.md`](https://github.com/vu-ctg/ukb_rap_workflows/blob/master/interactive_workspaces.md)

Coming soon: how to run MAGMA gene-based analyses and polygenic score analyses.

Developing a new analysis not already documented here? Have a helpful RAP tip to share? Feel free to add to this repository or contact @jesavage to be added as a contributor.
