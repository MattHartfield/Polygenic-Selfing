#!/bin/sh

# 24th February 2020
# Modification of Gertjan Bisschop's script for running array job on server
# Processing ms files from output
# To be run AFTER 'plots' file of other outputs
# Need to first run 'source activate haplostrips'

# Grid Engine options (lines prefixed with #$)
#$ -N Polysel_Self_MS
#$ -V
#$ -cwd
#$ -t 1-36 		# Run command for each line of parameter file
#$ -l h=c2 		# Run array job on this sub-server
#$ -o /data/hartfield/polyself/scripts/output/
#$ -e /data/hartfield/polyself/scripts/error/

SEL=$(sed -n ${SGE_TASK_ID}p /data/hartfield/polyself/scripts/PolyselParameters.txt | awk '{print $1}')
DOM=$(sed -n ${SGE_TASK_ID}p /data/hartfield/polyself/scripts/PolyselParameters.txt | awk '{print $2}')
SELF=$(sed -n ${SGE_TASK_ID}p /data/hartfield/polyself/scripts/PolyselParameters.txt | awk '{print $3}')
NEWOP=$(sed -n ${SGE_TASK_ID}p /data/hartfield/polyself/scripts/PolyselParameters.txt | awk '{print $4}')
if [ $NEWOP = "1.0" ]
then
	NEWOP=$(printf "%.0f" $NEWOP)
fi
NTR=$(sed -n ${SGE_TASK_ID}p /data/hartfield/polyself/scripts/PolyselParameters.txt | awk '{print $5}')
MVAR=$(sed -n ${SGE_TASK_ID}p /data/hartfield/polyself/scripts/PolyselParameters.txt | awk '{print $6}')

# Producing haplotype plots for each timepoint
if [ "$SGE_TASK_ID" -eq "$SGE_TASK_FIRST" ]
then
	rm -rf /scratch/mhartfield/polyself_out/plots/haps/
	mkdir /scratch/mhartfield/polyself_out/plots/haps/
	# Adding dummy header file to SLiM ms outputs, so they can be parsed by haplostrips
	for file in /scratch/mhartfield/polyself_out/ms/*
	do
		sed -i '1 i\ms 100 1 -t 10\n10000 2000 30000\n' $file
	done
else
	sleep 10
fi
/data/hartfield/polyself/scripts/haplostrips/haplostrips -s /scratch/mhartfield/polyself_out/ms/polyself_out_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_mvar${MVAR}_beforeshift.ms -o /scratch/mhartfield/polyself_out/plots/haps/HSBS_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_mvar${MVAR} -c 0.02 -C "darkred" -T
/data/hartfield/polyself/scripts/haplostrips/haplostrips -s /scratch/mhartfield/polyself_out/ms/polyself_out_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_mvar${MVAR}_aftershift.ms -o /scratch/mhartfield/polyself_out/plots/haps/HSAS_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_mvar${MVAR} -c 0.02 -C "darkred" -T
/data/hartfield/polyself/scripts/haplostrips/haplostrips -s /scratch/mhartfield/polyself_out/ms/polyself_out_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_mvar${MVAR}_simend.ms -o /scratch/mhartfield/polyself_out/plots/haps/HSE_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_mvar${MVAR} -c 0.02 -C "darkred" -T
rsync -avz /scratch/mhartfield/polyself_out/plots/* /data/hartfield/polyself/results/
