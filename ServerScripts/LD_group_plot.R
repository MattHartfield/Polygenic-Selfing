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

nbins <- 23		# How many to use in analyses (out of 50)
stopifnot(nbins<=50)
#midpoints <- seq(0,25e6-50e4,50e4) + 50e4/2
filenames <- c('time0','time1','time2','time3')

for(i in 1:10){
	dat <- read_table2(paste0("/scratch/mhartfield/polyself_out/haps/polyself_out_s",s,"_h",h,"_self",self,"_nt",N,"_msd",msd,"_isnm",isnm,"_stype",stype,"_ocsc",ocsc,"_",k,"_rep",i,"_LD.hap.ld"))
	dat <- dat %>% mutate(DIST=POS2-POS1)
	dat <- dat %>% mutate(LEVEL=cut(dat$DIST,seq(0,25e6,50e4),right=F))
	
	# Can we count how many LD measurements there are? Can we normalise by smallest value?
	# Only look at half the genome distance
	# First check what the smallest bin size is
	
	dim_s <- vector(mode="numeric",length=nbins)
	for(j in 1:nbins){
		dim_s[j] <- dim(subset(dat,LEVEL==unique(dat$LEVEL)[j]))[1]
	}
	
	stopifnot(dim_s[1]>0)	# sanity check - stop if no entries in smallest bin
	min_e <- min(dim_s[which(dim_s!=0)])
	
	# Then subsampling entries, first checking they're not zero
	dat2 <- sample_n(subset(dat,LEVEL==unique(dat$LEVEL)[1]),min_e,replace=F)
	for(j in 2:nbins){
		if(dim_s[j] != 0){
			dat2 <- rbind(dat2,sample_n(subset(dat,LEVEL==unique(dat$LEVEL)[j]),min_e,replace=F))
		}		
	}
	
	dat2 <- cbind(dat2,i)
	names(dat2)[10] <- c("Rep")
	
	if(i==1){
		mainres <- dat2
	}else{
		mainres <- rbind(mainres,dat2)
	}
	
}

# Scaling to Mb
#mainres <- mainres %>% mutate(dist_mid_mb=midp/1e6)
mainres <- mainres %>% mutate(DIST_MB=DIST/1e6)
mainres$Rep <- as.factor(mainres$Rep)

# Plotting LD decay
mh <- switch(which(k==filenames),"Before Optimum Shift","40 Generations After","300 Generations After","1000 Generations After")
myp <- ggplot(mainres,aes(x=DIST_MB,y=`R^2`,color=Rep)) + 
	geom_point(alpha=0.1) + 
	geom_smooth() + 
    scale_color_brewer(palette = "RdBu") + 
	labs(x="Distance (Mb)",y="Mean LD",title=mh) + 
	ylim(0,1) + 
	scale_x_continuous(labels=comma) + 
	theme_bw(base_size=36) + 
	theme(plot.title=element_text(hjust=0.5)) + 
	theme(legend.position="none")

ggsave(filename=paste0("/scratch/mhartfield/polyself_out/plots/haps/LDDec_",k,"_s",s,"_h",h,"_self",self,"_nt",N,"_msd",msd,"_isnm",isnm,"_stype",stype,"_ocsc",ocsc,".pdf"),plot=myp,device="pdf",width=12,height=12)
