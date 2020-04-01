#!/bin/sh

# 24th February 2020
# Modification of Gertjan Bisschop's script for running array job on server
# Processing haplotype files from output
# To be run AFTER 'plots' file of other outputs
# Need to first run 'source activate polysel-env'

# Grid Engine options (lines prefixed with #$)
#$ -N Polysel_Self_Haps
#$ -V
#$ -cwd
#$ -t 1-48 		# Run command for each line of parameter file
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
MSD=$(sed -n ${SGE_TASK_ID}p /data/hartfield/polyself/scripts/PolyselParameters.txt | awk '{print $6}')

# Producing haplotype plots for each timepoint
if [ $SGE_TASK_ID -eq $SGE_TASK_FIRST ]
then
	echo "Deleting old haplotype files" >&1
	rm -rf /scratch/mhartfield/polyself_out/plots/haps/
	mkdir /scratch/mhartfield/polyself_out/plots/haps/
# 	Adding dummy header file to SLiM ms outputs, so they can be parsed by haplostrips
# 	for file in /scratch/mhartfield/polyself_out/ms/*
# 	do
# 		sed -i '1 i\ms 100 1 -t 10\n10000 2000 30000\n' $file
# 	done
else
	echo "Pausing for 10 seconds" >&1
	sleep 10
fi

for fname in beforeshift 20gens 150gens
do
	/data/hartfield/polyself/scripts/haplostrips/haplostrips -v /scratch/mhartfield/polyself_out/haps/polyself_out_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}_${fname}.vcf -i 1:1-30000000 -P /data/hartfield/polyself/scripts/Popinfo.poptable -o /scratch/mhartfield/polyself_out/plots/haps/HS_${fname}_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD} -c 0.02 -C "darkred" -T
	touch /scratch/mhartfield/polyself_out/plots/haps/HS_${fname}_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}.count
	for i in $(seq 1 50)
	do
		awk '/^##/ {next} {$1=$3=$4=$5=$6=$7=$8=$9=""; print $0}' /scratch/mhartfield/polyself_out/haps/polyself_out_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}_${fname}.vcf | tail -n +2 | awk 'NR==FNR{A[$1]; next} {if($1 in A) {$1 = ""; print $0}}' /scratch/mhartfield/polyself_out/haps/polyself_out_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}_${fname}.pos - | awk -v b=$i '{print $b}' - | awk -F "|" '{SUM+=$1+$2}END{print SUM}' >> /scratch/mhartfield/polyself_out/plots/haps/HS_${fname}_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}.count
	done
done
rsync -avz /scratch/mhartfield/polyself_out/plots/* /data/hartfield/polyself/results/
