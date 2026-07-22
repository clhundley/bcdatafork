#!/bin/bash -e
#SBATCH --job-name=alignment_results
#SBATCH --time=7-00:00:00
#SBATCH --array=0-17
#SBATCH --output=/work/clh162/Data+/Sophie/2025-2026-team-code-sac165/Data+_team/Sophie/alignment_%A_%a.out
#SBATCH --error=/work/clh162/Data+/Sophie/2025-2026-team-code-sac165/Data+_team/Sophie/alignment_%A_%a.err
#SBATCH --partition=common
#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=sophie.chi@duke.edu

# load hisat2
module load HISAT2

# load samtools
module load samtools

# set paths
TRIMMED_DIR=/work/clh162/Data+/Sophie/2025-2026-team-code-sac165/Data+_team/Sophie/trimmed_reads
INDEX_DIR=/work/clh162/OysterRNA24/hisat2_align/Cv_genome_RU_2025_shared/hisat2_index/c.virginica_HFM_index
ALIGNMENT_OUTPUT=/work/clh162/Data+/Sophie/2025-2026-team-code-sac165/Data+_team/Sophie/alignment_results

# make folder for alignment results
mkdir -p $ALIGNMENT_OUTPUT

# make array of sample names; val_1.fq.gz is added because of output from trim galore
SAMPLE_NAMES=($(basename -a $TRIMMED_DIR/*_R1_001_val_1.fq.gz | sed 's/_R1_001_val_1.fq.gz//'))

# index to get individual sample name from array of sample names
SAMPLE=${SAMPLE_NAMES[$SLURM_ARRAY_TASK_ID]}

# get both reads for each sample
READ1=${TRIMMED_DIR}/${SAMPLE}_R1_001_val_1.fq.gz
READ2=${TRIMMED_DIR}/${SAMPLE}_R2_001_val_2.fq.gz

# run hisat2 on trimmed reads
echo "Running HISAT2 for sample: $SAMPLE"

hisat2 -p $SLURM_CPUS_PER_TASK -x $INDEX_DIR -1 $READ1 -2 $READ2 -S ${ALIGNMENT_OUTPUT}/${SAMPLE}.sam --summary-file ${ALIGNMENT_OUTPUT}/${SAMPLE}_summary.txt

echo "HISAT2 complete for sample: $SAMPLE"

# convert sam file to bam file and sort
samtools view -b ${ALIGNMENT_OUTPUT}/${SAMPLE}.sam | samtools sort -o ${ALIGNMENT_OUTPUT}/${SAMPLE}_sorted.bam
