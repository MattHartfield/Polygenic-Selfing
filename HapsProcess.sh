#!/bin/sh
# 26th Feb 2020
# Script for compiling haplotype graphs
# So can process in parallel

SEL=$(sed -n $1p /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/ServerScripts/PolyselParameters.txt | awk '{print $1}')
DOM=$(sed -n $1p /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/ServerScripts/PolyselParameters.txt | awk '{print $2}')
SELF=$(sed -n $1p /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/ServerScripts/PolyselParameters.txt | awk '{print $3}')
# NEWOP=$(sed -n $1p /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/ServerScripts/PolyselParameters.txt | awk '{print $4}')
# if [ $NEWOP = "1.0" ]
# then
# 	NEWOP=$(printf "%.0f" $NEWOP)
# fi
NTR=$(sed -n $1p /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/ServerScripts/PolyselParameters.txt | awk '{print $4}')
MSD=$(sed -n $1p /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/ServerScripts/PolyselParameters.txt | awk '{print $5}')

#for ISSV in 0 1
for ISSV in 0
do
	# QTL Count plots
	Rscript /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/HapRCode/QTLCount.R ${SEL} ${DOM} ${SELF} ${NTR} ${MSD} ${ISSV}

	# Combining haplotype plots into one
# 	if [ $ISSV -eq 0 ]
# 	then
# 		pdfjam /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_time1_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}_issv${ISSV}.pdf /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_time2_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}_issv${ISSV}.pdf --nup 3x1 --delta='1cm 0cm' --landscape --outfile /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HSUC_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}_issv${ISSV}.pdf
# 		pdfjam /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_time1_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}_issv${ISSV}.count.pdf /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_time2_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}_issv${ISSV}.count.pdf --nup 3x1 --delta='1cm 0cm' --landscape --outfile /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HSUC_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}_issv${ISSV}.count.pdf
# 		pdfjam /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_time1_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}_issv${ISSV}.freq.pdf /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_time2_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}_issv${ISSV}.freq.pdf --nup 3x1 --delta='1cm 0cm' --landscape --outfile /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HSUC_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}_issv${ISSV}.freq.pdf
# 	fi
# 	if [ $ISSV -eq 1 ]
# 	then
# 		pdfjam /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_beforeshift_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}_issv${ISSV}.pdf /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_time1_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}_issv${ISSV}.pdf /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_time2_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}_issv${ISSV}.pdf --nup 3x1 --delta='1cm 0cm' --landscape --outfile /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HSUC_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}_issv${ISSV}.pdf
# 		pdfjam /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_beforeshift_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}_issv${ISSV}.count.pdf /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_time1_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}_issv${ISSV}.count.pdf /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_time2_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}_issv${ISSV}.count.pdf --nup 3x1 --delta='1cm 0cm' --landscape --outfile /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HSUC_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}_issv${ISSV}.count.pdf
# 		pdfjam /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_beforeshift_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}_issv${ISSV}.freq.pdf /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_time1_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}_issv${ISSV}.freq.pdf /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_time2_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}_issv${ISSV}.freq.pdf --nup 3x1 --delta='1cm 0cm' --landscape --outfile /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HSUC_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_msd${MSD}_issv${ISSV}.freq.pdf
# 	fi
	pdfjam /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_time0_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISSV}.pdf /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_time1_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISSV}.pdf /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_time2_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISSV}.pdf /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_time3_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISSV}.pdf --nup 4x1 --delta='1cm 0cm' --landscape --outfile /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HSUC_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISSV}.pdf
	pdfjam /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_time0_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISSV}.count.pdf /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_time1_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISSV}.count.pdf /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_time2_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISSV}.count.pdf /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_time3_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISSV}.count.pdf --nup 4x1 --delta='1cm 0cm' --landscape --outfile /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HSUC_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISSV}.count.pdf
	pdfjam /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_time0_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISSV}.freq.pdf /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_time1_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISSV}.freq.pdf /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_time2_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISSV}.freq.pdf /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_time3_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISSV}.freq.pdf --nup 4x1 --delta='1cm 0cm' --landscape --outfile /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HSUC_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISSV}.freq.pdf
	pdfcrop --margins '10 10 10 10' /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HSUC_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISSV}.pdf /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISSV}.pdf
	pdfcrop --margins '10 10 10 10' /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HSUC_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISSV}.count.pdf /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISSV}.count.pdf
	pdfcrop --margins '10 10 10 10' /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HSUC_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISSV}.freq.pdf /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISSV}.freq.pdf
	sips -s format jpeg /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISSV}.pdf --out /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISSV}.jpeg

	# Removing old files
# 	if [ $ISSV -eq 1 ]
# 	then
		
# 	fi
	rm /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_time0_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISSV}*
	rm /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_time1_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISSV}*
	rm /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_time2_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISSV}*
	rm /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_time3_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISSV}*	
	rm /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HSUC_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISSV}.pdf
	rm /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HSUC_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISSV}.count.pdf
	rm /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HSUC_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISSV}.freq.pdf

	# Sorting final files into requisite folders
	if [ $SEL = "0" ]
	then
		if [ $ISSV -eq 0 ]
		then
			cp /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISSV}* /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/neutral/contmut/
		elif [ $ISSV -eq 1 ]
		then
			cp /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISSV}* /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/neutral/stopmut/
		fi
	else
		if [ $DOM = "0.02" ]
		then
			if [ $ISSV -eq 0 ]
			then
				cp /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISSV}* /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/weakdom/contmut/
			elif [ $ISSV -eq 1 ]
			then
				cp /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISSV}* /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/weakdom/stopmut/
			fi			
		elif [ $DOM = "0.2" ]
		then
			if [ $ISSV -eq 0 ]
			then
				cp /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISSV}* /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/strongdom/contmut/
			elif [ $ISSV -eq 1 ]
			then
				cp /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISSV}* /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/strongdom/stopmut/
			fi
		fi
	fi
	rm /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISSV}*
done
