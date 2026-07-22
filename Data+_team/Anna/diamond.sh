#!/bin/bash -e

#SBATCH --job-name=diamond_oyster
#SBATCH --time=1-00:00:00
#SBATCH -o diamond.out
#SBATCH -e diamond.err
#SBATCH --partition=common
#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G

#Email update setup
#SBATCH --mail-type=ALL #auto-send email on all updates
#SBATCH --mail-user=az199@duke.edu

#Load Diamond after Installations
source /hpc/home/az199/miniconda3/etc/profile.d/conda.sh
conda activate rna_seq

#Set paths
old_genome="/work/clh162/OysterRNA24/DEG_analysis/GO/Cvi_RU17_ncbi_dataset/data/GCF_002022765.2/protein.faa"
new_genome="/work/clh162/OysterRNA24/hisat2_align/Cv_genome_RU_2025_shared/Cvi_RU25.pep"
database="/work/clh162/Data+/Anna/2025-2026-team-code-az199/Data+_team/Anna/ru17_database"
diamond_out="/work/clh162/Data+/Anna/2025-2026-team-code-az199/Data+_team/Anna/diamond_results.txt"

# Create diamond-formatted database file
diamond makedb --in $old_genome -d $database

#Running a search 
diamond blastp \
    -d $database \
    -q $new_genome \
    -o $diamond_out \
    --evalue 1e-10 \
    --max-target-seqs 1 \
    --ultra-sensitive \
    --outfmt 6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore

conda deactivate