#!/bin/bash -e
#SBATCH --job-name=diamond
#SBATCH --time=7-00:00:00      
#SBATCH --output=/work/clh162/Data+/Sophie/2025-2026-team-code-sac165/Data+_team/Sophie/diamond.out
#SBATCH --error=/work/clh162/Data+/Sophie/2025-2026-team-code-sac165/Data+_team/Sophie/diamond.err
#SBATCH --partition=common
#SBATCH --nodes=1
#SBATCH --cpus-per-task=8       
#SBATCH --mem=16G               
#SBATCH --mail-type=ALL
#SBATCH --mail-user=sophie.chi@duke.edu

# activate conda environment
source /hpc/home/sac165/miniconda3/etc/profile.d/conda.sh
conda activate rnaseq

# set paths 
OLD_GENOME=/work/clh162/OysterRNA24/DEG_analysis/GO/Cvi_RU17_ncbi_dataset/data/GCF_002022765.2/protein.faa
BINARY_DIAMOND_DATABASE=/work/clh162/Data+/Sophie/2025-2026-team-code-sac165/Data+_team/Sophie/old_genome_reference.dmnd
NEW_GENOME=/work/clh162/OysterRNA24/hisat2_align/Cv_genome_RU_2025_shared/Cvi_RU25.pep
DIAMOND_OUTPUT=/work/clh162/Data+/Sophie/2025-2026-team-code-sac165/Data+_team/Sophie/diamond_result_matches.tsv

# create a diamond-formatted database file (.dmnd)
diamond makedb --in $OLD_GENOME -d $BINARY_DIAMOND_DATABASE

# run a search in blastp mode
diamond blastp -d $BINARY_DIAMOND_DATABASE -q $NEW_GENOME -o $DIAMOND_OUTPUT --evalue 1e-10 --max-target-seqs 1 --ultra-sensitive --outfmt 6

# deactivate conda environment
conda deactivate
