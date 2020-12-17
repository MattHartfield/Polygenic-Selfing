# 8th Dec 2020
# Plotting haplotype density

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

dat <- read_table2(paste0("/scratch/mhartfield/polyself_out/haps/polyself_out_s",s,"_h",h,"_self",self,"_nt",N,"_msd",msd,"_isnm",isnm,"_mscale",mscale,"_",k,"_haps_MajorHap.dat"))
dat <- dat %>% mutate(BIN_MID=(BIN_START+BIN_END+1)/2) %>% mutate(HF=FREQ/100)
# Some bins have no SNPs in them so freq = NA; replace with freq = 1 as there is only one haplotype
dat$HF[which(is.na(dat$HF))] <- 1

myp <- ggplot(dat,aes(BIN_MID,HF)) +
	geom_line() +
	labs(x="Position",y="Frequency of most common haplotype") +
	theme_bw()
	
ggsave(filename=paste0("/scratch/mhartfield/polyself_out/plots/haps/MajH_",k,"_s",s,"_h",h,"_self",self,"_nt",N,"_msd",msd,"_isnm",isnm,"_mscale",mscale,".pdf"),plot=myp,device="pdf",width=12,height=12)

# EOF
