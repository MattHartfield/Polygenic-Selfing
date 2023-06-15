#!/bin/sh

# 4th December 2019
# Modification of Gertjan Bisschop's script for running array job on server
# SLiM code of polygenic selection model
# Need to first run 'source activate polysel-env'

# 27th Jan 2020
# Only plots results, does not execute sims

# 26th Jul 2021
# OCSC version

# Grid Engine options (lines prefixed with #$)
#$ -N Polysel_Self_Plots_OCSC
#$ -V
#$ -cwd
#$ -t 1-3		# Run command for each line of parameter file
#$ -l h=c2 		# Run array job on this sub-server
#$ -o /data/hartfield/polyself/scripts/output/
#$ -e /data/hartfield/polyself/scripts/error/

SEL=$(sed -n ${SGE_TASK_ID}p /data/hartfield/polyself/scripts/PolyselParameters_OCSC.txt | awk '{print $1}')
DOM=$(sed -n ${SGE_TASK_ID}p /data/hartfield/polyself/scripts/PolyselParameters_OCSC.txt | awk '{print $2}')
NTR=$(sed -n ${SGE_TASK_ID}p /data/hartfield/polyself/scripts/PolyselParameters_OCSC.txt | awk '{print $4}')
ISNM=$(sed -n ${SGE_TASK_ID}p /data/hartfield/polyself/scripts/PolyselParameters_OCSC.txt | awk '{print $5}')
STYPE=$(sed -n ${SGE_TASK_ID}p /data/hartfield/polyself/scripts/PolyselParameters_OCSC.txt | awk '{print $6}')
OCSC=$(sed -n ${SGE_TASK_ID}p /data/hartfield/polyself/scripts/PolyselParameters_OCSC.txt | awk '{print $7}')
RT=400

# Running plot code
if [ $SGE_TASK_ID -eq $SGE_TASK_FIRST ]
then
	rm -rf /scratch/mhartfield/polyself_out/plots/neutral/contmut/ocsc/ /scratch/mhartfield/polyself_out/plots/weakdom/contmut/ocsc/ /scratch/mhartfield/polyself_out/plots/strongdom/contmut/ocsc/
	mkdir /scratch/mhartfield/polyself_out/plots/neutral/contmut/ocsc/ /scratch/mhartfield/polyself_out/plots/weakdom/contmut/ocsc/ /scratch/mhartfield/polyself_out/plots/strongdom/contmut/ocsc/
	sed -i 's/NAN/NA/g' /scratch/mhartfield/polyself_out/data/*ocsc1*
else
	echo "Pausing for 10 seconds" >&1
	sleep 10
fi

Rscript /data/hartfield/polyself/scripts/Output_Plot_Server_OCSC.R ${SEL} ${DOM} ${NTR} ${ISNM} ${STYPE} ${OCSC} ${RT}
rsync -avz /scratch/mhartfield/polyself_out/plots/* /data/hartfield/polyself/results/
