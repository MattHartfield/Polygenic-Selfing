#!/bin/sh
# 26th Feb 2020
# Script for compiling haplotype graphs
# So can process in parallel

SEL=$(sed -n $1p /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/ServerScripts/PolyselParameters.txt | awk '{print $1}')
DOM=$(sed -n $1p /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/ServerScripts/PolyselParameters.txt | awk '{print $2}')
SELF=$(sed -n $1p /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/ServerScripts/PolyselParameters.txt | awk '{print $3}')
NTR=$(sed -n $1p /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/ServerScripts/PolyselParameters.txt | awk '{print $4}')
ISNM=$(sed -n $1p /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/ServerScripts/PolyselParameters.txt | awk '{print $5}')
STYPE=$(sed -n $1p /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/ServerScripts/PolyselParameters.txt | awk '{print $6}')
OCSC=$(sed -n $1p /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/ServerScripts/PolyselParameters.txt | awk '{print $7}')
MSD=0.25

# QTL Count plots
Rscript /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/HapRCode/QTLCount.R ${SEL} ${DOM} ${SELF} ${NTR} ${MSD} ${ISNM} ${STYPE} ${OCSC}

# Combining haplotype plots into one
if [ $SEL = "0" ]
then
	pdfjam /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_time0_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}.pdf /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_time1_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}.pdf /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_time2_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}.pdf /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_time3_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}.pdf /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HapPlotLegend.pdf --nup 5x1 --delta='0.25cm 0cm' --landscape --outfile /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HSUC_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}.pdf
else
	pdfjam /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_time0_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}.pdf /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_time1_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}.pdf /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_time2_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}.pdf /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_time3_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}.pdf /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HapPlotLegendDel.pdf --nup 5x1 --delta='0.25cm 0cm' --landscape --outfile /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HSUC_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}.pdf
fi
pdfjam /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/LDP_time0_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}.pdf /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/LDP_time1_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}.pdf /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/LDP_time2_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}.pdf /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/LDP_time3_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}.pdf /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/LDPlotLegend.pdf --nup 5x1 --delta='0.25cm 0cm' --landscape --outfile /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/LDPUC_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}.pdf
pdfjam /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/LDDec_time0_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}.pdf /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/LDDec_time1_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}.pdf /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/LDDec_time2_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}.pdf /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/LDDec_time3_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}.pdf --nup 4x1 --delta='0.25cm 0cm' --landscape --outfile /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/LDDecUC_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}.pdf
pdfjam /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}_count1.pdf /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}_freq.pdf /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}_count2.pdf /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}_count3.pdf --nup 1x4 --delta='0cm 1cm' --landscape --outfile /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HSUC_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}.count.pdf
pdfcrop --margins 5 /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HSUC_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}.pdf /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}.pdf
pdfcrop --margins 5 /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/LDPUC_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}.pdf /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/LDP_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}.pdf
pdfcrop --margins 5 /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/LDDecUC_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}.pdf /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/LDDec_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}.pdf
pdfcrop --margins 5 /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HSUC_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}.count.pdf /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}.count.pdf

# Removing old files
rm /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_time0_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}*
rm /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_time1_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}*
rm /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_time2_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}*
rm /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_time3_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}*
rm /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/LDP_time0_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}.pdf
rm /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/LDP_time1_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}.pdf
rm /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/LDP_time2_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}.pdf
rm /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/LDP_time3_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}.pdf
rm /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/LDDec_time0_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}.pdf
rm /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/LDDec_time1_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}.pdf
rm /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/LDDec_time2_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}.pdf
rm /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/LDDec_time3_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}.pdf
rm /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}_count1.pdf
rm /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}_count2.pdf
rm /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}_count3.pdf	
rm /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}_freq.pdf
rm /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HSUC_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}.pdf
rm /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HSUC_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}.count.pdf
rm /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/LDPUC_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}.pdf
rm /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/LDDecUC_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}.pdf

# Sorting final files into requisite folders
if [ $SEL = "0" ]
then
	if [ $ISNM -eq 0 ]
	then
		if [ $STYPE -eq 0 ]
		then
			if [ $OCSC -eq 0 ]
			then
				cp /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}* /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/LDP_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}* /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/LDDec_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}* /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/neutral/contmut/ishift
			elif [ $OCSC -eq 1 ]
			then
				cp /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}* /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/LDP_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}* /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/LDDec_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}* /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/neutral/contmut/ocsc
			fi
		elif [ $STYPE -ne 0 ]
		then
			cp /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}* /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/LDP_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}* /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/LDDec_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}* /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/neutral/contmut/gshift
		fi
	elif [ $ISNM -eq 1 ]
	then
		if [ $STYPE -eq 0 ]
		then
			cp /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}* /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/LDP_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}* /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/LDDec_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}* /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/neutral/stopmut/ishift
		elif [ $STYPE -ne 0 ]
		then
			cp /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}* /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/LDP_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}* /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/LDDec_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}* /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/neutral/stopmut/gshift
		fi
	fi
else
	if [ $DOM = "0.02" ]
	then
		if [ $ISNM -eq 0 ]
		then
			if [ $STYPE -eq 0 ]
			then
				if [ $OCSC -eq 0 ]
				then
					cp /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}* /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/LDP_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}* /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/LDDec_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}* /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/weakdom/contmut/ishift
				elif [ $OCSC -eq 1 ]
				then
					cp /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}* /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/LDP_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}* /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/LDDec_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}* /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/weakdom/contmut/ocsc
				fi				
			elif [ $STYPE -ne 0 ]
			then
				cp /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}* /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/LDP_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}* /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/LDDec_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}* /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/weakdom/contmut/gshift
			fi
		elif [ $ISNM -eq 1 ]
		then
			if [ $STYPE -eq 0 ]
			then
				cp /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}* /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/LDP_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}* /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/LDDec_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}* /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/weakdom/stopmut/ishift
			elif [ $STYPE -ne 0 ]
			then
				cp /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}* /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/LDP_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}* /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/LDDec_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}* /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/weakdom/stopmut/gshift
			fi
		fi			
	elif [ $DOM = "0.2" ]
	then
		if [ $ISNM -eq 0 ]
		then
			if [ $STYPE -eq 0 ]
			then
				if [ $OCSC -eq 0 ]
				then
					cp /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}* /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/LDP_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}* /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/LDDec_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}* /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/strongdom/contmut/ishift
				elif [ $OCSC -eq 1 ]
				then
					cp /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}* /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/LDP_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}* /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/LDDec_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}* /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/strongdom/contmut/ocsc
				fi				
			elif [ $STYPE -ne 0 ]
			then
				cp /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}* /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/LDP_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}* /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/LDDec_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}* /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/strongdom/contmut/gshift
			fi
		elif [ $ISNM -eq 1 ]
		then
			if [ $STYPE -eq 0 ]
			then
				cp /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}* /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/LDP_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}* /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/LDDec_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}* /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/strongdom/stopmut/ishift
			elif [ $STYPE -ne 0 ]
			then
				cp /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}* /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/LDP_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}* /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/LDDec_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}* /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/strongdom/stopmut/gshift
			fi
		fi
	fi
fi

rm /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HS_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}* /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/LDP_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}* /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/LDDec_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_msd${MSD}_isnm${ISNM}_stype${STYPE}_ocsc${OCSC}*
