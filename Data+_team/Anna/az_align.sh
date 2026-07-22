#!/bin/bash -e

##Given job descriptions/parameters
#SBATCH --job-name=az_align_out
#SBATCH --mem=32G
#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --time=7-00:00:00
#SBATCH --array=0-17 #read the 18 files at the same time

#SBATCH -o az_align-%a.out #saves output to this file, replace %a w/ unique array ID
#SBATCH -e az_align-%a.err #saves error to the file, replace %a w/ unique array ID

#SBATCH --mail-type=ALL #auto-send email on all updates
#SBATCH --mail-user=az199@duke.edu

source /etc/profile.d/modules.sh 

#Load modules
module load HISAT2
module load samtools

#Establish paths
raw_input="/work/clh162/OysterRNA24/rawreads"
trim_out="/work/clh162/Data+/Anna/2025-2026-team-code-az199/Data+_team/Anna/trim_results"
index_out="/work/clh162/Data+/Anna/2025-2026-team-code-az199/Data+_team/Anna/align_results"
reference="/work/clh162/OysterRNA24/hisat2_align/Cv_genome_RU_2025_shared/Cvi_RU25_genome.fa"
sam_dir="/work/clh162/Data+/Anna/2025-2026-team-code-az199/Data+_team/Anna/sam_results"
bam_dir="/work/clh162/Data+/Anna/2025-2026-team-code-az199/Data+_team/Anna/bam_results"

#Create directory
mkdir -p $index_out
mkdir -p $sam_dir
mkdir -p $bam_dir

#Building index
hisat2-build ${reference} ${index_out}/Cvi_indexed

##Decipher raw inputs and paths for each read sample
#1. generates rsamples from the rawreads for R1, read, pipe, strip away suffix
#2. define the index for each rsample in the array through job passing
#3. define R1 and R2 for the sample
rsamples=($(ls ${trim_out}/*_R1_001_val_1.fq.gz | sed 's/_R1_001_val_1.fq.gz//' | xargs -n 1 basename))
rsample=${rsamples[$SLURM_ARRAY_TASK_ID]}
r1_trim=${trim_out}/${rsample}_R1_001_val_1.fq.gz
r2_trim=${trim_out}/${rsample}_R2_001_val_2.fq.gz

##Perform alignment (details can be found on NIH Lesson 9 website)
#1. Allow 8 CPU cores to run this task simultaneously
#2. -x for enter the path to indexed reference genome
#3. -1 prompts for r1
#4. -2 prompts for r2
#5. -s prompts the output SAM file path
#6. --summary-file 
#7. convert sam to bam through sorting, use 8 additional CPUs to run this
hisat2 -p 8 \
    -x ${index_out}/Cvi_indexed \
    -1 ${r1_trim} \
    -2 ${r2_trim} \
    --summary-file ${sam_dir}/${rsample}summary.txt \
| samtools view -bS - \
| samtools sort -@ 8 -o ${bam_dir}/${rsample}_sorted.bam

#Completion print statement
echo "Hisat2 alignment completed for samples: ${rsample}"