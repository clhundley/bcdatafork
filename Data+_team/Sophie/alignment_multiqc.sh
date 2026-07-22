#!/bin/bash -e
#SBATCH --job-name=alignment_multiqc
#SBATCH --time=7-00:00:00      
#SBATCH --output=/work/clh162/Data+/Sophie/2025-2026-team-code-sac165/Data+_team/Sophie/alignment_multiqc_%A_%a.out
#SBATCH --error=/work/clh162/Data+/Sophie/2025-2026-team-code-sac165/Data+_team/Sophie/alignment_multiqc_%A_%a.err
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
ALIGNMENT_OUTPUT=/work/clh162/Data+/Sophie/2025-2026-team-code-sac165/Data+_team/Sophie/alignment_results
ALIGNMENT_MULTIQC=/work/clh162/Data+/Sophie/2025-2026-team-code-sac165/Data+_team/Sophie/alignment_multiqc

# make folder for alignment multiqc output
mkdir -p $ALIGNMENT_MULTIQC

# run multiqc on alignment data
multiqc $ALIGNMENT_OUTPUT -o $ALIGNMENT_MULTIQC

echo "Alignment Multiqc complete"

# deactivate conda environment
conda deactivate