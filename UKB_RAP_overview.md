# General information for getting started on UKB-RAP

## 1. Create a project: 
All UKB data as well as your own files and scripts are organized in "projects" on the RAP. To get started, you will need to create a new project of your own (https://dnanexus.gitbook.io/uk-biobank-rap/getting-started/quickstart/creating-a-project). You can create multiple projects and share them with  users on the same UKB application number to facilitate collaboration. There is also a shared CTG-UKB project which includes all of the UKB data, updated regularly (so each user does not need to dispense large datasets to their own projects), as well as files used in common applications such as subject and variant filtering lists and locally generated covariates. Please contact the CTG-UKB manager to be added to this shared project. Some scripts in this repository require files from this shared project to function.

## 2. Viewing and creating a cohort
Unlike the Unix environment of an HPC cluster, the UKB-RAP allows for only very limited direct interaction with data files. The website GUI or command line interface (see below) allow you to browse through and organize files, but not to view or manipulate them directly. You can, however, use the [`Cohort Browser`](https://documentation.dnanexus.com/user/cohort-browser) via the website to explore data interactively. You can view distributions of existing data fields, filter subjects based on any data field criteria or genetic variants, and create a 'cohort' of individuals and variables. Information in the cohort browser is organized in the same way as the [`UKB data showcase website`](https://biobank.ctsu.ox.ac.uk/crystal/search.cgi). Once you have a cohort selected, these can be exported for further analysis:
- [`export_phenotypes.md`](https://github.com/vu-ctg/ukb_rap_workflows/blob/master/common_tasks/export_phenotypes.md)
- [`UKB community help page`](https://community.ukbiobank.ac.uk/hc/en-gb/community/posts/16019569797021-Query-of-the-Week-1-Export-Phenotypic-Data-to-a-File)

If you prefer to work with the data interactively in an R/Python/Unix terminal, this is also possible - but has to be run on a computing instance, which has associated costs (unlike the Cohort Browser). See [`interactive_workspaces.md`](https://github.com/vu-ctg/ukb_rap_workflows/blob/master/interactive_workspaces.md) for more information.

## 3. File structure of UKB data
- Explanation of the filename conventions: https://dnanexus.gitbook.io/uk-biobank-rap/getting-started/data-structure 
- Files that contain data on a cohort of participants (such as PLINK, BGEN or pVCF files) are named in this fashion: 
```
ukb<FIELD-ID>_c<CHROM>_b<BLOCK>_v<VERSION>.<SUFFIX>
    - 23157 is the data field: https://biobank.ctsu.ox.ac.uk/ukb/field.cgi?id=23157 
    - c1 is chromosome 1
    - b1 is block 1
```

## 4. Command line interface: 
The website GUI has somewhat limited file manipulation tools (for example, you can move files down *into* a subfolder but not up *from* a subfolder) and can be very slow to load. It is often more convenient to navigate the RAP using the `dx` [`command-line tool`](https://dnanexus.gitbook.io/uk-biobank-rap/working-on-the-research-analysis-platform/running-analysis-jobs/command-line-interface) which has been developed specifically for this system. `dx` is similar to bash language, though with a more limited set of commands.

To use `dx`, first download install the Python package on your local machine or from within your Snellius account: https://documentation.dnanexus.com/downloads 

After installation you can interact with files and run analyses on the RAP directly.
### Basic commands:
- Log in and out, and check your login info
```
dx login
dx logout
dx whoami
```
- Select a project to work on (in Step 1 above, either you created a project(s) or have been added to the shared CTG project). To list all of your projects, run `dx select`, then enter the corresponding project number to pick which one to use. 
```
dx select

Note: Use dx select --level VIEW or dx select --public to select from projects for
which you only have VIEW permissions.

Available projects (CONTRIBUTE or higher):
0) your_project_name (ADMINISTER)
1) CTG-UKB_shared_project_name (CONTRIBUTE)

Pick a numbered choice [0]:
```
- Then, list the content of the project using `dx ls` to show all the files in the home directory of the selected project. These should look exactly the same as when viewing the project in the website GUI.
```
dx ls
> .table-exporter/
> Bulk/
> Relative Info/
> Showcase metadata/
> app12345_20250101.dataset
> my_own_folder
```
- To navigate around, use `dx cd`. To move or copy files, create new directories, etc., the commands are the same as in bash but with `dx` in front:
```
dx cd my_own_folder/
dx ls
> my_own_file1
> my_own_file2
dx mkdir newfolder
dx mv my_own_file1 newfolder/file3
dx ls newfolder
> file3
```
- The `dx download` and `dx upload` commands can be used to download files from the RAP to your local machine or upload them, respectively. !! USE WITH CAUTION as any files containing individual-level UKB participant information may NOT be downloaded locally without special exemption, and downloading files incurs [`egress costs`](https://20779781.fs1.hubspotusercontent-na1.net/hubfs/20779781/Product%20Team%20Folder/Rate%20Cards/BiobankResearchAnalysisPlatform_Rate%20Card_Current.pdf) !!
- Manipulating files or running analyses on the RAP is done through the use of apps. These can be initiated using the `dx run` command to start up an app such as Plink or [`Swiss Army Knife`](https://platform.dnanexus.com/app/swiss-army-knife). Running apps incurs costs and requires additional settings such as input/output file locations and instance types - see other pages on this repository for additional examples.
```
### Example with bcftools 

dx run app-swiss-army-knife \
-iin={projectID}:{path} \
-icmd="bcftools view -g het * -O z > cX_b0_v1-filtered.vcf.gz" \
--instance-type mem1_ssd1_v2_x2 \
--name bcftools_test
```
- For a more complete list of `dx` commands, use the help function (`dx -h`) or check the [`documentation`](https://documentation.dnanexus.com/user/helpstrings-of-sdk-command-line-utilities). Another useful site is https://github.com/dnanexus/OpenBio/blob/master/UKB_notebooks/ukb-rap-pheno-basic.ipynb


## 5. Tips and miscellaneous info

- Rate card for computing, storage, and egress costs: https://20779781.fs1.hubspotusercontent-na1.net/hubfs/20779781/Product%20Team%20Folder/Rate%20Cards/BiobankResearchAnalysisPlatform_Rate%20Card_Current.pdf
- Everything you can do on the RAP can be done interactively via the website GUI or via command line interface (dx program). File management and (repetitive) job submission is often easier via command line. To interactively work with your data instead of submitting a job, use the JupyterLab (R / Python / Terminal), Posit workbench (RStudio - including plots), or Cloud Workspace (ssh login to Unix environment) tools.
- The costs are the same for the same instance type for all tools/apps, except RStudio and Spark clusters which are more expensive. The instance types are NOT listed in cost order on RAP - make sure to choose the right one!! Least expensive is mem1_ssd1_v2_x2 - this is fine for simple data exploration but not enough for large genetic analyses.
- **Make sure to set cost/time limits for every job you start!** For a few apps, including RStudio, it’s not possible to set limits - so don’t forget to end these when you’re finished.
File IDs are unique. File names are not. Refer to the file you want by its specific ID and don’t try to delete a file by overwriting with one of the same name.
- All output from a job gets returned to your specified output folder. This includes intermediate files and files created in earlier steps of a workflow - which may be very large. Avoid extra storage costs by adding a step to remove unnecessary files within your job script, if possible, or remember to delete manually right away.
- Jobs are charged to the project where the output is directed. You can however use input files from any project that you have permission to access.
- Instances with low memory/CPUs cost less, but can get stuck or not produce results if the resources are insufficient for the job, costing more in the long run than a larger instance (and being more likely to get kicked from a low priority queue). Small parallel jobs are more efficient than large ones. In practice, instances with 2-4 CPUs are not enough to run analyses such as GWAS on the full UKB sample; aim for 8-36 CPUs for these types of analyses.
