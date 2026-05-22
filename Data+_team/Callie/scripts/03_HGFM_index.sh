#!/bin/bash -e
#SBATCH --job-name=hisat2_HGFM_index
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
GFF=/work/clh162/OysterRNA24/hisat2_align/Cvi_RU25.gff3
INDEX_DIR=/work/clh162/OysterRNA24/hisat2_align/Cv_genome_RU_2025_shared/hisat2_index
mkdir -p ${INDEX_DIR}

## Create a GFT file from the GFF file ##

#GFT=/work/clh162/OysterRNA24/hisat2_align/Cvi_RU25.gft


## Create HGFM (Hierarchical Graph FM) index ## 
    # Compared to a HFM (Hierarchical FM) index which aligns reads to a single reference genome, 
    # a HGFM incorporates known genetic variation (like SNPs) along with the reference genome to assist in higher accuracy alignment.
    # HGFMs are best used with RNA-seq analysis work 
# First, extract splice sites (location where intron + exon meet) 
hisat2_extract_splice_sites.py ${GTF} > ${INDEX_DIR}/c.virginica_splice_sites.txt

# Next, extract exons 
hisat2_extract_exons.py ${GTF} > ${INDEX_DIR}/c.virginica_exons.txt

# Finally, compile index 
hisat2-build \
    -p ${SLURM_CPUS_PER_TASK} \
    -ss ${INDEX_DIR}/c.virginica_splice_sites.txt \
    -exon ${INDEX_DIR}/c.virginica_exons.txt \
    ${GENOME} ${INDEX_DIR}/c.virginica_HGFM_index 