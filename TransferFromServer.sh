#!/bin/sh
# 13th Dec 2019
# Transferring sim results files FROM server using rsync.
rm /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/ServerPlots/*
rsync -avz mhartfield@qmaster:/data/hartfield/polyself/results/PolyselPlot_* /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/ServerPlots/