#!/bin/bash -e

##Given job descriptions/parameters
#SBATCH --job-name=az_fastqc_trimmed_out
#SBATCH --mem=16G
#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --time=7-00:00:00
#SBATCH --array=0-17 #read the 18 files at the same time

#SBATCH -o azfastqctrim-%a.out #saves output to this file, replace %a w/ unique array ID
#SBATCH -e azfastqctrim-%a.err #saves error to the file, replace %a w/ unique array ID

#SBATCH --mail-type=ALL #auto-send email on all updates
#SBATCH --mail-user=az199@duke.edu

#Load modules
module load FastQC

#Establish paths
trim_in="/work/clh162/Data+/Anna/2025-2026-team-code-az199/Data+_team/Anna/trim_results"
fastqc_trim_dir="/work/clh162/Data+/Anna/2025-2026-team-code-az199/Data+_team/Anna/fastqc_trim_results"

#Create folders
mkdir -p $fastqc_trim_dir

##Decipher raw inputs and paths for each read sample
#1. generates rsamples from the rawreads for R1, read, pipe, strip away suffix
#2. define the index for each rsample in the array through job passing
#3. define R1 and R2 for the sample
rsamples=($(ls ${trim_in}/*_val_1.fq.gz | sed 's/_val_1.fq.gz//' | xargs -n 1 basename))
rsample=${rsamples[$SLURM_ARRAY_TASK_ID]}
r1=${trim_in}/${rsample}_val_1.fq.gz
r2=${trim_in}/${rsample}_val_2.fq.gz

#Run data on the raw samples, output path, -t (threads)
fastqc -o ${fastqc_trim_dir} -t ${SLURM_CPUS_PER_TASK} ${r1} ${r2}

#Print completion ticket
echo "FastQC Completed for trimmed sample: ${rsample}"