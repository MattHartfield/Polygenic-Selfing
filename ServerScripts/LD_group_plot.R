# 9th Dec 2021
# Calculating LD score for each SNP in haploplot

library(tidyverse)
library(scales)

args <- commandArgs(trailingOnly = TRUE)
s <- as.double(args[1])			# Selection coefficient, background mutations
h <- as.double(args[2])			# Dominance coefficient
self <- as.double(args[3])		# Selfing rate
N <- as.integer(args[4])		# Number of traits each QTL affects
msd <- as.double(args[5])		# Standard deviation of mutational effect
isnm <- as.integer(args[6])		# Is mutation stopped after optimum shift
stype <- as.integer(args[7])	# Optimum shift type
ocsc <- as.integer(args[8])		# Is rescaled outcrossing type or not
k <- args[9]

maxd <- 12.5 		# Maximum distance to use (in Mb)
stopifnot(maxd<=25)
min_ee <- 10		# Minimum number of bin entries to be included in plot
filenames <- c('time0','time1','time2','time3')

for(i in 1:10){
	dat <- read_table2(paste0("/scratch/mhartfield/polyself_out/haps/polyself_out_s",s,"_h",h,"_self",self,"_nt",N,"_msd",msd,"_isnm",isnm,"_stype",stype,"_ocsc",ocsc,"_",k,"_rep",i,"_LD.hap.ld"))
	dat <- dat %>% mutate(DIST=POS2-POS1)
	dat <- dat %>% mutate(LEVEL=cut(dat$DIST,seq(0,25e6,50e4),right=F))
	
	# Can we count how many LD measurements there are? Can we normalise by smallest value?
	# Only look at part of the genetic distance
	# First check what the smallest bin size is within desired range
	
	dat <- dat %>% filter(DIST<=maxd*1e6)
	nbins <- length(unique(dat$LEVEL))
	dim_s <- vector(mode="numeric",length=nbins)
	for(j in 1:nbins){
		dim_s[j] <- dim(subset(dat,LEVEL==unique(dat$LEVEL)[j]))[1]
	}
	
	stopifnot(dim_s[1]>0)	# sanity check - stop if no entries in smallest bin
	min_e <- min(dim_s[which(dim_s!=0)])
	
	if(min_e >= min_ee)
	{
		# Then subsampling entries, first checking they're not zero
		dat2 <- sample_n(subset(dat,LEVEL==unique(dat$LEVEL)[1]),min_e,replace=F)
		for(j in 2:nbins){
			if(dim_s[j] != 0){
				dat2 <- rbind(dat2,sample_n(subset(dat,LEVEL==unique(dat$LEVEL)[j]),min_e,replace=F))
			}
		}
	
		dat2 <- cbind(dat2,i)
		names(dat2)[10] <- c("Rep")
	
		if(exists("mainres"))
		{
			mainres <- rbind(mainres,dat2)
		}else{
			mainres <- dat2
		}
	
	}
	
}

# Scaling distances to Mb
mainres <- mainres %>% mutate(DIST_MB=DIST/1e6)
mainres$Rep <- as.factor(mainres$Rep)

# Plotting LD decay (r^2 and Dprime)
mh <- switch(which(k==filenames),"Before Optimum Shift","40 Generations After","300 Generations After","1000 Generations After")
myp1 <- ggplot(mainres,aes(x=DIST_MB,y=`R^2`)) + 
	geom_point(aes(color=Rep),alpha=0.1) + 
	geom_smooth(aes(color=Rep)) + 
	geom_smooth(col='black',size=2,linetype="dashed", se=FALSE) + 
    scale_color_brewer(palette = "RdBu") + 
	labs(x="Distance (Mb)",y=expression(paste("Mean LD (",r^2,")")),title=mh) + 
	xlim(0,maxd) + 
	ylim(0,1) + 
	scale_x_continuous(labels=comma) + 
	theme_bw(base_size=36) + 
	theme(plot.title=element_text(hjust=0.5)) + 
	theme(legend.position="none")
	
myp2 <- ggplot(mainres,aes(x=DIST_MB,y=abs(Dprime))) + 
	geom_point(aes(color=Rep),alpha=0.1) + 
	geom_smooth(aes(color=Rep)) + 
	geom_smooth(col='black',size=2,linetype="dashed", se=FALSE) + 
    scale_color_brewer(palette = "RdBu") + 
	labs(x="Distance (Mb)",y="Mean LD (D', absolute value)",title=mh) + 
	xlim(0,maxd) + 
	ylim(0,1) + 
	scale_x_continuous(labels=comma) + 
	theme_bw(base_size=36) + 
	theme(plot.title=element_text(hjust=0.5)) + 
	theme(legend.position="none")

ggsave(filename=paste0("/scratch/mhartfield/polyself_out/plots/haps/LDDec_",k,"_s",s,"_h",h,"_self",self,"_nt",N,"_msd",msd,"_isnm",isnm,"_stype",stype,"_ocsc",ocsc,".pdf"),plot=myp1,device="pdf",width=12,height=12)

ggsave(filename=paste0("/scratch/mhartfield/polyself_out/plots/haps/LDDec_Dp_",k,"_s",s,"_h",h,"_self",self,"_nt",N,"_msd",msd,"_isnm",isnm,"_stype",stype,"_ocsc",ocsc,".pdf"),plot=myp2,device="pdf",width=12,height=12)
