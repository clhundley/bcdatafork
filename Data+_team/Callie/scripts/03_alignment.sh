#!/bin/bash -e
#SBATCH --job-name=alignment_array
#SBATCH --time=7-00:00:00
#SBATCH --array=1-36
#SBATCH --output=/work/clh162/OysterRNA24/logs/hisat2_alignment_%A_%a.out
#SBATCH --error=/work/clh162/OysterRNA24/logs/hisat2_alignment_%A_%a.err
#SBATCH --partition=common
#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=callie.hundley@duke.edu

## Load module - HISAT2 already loaded on DCC ## 
module load HISAT2

## Set Paths ## 
TRIMMED_DIR=/work/clh162/OysterRNA24/trimmedreads
INDEX_DIR=/work/clh162/OysterRNA24/hisat2_align/Cv_genome_RU_2025_shared/hisat2_index
ALIGNED_DIR=/work/clh162/OysterRNA24/hisat2_align/alignedreads
BAM_DIR=/work/clh162/OysterRNA24/hisat2_index
mkdir -p ${ALIGNED_DIR} ${BAM_DIR}


## Set up direction/path to each sample ##
# Make list of trimmed sample names (without _R1/_R2 suffix)
SAMPLES=($(ls ${TRIMMED_DIR}/*_R1_001_val_1.fq.gz | sed 's/_R1_001_val_1.fq.gz//' | xargs -n 1 basename))

# Index an individual sample from the list for this array task
SAMPLE=${SAMPLES[$SLURM_ARRAY_TASK_ID-1]}

# Define R1 and R2 for the sample 
R1=${TRIMMED_DIR}/${SAMPLE}_R1_001_val_1.fq.gz
R2=${TRIMMED_DIR}/${SAMPLE}_R2_001_val_2.fq.gz

echo "Aligning sample: ${SAMPLE}..."
hisat2 \
    -p ${SLURM_CPUS_PER_TASK} \
    -x ${INDEX_DIR} \
    -1 ${TRIMMED_DIR}/${R1} \
    -2 ${TRIMMED_DIR}/${R2} \
    -S ${ALIGNED_DIR}/${SAMPLE}.sam 
