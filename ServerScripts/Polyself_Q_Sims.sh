#!/bin/sh

# 4th December 2019
# Modification of Gertjan Bisschop's script for running array job on server
# SLiM code of polygenic selection model

# 29th Jan 2020
# Runs sims only

# Grid Engine options (lines prefixed with #$)
#$ -N Polysel_Self_Sims
#$ -cwd
#$ -t 1 		# Run command for each line of parameter file
#$ -l h=c2 		# Run array job on this sub-server
#$ -o /data/hartfield/polyself/scripts/output/
#$ -e /data/hartfield/polyself/scripts/error/

SEL=$(sed -n ${SGE_TASK_ID}p /data/hartfield/polyself/scripts/PolyselParameters.txt | awk '{print $1}')
DOM=$(sed -n ${SGE_TASK_ID}p /data/hartfield/polyself/scripts/PolyselParameters.txt | awk '{print $2}')
SELF=$(sed -n ${SGE_TASK_ID}p /data/hartfield/polyself/scripts/PolyselParameters.txt | awk '{print $3}')
NEWOP=$(sed -n ${SGE_TASK_ID}p /data/hartfield/polyself/scripts/PolyselParameters.txt | awk '{print $4}')
NTR=$(sed -n ${SGE_TASK_ID}p /data/hartfield/polyself/scripts/PolyselParameters.txt | awk '{print $5}')
MVAR=$(sed -n ${SGE_TASK_ID}p /data/hartfield/polyself/scripts/PolyselParameters.txt | awk '{print $6}')

# Running simulations, parameters in 'PolyselParameters.txt'
if [ "$SGE_TASK_ID" -eq "$SGE_TASK_FIRST" ]
then
	rm -rf /scratch/mhartfield/polyself_out/
	mkdir /scratch/mhartfield/polyself_out/
	mkdir /scratch/mhartfield/polyself_out/data/
	mkdir /scratch/mhartfield/polyself_out/ms/
	mkdir /scratch/mhartfield/polyself_out/phendat/
else
	sleep 10
fi
/ceph/software/slim/slim_v3.3/SLiM/slim -d s=$SEL -d h=$DOM -d sfrate=$SELF -d newo=$NEWOP -d nt=$NTR -d mvar=$MVAR /data/hartfield/polyself/scripts/Polygenic_Selection_With_Selfing.slim
