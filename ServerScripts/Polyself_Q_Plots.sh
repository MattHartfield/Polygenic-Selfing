#!/bin/sh

# 4th December 2019
# Modification of Gertjan Bisschop's script for running array job on server
# SLiM code of polygenic selection model
# Need to first run 'source activate polysel-env'

# 27th Jan 2020
# Only plots results, does not execute sims

# Grid Engine options (lines prefixed with #$)
#$ -N Polysel_Self_Plots
#$ -V
#$ -cwd
#$ -t 1-2		# Run command for each line of parameter file
#$ -l h=c2 		# Run array job on this sub-server
#$ -o /data/hartfield/polyself/scripts/output/
#$ -e /data/hartfield/polyself/scripts/error/

SEL=$(sed -n ${SGE_TASK_ID}p /data/hartfield/polyself/scripts/PolyselParametersPlots.txt | awk '{print $1}')
DOM=$(sed -n ${SGE_TASK_ID}p /data/hartfield/polyself/scripts/PolyselParametersPlots.txt | awk '{print $2}')
NTR=$(sed -n ${SGE_TASK_ID}p /data/hartfield/polyself/scripts/PolyselParametersPlots.txt | awk '{print $4}')
MSD=$(sed -n ${SGE_TASK_ID}p /data/hartfield/polyself/scripts/PolyselParametersPlots.txt | awk '{print $5}')

# Running plot code
if [ $SGE_TASK_ID -eq $SGE_TASK_FIRST ]
then
	echo "Deleting old plot files" >&1
	fds='neutral weakdom strongdom'
	fsv='contmut stopmut'
	rm -rf /data/hartfield/polyself/results/*
	rm -rf /scratch/mhartfield/polyself_out/plots/
	mkdir /scratch/mhartfield/polyself_out/plots/ 
	for fd in $fds
	do
		mkdir /scratch/mhartfield/polyself_out/plots/$fd/
		for fs in $fsv
		do
			mkdir /scratch/mhartfield/polyself_out/plots/$fd/$fs/
		done
	done
	sed -i 's/NAN/NA/g' /scratch/mhartfield/polyself_out/data/*
else
	echo "Pausing for 10 seconds" >&1
	sleep 10
fi

Rscript /data/hartfield/polyself/scripts/Output_Plot_Server.R ${SEL} ${DOM} ${NTR} ${MSD}
rsync -avz /scratch/mhartfield/polyself_out/plots/* /data/hartfield/polyself/results/
