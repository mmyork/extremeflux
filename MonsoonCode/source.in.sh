#!/bin/bash
#SBATCH --job-name=source.in                     # the name of your job
#SBATCH --output=/scratch/my464/cflux/code2/source.in.txt    # this is the file your output and errors go to
#SBATCH --chdir=/scratch/my464/cflux/code2            # your work directory
#SBATCH --time=300:00:00                	    # (max time) 30 minutes, hmm ya that sounds good 
#SBATCH --mem=100000                          # (total mem) 4GB of memory hmm, sounds good to me
#SBATCH -c4                                 # 4 cpus, sounds good to me

module load R
srun R

Rscript source.in.R