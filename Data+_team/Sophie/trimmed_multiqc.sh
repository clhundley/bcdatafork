#!/bin/bash -e
#SBATCH --job-name=trimmed_multiqc
#SBATCH --time=7-00:00:00
#SBATCH --output=/work/clh162/Data+/Sophie/2025-2026-team-code-sac165/Data+_team/Sophie/trimmed_multiqc_%A_%a.out
#SBATCH --error=/work/clh162/Data+/Sophie/2025-2026-team-code-sac165/Data+_team/Sophie/trimmed_multiqc_%A_%a.err
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
TRIMMED_FASTQC_DIR=/work/clh162/Data+/Sophie/2025-2026-team-code-sac165/Data+_team/Sophie/trimmed_fastqc
TRIMMED_MULTIQC=/work/clh162/Data+/Sophie/2025-2026-team-code-sac165/Data+_team/Sophie/trimmed_multiqc

# make folder for multiqc data
mkdir -p $TRIMMED_MULTIQC

# run multiqc on trimmed reads
multiqc $TRIMMED_FASTQC_DIR -o $TRIMMED_MULTIQC

echo "MultiQC complete"

# deactivate conda environment
conda deactivate