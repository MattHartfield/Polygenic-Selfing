#!/bin/sh
# 13th Dec 2019
# Transferring sim results files FROM server using rsync.

# 26th Feb 2020
# Not just download data but process haplotype data, merge separate plots into one file

# Download data from server
rm -r /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/ServerPlots/*
rsync -avz mhartfield@qmaster:/data/hartfield/polyself/results/* /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/ServerPlots/

# Processing haplotype plots
rm -r HapInfo
mkdir HapInfo
mkdir /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/ServerPlots/haps/neutral
mkdir /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/ServerPlots/haps/strongdom
mkdir /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/ServerPlots/haps/weakdom

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

for((j = 0; j < RE; ++j))
do
echo "Running batch ${NL}"
./HapsProcess.sh $((8*${NL} + ${j})) &
done
wait

echo 'All data processed'
