# 6th June 2022
# Plotting polygenic score associated with sample

# 15th June 2022
# Version for dealing with OCSC cases

library(RColorBrewer)
library(tidyverse)
library(cowplot)

args <- commandArgs(trailingOnly = TRUE)
s <- as.double(args[1])			# Selection coefficient, background mutations
h <- as.double(args[2])			# Dominance coefficient
N <- as.integer(args[3])		# Number of traits each QTL affects
msd <- as.double(args[4])		# Standard deviation of mutational effect
isnm <- as.integer(args[5])		# Is mutation stopped after optimum shift
stype <- as.integer(args[6])	# Optimum shift type
ocsc <- 1

pcol <- brewer.pal(n=4,name='Dark2')
pcol <- pcol[c(4,1)]


# Generating headings
if(s == 0){
	midh1 <- ", no background deleterious mutation. "
}else{
	midh1 <- paste0(" with background deleterious mutation (s = ",s,", h = ",h,"). ")
}

# For output headings	
if(N==1){
	endh1 <- "1 trait. "
}else{
	endh1 <- paste0(N," traits. ")
}

# For different mutation types
if(isnm==0){
	endp <- "Continuous mutation."
}else if(isnm==1){
	endp <- "No mutation after shift."
}

# For different optimum types
if(stype==0){
	endpb <- " Sudden optimum shift."
}else if(stype==1){
	endpb <- " Gradual optimum shift."
}

timelist <- c('time0','time1','time2','time3')
selflist <- c(0,0.999)
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
	if(inself==0){
		inocsc <- 1
	}else{
		inocsc <- 0
	}
	infos <- read_delim(paste0("/scratch/mhartfield/polyself_out/haps/polyself_out_s",s,"_h",h,"_self",inself,"_nt",N,"_msd",msd,"_isnm",isnm,"_stype",stype,"_ocsc",inocsc,"_",intime,"_rep",inrep,".info"),delim=" ")
	vcfin <- read_delim(paste0("/scratch/mhartfield/polyself_out/haps/polyself_out_s",s,"_h",h,"_self",inself,"_nt",N,"_msd",msd,"_isnm",isnm,"_stype",stype,"_ocsc",inocsc,"_",intime,"_rep",inrep,".vcf"),delim='\t',skip=12)[,c(2,8)] %>% filter(grepl("MT=3",INFO))
	outres[a,4] <- dim(vcfin)[1] # Number QTLs in sample
	infos <- infos[infos$POS%in%vcfin$POS,]

	FREQS <- vcfin %>% select(INFO) %>% apply(.,1,function(x) strsplit(x,split=";")) %>% lapply(.,function(x) strsplit(x[[1]][7],split="=")[[1]][2]) %>% unlist %>% as.numeric
	FREQS <- FREQS/100
	qtlfr <- cbind(vcfin[1],FREQS) %>% as_tibble
	qtlfr <- inner_join(qtlfr,infos) %>% mutate(pscore=FREQS*MeanQTL)
	outres[a,5:7] <- as_tibble_row(c(colMeans(qtlfr)[2:3],colSums(qtlfr)[4])) # Polygenic score for sample (and other metrics)
		
}

outres <- outres %>% 
	mutate(Time=as.character(Time)) %>%
	mutate(Time=case_when(
		Time=="time0" ~ "Before\nShift",
		Time=="time1" ~ "40\nGens",
		Time=="time2" ~ "300\nGens",
		Time=="time3" ~ "1000\nGens",
		)
	) %>% 
	mutate(Time=as.factor(Time)) %>%
	mutate(Time=fct_relevel(Time,"Before\nShift","40\nGens","300\nGens","1000\nGens"))

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

line_sz <- 1 	# Line thickness
mr <- 24
op1 <- ggplot(plottab,aes(x=Time,y=mps,group=Self,color=Self)) +
		geom_line(size=line_sz) +
		geom_point() + 
		geom_pointrange(aes(ymin=mps-mci,ymax=mps+mci),size=line_sz) + 
		labs(x="Timepoint",y="Polygenic\nScore",color="Self-Fertilisation Value:") +
		theme_bw(base_size=30) + 
		theme(plot.margin=margin(mr,mr,mr,mr)) +
		scale_color_manual(values = pcol)
		
op2 <- ggplot(NQtab,aes(x=Time,y=mNQ,group=Self,color=Self)) +
		geom_line(size=line_sz) +
		geom_point() + 
		geom_pointrange(aes(ymin=mNQ-NQci,ymax=mNQ+NQci),size=line_sz) + 
		labs(x="Timepoint",y="Mean Number\nof Mutations",color="Self-Fertilisation Value:") +
		theme_bw(base_size=30) + 
		theme(plot.margin=margin(mr,mr,mr,mr)) +
		scale_color_manual(values = pcol)

op3 <- ggplot(Frtab,aes(x=Time,y=mFr,group=Self,color=Self)) +
		geom_line(size=line_sz) +
		geom_point() + 
		geom_pointrange(aes(ymin=mFr-Frci,ymax=mFr+Frci),size=line_sz) + 
		labs(x="Timepoint",y="Mean\nMutation Frequency",color="Self-Fertilisation Value:") +
		theme_bw(base_size=30) + 
		theme(plot.margin=margin(mr,mr,mr,mr)) +
		scale_color_manual(values = pcol)

op4 <- ggplot(AEtab,aes(x=Time,y=mAE,group=Self,color=Self)) +
		geom_line(size=line_sz) +
		geom_point() + 
		geom_pointrange(aes(ymin=mAE-AEci,ymax=mAE+AEci),size=line_sz) + 
		labs(x="Timepoint",y="Mean\nMutation Effect",color="Self-Fertilisation Value:") +
		theme_bw(base_size=30) + 
		theme(plot.margin=margin(mr,mr,mr,mr)) +
		scale_color_manual(values = pcol)
		
# All together and printing to file
# See: https://wilkelab.org/cowplot/articles/shared_legends.html
title <- ggdraw() + draw_label(paste0("Polygenic score of sample (rescaled outcrossing case)",midh1,"\n",endh1,endp,endpb),fontface="bold",x=0,hjust=0,size=24)
opA <- plot_grid(op1 + theme(legend.position="none"),op2 + theme(legend.position="none"),op3 + theme(legend.position="none"),op4 + theme(legend.position="none"),labels=c('i','ii','iii','iv'),label_size=30)
leg_b <- get_legend(op1 + theme(legend.position="bottom"))
opB <- plot_grid(title,opA,leg_b,ncol=1,rel_heights=c(.075,1,.05))

gr <- (1+sqrt(5))/2
baseh = 12
ggsave(filename=paste0("/scratch/mhartfield/polyself_out/plots/haps/Pscore_s",s,"_h",h,"_nt",N,"_msd",msd,"_isnm",isnm,"_stype",stype,"_ocsc",ocsc,".pdf"),plot=opB,device="pdf",width=baseh*gr,height=baseh)
