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
#$ -l h=c5 		# Run array job on this sub-server
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
	# Creating haplostrips output
	/data/hartfield/polyself/scripts/haplostrips/haplostrips -v /scratch/mhartfield/polyself_out/haps/polyself_out_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}_${fname}_QTL.vcf -i 1:1-25000000 -P /data/hartfield/polyself/scripts/Popinfo.poptable -o /scratch/mhartfield/polyself_out/plots/haps/HS_${fname}_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD} -c 0.02 -C "darkred" -T
	# Producing base file for QTL output info
	touch /scratch/mhartfield/polyself_out/plots/haps/HS_${fname}_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}.count
	touch /scratch/mhartfield/polyself_out/plots/haps/HS_${fname}_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}.freq
	# (1) VCF with QTLs only 
	awk '/^##/ {next} {$1=$3=$4=$5=$6=$7=$8=$9=""; print $0}' /scratch/mhartfield/polyself_out/haps/polyself_out_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}_${fname}_QTL.vcf | tail -n +2 | awk 'NR==FNR{A[$1];B[$2]; next} {if($1 in A) {print $0}}' /scratch/mhartfield/polyself_out/haps/polyself_out_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}_${fname}.info - > /scratch/mhartfield/polyself_out/haps/polyself_out_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}_${fname}.temp
	NL=$(wc -l < /scratch/mhartfield/polyself_out/haps/polyself_out_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}_${fname}.temp)
	if [ $NL -gt 0 ]
	then
		# (2) Frequency of QTLs in sample
		for j in $(seq 1 $NL)
		do
			# Note (NF-1) in awk command below since also include position as a field
			sed -n ${j}p /scratch/mhartfield/polyself_out/haps/polyself_out_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}_${fname}.temp | sed -e 's/|/ /g' | awk 'BEGIN{SUM=0;}{for (i=2;i<=NF;i++) SUM+=$i}END{print $1, SUM/(NF-1)}' >> /scratch/mhartfield/polyself_out/plots/haps/HS_${fname}_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}.freq
		done
		# (3) Info file with QTLs only, sorted by position
		tail -n +2 /scratch/mhartfield/polyself_out/haps/polyself_out_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}_${fname}.info | sort -n -k 1 - | awk 'NR==FNR{A[$1];B[$2]; next} {if($1 in A) {print $0}}' /scratch/mhartfield/polyself_out/haps/polyself_out_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}_${fname}.temp - > /scratch/mhartfield/polyself_out/haps/polyself_out_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}_${fname}.temp2
		# (4) Join new VCF, info files; delete old files
		join -1 1 -2 1 /scratch/mhartfield/polyself_out/haps/polyself_out_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}_${fname}.temp2 /scratch/mhartfield/polyself_out/haps/polyself_out_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}_${fname}.temp > /scratch/mhartfield/polyself_out/haps/polyself_out_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}_${fname}.temp3
		rm -f /scratch/mhartfield/polyself_out/haps/polyself_out_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}_${fname}.temp /scratch/mhartfield/polyself_out/haps/polyself_out_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}_${fname}.temp2
		# (5) From new file, calculate total QTL per site per individual
		awk '{print $2}' /scratch/mhartfield/polyself_out/haps/polyself_out_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}_${fname}.temp3 > /scratch/mhartfield/polyself_out/haps/polyself_out_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}_${fname}.temp4
		for i in $(seq 1 50)
		do
			awk -v b=$(($i + 2)) '{print $b}' /scratch/mhartfield/polyself_out/haps/polyself_out_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}_${fname}.temp3 | awk -F "|" '{print $1 + $2}' | paste /scratch/mhartfield/polyself_out/haps/polyself_out_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}_${fname}.temp4 - > /scratch/mhartfield/polyself_out/haps/polyself_out_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}_${fname}.temp5
			rm -f /scratch/mhartfield/polyself_out/haps/polyself_out_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}_${fname}.temp4
			cp /scratch/mhartfield/polyself_out/haps/polyself_out_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}_${fname}.temp5 /scratch/mhartfield/polyself_out/haps/polyself_out_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}_${fname}.temp4
			rm -f /scratch/mhartfield/polyself_out/haps/polyself_out_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}_${fname}.temp5
		done
		rm -f /scratch/mhartfield/polyself_out/haps/polyself_out_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}_${fname}.temp3
		# (6) Print off (i) total number of QTLs (ii) total QTL effects per individual to file
		for i in $(seq 1 50)
		do
			awk -v b=$(($i + 1)) '{SUM+=$b; QTLP+=$b*$1}END{print SUM,QTLP}' /scratch/mhartfield/polyself_out/haps/polyself_out_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}_${fname}.temp4 >> /scratch/mhartfield/polyself_out/plots/haps/HS_${fname}_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}.count
		done
		rm -f /scratch/mhartfield/polyself_out/haps/polyself_out_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}_${fname}.temp4
	else
		echo "NA NA" >> /scratch/mhartfield/polyself_out/plots/haps/HS_${fname}_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}.freq
		for i in $(seq 1 50)
		do
			echo "0 NA" >> /scratch/mhartfield/polyself_out/plots/haps/HS_${fname}_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}.count
		done
		rm -f /scratch/mhartfield/polyself_out/haps/polyself_out_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}_${fname}.temp
	fi
done
rsync -avz /scratch/mhartfield/polyself_out/plots/* /data/hartfield/polyself/results/
