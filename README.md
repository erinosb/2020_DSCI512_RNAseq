# 2020_DSCI512_RNAseq

*DSCI512 - RNA sequencing data analysis - course scripts*

*A simple set of wrappers and tools for RNA-seq analysis. These tools were designed for the DSCI512 RNA-seq analysis class at Colorado State University*

Below is a tutorial on the use of these scripts:

----


## Let's download the script templates I've written on github.

We will build on these scripts each class session.
You will be able to tailor these templates to your own purposes for future use and for the final project.


**Exercise**

  * Locate the green **code** button on the top right of this page. Click it.
  * Click on the clipboard icon. This will save a github URL address to your clipboard.
  * Switch over to JupyterHub linked to SUMMIT.
  * Navigate into your directory for `PROJ01_GomezOrte/02_scripts` and use `git clone` as shown below to pull the information from github to your location on SUMMIT.
  
```bash
$ cd /scratch/summit/<eID>@colostate.edu    #Replace <eID> with your EID
$ cd PROJ01_GomezOrte
$ git clone <paste path to github repository here>
```

**Explore what you obtained.**

Notice that instead of having a single script, you now have a few scripts. These will work in a **Two step** method for executing jobs on summit. The `execute` script calls the `analyze` script. This Readme file and a license file were also downloaded.

Let's copy the two scripts up one directory. This will create duplicate copies for you to edit on and will move the scripts directly into ''02_scripts'', not its sub-directory.

```bash
$ cd 2020_DSCI512_RNAseq
$ cp RNAseq_analyzer_201119.sh ..
$ cp execute_RNAseq_pipeline.sbatch ..
$ cd ..
```

----
## The RNAseqAnalyzer Script 


The **RNAseq_analyzer_201119.sh** script contains our pipeline. 

Let's briefly peek into it and see that it contains. 
  * Open **RNAseq_analyzer_201119.sh** in an editor window. You'll notice the following sections.

**The pipeline**
  * A shebang
  * A long comment section with documentation on its use
  * MODIFY THIS SECTION - *you will tailor this section to each job*
  * BEGIN CODE - *the code starts and reports how it is running*
  * META DATA - *this part pulls information out of the metadata file to create bash arrays*
  * PIPELINE - *right now this contains a for loop that will execute fastp. We will add onto this section each class*
  * VERSIONS - *this prints out the versions of software used for your future methods section*

**Exercise - explore the analyzer**
  * In MODIFY THIS SECTION, tailor your RNAseq_analyzer_201119.sh to suit your own input directory
    * Change `inputdir="<yourinputdir>"` to `inputdir="../01_input''` (should match your actual input directory)
    * Eventually we will modify most things in this section but for now, just change that one thing.
  * Type `exit` on line 133 right before `# FASTP to remove unwanted sequences`. This will short circuit the script and ask it to simply run the code above `exit`
  * Run the code with the following command line:
 
 ```bash
#USAGE:
#     bash RNAseq_analyzer_201119.sh </path/metadatafile.txt> <number of threads>
#                  Make sure the metadata filename and path is correct
#                  Number of threads refers to how many cores to use for parallel processing

$ bash RNAseq_analyzer_201119.sh ../01_input/metadata_gomezOrte.txt 1
```

  * Walk through the output that was displayed to the screen and find every place in the code that specified each line of output
  
**Exercise - explore the fastp loop of the analyzer**
  * Next, we will explore how the fastp loop of the analyzer works.
  * **Important:** Remove the `exit` line of code you introduced at line 133.
  * Look at the general structure of how the loop is written.

```bash
for (( counter=0; counter < ${#samples1[@]}; counter++ ))
do
  # stuff here
done
```
  * This means that we start a counter at 0 (`counter=0`). Each time we go through the loop, we advance the counter by 1 (`counter++`). The loops continue as long as the counter is less than the length of the array called **samples1** (`counter < ${#samples1[@]}`). When the counter hits the length of the sample1 array, the loops stop. You can notice by looking up in the script, that **samples1** is an array that lists all the forward fastq files in our metadatafile (SRR#####\_1.fastq). 
  * **Exercise:** Turn off the fastp commands within this file and instead just explore the loop. 
  * Let's comment out the following sections of code by putting # signs in front of each line. This will turn them off.
  
```bash
    ## Make output directories
#    mkdir -p $outputdir"01_fastp/"$samplename
    
    ## execute fastp
#    cmd1="fastp -i $inputdir/$sample1 \
#-I $inputdir/$sample2 \
#-o ${outputdir}01_fastp/${samplename}/${samplename}_trim_1.fastq \
#-O ${outputdir}01_fastp/${samplename}/${samplename}_trim_2.fastq \
#-h ${outputdir}01_fastp/${samplename}/${samplename}_report.html \
#-j ${outputdir}01_fastp/${samplename}/${samplename}_report.json \
#--detect_adapter_for_pe \
#--thread $pthread \
#-x -g "
#    
#    echo -e "\t$ ${cmd1}"
#    time eval $cmd1
```
  * Let's use echo statements to see what the value of each variable is. Where it says ENTER ECHO STATEMENTS HERE, put the following echo statements:
  
```bash
    ## Echo statements
    
            ##### ENTER ECHO STATEMENTS HERE #####
    echo -e "The counter is currently $counter"
    echo -e "The samplename is currently $samplename"
    echo -e "Sample1 is currently $sample1"
    echo -e "Sample2 is currently $sample2 \n"
```  
  * Observe how the loop operated. 
  
  * **Exercise**: Turn everything back how it was. Un-comment the lines of code you commented. Remove the echo statements you added. 
  
----
## The Execute script 

The **execute_RNAseq_pipeline.sbatch** script will be used to submit the analyze script to the **job batch manager** called **SLURM**. This will put your analyze script in the queue and specify how it should be run on the supercomputer system.

For more background on SLURM:
  * [JOB SUBMISSIONS ON SUMMIT](https://curc.readthedocs.io/en/latest/running-jobs/batch-jobs.html)
  * [SLURM ON SUMMIT - FAQ](https://curc.readthedocs.io/en/latest/faq.html)
  * [SLURM DOCUMENTATION](https://slurm.schedmd.com/sbatch.html)

To execute the bash script, we will do the following...

```bash
$ sbatch execute_RNAseq_pipeline.sbatch
```

By doing this, the **execute** script will submit the **analyzer** script to **SLURM**. This will ensure the **analyzer** script is run at the proper time and with the requested resources on compute nodes on the SUMMIT system. What is SLURM? Slurm is a job scheduling system for large and small Linux clusters. It puts your job into a 'queue'. When the resources you have requested are available, your job will begin. SLURM is organized so that different users have different levels of priority in the queue. On SUMMIT, users who use fewer resources have higher priority. Power users have less priority and are encouraged to purchase greater access to the system if it is a problem.

Let's open **execute_RNAseq_pipeline.sbatch** in an editor window and explore how it works. 

**Exercise - modify the execute script**
  * Open **execute_RNAseq_pipeline.sbatch** in an editor window
  * It should look like the script below.
  * Tailor the sbatch preamble to fit your preferences:
      * **ntasks** - pick the number of ntasks to use. Try things around 4 or 6 to start out.
      * **mail-type** and **mail-user** - decide whether you want SLURM to email you when your job is done. If so, keep these lines of code and enter your proper e-mail. If not, delete them.
  * Tailor the **bash** command to fit your preferences:
     * Modify <metadatafile> to include the path and filename of your metadata file.
     * **DON'T CHANGE $SLURM TASKS. It will automatically populate whatever you put in --ntasks=# above.
  
```bash
#!/usr/bin/env bash

#SBATCH --job-name=RNAseq_pipeline 
#SBATCH --nodes=1                        # this script is designed to run on one node
#SBATCH --ntasks=<number of threads>     # modify this number to reflect how many cores you want to use (up to 24)
#SBATCH --partition=shas-testing         # modify this to reflect which queue you want to use. Either 'shas' or 'shas-testing'
#SBATCH --qos=testing                     # modify this to reflect which queue you want to use. Options are 'normal' and 'testing'
#SBATCH --mail-type=END                  # Keep these two lines of code if you want an e-mail sent to you when it is complete.
#SBATCH --mail-user=<eID@colostate.edu>  # add your e-mail here
#SBATCH --output=log_RNAseq_pipe_%j.txt  # this will capture all output in a logfile with %j as the job #

######### Instructions ###########

# Modify your SLURM entries above to fit your choices
# Below, modify the SECOND argument to point to YOUR metadata.file
# Below, you don't need to change $SLURM_NTASKS. It will automatically populate whatever you put in --ntasks=# above.

## execute the RNA-seq_pipeline
bash RNAseq_analyzer_201119.sh <metadatafile> $SLURM_NTASKS
```

**Exercise - Run the execute script**

```bash
$ sbatch execute_RNAseq_pipeline.sbatch

$ squeue -u $USER     # Check on your running scripts. Note! One will be JupyterHub and the other will be your job submission


# Other useful SLURM Commands
$ squeue -u $USER --start #When is my job projected to start?
$ sstat -j <your_job-id>   # Information about your job
$ sstat --format=JobID,NTasks,MaxRSS --j <your_job_id>      # Get select information on memory usage and other stats from ssstat
$ scancel <your_job-id> # Cancel your job

# Other ways to check on your job
  # Check your readfile with more or tail
  # Check your output directories
```

  * See [More info on useful SLURM Commands](https://curc.readthedocs.io/en/latest/running-jobs/slurm-commands.html)
  
**About github**

  * github is a great place to store your code and share projects with collaborators. 
  * [My Favorite short github tutorial](https://rogerdudler.github.io/git-guide/)
  
  
# December 3, 2020 - Automation Revisited 

Today we will continue to add on to the automation pipeline we started a few weeks ago.

I have added some scripts into this repository that you can use for the Gomez-Orte dataset. You can also use these scripts for your Final Project. Let's update the scripts we have:

  * Navigate to your `PROJ01_GomezOrte/02_scripts directory`
  * Navigate inside the folder `2020_DSCI512_RNAseq`
  
```bash
$ pwd
~/PROJ01_GomezOrte/02_scripts
$ cd 2020_DSCI512_RNAseq
```

  * Now you are in the github sync'd directory we initiated last time (see instructions above).
  * To update this directory and obtain new scripts, **pull** from the github repository like so..
  
```bash
$ git pull
```





