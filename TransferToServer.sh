#!/bin/sh
# 13th Dec 2019
# Transferring sim files to server using rsync

# 17th Mar 2020
# Creating replicate sims from base 'PolyselParameters' file

rm ServerScripts/PolyselParametersBig.txt
touch ServerScripts/PolyselParametersBig.txt
NL=$(wc -l < ServerScripts/PolyselParameters.txt)
NREPS=20
for (( j=1; j <= NL; ++j ))
	do
	for (( i=1; i <= NREPS; ++i ))
	do
		awk -v ln=${j} -v rep=${i} 'NR==1{print $0 " " rep}' ServerScripts/PolyselParameters.txt >> ServerScripts/PolyselParametersBig.txt
	done
done

rsync -avz /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/Polygenic_Selection_With_Selfing.slim /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/ServerScripts/* mhartfield@qmaster:/data/hartfield/polyself/scripts/
