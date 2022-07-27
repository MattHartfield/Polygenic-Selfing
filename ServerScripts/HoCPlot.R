# 27th July 2022
# Figure to show HOC variance under outcrossing (supp figure)

library(tidyverse)
library(RColorBrewer)
library(plyr)

pop <- 5000				# Population size
tchange <- 2*pop		# Time at which optimum changes
gr <- (1+sqrt(5))/2 	# Scaling ratio for plot outputs
msd <- 0.25				# Standard deviation of mutational effect
HoCV <- 0.08			# Expected House Of Cards Variance (with mutation rate 4e-8)
reps <- 10				# Number of replicates per parameter set
pcol <- brewer.pal(n=6,name='Dark2')[c(1:4,6)]

# Function for calculating mean
mnona <- function(x){
	return(mean(x,na.rm=T))
}

# Bootstrap 95% CI from list
bslist <- function(x,bsr){
	
	bsm <- vector(mode="list",length=bsr)
	for(i in 1:bsr)
	{
		bsl <- x[sample.int(length(x),length(x),replace=T)]
		bsm[[i]] <- t(as.matrix(apply(rbind.fill.matrix(bsl), 2, mnona)))
	}
	
	return(apply(rbind.fill.matrix(bsm), 2, function(x) quantile(x,c(0.025,0.975),na.rm=T)))

}

# Setting up for rep 1
dat <- read_table2("/scratch/mhartfield/polyself_out/data/polyself_out_s0_h0.02_self0_nt1_msd0.25_isnm0_stype0_ocsc0_rep1.dat")
maindt <- subset(dat,Generation < tchange) %>% select(Generation,GenVar1)

# Then getting other reps
for(i in 2:reps){
	dat <- read_table2(paste0("/scratch/mhartfield/polyself_out/data/polyself_out_s0_h0.02_self0_nt1_msd0.25_isnm0_stype0_ocsc0_rep",i,".dat"))
	subdt <- subset(dat,Generation < tchange) %>% select(GenVar1)
	maindt <- cbind(maindt,subdt)
}

meanGV <- apply(maindt[,-1],1, mnona)

# output
# pdf(file=paste0('/scratch/mhartfield/polyself_out/plots/',outf,'/',outf2,'/',outf3,'/PolyselPlot_Fitness_neutral_T',N,'_sel',s,'_h',h,endfn,endfnb,'_ocsc',ocsc,'.pdf'),width=8*gr,height=8)