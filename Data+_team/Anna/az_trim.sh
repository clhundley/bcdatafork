#!/bin/bash -e

##Given job descriptions/parameters
#SBATCH --job-name=az_trimmed_out
#SBATCH --mem=16G
#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --time=7-00:00:00
#SBATCH --array=0-17 #read the 18 files at the same time

#SBATCH -o aztrimraw-%a.out #saves output to this file, replace %a w/ unique array ID
#SBATCH -e aztrimraw-%a.err #saves error to the file, replace %a w/ unique array ID

#SBATCH --mail-type=ALL #auto-send email on all updates
#SBATCH --mail-user=az199@duke.edu

#Load environment/modules
source /hpc/home/az199/miniconda3/etc/profile.d/conda.sh
conda activate rna_seq

#Establish paths
raw_input="/work/clh162/OysterRNA24/rawreads"
trim_out="/work/clh162/Data+/Anna/2025-2026-team-code-az199/Data+_team/Anna/trim_results"

#Create folders
mkdir -p $trim_out

##Decipher raw inputs and paths for each read sample
#1. generates rsamples from the rawreads for R1, read, pipe, strip away suffix
#2. define the index for each rsample in the array through job passing
#3. define R1 and R2 for te sample
rsamples=($(ls ${raw_input}/*_R1_001.fastq.gz | sed 's/_R1_001.fastq.gz//' | xargs -n 1 basename))
rsample=${rsamples[$SLURM_ARRAY_TASK_ID]}
r1=${raw_input}/${rsample}_R1_001.fastq.gz
r2=${raw_input}/${rsample}_R2_001.fastq.gz

#Trim-galore instructions
trim_galore \
    --paired ${r1} ${r2} \
    --quality 30 \
    --output_dir $trim_out

#Print completion statement
echo "Trimming Completed for ${rsample}"

conda deactivate 