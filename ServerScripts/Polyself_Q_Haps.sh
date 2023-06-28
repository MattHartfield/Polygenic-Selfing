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
#$ -t 1-28		# Run command for each line of parameter file (note, not 29 as no need for haplotypes for OCSC = 2)
#$ -l h=c3 		# Run array job on this sub-server
#$ -o /data/hartfield/polyself/scripts/output/
#$ -e /data/hartfield/polyself/scripts/error/

SEL=$(sed -n ${SGE_TASK_ID}p /data/hartfield/polyself/scripts/PolyselParameters.txt | awk '{print $1}')
DOM=$(sed -n ${SGE_TASK_ID}p /data/hartfield/polyself/scripts/PolyselParameters.txt | awk '{print $2}')
SELF=$(sed -n ${SGE_TASK_ID}p /data/hartfield/polyself/scripts/PolyselParameters.txt | awk '{print $3}')
NTR=$(sed -n ${SGE_TASK_ID}p /data/hartfield/polyself/scripts/PolyselParameters.txt | awk '{print $4}')
ISNM=$(sed -n ${SGE_TASK_ID}p /data/hartfield/polyself/scripts/PolyselParameters.txt | awk '{print $5}')
STYPE=$(sed -n ${SGE_TASK_ID}p /data/hartfield/polyself/scripts/PolyselParameters.txt | awk '{print $6}')
OCSC=$(sed -n ${SGE_TASK_ID}p /data/hartfield/polyself/scripts/PolyselParameters.txt | awk '{print $7}')
MSD=0.25

# Producing haplotype plots for each timepoint
if [ $SGE_TASK_ID -eq $SGE_TASK_FIRST ]
then
	echo "Deleting old haplotype files" >&1
	rm -rf /scratch/mhartfield/polyself_out/plots/haps/
	mkdir /scratch/mhartfield/polyself_out/plots/haps/
else
	echo "Pausing for 10 seconds" >&1
	sleep 10
fi

# Processing data
fstr="time0 time1 time2 time3"
for fname in ${fstr}
do
	echo "Processing data for time ${fname}" >&1
	# Creating LD file for plots
	for a in $(seq 1 10)
	do
		vcftools --vcf /scratch/mhartfield/polyself_out/haps/polyself_out_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}_${fname}_rep${a}.vcf --thin 500000 --maf 0.1 --hap-r2 --out /scratch/mhartfield/polyself_out/haps/polyself_out_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}_${fname}_rep${a}_LD
		rm -rf /scratch/mhartfield/polyself_out/haps/polyself_out_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}_${fname}_rep${a}_LD.log
	done

	# Creating plots of QTL distribution throughout haplotypes
	echo "Plotting haplotype samples" >&1
	Rscript /data/hartfield/polyself/scripts/Hap_Plot_QTL.R ${SEL} ${DOM} ${SELF} ${NTR} ${MSD} ${ISNM} ${STYPE} ${OCSC} ${fname}
	
	# Creating plots of LD decay
	echo "Plotting LD decay" >&1
	Rscript /data/hartfield/polyself/scripts/LD_group_plot.R ${SEL} ${DOM} ${SELF} ${NTR} ${MSD} ${ISNM} ${STYPE} ${OCSC} ${fname}

done

# Plotting polygenic score over timepoints
DOPS=$(awk -v ins=$SELF 'BEGIN{if(ins==0) print 0; else print 1}')
if [ $DOPS -eq 0 -a $OCSC -eq 0 ]
then
	echo "Plotting polygenic scores" >&1
	Rscript /data/hartfield/polyself/scripts/Polygenic_Score_Calc.R ${SEL} ${DOM} ${NTR} ${MSD} ${ISNM} ${STYPE}
elif [ $DOPS -eq 0 -a $OCSC -eq 1 ]
then
	echo "Plotting polygenic scores (OCSC)" >&1
	Rscript /data/hartfield/polyself/scripts/Polygenic_Score_Calc_OCSC.R ${SEL} ${DOM} ${NTR} ${MSD} ${ISNM} ${STYPE}
fi

rsync -avz /scratch/mhartfield/polyself_out/plots/* /data/hartfield/polyself/results/
