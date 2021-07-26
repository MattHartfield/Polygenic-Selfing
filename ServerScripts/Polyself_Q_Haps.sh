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
#$ -t 1-23		# Run command for each line of parameter file
#$ -l h=c1 		# Run array job on this sub-server
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
	# Creating LD file for plots
	vcftools --vcf /scratch/mhartfield/polyself_out/haps/polyself_out_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}_${fname}.vcf --thin 500000 --maf 0.05 --hap-r2 --out /scratch/mhartfield/polyself_out/haps/polyself_out_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}_${fname}_LD
	rm -rf /scratch/mhartfield/polyself_out/haps/polyself_out_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}_${fname}_LD.log

	# Creating plots of QTL distribution throughout haplotypes
	Rscript /data/hartfield/polyself/scripts/Hap_Plot_QTL.R ${SEL} ${DOM} ${SELF} ${NTR} ${MSD} ${ISNM} ${STYPE} ${OCSC} ${fname}

	# Producing base file for QTL output info
	touch /scratch/mhartfield/polyself_out/plots/haps/HS_${fname}_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}.count
	touch /scratch/mhartfield/polyself_out/plots/haps/HS_${fname}_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}.freq
	# (1) VCF with QTLs only 
	awk '/^##/ {next} {$1=$3=$4=$5=$6=$7=$8=$9=""; print $0}' /scratch/mhartfield/polyself_out/haps/polyself_out_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}_${fname}.vcf | tail -n +2 | awk 'NR==FNR{A[$1]; next} {if($1 in A) {print $0}}' /scratch/mhartfield/polyself_out/haps/polyself_out_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}_${fname}.info - > /scratch/mhartfield/polyself_out/haps/polyself_out_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}_${fname}.temp
	NL=$(wc -l < /scratch/mhartfield/polyself_out/haps/polyself_out_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}_${fname}.temp)
	if [ $NL -gt 0 ]
	then
		# (2) Frequency of QTLs in sample, excluding fixed QTLs
		for j in $(seq 1 $NL)
		do
			# Note (NF-1) in awk command below since also include position as a field
			sed -n ${j}p /scratch/mhartfield/polyself_out/haps/polyself_out_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}_${fname}.temp | sed -e 's/|/ /g' | awk 'BEGIN{SUM=0;}{for (i=2;i<=NF;i++) SUM+=$i}END{if (SUM!=(NF-1)) print $1, SUM/(NF-1)}' >> /scratch/mhartfield/polyself_out/plots/haps/HS_${fname}_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}.freq
		done
		NL2=$(wc -l < /scratch/mhartfield/polyself_out/plots/haps/HS_${fname}_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}.freq)
		if [ $NL2 -gt 0 ]
		then
			# (3) Info file with QTLs only, sorted by position
			tail -n +2 /scratch/mhartfield/polyself_out/haps/polyself_out_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}_${fname}.info | sort -n -k 1 - | awk 'NR==FNR{A[$1]; next} {if($1 in A) {print $0}}' /scratch/mhartfield/polyself_out/plots/haps/HS_${fname}_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}.freq - > /scratch/mhartfield/polyself_out/haps/polyself_out_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}_${fname}.temp2
			# (3a) Cutting out fixed QTLs in VCF
			awk 'NR==FNR{A[$1]; next} {if($1 in A) {print $0}}' /scratch/mhartfield/polyself_out/plots/haps/HS_${fname}_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}.freq /scratch/mhartfield/polyself_out/haps/polyself_out_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}_${fname}.temp > /scratch/mhartfield/polyself_out/haps/polyself_out_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}_${fname}.tempA
			# (4) Join new VCF, info files; delete old files
			join -1 1 -2 1 /scratch/mhartfield/polyself_out/haps/polyself_out_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}_${fname}.temp2 /scratch/mhartfield/polyself_out/haps/polyself_out_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}_${fname}.tempA > /scratch/mhartfield/polyself_out/haps/polyself_out_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}_${fname}.temp3
			rm -f /scratch/mhartfield/polyself_out/haps/polyself_out_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}_${fname}.temp /scratch/mhartfield/polyself_out/haps/polyself_out_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}_${fname}.tempA /scratch/mhartfield/polyself_out/haps/polyself_out_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}_${fname}.temp2
			# (5) From new file, calculate total QTL per site per individual
			awk '{print $2}' /scratch/mhartfield/polyself_out/haps/polyself_out_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}_${fname}.temp3 > /scratch/mhartfield/polyself_out/haps/polyself_out_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}_${fname}.temp4
			for i in $(seq 1 50)
			do
				awk -v b=$(($i + 2)) '{print $b}' /scratch/mhartfield/polyself_out/haps/polyself_out_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}_${fname}.temp3 | awk -F "|" '{print $1 + $2}' | paste /scratch/mhartfield/polyself_out/haps/polyself_out_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}_${fname}.temp4 - > /scratch/mhartfield/polyself_out/haps/polyself_out_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}_${fname}.temp5
				rm -f /scratch/mhartfield/polyself_out/haps/polyself_out_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}_${fname}.temp4
				cp /scratch/mhartfield/polyself_out/haps/polyself_out_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}_${fname}.temp5 /scratch/mhartfield/polyself_out/haps/polyself_out_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}_${fname}.temp4
				rm -f /scratch/mhartfield/polyself_out/haps/polyself_out_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}_${fname}.temp5
			done
			rm -f /scratch/mhartfield/polyself_out/haps/polyself_out_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}_${fname}.temp3
			# (6) Print off (i) total number of QTLs (ii) total QTL effects per individual to file
			for i in $(seq 1 50)
			do
				awk -v b=$(($i + 1)) '{SUM+=$b; QTLP+=$b*$1}END{print SUM,QTLP}' /scratch/mhartfield/polyself_out/haps/polyself_out_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}_${fname}.temp4 >> /scratch/mhartfield/polyself_out/plots/haps/HS_${fname}_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}.count
			done
			rm -f /scratch/mhartfield/polyself_out/haps/polyself_out_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}_${fname}.temp4
		else
			echo "NA NA" >> /scratch/mhartfield/polyself_out/plots/haps/HS_${fname}_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}.freq
			for i in $(seq 1 50)
			do
				echo "0 NA" >> /scratch/mhartfield/polyself_out/plots/haps/HS_${fname}_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}.count
			done
			rm -f /scratch/mhartfield/polyself_out/haps/polyself_out_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}_${fname}.temp
		fi
	else
		echo "NA NA" >> /scratch/mhartfield/polyself_out/plots/haps/HS_${fname}_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}.freq
		for i in $(seq 1 50)
		do
			echo "0 NA" >> /scratch/mhartfield/polyself_out/plots/haps/HS_${fname}_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}.count
		done
		rm -f /scratch/mhartfield/polyself_out/haps/polyself_out_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}_${fname}.temp
	fi
done

rsync -avz /scratch/mhartfield/polyself_out/plots/* /data/hartfield/polyself/results/
