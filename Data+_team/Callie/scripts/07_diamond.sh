#!/bin/bash -e
#SBATCH --job-name=diamond_Cvi3.0_to_Cvi_RU25
#SBATCH --time=1-00:00:00
#SBATCH --output=/work/clh162/OysterRNA24/logs/diamond_Cvi_Yale25_to_Cvi_RU25_%A.out
#SBATCH --error=/work/clh162/OysterRNA24/logs/diamond_Cvi_Yale25_to_Cvi_RU25_%A.err
#SBATCH --partition=common
#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=callie.hundley@duke.edu

## Activate conda environment (RNA-seq) with diamond program loaded ##
source /hpc/home/clh162/miniconda3/etc/profile.d/conda.sh
conda activate RNA-seq

## Set paths ##
OLD_PROTEOME=/work/clh162/OysterRNA24/DEG_analysis/GO/Cvi_RU17_ncbi_dataset/data/GCF_002022765.2/protein.faa
NEW_PROTEOME=/work/clh162/OysterRNA24/hisat2_align/Cv_genome_RU_2025_shared/Cvi_RU25.pep
DIR_OUT=/work/clh162/OysterRNA24/DEG_analysis/GO/diamond/

## Make path directory ##
mkdir -p ${DIR_OUT}

## Create diamond index using new proteome to blast against the old proteome ##
diamond makedb \
    --in ${OLD_PROTEOME} \
    -d ${DIR_OUT}/Cvi_Yale25_db

## Run diamond blastp ## 
diamond blastp \
    -q ${NEW_PROTEOME} \
    --db ${DIR_OUT}/Cvi_Yale25_db.dmnd \
    -out ${DIR_OUT}/old_to_new_diamond.tsv \
    --evalue 1e-10 \
    --max-target-seqs 1 \
    --ultra-sensitive \
    --outfmt 6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore