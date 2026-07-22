#!/bin/bash -e
#SBATCH --job-name=trimmed_fastqc
#SBATCH --time=7-00:00:00
#SBATCH --array=0-17
#SBATCH --output=/work/clh162/Data+/Sophie/2025-2026-team-code-sac165/Data+_team/Sophie/trimmed_fastqc_%A_%a.out
#SBATCH --error=/work/clh162/Data+/Sophie/2025-2026-team-code-sac165/Data+_team/Sophie/trimmed_fastqc_%A_%a.err
#SBATCH --partition=common
#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=16G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=sophie.chi@duke.edu

# load fastqc
module load FastQC

# set paths
TRIMMED_DIR=/work/clh162/Data+/Sophie/2025-2026-team-code-sac165/Data+_team/Sophie/trimmed_reads
TRIMMED_FASTQC_DIR=/work/clh162/Data+/Sophie/2025-2026-team-code-sac165/Data+_team/Sophie/trimmed_fastqc

# make folder for trimmed fastqc data
mkdir -p $TRIMMED_FASTQC_DIR

# make array of sample names; val_1.fq.gz is added because of output from trim galore
SAMPLE_NAMES=($(basename -a $TRIMMED_DIR/*_R1_001_val_1.fq.gz | sed 's/_R1_001_val_1.fq.gz//'))

# index to get individual sample name from array of sample names
SAMPLE=${SAMPLE_NAMES[$SLURM_ARRAY_TASK_ID]}

# get both reads for each sample
READ1_TRIM=${TRIMMED_DIR}/${SAMPLE}_R1_001_val_1.fq.gz
READ2_TRIM=${TRIMMED_DIR}/${SAMPLE}_R2_001_val_2.fq.gz

# run fastqc on the trimmed reads 
echo "Running FastQC for sample: $SAMPLE"

fastqc -o $TRIMMED_FASTQC_DIR -t $SLURM_CPUS_PER_TASK $READ1_TRIM $READ2_TRIM

echo "FastQC complete for sample: $SAMPLE"