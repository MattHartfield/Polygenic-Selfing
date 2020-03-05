#!/bin/sh

# 4th December 2019
# Modification of Gertjan Bisschop's script for running array job on server
# SLiM code of polygenic selection model
# Need to first run 'source activate r_env'

# 27th Jan 2020
# Only plots results, does not execute sims

# Grid Engine options (lines prefixed with #$)
#$ -N Polysel_Self_Plots
#$ -V
#$ -cwd
#$ -l h=c2 		# Run array job on this sub-server
#$ -o /data/hartfield/polyself/scripts/output/
#$ -e /data/hartfield/polyself/scripts/error/

# Running plot code
rm -rf /data/hartfield/polyself/results/*
rm -rf /scratch/mhartfield/polyself_out/plots/
mkdir /scratch/mhartfield/polyself_out/plots/ /scratch/mhartfield/polyself_out/plots/neutral/ /scratch/mhartfield/polyself_out/plots/weakdom/ /scratch/mhartfield/polyself_out/plots/strongdom/
sed -i 's/NAN/NA/g' /scratch/mhartfield/polyself_out/data/*
Rscript /data/hartfield/polyself/scripts/Output_Plot_Server.R
rsync -avz /scratch/mhartfield/polyself_out/plots/* /data/hartfield/polyself/results/