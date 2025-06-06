# How to work with UKB-RAP data interactively in R, RStudio, Python, and Unix

The RAP does not allow for much direct interaction with data files, which can make browsing and small data management tasks a challenge. However, there are several ways to work interactively with data or files on the RAP using a Unix, R, or Python interface.

* Each of these options requires initializing a computing instance with the appropriate resources for your job. For most small data exploration or management tasks, the smallest/least expensive option (mem1_ssd1_v2_x2) is generally fine - but this won't be enough for larger genetic analyses. The instance costs are the same for the same instance type for all tools/apps, except *Spark clusters* which are more expensive. The instance types are NOT listed in cost order on RAP - make sure to choose the right one!
* * Interactive jobs follow the same priority rules as regular jobs, so be aware you may be kicked and save often if using a low priority instance.

* Like regular jobs, interactive jobs also require you to download files from your project to the local instance where you will be working, and upload any files you want to save at the end. Use `dx upload` and `dx download` to do so.

* You can generally also save a "snapshot" of your interactive workspace in its current state so that you can return to an analysis-in-progress later on. This may be helpful, e.g. if you need to use custom packages for your analysis which take a long time to install, as the RAP has no user installation location so these would otherwise need to be re-installed on every new instance. A snapshot saves a timestamped file in your project (folder “.Notebook_snapshots”) which contains all of the current settings/installations as well as local files you have downloaded or created. You can launch a new session and load the saved snapshot to restore your working environment exactly as it was.
* * N.B. these snapshots do have storage costs equivalent to the size of all files in the local environment at the time of save!

## JupyterLab (Python / R / Terminal)

From the 'Tools' menu select JupyterLab, then click '+ New JupyterLab'. Select the project you want to work in (where analysis costs will be charged and output will be returned). Select your job priority, resources, and what type of computing environment you want to use (Python/R which also includes a Unix terminal, ML, image processing, or Stata). 

<img width="350" alt="jupyterlab" src="https://github.com/user-attachments/assets/9429237c-fd27-4772-8966-06dcac6f4c71" />

After launching the environment, it will take several minutes to initialize and then you can click the link to open your new active environment from the Tools > JupyterLab page. From the Launcher page, open a Terminal and use `dx download <project-id>:<path/to/filename/or/id>` to load any files needed from your project. 
* N.B. there is a file browser panel which you can use to navigate through your project files but the 'download' option here puts files on your local/personal computer (usually NO!), not on the 'local' instance!

Use the Launcher to open R/Python console or notebook if desired and run your analyses (no data visualization possible). 

Return to your Terminal and use `dx upload <mynewfile.txt>` to save any newly created files back to your project. When you're finished, click 'File > Shut Down' from within the JupyterLab window or 'End Environment' from the Tools > JupyterLab page within the main RAP (you can use the same page to re-open an active environment that you have accidentally exited). 

Need more time than you planned? Click the 'Update duration' button in the top right.



## Posit Workbench (RStudio)

For an interactive environment that does allow for data visualization, RStudio is available on the RAP. From the 'Tools' menu select 'Posit Workbench (RStudio)' (on some pages you can only find this via the list in 'Tools > Tools Library'), then click '+ New Workbench'. Select the project you want to work in (where analysis costs will be charged and output will be returned). Select your job priority and resources. 

!!! IMPORTANT: Unlike other apps, there is NOT an automatic time limit on RStudio jobs and it is not possible to set one, so be attentive about shutting down your workbench as soon as you're finished. The workbench DOES NOT END when you close the window !!!

After launching the environment, it will take several minutes to initialize and then you can click the link to open your new active environment from the Tools > Posit Workbench (RStudio) page. From the Launcher page, open a new RStudio Pro Session. Click on the Terminal window next to the R Console window and use `dx download <project-id>:<path/to/filename/or/id>` to load any files needed from your project. Run your analyses as desired.

Return to the Terminal window and use `dx upload <mynewfile.txt>` to save any newly created files back to your project. When you're finished, click 'Terminate' in the top right corner (not 'File > Quit Session'; this only closes the RStudio window) or 'End Environment' from the Tools > Posit Workbench page within the main RAP (you can use the same page to re-open an active environment that you have accidentally exited). 


## Cloud Workstation (Unix)

For a simple Unix environment, you can also launch a Cloud Workstation via the 'Tools > Tools Library' page and ssh into the job once it is launched. I'm not sure what, if any, use case this is better for than the Terminal within JupyterLab described above - but it is another option. More information here: https://ukbiobank.dnanexus.com/panx/tool/app/cloud_workstation 


