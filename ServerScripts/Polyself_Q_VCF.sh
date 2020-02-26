#!/bin/sh

# 24th February 2020
# Modification of Gertjan Bisschop's script for running array job on server
# Processing VCF files from output
# To be run AFTER 'plots' file of other outputs
# Need to first run 'source activate haplostrips'

# Grid Engine options (lines prefixed with #$)
#$ -N Polysel_Self_VCF
#$ -V
#$ -cwd
#$ -t 1-24 		# Run command for each line of parameter file
#$ -l h=c2 		# Run array job on this sub-server
#$ -o /data/hartfield/polyself/scripts/output/
#$ -e /data/hartfield/polyself/scripts/error/

SEL=$(sed -n ${SGE_TASK_ID}p /data/hartfield/polyself/scripts/PolyselParameters.txt | awk '{print $1}')
DOM=$(sed -n ${SGE_TASK_ID}p /data/hartfield/polyself/scripts/PolyselParameters.txt | awk '{print $2}')
SELF=$(sed -n ${SGE_TASK_ID}p /data/hartfield/polyself/scripts/PolyselParameters.txt | awk '{print $3}')
NEWOP=$(sed -n ${SGE_TASK_ID}p /data/hartfield/polyself/scripts/PolyselParameters.txt | awk '{print $4}')
NTR=$(sed -n ${SGE_TASK_ID}p /data/hartfield/polyself/scripts/PolyselParameters.txt | awk '{print $5}')
MVAR=$(sed -n ${SGE_TASK_ID}p /data/hartfield/polyself/scripts/PolyselParameters.txt | awk '{print $6}')

# Producing haplotype plots for each timepoint
if [ "$SGE_TASK_ID" -eq "$SGE_TASK_FIRST" ]
then
	rm -rf /scratch/mhartfield/polyself_out/plots/haps/
	mkdir /scratch/mhartfield/polyself_out/plots/haps/
	# Producing poptable
	rm -f /data/hartfield/polyself/scripts/simpopdat.poptable
	touch /data/hartfield/polyself/scripts/simpopdat.poptable
	echo -e "sample\tpop\tsuper_pop" >> /data/hartfield/polyself/scripts/simpopdat.poptable
	for (( i=0; i < 200; ++i ))
	do
		echo -e "i${i}\tp1\tp1" >> /data/hartfield/polyself/scripts/simpopdat.poptable
	done
else
	sleep 10
fi
/data/hartfield/polyself/scripts/haplostrips/haplostrips -v /scratch/mhartfield/polyself_out/vcf/polyself_out_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_mvar${MVAR}_beforeshift.vcf  -i 1:0-99999 -o /scratch/mhartfield/polyself_out/plots/haps/HSBS_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_mvar${MVAR} -P /data/hartfield/polyself/scripts/simpopdat.poptable -C "darkred"
/data/hartfield/polyself/scripts/haplostrips/haplostrips -v /scratch/mhartfield/polyself_out/vcf/polyself_out_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_mvar${MVAR}_aftershift.vcf  -i 1:0-99999 -o /scratch/mhartfield/polyself_out/plots/haps/HSAS_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_mvar${MVAR} -P /data/hartfield/polyself/scripts/simpopdat.poptable -C "darkred"
/data/hartfield/polyself/scripts/haplostrips/haplostrips -v /scratch/mhartfield/polyself_out/vcf/polyself_out_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_mvar${MVAR}_simend.vcf  -i 1:0-99999 -o /scratch/mhartfield/polyself_out/plots/haps/HSE_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_mvar${MVAR} -P /data/hartfield/polyself/scripts/simpopdat.poptable -C "darkred"
rsync -avz /scratch/mhartfield/polyself_out/plots/* /data/hartfield/polyself/results/
