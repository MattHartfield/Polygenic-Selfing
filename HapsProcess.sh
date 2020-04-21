#!/bin/sh
# 26th Feb 2020
# Script for compiling haplotype graphs
# So can process in parallel

SEL=$(sed -n $1p /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/ServerScripts/PolyselParameters.txt | awk '{print $1}')
DOM=$(sed -n $1p /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/ServerScripts/PolyselParameters.txt | awk '{print $2}')
SELF=$(sed -n $1p /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/ServerScripts/PolyselParameters.txt | awk '{print $3}')
NEWOP=$(sed -n $1p /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/ServerScripts/PolyselParameters.txt | awk '{print $4}')
if [ $NEWOP = "1.0" ]
then
	NEWOP=$(printf "%.0f" $NEWOP)
fi
NTR=$(sed -n $1p /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/ServerScripts/PolyselParameters.txt | awk '{print $5}')
MSD=$(sed -n $1p /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/ServerScripts/PolyselParameters.txt | awk '{print $6}')

# PCA plots
#Rscript /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/HapRCode/HaplotypePCA.R ${SEL} ${DOM} ${SELF} ${NEWOP} ${NTR} ${MSD}

# QTL Count plots
Rscript /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/HapRCode/QTLCount.R ${SEL} ${DOM} ${SELF} ${NEWOP} ${NTR} ${MSD}

# Combining haplotype plots into one
pdfjam /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_beforeshift_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}.pdf /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_20gens_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}.pdf /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_150gens_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}.pdf --nup 3x1 --delta='1cm 0cm' --landscape --outfile /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HSUC_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}.pdf
#pdfjam /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_beforeshift_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}.dist.pdf /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_20gens_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}.dist.pdf /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_150gens_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}.dist.pdf --nup 3x1 --delta='1cm 0cm' --landscape --outfile /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HSUC_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}.dist.pdf
#pdfjam /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_beforeshift_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}.pca.pdf /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_20gens_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}.pca.pdf /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_150gens_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}.pca.pdf --nup 3x1 --delta='1cm 0cm' --landscape --outfile /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HSUC_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}.pca.pdf
pdfjam /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_beforeshift_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}.count.pdf /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_20gens_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}.count.pdf /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_150gens_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}.count.pdf --nup 3x1 --delta='1cm 0cm' --landscape --outfile /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HSUC_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}.count.pdf
pdfjam /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_beforeshift_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}.freq.pdf /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_20gens_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}.freq.pdf /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_150gens_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}.freq.pdf --nup 3x1 --delta='1cm 0cm' --landscape --outfile /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HSUC_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}.freq.pdf
#pdfjam /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_beforeshift_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}.QTLeff.pdf /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_20gens_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}.QTLeff.pdf /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_150gens_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}.QTLeff.pdf --nup 3x1 --delta='1cm 0cm' --landscape --outfile /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HSUC_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}.QTLeff.pdf
pdfcrop --margins '10 10 10 10' /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HSUC_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}.pdf /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}.pdf
#pdfcrop --margins '10 10 10 10' /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HSUC_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}.dist.pdf /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}.dist.pdf
#pdfcrop --margins '10 10 10 10' /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HSUC_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}.pca.pdf /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}.pca.pdf
pdfcrop --margins '10 10 10 10' /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HSUC_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}.count.pdf /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}.count.pdf
pdfcrop --margins '10 10 10 10' /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HSUC_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}.freq.pdf /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}.freq.pdf
#pdfcrop --margins '10 10 10 10' /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HSUC_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}.QTLeff.pdf /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}.QTLeff.pdf
sips -s format jpeg /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}.pdf --out /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}.jpeg

# Removing old files
rm /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_beforeshift_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}*
rm /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_20gens_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}*
rm /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_150gens_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}*
rm /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HSUC_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}.pdf
#rm /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HSUC_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}.dist.pdf
#rm /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HSUC_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}.pca.pdf
rm /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HSUC_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}.count.pdf
rm /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HSUC_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}.freq.pdf
#rm /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HSUC_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}.QTLeff.pdf

# Sorting final files into requisite folders
if [ $SEL = "0" ]
then
	cp /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}* /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/neutral/
else
	if [ $DOM = "0.02" ]
	then
		cp /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}* /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/weakdom/
	elif [ $DOM = "0.2" ]
	then
		cp /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}* /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/strongdom/
	fi
fi
rm /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}*
