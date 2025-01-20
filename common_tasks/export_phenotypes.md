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

