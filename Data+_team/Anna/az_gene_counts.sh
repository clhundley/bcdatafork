#!/bin/bash -e

##Given job descriptions/parameters
#SBATCH --job-name=az_gene_count
#SBATCH --mem=12G
#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --time=01:00:00
#SBATCH --array=0-17

#Saved paths
#SBATCH -o az_gcount-%a.out #saves output to this file, replace %a w/ unique array ID
#SBATCH -e az_gcount-%a.err #saves error to the file, replace %a w/ unique array ID

#Email update setup
#SBATCH --mail-type=ALL #auto-send email on all updates
#SBATCH --mail-user=az199@duke.edu

#Load modules/tools
module load Subread

#Establish paths
trim_out="/work/clh162/Data+/Anna/2025-2026-team-code-az199/Data+_team/Anna/trim_results"
bam_dir="/work/clh162/Data+/Anna/2025-2026-team-code-az199/Data+_team/Anna/bam_results"
feature_counts="/work/clh162/Data+/Anna/2025-2026-team-code-az199/Data+_team/Anna/gcount_results"
annotation="/work/clh162/OysterRNA24/hisat2_align/Cv_genome_RU_2025_shared/Cvi_RU25.gtf"

rsamples=($(ls ${trim_out}/*_R1_001_val_1.fq.gz | sed 's/_R1_001_val_1.fq.gz//' | xargs -n 1 basename))
rsample=${rsamples[$SLURM_ARRAY_TASK_ID]}

#Make directory
mkdir -p $feature_counts

#Perform featurecounts on files
featureCounts -T ${SLURM_CPUS_PER_TASK} \
              -p --countReadPairs \
              -a ${annotation} \
              -g gene_id \
              -o ${feature_counts}/${rsample}_count.txt \
${bam_dir}/${rsample}_sorted.bam

#Print completion statement
echo "Feature gene count completed"