# 6th June 2022
# Plotting polygenic score associated with sample

library(tidyverse)

# args <- commandArgs(trailingOnly = TRUE)
# s <- as.double(args[1])			# Selection coefficient, background mutations
# h <- as.double(args[2])			# Dominance coefficient
# self <- as.double(args[3])		# Selfing rate
# N <- as.integer(args[4])		# Number of traits each QTL affects
# msd <- as.double(args[5])		# Standard deviation of mutational effect
# isnm <- as.integer(args[6])		# Is mutation stopped after optimum shift
# stype <- as.integer(args[7])	# Optimum shift type
# ocsc <- as.integer(args[8])		# Is rescaled outcrossing type or not
# k <- args[9] 

# Uncomment to use test values
s <- 0
h <- 0.02
#self <- 0.99
N <- 5
msd <- 0.25
isnm <- 0
stype <- 0
ocsc <- 0
#k <- "time1"
#i <- 1

timelist <- c('time0','time1','time2','time3')
selflist <- c(0,0.5,0.9,0.99,0.999)
replist <- c(1:10)
outres <- cbind(expand.grid(timelist,selflist,replist),matrix(data=0,nrow=dim(expand.grid(timelist,selflist,replist))[1],ncol=4))
names(outres) <- c("Time","Self","Rep","NQTL","Mfr","MQTL","Pscore")
outres <- as_tibble(outres)

# calculating pscore per timepoint, selfing rate, simulation replicate

for(a in 1:dim(outres)[1]){
	
	intime <- timelist[as.numeric(outres[a,1])]
	inself <- outres[a,2]
	inrep <- outres[a,3]
	
	# Read in info, frequency files of quantitative trait variants
	infos <- read_delim(paste0("/scratch/mhartfield/polyself_out/haps/polyself_out_s",s,"_h",h,"_self",inself,"_nt",N,"_msd",msd,"_isnm",isnm,"_stype",stype,"_ocsc",ocsc,"_",intime,"_rep",inrep,".info"),delim=" ")
	vcfin <- read_delim(paste0("/scratch/mhartfield/polyself_out/haps/polyself_out_s",s,"_h",h,"_self",inself,"_nt",N,"_msd",msd,"_isnm",isnm,"_stype",stype,"_ocsc",ocsc,"_",intime,"_rep",inrep,".vcf"),delim='\t',skip=12)[,c(2,8)] %>% filter(grepl("MT=3",INFO))
	outres[a,4] <- dim(vcfin)[1] # Number QTLs in sample
	infos <- infos[infos$POS%in%vcfin$POS,]

	FREQS <- vcfin %>% select(INFO) %>% apply(.,1,function(x) strsplit(x,split=";")) %>% lapply(.,function(x) strsplit(x[[1]][7],split="=")[[1]][2]) %>% unlist %>% as.numeric
	FREQS <- FREQS/100
	qtlfr <- cbind(vcfin[1],FREQS) %>% as_tibble
	qtlfr <- inner_join(qtlfr,infos) %>% mutate(pscore=FREQS*MeanQTL)
	outres[a,5:7] <- as_tibble_row(c(colMeans(qtlfr)[2:3],colSums(qtlfr)[4])) # Polygenic score for sample (and other metrics)
		
}

# Calculating (i) mean of key values over replicates (ii) sd (iii) 95% CI, then plotting
# Number QTLs
NQtab <- outres %>% group_by(Time,Self) %>% summarize(mNQ=mean(NQTL),NQsd=sd(NQTL),NQci=qt(0.975,length(replist)-1)*sd(NQTL)/sqrt(length(replist)))
NQtab$Self <- as.factor(NQtab$Self)

# Mean frequency
Frtab <- outres %>% group_by(Time,Self) %>% summarize(mFr=mean(Mfr),Frsd=sd(Mfr),Frci=qt(0.975,length(replist)-1)*sd(Mfr)/sqrt(length(replist)))
Frtab$Self <- as.factor(Frtab$Self)

# Mean allele effect
AEtab <- outres %>% group_by(Time,Self) %>% summarize(mAE=mean(MQTL),AEsd=sd(MQTL),AEci=qt(0.975,length(replist)-1)*sd(MQTL)/sqrt(length(replist)))
AEtab$Self <- as.factor(AEtab$Self)

# Polygenic score
plottab <- outres %>% group_by(Time,Self) %>% summarize(mps=mean(Pscore),msd=sd(Pscore),mci=qt(0.975,length(replist)-1)*sd(Pscore)/sqrt(length(replist)))
plottab$Self <- as.factor(plottab$Self)

outplot <- ggplot(plottab,aes(x=Time,y=mps,ymin=mps-mci,ymax=mps+mci,color=Self)) +
		geom_pointrange() + 
		geom_point() + 
		geom_line() +
		labs(x="Timepoint",y="Mean Polygenic Score") +
		theme_bw(base_size=36)
		
ggsave(filename=paste0("/scratch/mhartfield/polyself_out/plots/haps/Pscore_s",s,"_h",h,"_nt",N,"_msd",msd,"_isnm",isnm,"_stype",stype,"_ocsc",ocsc,".pdf"),plot=outplot,device="pdf",width=12,height=12)

# Stopped 5pm 7th June 2022
# to do next:
## Clean up plots, nicer headings, legends etc
## Measure other properties of interest (number of qtls? mean frequencies?)
