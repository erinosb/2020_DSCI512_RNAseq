# 2020_DSCI512_RNAseq
DSCI512 - RNA sequencing data analysis - course scripts

A simple set of wrappers and tools for RNA-seq analysis. These tools were designed for the DSCI512 RNA-seq analysis class at Colorado State University

Below is a tutorial on the use of these scripts:
----


## Let's download the script templates I've written on github.

We will build on these scripts each session.
You will be able to tailor these templates to your own purposes.


**Exercise**

  * Locate the green **clone or download** button on the top right of this page. Click it.
  * Click on the clipboard icon. This will save a github URL address to your clipboard.
  * Switch over to JupyterHub linked to SUMMIT.
  * Navigate into your folder for `PROJ01_GomezOrte/02_scripts` and use `git clone` as shown below to pull the information from github to your location on summit.
  
```bash
$ cd /scratch/summit/<eID>@colostate.edu    #Replace <eID> with your EID
$ cd PROJ01_GomezOrte
$ git clone <paste path to github repository here>
```

**Explore what you obtained.**

Let's copy the two scripts up one directory. This will create a duplicate copy for you to work on and will move the script directly into the ''02_scripts'' directory, not its sub-directory.

```bash
$ cd 2020_DSCI512_RNAseq
$ cp analyze ..
$ cp execute ..
$ cd ..
```

Notice that instead of having a single script, you now have a few scripts. These will work in a **Two step** method for executing jobs on summit. The `execute` script calls the `analyze` script.

To execute the pipeline, you would do the following:

```bash
$ sbatch execute_RNAseq_pipeline.sbatch
```

By doing this, the `execute` script will start the `analyze` script by calling the following lines of code:

```bash

## execute the RNA-seq_pipeline
bash RNAseq_analyzer_191204.sh ../../01_input/metadata_gomezOrte_subset.txt $SLURM_NTASKS
```

**Usage:** `bash RNAseq_analyzer_191204.sh <metadatafile.txt> <number of threads>`
   *  Make sure the metadata file is correct.
   *  $SLURM_NTASKS automatically pulls the number of threads you have requested in the #SBATCH header.

**Exercise**
  * Open execute_RNAseq_pipeline.sbatch in an editor window
  * Tailor your execute_RNAseq_pipeline.sbatch script to suit your own inputs
  * Check the sbatch preamble to make sure everything appears to be working correctly
  * Include the proper path to your metadata file
