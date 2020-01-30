#!/bin/sh
# 13th Dec 2019
# Transferring sim results files FROM server using rsync.
rm -r /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/ServerPlots/*
rsync -avz mhartfield@qmaster:/data/hartfield/polyself/results/* /Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/ServerPlots/