# README FOR POLYGENIC SELECTION UNDER SELFING SIMULATION FILES

Scripts used in the study "Polygenic selection to a changing optimum under self-fertilisation". Comments to m.hartfield@ed.ac.uk.

### Main Simulation

`Polygenic_Selection_With_Selfing.slim` is the main [SLiM](https://messerlab.org/slim/ "SLiM") file used to perform simulations. It is currently set up to run via the command-line using the following to define the main parameters:

> slim -d s=${SEL} -d h=${DOM} -d sfrate=${SELF} -d nt=${NTR} -d rep=${REP} -d isnm=${ISNM} -d runtime=${RT} -d oc\_sc=${OCSC} -d stype=${STYPE} Polygenic\_Selection\_With\_Selfing.slim

Where the values in brackets represent input variables:
- $(SEL} is the deleterious mutation selection coefficient (0 for neutral mutations);
- $(DOM} is the dominance coefficient of deleterious mutations;
- $(SELF} is the fraction of reproductions that occur by self-fertilisation;
- $(NTR} denotes how pleiotropic mutations are (i.e., how many traits each quantitative allele affects);
- $(REP} is a number to denote which simulation replicate is running for that parameter set;
- $(ISNM} denotes whether mutation continues after the optimum shift (0 = yes, 1 = no);
- $(RT} is the number of generations (plus one) that the simulation runs for after the optimum shift;
- $(OCSC} determine whether to run a simulation assuming outcrossing but with rescaled parameters to reflect those under high selfing (0 = no, 1 = yes, 2  = a special case where mutation, recombination rates are reduced 10-fold for diagnostic purposes);
- $(STYPE} determines the nature of the optimum shift. 0 denotes an instant change, 1 for a gradual change.

Alternatively, if you look at the code you will see a set of commands that are commented out underneath the line `Uncomment if running on home machine; comment out otherwise`. If you remove these comments then this will allow the simulation to run on a local machine without the need for command-line parameters, so commands can be defined in the code itself. This is good for testing but not recommended for running replicate simulations.

### Scripts for plotting and data analyses

The folder `ServerScripts` contains scripts used to process resulting simulation outputs.

#### Parameter file

`PolyselParameters.txt` provides a file of parameters to use in simulations. Each column represents, from left to right, deleterious mutation selection coefficient (SEL); dominance coefficient (DOM); selfing fraction (SELF); pleiotropy level (NTR); whether mutation continues after the shift (ISNM); nature of optimum shift (STYPE); rescaled outcrossing parameter (OCSC).

#### R scripts

>Rscript Output\_Plot\_Server.R ${SEL} ${DOM} ${NTR} ${ISNM} ${STYPE} ${OCSC} ${CU}
>Rscript Output\_Plot\_Server\_OCSC.R ${SEL} ${DOM} ${NTR} ${ISNM} ${STYPE} ${OCSC} ${CU}

Produces plots of mean trait values; mean and variance in fitness; inbreeding depression; genetic variance components; properties of fixed mutations. Input parameters are as for the simulation; ${CU} denotes the maximum time post-optimum shift with which to plot results. `OCSC` version compares highly selfing case with rescaled outcrossing case. Hence, OCSC should be set to 0 in the first example and 1 in the second.

> Rscript Hap\_Plot\_QTL.R ${SEL} ${DOM} ${SELF} ${NTR} ${MSD} ${ISNM} ${STYPE} ${OCSC} ${fname}

Plots haplotype snapshots and properties of selected mutations. Input parameters are as for the simulation; ${fname} is one of `time0 time1 time2 time3` denoting different times when haplotypes were sampled.

> Rscript LD\_group\_plot.R ${SEL} ${DOM} ${SELF} ${NTR} ${MSD} ${ISNM} ${STYPE} ${OCSC} ${fname}

Plots LD decay over simulation replicates.

> Rscript Polygenic\_Score\_Calc.R ${SEL} ${DOM} ${NTR} ${MSD} ${ISNM} ${STYPE}
> Rscript Polygenic\_Score\_Calc_OCSC.R ${SEL} ${DOM} ${NTR} ${MSD} ${ISNM} ${STYPE}

Plots polygenic scores over time.

> Rscript HoCPlot.R

Plots genic variance and compares it to House-of-Cards expectation.

#### Shell scripts

For completeness I have also included the shell scripts (ending with .sh) that are used to run different parts of the simulations and analyses on the ClubAshworth computer cluster at the Institute of Ecology and Evolution at The University of Edinburgh. These will have to be modified if intended to be run on a different machine, and are included for archiving and illustrating simulation post-processing (e.g., for plotting haplotype information in 'Polyself\_Q\_Haps.sh').

### Local files

These are files that were located on the local machine (i.e., not a cluster) for post-processing and plotting of data.

#### Shell scripts

`TransferToServer.sh` and `TransferFromServer.sh` are shell files for transferring files to and from the computer cluster. The former modifies the parameter file so it can be used in different circumstances (e.g., adding replicates for simulations). The latter starts executing code to compile individual plots into individual files.

`HapsProcess.sh` runs code to compile plots using PdfJam. It uses the following scripts located in the `HapRCode` folder:

> Rscript LegendPlot.R 
> Rscript QTLCount.R ${SEL} ${DOM} ${SELF} ${NTR} ${MSD} ${ISNM} ${STYPE} ${OCSC}

Which (i) produces legends for use with composite plots, and (ii) outputs statistics of quantitative trait mutations (relating to number, effect and frequency).
