# 27th July 2022
# Figure to show HOC variance under outcrossing (supp figure)

library(tidyverse)
library(RColorBrewer)
library(plyr)

pop <- 5000				# Population size
tchange <- 10*pop		# Time at which optimum changes
gr <- (1+sqrt(5))/2 	# Scaling ratio for plot outputs
msd <- 0.25				# Standard deviation of mutational effect
reps <- 10				# Number of replicates per parameter set
pcol <- brewer.pal(n=6,name='Dark2')[c(1:4,6)]

HoCVL <- 0.08			# Expected House Of Cards Variance (with mutation rate 4e-8)
HoCVS <- 0.008			# Expected House Of Cards Variance (with mutation rate 4e-9)

# Function for calculating mean
mnona <- function(x){
	return(mean(x,na.rm=T))
}

# Bootstrap 95% CI from list
bsCI_HoC <- function(x,bsr){
	
	bsm <- matrix(data=NA,nrow=bsr,ncol=nrow(x))
	for(i in 1:bsr)
	{
		bsl <- x[sample.int(length(x),length(x),replace=T)]
		bsm[i,] <- apply(bsl,1,mnona)
	}
	
	return(apply(bsm, 2, function(x) quantile(x,c(0.025,0.975),na.rm=T)))

}

# Setting up for rep 1
datL <- read_table2("/data/hartfield/polyself/analyses/data/polyself_out_s0_h0.02_self0_nt1_msd0.25_isnm0_stype0_ocsc0_rep1.dat")
maindtL <- subset(datL,Generation < tchange) %>% select(Generation,GenVar1)

datS <- read_table2("/data/hartfield/polyself/analyses/data/polyself_out_s0_h0.02_self0_nt1_msd0.25_isnm0_stype0_ocsc3_rep1.dat")
maindtS <- subset(datS,Generation < tchange) %>% select(Generation,GenVar1)

# Then getting other reps
for(i in 2:reps){
	datL <- read_table2(paste0("/data/hartfield/polyself/analyses/data/polyself_out_s0_h0.02_self0_nt1_msd0.25_isnm0_stype0_ocsc0_rep",i,".dat"))
	datS <- read_table2(paste0("/data/hartfield/polyself/analyses/data/polyself_out_s0_h0.02_self0_nt1_msd0.25_isnm0_stype0_ocsc3_rep",i,".dat"))	
	subdtL <- subset(datL,Generation < tchange) %>% select(GenVar1)
	subdtS <- subset(datS,Generation < tchange) %>% select(GenVar1)	
	maindtL <- cbind(maindtL,subdtL)
	maindtS <- cbind(maindtS,subdtS)
}

meanGVL <- apply(maindtL[,-1],1, mnona)
meanGVS <- apply(maindtS[,-1],1, mnona)

CI_GVL <- bsCI_HoC(maindtL[,-1],1000)
CI_GVS <- bsCI_HoC(maindtS[,-1],1000)

# output
pdf(file=paste0('/data/hartfield/polyself/results/HoC_Check.pdf'),width=8*gr,height=8)
plot(maindtL[,1],log(meanGVL),type='l',xlab="Generation Number",ylab="Genic Variance",xlim=c(8000,10000),ylim=c(-5,-2),col=pcol[1],lwd=3,cex.lab=1.5,cex.axis=1.5,yaxt="n")
axis(2,at=seq(-5,-2,0.5),labels=sprintf("%.3f",exp(seq(-5,-2,0.5))),cex.axis=1.5)
lines(maindtS[,1],log(meanGVS),col=pcol[2],lwd=3)
abline(h=log(HoCVL),lty=2,col=pcol[1],lwd=2)
abline(h=log(HoCVS),lty=2,col=pcol[2],lwd=2)
polygon(c(maindtL[,1],rev(maindtL[,1])),c(log(CI_GVL[1,]),rev(log(CI_GVL[2,]))),col=adjustcolor(pcol[1], alpha.f=0.35),border=F)
polygon(c(maindtS[,1],rev(maindtS[,1])),c(log(CI_GVS[1,]),rev(log(CI_GVS[2,]))),col=adjustcolor(pcol[2], alpha.f=0.35),border=F)
legend("right",legend=c("Baseline mutation rate","10-fold lower mutation rate"),lty=1,lwd=3,col=pcol[1:2],cex=1.5)
dev.off()
