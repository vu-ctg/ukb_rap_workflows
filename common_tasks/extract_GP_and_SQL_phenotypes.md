# How to extract (GP) phenotypes from SQL databases

Some bulk data such as the GP (primary care) records are only stored in SQL databases and cannot be extracted interactively or easily using the Table Exporter. 

To extract these phenotypes, start up a spark cluster on the RAP either via dx run or interactively using Tools >> JupyterHub >> + New JupyterLab >> [select project] >> [select 'Spark Cluster' instead of 'Single Node' option] >> Start Environment 

After the environment initializes, adapt the example Python code below to extract the desired data from the desired database.


<i>N.B. All data fields can be accessed using SQL commands in this way, but most are easier to access using dx extract_dataset or Table Exporter.</i>

```
#setup
import dxpy
import pyspark
config = pyspark.SparkConf().setAll([('spark.kryoserializer.buffer.max', '128'),('spark.sql.execution.arrow.pyspark.enabled','true')])  
sc = pyspark.SparkContext(conf=config)
spark = pyspark.sql.SparkSession(sc)

#initialize dataset - replace app16406_XXX with your own dataset file name
spark.sql("USE app16406_20250423130546" ) 
spark.sql("SHOW TABLES").show(truncate=False)

# replace with SQL command for your desired variables/conditions from your desired database
# example databases include gp_scripts (GP prescription records) and gp_clinical (GP clinical events) - but there are many others
# these database names are hard coded and do not change across projects/applications

df = spark.sql("SELECT * FROM gp_scripts WHERE read_2 = 'du3..' OR read_2 = 'du31.' OR read_2 = 'du32.' OR read_2 = 'du33.' OR read_2 = 'du34.'  ")

```
