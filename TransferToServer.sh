#!/bin/sh
# 13th Dec 2019
# Transferring sim files to server using rsync

# 17th Mar 2020
# Creating replicate sims from base 'PolyselParameters' file

rm ServerScripts/PolyselParametersBig.txt ServerScripts/PolyselParametersPlots.txt ServerScripts/PolyselParametersBig_OCSC.txt
touch ServerScripts/PolyselParametersBig.txt
touch ServerScripts/PolyselParametersBig_OCSC.txt
touch ServerScripts/PolyselParametersPlots.txt

# 1: non-OCSC
NL=$(wc -l < ServerScripts/PolyselParameters.txt)
NREPS=10
for (( j=1; j <= NL; ++j ))
	do
	for (( i=1; i <= NREPS; ++i ))
	do
		# Adding rep number to each parameter set
		awk -v ln=${j} -v rep=${i} 'NR==ln{print $0 " "rep}' ServerScripts/PolyselParameters.txt >> ServerScripts/PolyselParametersBig.txt
	done
	SELF=$(sed -n ${j}p ServerScripts/PolyselParameters.txt | awk '{print $3}')
	if [ "$SELF" == 0 ]
	then
		sed -n ${j}p ServerScripts/PolyselParameters.txt >> ServerScripts/PolyselParametersPlots.txt
	fi
done

# 2: OCSC
NL2=$(wc -l < ServerScripts/PolyselParameters_OCSC.txt)
for (( j=1; j <= NL2; ++j ))
	do
	for (( i=1; i <= NREPS; ++i ))
	do
		# Adding rep number to each parameter set
		awk -v ln=${j} -v rep=${i} 'NR==ln{print $0 " "rep}' ServerScripts/PolyselParameters_OCSC.txt >> ServerScripts/PolyselParametersBig_OCSC.txt
	done
done

rsync -avz /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/Polygenic_Selection_With_Selfing.slim /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/ServerScripts/* mhartfield@qmaster:/data/hartfield/polyself/scripts/
