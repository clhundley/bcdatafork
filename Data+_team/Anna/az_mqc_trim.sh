#!/bin/bash -e

##Given job descriptions/parameters
#SBATCH --job-name=az_mqc_trimmed_out
#SBATCH --mem=16G
#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --time=01:00:00

#SBATCH -o azmultiqc_trim-%j.out #saves output to this file, replace %j w/ unique array ID
#SBATCH -e azmultiqc_trim-%j.err #saves error to the file, replace %j w/ unique array ID

#SBATCH --mail-type=ALL #auto-send email on all updates
#SBATCH --mail-user=az199@duke.edu

#Load modules and enviroments
source /hpc/home/az199/miniconda3/etc/profile.d/conda.sh
conda activate rna_seq

#establish paths
fastqc_trim_dir="/work/clh162/Data+/Anna/2025-2026-team-code-az199/Data+_team/Anna/fastqc_trim_results"
multiqc_trim_dir="/work/clh162/Data+/Anna/2025-2026-team-code-az199/Data+_team/Anna/multiqc_results"

#create folders
mkdir -p $multiqc_trim_dir

#run data 
multiqc $fastqc_trim_dir -o $multiqc_trim_dir

#print completion ticket
echo "MultiQC Completed"

conda deactivate