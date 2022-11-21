# README FOR POLYGENIC SELECTION UNDER SELFING SIMULATION FILES

Scripts used in the study "Polygenic selection to a changing optimum under self-fertilisation". Comments to m.hartfield@ed.ac.uk.

### Main Simulation

`Polygenic_Selection_With_Selfing.slim` is the main SLiM file used to perform simulations. It is currently set up to run via the command-line using the following to define the main parameters:

> slim -d s=(SEL) -d h=(DOM) -d sfrate=(SELF) -d nt=(NTR) -d rep=(REP) -d isnm=(ISNM) -d runtime=(RT) -d oc\_sc=(OCSC) -d stype=(STYPE) Polygenic\_Selection\_With\_Selfing.slim

Where the values in brackets represent input variables:
- (SEL) is the deleterious mutation selection coefficient (0 for neutral mutations)
- (DOM) is the dominance coefficient of deleterious mutations
- (SELF) is the fraction of reproductions that occur by self-fertiliastion
- (NTR) is...
