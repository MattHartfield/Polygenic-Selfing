#!/bin/sh
# 26th Feb 2020
# Script for compiling haplotype graphs
# So can process in parallel

SEL=$(sed -n $1p /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/ServerScripts/PolyselParameters.txt | awk '{print $1}')
DOM=$(sed -n $1p /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/ServerScripts/PolyselParameters.txt | awk '{print $2}')
SELF=$(sed -n $1p /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/ServerScripts/PolyselParameters.txt | awk '{print $3}')
NEWOP=$(sed -n $1p /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/ServerScripts/PolyselParameters.txt | awk '{print $4}')
NTR=$(sed -n $1p /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/ServerScripts/PolyselParameters.txt | awk '{print $5}')
MVAR=$(sed -n $1p /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/ServerScripts/PolyselParameters.txt | awk '{print $6}')
pdfjam /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/ServerPlots/haps/HSBS_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_mvar${MVAR}.pdf /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/ServerPlots/haps/HSAS_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_mvar${MVAR}.pdf /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/ServerPlots/haps/HSE_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_mvar${MVAR}.pdf --nup 3x1 --delta='1cm 0cm' --landscape --outfile /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/ServerPlots/haps/HSUC_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_mvar${MVAR}.pdf
pdfjam /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/ServerPlots/haps/HSBS_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_mvar${MVAR}.dist.pdf /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/ServerPlots/haps/HSAS_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_mvar${MVAR}.dist.pdf /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/ServerPlots/haps/HSE_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_mvar${MVAR}.dist.pdf --nup 3x1 --delta='1cm 0cm' --landscape --outfile /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/ServerPlots/haps/HSUC_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_mvar${MVAR}.dist.pdf
pdfcrop --margins '10 10 10 10' /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/ServerPlots/haps/HSUC_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_mvar${MVAR}.pdf /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/ServerPlots/haps/HS_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_mvar${MVAR}.pdf
pdfcrop --margins '10 10 10 10' /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/ServerPlots/haps/HSUC_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_mvar${MVAR}.dist.pdf /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/ServerPlots/haps/HS_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_mvar${MVAR}.dist.pdf
rm -f /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/ServerPlots/haps/HSBS_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_mvar${MVAR}*
rm -f /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/ServerPlots/haps/HSAS_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_mvar${MVAR}*
rm -f /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/ServerPlots/haps/HSE_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_mvar${MVAR}*
rm -f /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/ServerPlots/haps/HSUC_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_mvar${MVAR}.pdf
rm -f /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/ServerPlots/haps/HSUC_s${SEL}_h${DOM}_self${SELF}_nt${NTR}_newo${NEWOP}_mvar${MVAR}.dist.pdf
