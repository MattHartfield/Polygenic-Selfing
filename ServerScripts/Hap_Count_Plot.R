# 8th Dec 2020
# Plotting frequency of haplotypes

library(tidyverse)

args <- commandArgs(trailingOnly = TRUE)
s <- as.double(args[1])			# Selection coefficient, background mutations
h <- as.double(args[2])			# Dominance coefficient
self <- as.double(args[3])		# Selfing rate
N <- as.integer(args[4])		# Number of traits each QTL affects
msd <- as.double(args[5])		# Standard deviation of mutational effect
isnm <- as.integer(args[6])		# Is mutation stopped after optimum shift
mscale <- as.integer(args[7])	# Scaling of mutation rate
k <- args[8] 					# Which timepoint to use

hf <- count.fields(paste0("/scratch/mhartfield/polyself_out/haps/polyself_out_s",s,"_h",h,"_self",self,"_nt",N,"_msd",msd,"_isnm",isnm,"_mscale",mscale,"_",k,"_haps.hapcount"))
hfm <- max(hf)
hdat <- read.table(paste0("/scratch/mhartfield/polyself_out/haps/polyself_out_s",s,"_h",h,"_self",self,"_nt",N,"_msd",msd,"_isnm",isnm,"_mscale",mscale,"_",k,"_haps.hapcount"),col.names=paste0("V",seq_len(hfm)),skip=1,fill=T,as.is=T)
dat <- data.frame(BIN_START=hdat$V2,BIN_END=hdat$V3,H1=NA,HM=NA)
dat <- dat %>% mutate(BIN_MID=(BIN_START+BIN_END+1)/2e6) # Mid-point in terms of Mb
for(j in 1:length(hf))
{
	if(hf[j]>=7)
	{
		tx <- as.numeric(sapply(hdat[j,7:hf[j]],function(x) unlist(strsplit(x,":"))))
		dat[j,3] <- sum(tx[seq(1,length(tx)-1,2)]*(tx[seq(2,length(tx),2)]/100)^2)
		dat[j,4] <- tx[length(tx)]/100
	}else{
		# Some bins have no SNPs in them so no distinct haplotypes are formed; replace with freq = 1 as there is only one haplotype
		dat[j,3] <- 1
		dat[j,4] <- 1		
	}
}

#dat <- read_table2(paste0("/scratch/mhartfield/polyself_out/haps/polyself_out_s",s,"_h",h,"_self",self,"_nt",N,"_msd",msd,"_isnm",isnm,"_mscale",mscale,"_",k,"_haps_MajorHap.dat"))
#dat$HF[which(is.na(dat$HF))] <- 1

#myt <-  + theme(plot.margin=unit(c(5.5,10.5,5.5,5.5),unit="pt"))
#theme_set(myt)

myp <- ggplot(dat,aes(x=BIN_MID)) +
	geom_line(aes(y=H1),size=2) +
	geom_line(aes(y=HM),size=2,col="red") +
	labs(x="Position (Mb)",y="Haplotype Statistic") +
	ylim(0,1) +
	theme_bw(base_size=24)
	
ggsave(filename=paste0("/scratch/mhartfield/polyself_out/plots/haps/MajH_",k,"_s",s,"_h",h,"_self",self,"_nt",N,"_msd",msd,"_isnm",isnm,"_mscale",mscale,".pdf"),plot=myp,device="pdf",width=12,height=12)

# EOF
