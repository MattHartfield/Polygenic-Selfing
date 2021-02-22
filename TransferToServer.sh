#!/bin/sh
# 13th Dec 2019
# Transferring sim files to server using rsync

# 17th Mar 2020
# Creating replicate sims from base 'PolyselParameters' file

rm ServerScripts/PolyselParametersBig.txt ServerScripts/PolyselParametersPlots.txt
touch ServerScripts/PolyselParametersBig.txt
touch ServerScripts/PolyselParametersPlots.txt
NL=$(wc -l < ServerScripts/PolyselParameters.txt)
NREPS=10
for (( j=1; j <= NL; ++j ))
	do
	for (( i=1; i <= NREPS; ++i ))
	do
		# Adds extra parameters:
		# 1) determining whether mutation continues after burn-in (0) or whether it stops (1)
		# 2) Whether there is a sudden optimum shift (0) or gradual change (1)
		awk -v ln=${j} -v rep=${i} 'NR==ln{print $0 " 1 0 " rep}' ServerScripts/PolyselParameters.txt >> ServerScripts/PolyselParametersBig.txt
		awk -v ln=${j} -v rep=${i} 'NR==ln{print $0 " 1 1 " rep}' ServerScripts/PolyselParameters.txt >> ServerScripts/PolyselParametersBig.txt
	done
	if [ $(($j % 4)) -eq 1 ]
	then
		sed -n ${j}p ServerScripts/PolyselParameters.txt >> ServerScripts/PolyselParametersPlots.txt
	fi
done

rsync -avz /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/Polygenic_Selection_With_Selfing.slim /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/ServerScripts/* mhartfield@qmaster:/data/hartfield/polyself/scripts/
