#!/bin/bash -e
#SBATCH --job-name=trimmed_reads
#SBATCH --time=7-00:00:00
#SBATCH --array=0-17
#SBATCH --output=/work/clh162/Data+/Sophie/2025-2026-team-code-sac165/Data+_team/Sophie/trimmed_reads_%A_%a.out
#SBATCH --error=/work/clh162/Data+/Sophie/2025-2026-team-code-sac165/Data+_team/Sophie/trimmed_reads_%A_%a.err
#SBATCH --partition=common
#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=sophie.chi@duke.edu

# activate conda environment
source /hpc/home/sac165/miniconda3/etc/profile.d/conda.sh
conda activate rnaseq

# set paths
RAW_DIR=/work/clh162/OysterRNA24/rawreads
TRIMMED_DIR=/work/clh162/Data+/Sophie/2025-2026-team-code-sac165/Data+_team/Sophie/trimmed_reads

# make folder for trimmed reads
mkdir -p $TRIMMED_DIR

# make array of sample names
SAMPLE_NAMES=($(basename -a $RAW_DIR/*_R1_001.fastq.gz | sed 's/_R1_001.fastq.gz//'))

# index to get an individual sample name from the array of sample names
SAMPLE=${SAMPLE_NAMES[$SLURM_ARRAY_TASK_ID]}

# get both reads for each sample
READ1=${RAW_DIR}/${SAMPLE}_R1_001.fastq.gz
READ2=${RAW_DIR}/${SAMPLE}_R2_001.fastq.gz

# run trim galore
echo "Running TrimGalore for sample: $SAMPLE"

trim_galore --paired $READ1 $READ2 --quality 30 --output_dir $TRIMMED_DIR

echo "TrimGalore complete for sample: $SAMPLE"

# deactivate conda environment
conda deactivate



