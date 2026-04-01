## How to extract phenotype data
Useful resources: 
- https://github.com/UK-Biobank/UKB-RAP-Notebooks-Access
- https://community.ukbiobank.ac.uk/hc/en-gb/community/posts/16019569797021-Query-of-the-Week-1-Export-Phenotypic-Data-to-a-File#comments
- https://github.com/dnanexus/OpenBio/blob/master/dx-toolkit/dx_extract_dataset_python.ipynb
- https://dnanexus.gitbook.io/uk-biobank-rap/working-on-the-research-analysis-platform/accessing-data/accessing-phenotypic-data
-    https://dnanexus.gitbook.io/uk-biobank-rap/working-on-the-research-analysis-platform/accessing-data/using-spark-to-analyze-tabular-data

--- 
There are multiple ways to extract phenotype data (i.e., a subset of data fields) from the large UKB database, though they are often not intuitive. 

The simplest method is to use the interactive Cohort Browser on the UKB-RAP website to generate a subset of participants and data fields that you wish to work with. Navigate to your project (or the CTG shared project) and select the most recent dispersed .dataset file. This will open up a new dashboard with menus where you can filter your participants or select data fields to show (tiles), using the same navigational structure as how the UKB Data Showcase. (Note that bulk data fields are not shown here but can be navigated via the /Bulk/ folder in the top level of a project where this type of data has been dispersed.) Once a Cohort is create, you can use the Table Exporter tool to convert this into a csv/tsv format file and use the interactive tools such as Jupyter Notebooks to explore or process the phenotype file further.


An alternative tool is the command line dx extract_dataset. However, this tool extracts individual-level data directly to the user's local machine and is therefore not in compliance with our project's data download regulations. It can however be useful to extract dictionaries and meta-data that may be helpful to input in the Table Exporter/Spark tools. For example:

```
dx extract_dataset {projectID}:{recordID} -ddd
```
where {projectID} is the project ID of your RAP project and {recordID} is the record ID (e.g., the file with UKB tabular data dispersed to your project, usually looks like "app12345_20251212345.dataset", or a dashboard view or cohort browser)

- The above command results in 3 outputs on the local directory (not on the folder on UKB RAP but on the device's local directory). 

```
*.data_dictionary.csv
*.entity_dictionary.csv
*.codings.csv
```
These dictionary files show information about the entities (SQL tables where different data types are stored), data field names/formats/descriptions, and coding schemes. These files have also been uploaded to the CTG shared project folder for reference.


- List all the available fields

```
dx extract_dataset {projectID}:{recordID} --list-fields > all_fields.txt
```

- List all the available entities
```
dx extract_dataset {projectID}:{recordID} --list-entities > all_entities.txt
```


- NOTES: 
    + If there are a lot of fields to extract, the Cohort Browser/Table Exporter can be quite slow or fail because it overwhelms the server (see: https://community.dnanexus.com/s/question/0D582000004TONTCA4/are-there-simpler-ways-of-doing-things). Using spark or direct SQL commands to extract large sets of phenotypes is more efficient. See the above resources for more info on different ways to extract large and small datasets.
    + dx extract_dataset should only be used for examinining meta-data, otherwise it will extract individual-level data to the user's local machine instead of the user's RAP project (not allowed!)
