# 2020_DSCI512_RNAseq
DSCI512 - RNA sequencing data analysis - course scripts

A simple set of wrappers and tools for RNA-seq analysis. These tools were designed for the DSCI512 RNA-seq analysis class at Colorado State University

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

Let's briefly peek into it and see that it contains

  * A shebang
  * A long comment section with documentation on its use
  * MODIFY THIS SECTION - *you will tailor this section to each job*
  * BEGIN CODE - *the code starts and reports how it is running*
  * META DATA - *this part pulls information out of the metadata file to create bash arrays*
  * PIPELINE - *right now this contains a for loop that will execute fastp. We will add onto this section each class*
  * VERSIONS - *this prints out the versions of software used for your future methods section*

**Exercise - explore the analyzer**
  * Open RNAseq_analyzer_201119.sh in an editor window
  * In MODIFY THIS SECTION, tailor your RNAseq_analyzer_201119.sh to suit your own input directory
    * Change `inputdir=<yourinputdir>` to `inputdir="../01_input''` (should match your actual input directory)
    * Eventually we will modify most things in this section but for now, just change that one thing.
  * Type `exit` on line 133 right before `# FASTP to remove unwanted sequences`. This will short circuit the script and ask it to simply run the code above `exit`
  * Run the code with the following command line:
 
 ```bash
#USAGE:
#     bash RNAseq_analyzer_201119.sh <metadataPathAndFile> <pthreads>

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
  * This means that we start a counter at 0 (`counter=0`), each time we go through the loop, we advance the counter by 1 (`counter++`), and the loop continues as long as the counter is less than the length of the array called **samples1**. You can notice by looking up in the script, that **samples1** is an array that lists all the forward fastq files in our metadatafile (SRR#####\_1.fastq). 
  * Exercise: Let's turn off the fastp commands within this file and instead just explore the loop. 
  * Put # signs in front of the following lines of code:
  
```bash
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
  * Just above that section, where it says ENTER ECHO STATEMENTS HERE, put the following echo statements:

```bash
    ## Echo statements
    
            ##### ENTER ECHO STATEMENTS HERE #####
    echo -e "The counter is currently $counter"
    echo -e "The samplename is currently $samplename"
    echo -e "Sample1 is currently $sample1"
    echo -e "Sample2 is currently $sample2"
```  
  
The **execute** script will be used to submit the analyze script to the job sharing utility on SUMMIT called SLURM. This will put your analyze script in the queue and specify how it should be run on the supercomputer system.

To execute the bash script, you would do the following...

```bash
$ sbatch execute_RNAseq_pipeline.sbatch
```

By doing this, the `execute` script will start the `analyze` script by calling the following lines of code:

```bash

## execute the RNA-seq_pipeline
bash RNAseq_analyzer_201119.sh ../01_input/metadata_gomezOrte_subset.txt $SLURM_NTASKS
```

**Usage:** `bash RNAseq_analyzer_201119.sh <metadatafile.txt> <number of threads>`
   *  Make sure the metadata filename and path is correct
   *  $SLURM_NTASKS automatically pulls the number of threads you have requested in the #SBATCH header.

**Exercise**
  * Open execute_RNAseq_pipeline.sbatch in an editor window
  * Tailor your execute_RNAseq_pipeline.sbatch script to suit your own inputs
  * Check the sbatch preamble to make sure everything appears to be working correctly
  * Include the proper path to your metadata file
