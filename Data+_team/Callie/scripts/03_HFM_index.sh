#!/bin/bash -e
#SBATCH --job-name=hisat2_HFM_index
#SBATCH --time=7-00:00:00
#SBATCH --output=/work/clh162/OysterRNA24/logs/hisat2_index.out
#SBATCH --error=/work/clh162/OysterRNA24/logs/hisat2_index.err
#SBATCH --partition=common
#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=64G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=callie.hundley@duke.edu

## Load module - HISAT2 already loaded on DCC ## 
module load HISAT2

## Set Paths ## 
GENOME=/work/clh162/OysterRNA24/hisat2_align/Cv_genome_RU_2025_shared/Cvi_RU25_genome.fa
#GTF=/work/clh162/OysterRNA24/hisat2_align/c.virginica_annotation.gtf
INDEX_DIR=/work/clh162/OysterRNA24/hisat2_align/Cv_genome_RU_2025_shared/hisat2_index
mkdir -p ${INDEX_DIR}

## Create HFM (Hierarchical FM) index ## 
    # Aligns reads to a single reference genome 
hisat2-build \
    -p ${SLURM_CPUS_PER_TASK} \
    ${GENOME} ${INDEX_DIR}/c.virginica_HFM_index 