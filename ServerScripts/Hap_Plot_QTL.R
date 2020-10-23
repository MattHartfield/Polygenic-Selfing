# 10th Sept 2020
# Plotting haplotypes, and distribution of QTLs

library(tidyverse)
library(RColorBrewer)
library(gplots)

args <- commandArgs(trailingOnly = TRUE)
s <- as.double(args[1])			# Selection coefficient, background mutations
h <- as.double(args[2])			# Dominance coefficient
self <- as.double(args[3])		# Selfing rate
N <- as.integer(args[4])		# Number of traits each QTL affects
msd <- as.double(args[5])		# Standard deviation of mutational effect
isnm <- as.integer(args[6])		# Is mutation stopped after optimum shift
mscale <- as.integer(args[7])	# Scaling of mutation rate

filenames <- c('time0','time1','time2','time3')

for(k in filenames){

	# Reading in and sorting data
	dat <- read_delim(paste0("/scratch/mhartfield/polyself_out/haps/polyself_out_s",s,"_h",h,"_self",self,"_nt",N,"_msd",msd,"_isnm",isnm,"_mscale",mscale,"_",k,".vcf"),delim='\t',skip=12)[,-c(1,3:7,9)] %>% column_to_rownames("POS")
	del_idx <- grep("MT=2",dat[,1]) # Indices of deleterious variants
	dat <- dat[,-1] # Removing INFO field
	fc <- c()
	for(a in 0:49){
		if(a!=49){
			dat <- separate(dat,paste0("i",a),c(paste0("X",a),paste0("A",a),paste0("Y",a),paste0("B",a),paste0("Z",a)),sep="|") %>% select(c(paste0("A",0:a),paste0("B",0:a),paste0("i",(a+1):49)))
		}else{
			dat <- separate(dat,paste0("i",a),c(paste0("X",a),paste0("A",a),paste0("Y",a),paste0("B",a),paste0("Z",a)),sep="|") %>% select(c(paste0("A",0:a),paste0("B",0:a)))
		}
		fc <- c(fc,a,a+50)
	}
	dat <- dat[,fc+1]
	# Replacing '1' with '2' to indicate deleterious variants
	dat[del_idx,] <- apply(dat[del_idx,],c(1,2),function(x) ifelse(x==1,x<-2,x<-0))
	
	# Loading QTLs and assigning colour based on direction, mean strength
	hqc <- rev(brewer.pal(11,"RdBu")[1:5])
	lqc <- brewer.pal(11,"RdBu")[7:11]
	
	QTLd <- read_delim(paste0("/scratch/mhartfield/polyself_out/haps/polyself_out_s",s,"_h",h,"_self",self,"_nt",N,"_msd",msd,"_isnm",isnm,"_mscale",mscale,"_",k,".info"),delim=" ")
	QTLd <- QTLd[order(QTLd$POS),]
	QTLd <- QTLd %>% mutate(QTLs=ifelse(MeanQTL>=0, ceiling(MeanQTL*8), ceiling(MeanQTL*(-8)) ))
	QTLd[QTLd$QTLs>5,3] <- 5
	QTLd <- QTLd %>% mutate(QTLcol=ifelse(MeanQTL>=0, hqc[QTLs], lqc[QTLs] ))
	
	plotc <- c(rgb(242,242,242,125,max=255),"gray60","black")
	QTLc <- 3
	Qidx <- c()
	for(b in 1:dim(QTLd)[1]){
		if(length(which(row.names(dat)%in%QTLd[b,1]))!=0){
			Qidx2 <- which(row.names(dat)%in%QTLd[b,1])
			dat[Qidx2,dat[Qidx2,]==1] <- QTLc
			plotc <- c(plotc,QTLd[b,4])
			Qidx <- c(Qidx,Qidx2)
			QTLc <- QTLc + 1
		}
	}
	plotc <- unlist(plotc)
	
	# Creating sub matrix with stripped down entries; QTLs and other sites, no more than 100
	if(dim(dat)[1]>100){
		if(length(Qidx) < 100){
			dat2 <- dat[sort(c( sample( which(!(c(1:dim(dat)[1])%in%Qidx)) ,100-length(Qidx)), Qidx )),]
		}else if(length(Qidx) >= 100){
			dat2 <- dat[sort( sample(Qidx, 100) ),]
		}
		
	}
	
	# Plotting 
	mh <- switch(which(k==filenames),"Time 1","Time 2","Time 3",'Time 4')
	pdf(paste0("/scratch/mhartfield/polyself_out/plots/haps/HS_",k,"_s",s,"_h",h,"_self",self,"_nt",N,"_msd",msd,"_isnm",isnm,"_mscale",mscale,".pdf"),width=12,height=12)
	#pdf(paste0("HS_",k,"_s",s,"_h",h,"_self",self,"_nt",N,"_msd",msd,"_isnm",isnm,"_mscale",mscale,".pdf"),width=12,height=12)
	par(cex.main=3)
	heatmap.2(t(data.matrix(dat2)),Colv=F,Rowv=F,dendrogram="none",col=plotc,scale="none",trace="none",key=F,labRow=F,labCol=F,lwid=c(0.1,1),lhei=c(0.75,4),main=mh)
	dev.off()

}


# EOF