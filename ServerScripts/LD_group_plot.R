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

midpoints <- seq(0,25e6-50e4,50e4) + 50e4/2
filenames <- c('time0','time1','time2','time3')
mainres <- data.frame(row.names=c("LEVEL","meanr2","midp","Rep"))

for(i in 1:10){
	dat <- read_table2(paste0("/scratch/mhartfield/polyself_out/haps/polyself_out_s",s,"_h",h,"_self",self,"_nt",N,"_msd",msd,"_isnm",isnm,"_stype",stype,"_ocsc",ocsc,"_",k,"_rep",i,"_LD.hap.ld"))
	dat <- dat %>% mutate(DIST=POS2-POS1)
	dat <- dat %>% mutate(LEVEL=cut(dat$DIST,seq(0,25e6,50e4),right=F))

	meanLD <- dat %>% group_by(LEVEL) %>% summarize(meanr2=mean(`R^2`))
	meanLD <- cbind(meanLD,midpoints[as.numeric(meanLD$LEVEL)],i)
	names(meanLD)[c(3,4)] <- c("midp","Rep")
	
	mainres <- rbind(mainres,meanLD)
}

# Removing long distances (> 20Mb) and scaling to Mb
mainres <- mainres %>% filter(midp<=20000000)
mainres <- mainres %>% mutate(distmb=midp/1e6)

# Plotting LD decay
mh <- switch(which(k==filenames),"Before Optimum Shift","40 Generations After","300 Generations After","1000 Generations After")
myp <- ggplot(mainres,aes(distmb,meanr2)) + 
	geom_point() + 
	geom_smooth() + 
	labs(x="Distance (Mb)",y="Mean LD",title=mh) + 
	ylim(0,1) + 
	scale_x_continuous(labels=comma) + 
	theme_bw(base_size=36) + 
	theme(plot.title=element_text(hjust=0.5))

ggsave(filename=paste0("/scratch/mhartfield/polyself_out/plots/haps/LDDec_",k,"_s",s,"_h",h,"_self",self,"_nt",N,"_msd",msd,"_isnm",isnm,"_stype",stype,"_ocsc",ocsc,".pdf"),plot=myp,device="pdf",width=12,height=12)

#ggsave("/data/hartfield/polyself/results/haps/test_point.pdf",p)
#ggsave(filename=paste0("/scratch/mhartfield/polyself_out/plots/haps/LDP_",k,"_s",s,"_h",h,"_self",self,"_nt",N,"_msd",msd,"_isnm",isnm,"_stype",stype,"_ocsc",ocsc,".pdf"),plot=myp,device="pdf",width=12,height=12)

#pdf("/data/hartfield/polyself/results/haps/test_point.pdf")
#plot(meanLD$midp,y=meanLD$meanr2)
#dev.off()

# TO DO:
# If desired, thin bins so same number of simulations/pairwise comparisons per distance
