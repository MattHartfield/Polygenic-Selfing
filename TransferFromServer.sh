#!/bin/sh
# 13th Dec 2019
# Transferring sim results files FROM server using rsync.

# 26th Feb 2020
# Not just download data but process haplotype data, merge separate plots into one file

# Download data from server
rm -r /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/*
rsync -avz mhartfield@qmaster:/data/hartfield/polyself/results/* /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/

# Processing haplotype plots
rm -r HapInfo
mkdir HapInfo
fds='neutral weakdom strongdom'
fsv='contmut stopmut'
fmu='lowmut highmut'	
for fd in $fds
do
	mkdir /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/$fd/
	for fs in $fsv
	do
		mkdir /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/$fd/$fs/
		for fm in $fmu
		do
			mkdir /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/$fd/$fs/$fm/
		done
	done
done
	
NP=$(wc -l < ServerScripts/PolyselParameters.txt)
NL=$(($NP/8))
RE=$(($NP%8))
for (( i=0; i < NL; ++i ))
do
echo "Running batch ${i}"
./HapsProcess.sh $((8*${i} + 1)) &> HapInfo/HapInfo$((8*${i} + 1)).out &
./HapsProcess.sh $((8*${i} + 2)) &> HapInfo/HapInfo$((8*${i} + 2)).out &
./HapsProcess.sh $((8*${i} + 3)) &> HapInfo/HapInfo$((8*${i} + 3)).out &
./HapsProcess.sh $((8*${i} + 4)) &> HapInfo/HapInfo$((8*${i} + 4)).out &
./HapsProcess.sh $((8*${i} + 5)) &> HapInfo/HapInfo$((8*${i} + 5)).out &
./HapsProcess.sh $((8*${i} + 6)) &> HapInfo/HapInfo$((8*${i} + 6)).out &
./HapsProcess.sh $((8*${i} + 7)) &> HapInfo/HapInfo$((8*${i} + 7)).out &
./HapsProcess.sh $((8*${i} + 8)) &> HapInfo/HapInfo$((8*${i} + 8)).out &
wait
done

echo "Running batch ${NL}"
for((j = 1; j <= RE; ++j))
do
./HapsProcess.sh $((8*${NL} + ${j})) &> HapInfo/HapInfo$((8*${NL} + ${j})).out &
done
wait

echo 'All data processed'
