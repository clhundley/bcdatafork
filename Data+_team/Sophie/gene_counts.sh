#!/bin/bash -e
#SBATCH --job-name=gene_counts
#SBATCH --time=7-00:00:00
#SBATCH --output=/work/clh162/Data+/Sophie/2025-2026-team-code-sac165/Data+_team/Sophie/gene_counts_%j.out
#SBATCH --error=/work/clh162/Data+/Sophie/2025-2026-team-code-sac165/Data+_team/Sophie/gene_counts_%j.err
#SBATCH --partition=common
#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=16G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=sophie.chi@duke.edu

# load subread module
module load Subread

# set paths
ALIGNMENT_OUTPUT=/work/clh162/Data+/Sophie/2025-2026-team-code-sac165/Data+_team/Sophie/alignment_results
COUNTS_OUTPUT=/work/clh162/Data+/Sophie/2025-2026-team-code-sac165/Data+_team/Sophie/gene_counts
GENOME_ANNOTATION=/work/clh162/OysterRNA24/hisat2_align/Cv_genome_RU_2025_shared/Cvi_RU25.gtf

# make folder for gene counts output
mkdir -p $COUNTS_OUTPUT

# run featurecounts on alignment data - are we looking for gene_id or gene_name??
featureCounts -T $SLURM_CPUS_PER_TASK -p --countReadPairs -t exon -a $GENOME_ANNOTATION -g gene_id -o $COUNTS_OUTPUT/gene_counts.txt $ALIGNMENT_OUTPUT/*.bam

# convert txt file to csv
tr '\t' ',' < $COUNTS_OUTPUT/gene_counts.txt > $COUNTS_OUTPUT/gene_counts.csv