# 6th Feb 2024
# Code for calculating change in frequency for QTLs present in initial burn-in
# And how they relate to their fitness effects
# This one for all time points

library(tidyverse)
library(RColorBrewer)

args <- commandArgs(trailingOnly = TRUE)
s <- as.double(args[1])			# Selection coefficient, background mutations
h <- as.double(args[2])			# Dominance coefficient
self <- as.double(args[3])		# Selfing rate
N <- as.integer(args[4])		# Number of traits each QTL affects
msd <- as.double(args[5])		# Standard deviation of mutational effect
isnm <- as.integer(args[6])		# Is mutation stopped after optimum shift
stype <- as.integer(args[7])	# Optimum shift type
ocsc <- as.integer(args[8])		# Is rescaled outcrossing type or not
i <- 1

# Creating list of SNPs and frequencies over time
# for(i in 1:10)
# {
# Start with initial (pre-shift) timepoint
ttime0 <- read_delim(paste0("/data/hartfield/polyself/analyses/haps/polyself_out_s",s,"_h",h,"_self",self,"_nt",N,"_msd",msd,"_isnm",isnm,"_stype",stype,"_ocsc",ocsc,"_time0_rep",i,".info"),delim=" ")
ttime0a <- ttime0 %>% select(POS, MeanQTL,FREQ)
#ttime0x <- ttime0a %>% filter(!duplicated(POS)) %>% arrange(.,POS) # Removing those with duplicated position entries
ttime0x <- ttime0a %>% arrange(.,POS) # Removing those with duplicated position entries

# Now attaching all other timepoints, only retaining SNPs that appear at initial timepoint
ttime1 <- read_delim(paste0("/data/hartfield/polyself/analyses/haps/polyself_out_s",s,"_h",h,"_self",self,"_nt",N,"_msd",msd,"_isnm",isnm,"_stype",stype,"_ocsc",ocsc,"_time1_rep",i,".info"),delim=" ")
ttime1a <- ttime1 %>% select(POS,FREQ)
#ttime1a <- ttime1a %>% filter(!duplicated(POS))
ttime1x <- ttime1a[which(ttime1a$POS%in%ttime0a$POS),] %>% arrange(.,POS)
ttime_all <- left_join(ttime0x, ttime1x,by="POS")

ttime2 <- read_delim(paste0("/data/hartfield/polyself/analyses/haps/polyself_out_s",s,"_h",h,"_self",self,"_nt",N,"_msd",msd,"_isnm",isnm,"_stype",stype,"_ocsc",ocsc,"_time2_rep",i,".info"),delim=" ")
ttime2a <- ttime2 %>% select(POS,FREQ)
#ttime2a <- ttime2a %>% filter(!duplicated(POS))
ttime2x <- ttime2a[which(ttime2a$POS%in%ttime0a$POS),] %>% arrange(.,POS)
ttime_all <- left_join(ttime_all, ttime2x,by="POS")

ttime3 <- read_delim(paste0("/data/hartfield/polyself/analyses/haps/polyself_out_s",s,"_h",h,"_self",self,"_nt",N,"_msd",msd,"_isnm",isnm,"_stype",stype,"_ocsc",ocsc,"_time3_rep",i,".info"),delim=" ")
ttime3a <- ttime3 %>% select(POS,FREQ)
#ttime3a <- ttime3a %>% filter(!duplicated(POS))
ttime3x <- ttime3a[which(ttime3a$POS%in%ttime0a$POS),] %>% arrange(.,POS)
ttime_all <- left_join(ttime_all, ttime3x,by="POS")
	
names(ttime_all)[-c(1,2)] <- c("Time0", "Time1", "Time2", "Time3")
mainres <- replace_na(ttime_all,list("Time0"=0, "Time1"=0, "Time2"=0, "Time3"=0))
#mainres <- mainres %>% filter(Time3!=0)

# Loading QTLs and assigning colour based on direction, mean strength
hqc <- rev(brewer.pal(11,"RdBu")[1:5])
lqc <- brewer.pal(11,"RdBu")[7:11]
mainres <- mainres %>% mutate(QTLs=ifelse(MeanQTL>=0, ceiling(MeanQTL*8), ceiling(MeanQTL*(-8)) ))
mainres[mainres$QTLs>5,]$QTLs <- 5
mainres <- mainres %>% mutate(QTLcol=ifelse(MeanQTL>=0, hqc[QTLs], lqc[QTLs] ))
cols <- mainres$QTLcol
names(cols) <- mainres$POS
mainres <- mainres[,-c(7,8)]

mainres <- gather(mainres,"Timepoint","Frequency",-c(POS,MeanQTL))	# For plotting

# Plotting frequency difference
myp1 <- ggplot(mainres,aes(x=Timepoint,y=Frequency)) + 
	geom_line(aes(group=factor(POS),color=factor(POS))) + 
    scale_color_manual(values = cols) + 
	labs(x="Timepoint",y="Mutation Frequency") + 
	# xlim(0,maxd) + 
	# ylim(0,1) + 
	# scale_x_continuous(labels=comma) + 
	theme_bw(base_size=36) + 
	# theme(plot.title=element_text(hjust=0.5)) + 
	theme(legend.position="none")

ggsave(filename=paste0("/data/hartfield/polyself/results/haps/TimeChange_s",s,"_h",h,"_self",self,"_nt",N,"_msd",msd,"_isnm",isnm,"_stype",stype,"_ocsc",ocsc,"_AllTime.pdf"),plot=myp1,device="pdf",width=12,height=12)

# EOF