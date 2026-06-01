#!/bin/bash -e
#SBATCH --job-name=alignment_multiqc
#SBATCH --time=7-00:00:00
#SBATCH --output=/work/clh162/OysterRNA24/logs/hisat2_alignment_multiqc_%A.out
#SBATCH --error=/work/clh162/OysterRNA24/logs/hisat2_alignment_multiqc_%A.err
#SBATCH --partition=common
#SBATCH --nodes=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=callie.hundley@duke.edu

## Activate conda environment with Multiqc loaded ##
source /hpc/home/clh162/miniconda3/etc/profile.d/conda.sh
conda activate RNA-seq

## Set paths ##
HISAT2_SUMMARY=/work/clh162/OysterRNA24/hisat2_align/alignedreads
MULTIQC_OUT=/work/clh162/OysterRNA24/multiqc_report_aligned

## Run MultiQC ##
echo "Running MultiQC on alignment summary files"

multiqc ${HISAT2_SUMMARY}/*_hisat2_summary.txt -o ${MULTIQC_OUT}

echo "MultiQC complete!"

conda deactivate