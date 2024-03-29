#!/bin/sh

# 4th Aug 2022
# Creating plot of HoC results
# Need to first run 'source activate polysel-env'

# Grid Engine options (lines prefixed with #$)
#$ -N Polysel_Self_HoC
#$ -V
#$ -cwd
#$ -l h=c2 		# Run array job on this sub-server
#$ -o /data/hartfield/polyself/scripts/output/
#$ -e /data/hartfield/polyself/scripts/error/

Rscript /data/hartfield/polyself/scripts/HoCPlot.R
