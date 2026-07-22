#!/bin/bash -e

##Given job descriptions/parameters
#SBATCH --job-name=az_mqc_align_out
#SBATCH --mem=16G
#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --time=01:00:00

#Saved paths
#SBATCH -o az_mqc_align-%a.out #saves output to this file, replace %a w/ unique array ID
#SBATCH -e az_mqc_align-%a.err #saves error to the file, replace %a w/ unique array ID

#Email update setup
#SBATCH --mail-type=ALL #auto-send email on all updates
#SBATCH --mail-user=az199@duke.edu


#Establish paths
sam_dir="/work/clh162/Data+/Anna/2025-2026-team-code-az199/Data+_team/Anna/sam_results"
mqc_align="/work/clh162/Data+/Anna/2025-2026-team-code-az199/Data+_team/Anna/mqc_align_results"

#Load modules and enviroments
source /hpc/home/az199/miniconda3/etc/profile.d/conda.sh
conda activate rna_seq
mkdir -p $mqc_align

#Run MultiQC on the bam file
multiqc ${sam_dir} -o ${mqc_align}

#Print completion ticket
echo "MultiQC completed for aligned samples"

conda deactivate