#!/bin/bash
#SBATCH --job-name=test_bowtie
#SBATCH --time=120:00
#SBATCH -p normal
#SBATCH -c 5
#SBATCH --mem=8GB

# load all of the needed package
module load python/3.9.0
module load matplotlib
module load biology
module load bowtie2
module load samtools
module load sra-tools
pip install snakemake --user

bash overallPipeline.sh