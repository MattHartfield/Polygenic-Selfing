# 10th August 2023
# Code for calculating change in frequency for QTLs present in initial burn-in
# And how they relate to their fitness effects

library(tidyverse)
args <- commandArgs(trailingOnly = TRUE)
s <- as.double(args[1])			# Selection coefficient, background mutations
h <- as.double(args[2])			# Dominance coefficient
self <- as.double(args[3])		# Selfing rate
N <- as.integer(args[4])		# Number of traits each QTL affects
msd <- as.double(args[5])		# Standard deviation of mutational effect
isnm <- as.integer(args[6])		# Is mutation stopped after optimum shift
stype <- as.integer(args[7])	# Optimum shift type
ocsc <- as.integer(args[8])		# Is rescaled outcrossing type or not

# Comparing time0 (end of burn-in) and time2 (as adaptation has [nearly] finished)
for(i in 1:10)
{
	ttime0 <- read_delim(paste0("/scratch/mhartfield/polyself_out/haps/polyself_out_s",s,"_h",h,"_self",self,"_nt",N,"_msd",msd,"_isnm",isnm,"_stype",stype,"_ocsc",ocsc,"_time0_rep",i,".info"),delim=" ")
	ttime2 <- read_delim(paste0("/scratch/mhartfield/polyself_out/haps/polyself_out_s",s,"_h",h,"_self",self,"_nt",N,"_msd",msd,"_isnm",isnm,"_stype",stype,"_ocsc",ocsc,"_time2_rep",i,".info"),delim=" ")
	
	ttime0a <- ttime0 %>% select(POS,FREQ,MeanQTL)
	ttime2a <- ttime2 %>% select(POS,FREQ,MeanQTL)
	
	# Removing those with duplicated position entries
	# (Need to work out why they appear in the first place!)
	ttime0a <- ttime0a %>% filter(!duplicated(POS))
	ttime2a <- ttime2a %>% filter(!duplicated(POS))
	
	# Finding overlapping entries
	ttime0x <- ttime0a[which(ttime0a$POS%in%ttime2a$POS),] %>% arrange(.,POS)
	ttime2x <- ttime2a[which(ttime2a$POS%in%ttime0a$POS),] %>% arrange(.,POS)
	
	# Combining timesteps and finding frequency difference
	tdiff <- add_column(ttime0x, ttime2x$FREQ,.before="MeanQTL",.name_repair="unique")
	names(tdiff)[3] <- "FREQt2"
	tdiff <- tdiff %>% mutate(FDIFF = FREQt2-FREQ)
	
	tdiff <- cbind(tdiff,i)
	names(tdiff)[6] <- c("Rep")
	
	if(exists("mainres"))
	{
		mainres <- rbind(mainres,tdiff)
	}else{
		mainres <- tdiff
	}
}
mainres$Rep <- as.factor(mainres$Rep)

# Plotting frequency difference
myp1 <- ggplot(mainres,aes(x=MeanQTL,y=FDIFF)) + 
	geom_point(aes(color=Rep)) + 
    scale_color_brewer(palette = "RdBu") + 
	labs(x="Mean Mutation Effect Size",y="Change in Mutation Frequency") + 
	# xlim(0,maxd) + 
	# ylim(0,1) + 
	# scale_x_continuous(labels=comma) + 
	theme_bw(base_size=36) + 
	# theme(plot.title=element_text(hjust=0.5)) + 
	theme(legend.position="none")

ggsave(filename=paste0("/scratch/mhartfield/polyself_out/plots/haps/TimeChange_s",s,"_h",h,"_self",self,"_nt",N,"_msd",msd,"_isnm",isnm,"_stype",stype,"_ocsc",ocsc,".pdf"),plot=myp1,device="pdf",width=12,height=12)

# EOF