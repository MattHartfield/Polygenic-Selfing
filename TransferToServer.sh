#!/bin/sh
# 13th Dec 2019
# Transferring sim files to server using rsync

# 17th Mar 2020
# Creating replicate sims from base 'PolyselParameters' file

rm ServerScripts/PolyselParametersBig.txt ServerScripts/PolyselParametersPlots.txt ServerScripts/PolyselParameters_OCSC.txt
touch ServerScripts/PolyselParametersBig.txt
touch ServerScripts/PolyselParametersPlots.txt
touch ServerScripts/PolyselParameters_OCSC.txt

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
	OCSC=$(sed -n ${j}p ServerScripts/PolyselParameters.txt | awk '{print $7}')
	if [ "$OCSC" == 1 ]
	then
		sed -n ${j}p ServerScripts/PolyselParameters.txt >> ServerScripts/PolyselParameters_OCSC.txt
	else
		if [ "$SELF" == 0 ]
		then
			sed -n ${j}p ServerScripts/PolyselParameters.txt >> ServerScripts/PolyselParametersPlots.txt
		fi
	fi
done

rsync -avz /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/Polygenic_Selection_With_Selfing.slim /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/ServerScripts/* mhartfield@qmaster:/data/hartfield/polyself/scripts/
