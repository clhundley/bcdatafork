#!/bin/bash -e
#SBATCH --job-name=gff3_to_gtf_array
#SBATCH --time=7-00:00:00
#SBATCH --output=/work/clh162/OysterRNA24/logs/gff3_to_gtf_%A_%a.out
#SBATCH --error=/work/clh162/OysterRNA24/logs/gff3_to_gtf_%A_%a.err
#SBATCH --partition=common
#SBATCH --nodes=1
#SBATCH --mem=32G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=callie.hundley@duke.edu

# The source referenced to execute this can be found here: https://github.com/gpertea/gffread (in the examples folder in this repo)

## Load module (gffread) ## -- Was not installed on the DCC so installed to my RNA-seq environment
source /hpc/home/clh162/miniconda3/etc/profile.d/conda.sh
conda activate RNA-seq

## Set paths ##
GFF3=/work/clh162/OysterRNA24/hisat2_align/Cv_genome_RU_2025_shared/Cvi_RU25.gff3
GTF_DIR=/work/clh162/OysterRNA24/hisat2_align/Cv_genome_RU_2025_shared

## Convert files using gffread ##
gffread ${GFF3} -T -o ${GTF_DIR}/Cvi_RU25.gtf

conda deactivate
