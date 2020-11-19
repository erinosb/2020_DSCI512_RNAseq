#!/usr/bin/env bash

################################################
# PROGRAM:
# RNAseq_analyzer_201119.sh
#
# DESCRIPTION:
# This is a very basic RNA-seq pipeline that I use for analyzing fastq reads. Step1 is a
# simple wrapper that performs quality control, genome alignment, basic format
# conversions, and htseq-count tabulation for paired-end RNA-seq samples using a specified
# genome. Step2 is a clean up program that removes unnecessary files and compresses files
# to save space.
#
# AUTHOR:
# <yournamehere>
#
# START DATE:
# November, 19, 2020
#
# DEPENDENCIES:
# 	Requires the installation of the follwing software: 
#		fastp
#		hisat2
#		featureCounts
#		samtools
#		deep-tools
#
# 	Requires access to the Nishimura Lab installed software sources on SUMMIT.
#
# REQUIRES:
#    INPUT: .fastq files.    For each sample, paired forward and reverse sequencing files
#								are required. These should be placed in an input
#								directory.
#
#    INPUT: _metadata.txt file: A metadata file with two columns. The first two columns
#								are fastq file names. The third column is a "nickname"
#								of each sample. Later columns can be included with other
#								metadata information. Metadata file should be placed
#								within the inputdir directory.
#
#
#    HISAT2 INDEXES: .ht2 files for the genome. These are produced using hisat2-build. For
#								instructions see
#	           https://ccb.jhu.edu/software/hisat2/manual.shtml#the-hisat2-build-indexer
#
#    GENOME SEQUENCE: .fa  or .tar.gz file for the genome. This is the sequence of the 
#                                genome.
#
#    GENOME ANNOTATION: .gtf file for the genome. This is a genome annotation file of gene
#								features. Version and coordinates must match the genome
#								sequence (.fa above).
#
# USAGE:
# $ bash RNAseq_analyzer_201119.sh <metadata.txt> <number of threads>
#
# OUTPUT:
#
# KNOWN BUGS:
#
# THINGS TO IMPROVE:
#
################################################


####### MODIFY THIS SECTION #############

#The input samples live in directory:
inputdir="<yourinputdir>"

#Metadata file. This pulls the metadata path and file from the command line
metadata=$1

#This is where the ht2 files live:
hisat2path="<hisatpath/previx>"

#This is where the genome sequence lives:
genomefa="<genome.fa>"

#This is where the gtf file lives:
gtffile="<annotation.gtf>"

#This is the output_directory:
DATE=`date +%Y-%m-%d`
#OR
#DATE='2018-10-16'
outputdir="../03_output/"$DATE"_output/"


########## DONE MODIFYING ###############



########## BEGIN CODE ###############

echo -e ">>> INITIATING analyzer with command:\n\t$0 $@"

#Number of threads to use:
# Note - this imports the number of threads (ntasks) given in the command line
pthread=$2

# Make output directories
echo -e ">>> MAKING output directory"
echo -e "\tmkdir $outputdir"
mkdir -p $outputdir



####### META DATA #############

#These are the sample names, R1:
samples1=( $(cut -f 1 --output-delimiter=' ' $metadata) )

#These are the sample names, R2:
samples2=( $(cut -f 2 --output-delimiter=' ' $metadata) )

#These are the nicknames I want to give the files:
names=( $(cut -f 3 --output-delimiter=' ' $metadata) )



####### PIPELINE ##############

# Report back to the user which files will be processed and which names they'll be given:
echo -e ">>> INPUT: This script will process files from the metafile:\n\t$metadata"
echo -e ">>> PLAN: This script will process the sample files into the following names: "
echo -e "\tSAMPLE1\tSAMPLE2\tNAMES"

for (( counter=0; counter < ${#samples1[@]}; counter++ ))
do
    echo -e "\t${samples1[$counter]}\t${samples2[$counter]}\t${names[$counter]}"
done


# FASTP to remove unwanted sequences
# FASTP to determine quality
echo -e "\n>>> FASTP: Trimming excess and low-quality sequences from .fastq file; generating quality report"
mkdir -p $outputdir"01_fastp"

for (( counter=0; counter < ${#samples1[@]}; counter++ ))
do
    samplename=${names[$counter]}
    sample1=${samples1[$counter]}
    sample2=${samples2[$counter]}
    nickname=$names[$counter]}

    ## Echo statements
    
            ##### ENTER ECHO STATEMENTS HERE #####
    
    ## Make output directories
    mkdir -p $outputdir"01_fastp/"$samplename
    
    ## execute fastp
    cmd1="fastp -i $inputdir/$sample1 \
-I $inputdir/$sample2 \
-o ${outputdir}01_fastp/${samplename}/${samplename}_trim_1.fastq \
-O ${outputdir}01_fastp/${samplename}/${samplename}_trim_2.fastq \
-h ${outputdir}01_fastp/${samplename}/${nickname}_report.html \
-j ${outputdir}01_fastp/${samplename}/${nickname}_report.json \
--detect_adapter_for_pe \
--thread $pthread \
-x -g "
    
    echo -e "\t$ ${cmd1}"
    time eval $cmd1

done




######## VERSIONS #############
echo -e "\n>>> VERSIONS:"
echo -e "\n>>> FASTP VERSION:"
$fastp --version
echo -e "\n>>> HISAT2 VERSION:"
$hisat2 --version
echo -e "\n>>> SAMTOOLS VERSION:"
$samtools --version
echo -e "\n>>> FEATURECOUNTS VERSION:"
$featureCounts -v
echo -e "\n>>> BAMCOVERAGE VERSION:"
$bamCoverage --version
echo -e ">>> END: Analayzer complete."
