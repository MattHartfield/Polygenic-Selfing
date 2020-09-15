#!/bin/sh

# 4th December 2019
# Modification of Gertjan Bisschop's script for running array job on server
# SLiM code of polygenic selection model

# 29th Jan 2020
# Runs sims only
# Need to first run 'source activate polysel-env'

# Grid Engine options (lines prefixed with #$)
#$ -N Polysel_Self_Sims
#$ -V
#$ -cwd
#$ -t 1-80		# Run command for each line of parameter file
#$ -l h=c2 		# Run array job on this sub-server
#$ -o /data/hartfield/polyself/scripts/output/
#$ -e /data/hartfield/polyself/scripts/error/

SEL=$(sed -n ${SGE_TASK_ID}p /data/hartfield/polyself/scripts/PolyselParametersBig.txt | awk '{print $1}')
DOM=$(sed -n ${SGE_TASK_ID}p /data/hartfield/polyself/scripts/PolyselParametersBig.txt | awk '{print $2}')
SELF=$(sed -n ${SGE_TASK_ID}p /data/hartfield/polyself/scripts/PolyselParametersBig.txt | awk '{print $3}')
#NEWOP=$(sed -n ${SGE_TASK_ID}p /data/hartfield/polyself/scripts/PolyselParametersBig.txt | awk '{print $4}')
NTR=$(sed -n ${SGE_TASK_ID}p /data/hartfield/polyself/scripts/PolyselParametersBig.txt | awk '{print $4}')
MSD=$(sed -n ${SGE_TASK_ID}p /data/hartfield/polyself/scripts/PolyselParametersBig.txt | awk '{print $5}')
ISNM=$(sed -n ${SGE_TASK_ID}p /data/hartfield/polyself/scripts/PolyselParametersBig.txt | awk '{print $6}')
REP=$(sed -n ${SGE_TASK_ID}p /data/hartfield/polyself/scripts/PolyselParametersBig.txt | awk '{print $7}')

# Running simulations, parameters in 'PolyselParametersBig.txt'
if [ $SGE_TASK_ID -eq $SGE_TASK_FIRST ]
then
	echo "Deleting old files" >&1
	rm -rf /scratch/mhartfield/polyself_out/
	mkdir /scratch/mhartfield/polyself_out/
	mkdir /scratch/mhartfield/polyself_out/data/
	mkdir /scratch/mhartfield/polyself_out/haps/
	mkdir /scratch/mhartfield/polyself_out/phendat/
else
	echo "Pausing for 10 seconds" >&1
	sleep 10
fi
slim -d s=$SEL -d h=$DOM -d sfrate=$SELF -d nt=$NTR -d msd=$MSD -d rep=$REP -d isnm=$ISNM /data/hartfield/polyself/scripts/Polygenic_Selection_With_Selfing.slim
# if [ $NEWOP = "1.0" ]
# then
# 	NEWOP=$(printf "%.0f" $NEWOP)
# fi

if [ $REP -eq 1 ]
then
# 	if [ $ISSV -eq 0 ]
# 	then
# 		fstr="20gens 150gens"
# 	fi
# 	if [ $ISSV -eq 1 ]
# 	then
#    	fstr="beforeshift 20gens 150gens"
# 	fi
	fstr="0gens 20gens 150gens 500gens"
	for fname in ${fstr}
	do
		grep -E "#|MT=3" /scratch/mhartfield/polyself_out/haps/polyself_out_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_${fname}.vcf > /scratch/mhartfield/polyself_out/haps/polyself_out_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_${fname}_QTL.vcf
	done
fi
