#!/bin/bash -e
#SBATCH --job-name=fastqc_data
#SBATCH --array=0-17            
#SBATCH --time=7-00:00:00
#SBATCH --output=/work/clh162/Data+/Sophie/2025-2026-team-code-sac165/Data+_team/Sophie/fastqc_%A_%a.out
#SBATCH --error=/work/clh162/Data+/Sophie/2025-2026-team-code-sac165/Data+_team/Sophie/fastqc_%A_%a.err
#SBATCH --partition=common
#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=16G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=sophie.chi@duke.edu

# load fastqc
module load FastQC

# set paths
RAW_DIR=/work/clh162/OysterRNA24/rawreads
FASTQC_OUTPUT_DIR=/work/clh162/Data+/Sophie/2025-2026-team-code-sac165/Data+_team/Sophie/fastqc_data

# make folder for fastqc files
mkdir -p $FASTQC_OUTPUT_DIR

# make array of sample names
SAMPLE_NAMES=($(basename -a $RAW_DIR/*_R1_001.fastq.gz | sed 's/_R1_001.fastq.gz//'))

# index to get an individual sample name from the array of sample names
SAMPLE=${SAMPLE_NAMES[$SLURM_ARRAY_TASK_ID]}

# get both reads for each sample
READ1=${RAW_DIR}/${SAMPLE}_R1_001.fastq.gz
READ2=${RAW_DIR}/${SAMPLE}_R2_001.fastq.gz

# run fastqc on the raw reads and put them in the output folder
echo "Running FastQC for sample: $SAMPLE"

fastqc -o $FASTQC_OUTPUT_DIR -t $SLURM_CPUS_PER_TASK $READ1 $READ2

echo "FastQC complete for sample: $SAMPLE"
