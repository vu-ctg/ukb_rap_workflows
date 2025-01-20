## How to extract phenotypes data using dx
- Useful resources: 
https://community.ukbiobank.ac.uk/hc/en-gb/community/posts/16019569797021-Query-of-the-Week-1-Export-Phenotypic-Data-to-a-File#comments
- https://github.com/dnanexus/OpenBio/blob/master/dx-toolkit/dx_extract_dataset_python.ipynb

```
dx extract_dataset pid:rid -ddd
```
where pid is the project id and rid is the record id

- The above command results in 3 outputs on the local directory (not on the folder on UKB rap but on the device's local directory).

```
*.data_dictionary.csv
*.entity_dictionary.csv
*.codings.csv
```

- List all the available fields

```
dx extract_dataset {projectID}:{recordID} --list-fields > all_fields.txt
```

- List all the available entities
```
dx extract_dataset {projectID}:{recordID} --list-entities > all_entities.txt
```

- Extract phenotypic data for all participants in each field example

```
dx extract_dataset {projectID}:{recordID} --fields "participant.eid,participant.p100001_i0,participant.p100001_i1,participant.p100001_i2,participant.p100001_i3,participant.p100001_i4"
```

- Instead of giving a list of fields as inputs to `--fields`, a more efficient way is to have the list of fields as a file and use `----fields-file`

- NOTES: 
    + From my experience, if there are a lot of fields to extract, the command will fail because it overwhelms the server (see: https://community.dnanexus.com/s/question/0D582000004TONTCA4/are-there-simpler-ways-of-doing-things). Therefore, perhaps using spark to extract the phenotypes are more efficient
    + Resources for using spark to extract phenotypes:
    https://github.com/UK-Biobank/UKB-RAP-Notebooks-Access
    https://dnanexus.gitbook.io/uk-biobank-rap/working-on-the-research-analysis-platform/accessing-data/using-spark-to-analyze-tabular-data 
