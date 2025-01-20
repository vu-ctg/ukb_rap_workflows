# ukb_rap_workflows
This repository contains documentation on how to run analyses on UKB_RAP

1. How to extract phenotypes data using dx: `common_tasks/export_phenotypes.md`
2. Example script to scrape UKB Showcase to get the field-ids: `codes/ukb_showcase_webscrape/ukb_showcase_webscrape.py`
    - Note that the variables in this script are currently hard-coded. One needs to update some of the values to run for a field of interest
3. How to create the file to use as input for `dx extract_dataset`: `codes/export_phenotypes/subset_all_fields.py`
4. How to run PHESANT: `run_phesant/run_phesant_readme.md`