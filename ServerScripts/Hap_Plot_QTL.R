# 10th Sept 2020
# Plotting haplotypes, and distribution of QTLs

library(tidyverse)
library(RColorBrewer)

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
#	dat <- read_delim(paste0("VCFout_test_",k,".vcf"),delim='\t',skip=13)[,-c(1,3:9)] %>% column_to_rownames("POS")
	dat <- read_delim(paste0("/scratch/mhartfield/polyself_out/haps/polyself_out_s",s,"_h",h,"_self",self,"_nt",N,"_msd",msd,"_isnm",isnm,"_mscale",mscale,"_",k,".vcf"),delim='\t',skip=12)[,-c(1,3:9)] %>% column_to_rownames("POS")
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
	
	# Plotting heatmap of just polymorphisms without QTL colour coding. NOTE USE OF 'SCALE=NONE', IMPORTANT!!!!
	# heatmap(t(data.matrix(dat)),Colv=NA,Rowv=NA,col=c("white","black"),scale="none")
	
	# Loading QTLs and assigning colour based on direction, mean strength
	
	hqc <- rev(brewer.pal(11,"RdBu")[1:5])
	lqc <- brewer.pal(11,"RdBu")[7:11]
	
	QTLd <- read_delim(paste0("/scratch/mhartfield/polyself_out/haps/polyself_out_s",s,"_h",h,"_self",self,"_nt",N,"_msd",msd,"_isnm",isnm,"_mscale",mscale,"_",k,".info"),delim=" ")
	QTLd <- QTLd[order(QTLd$POS),]
#	mq <-  max(QTLd[QTLd$MeanQTL>0,2])
#	minq <- min(QTLd[QTLd$MeanQTL<0,2])
	QTLd <- QTLd %>% mutate(QTLs=ifelse(MeanQTL>=0, ceiling(MeanQTL*8), ceiling(MeanQTL*(-8)) ))
	QTLd[QTLd$QTLs>5,3] <- 5
	QTLd <- QTLd %>% mutate(QTLcol=ifelse(MeanQTL>=0, hqc[QTLs], lqc[QTLs] ))
	
	plotc <- c("white","black")
	QTLc <- 2
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
	
#	pdf(paste0("Hap_Plot_",k,".pdf"),width=12,height=12)
	pdf(paste0("/scratch/mhartfield/polyself_out/plots/haps/HS_",k,"_s",s,"_h",h,"_self",self,"_nt",N,"_msd",msd,"_isnm",isnm,"_mscale",mscale,".pdf"),width=12,height=12)
	heatmap(t(data.matrix(dat2)),Colv=NA,Rowv=NA,col=plotc,scale="none")
	dev.off()
	
}

# Debug unusual heatmap
#dat2 <- read.table("dat2_test.dat")
#heatmap(t(data.matrix(dat2)),Colv=NA,Rowv=NA,col=c("white","black","red"))

# Old code, did not sort/scale by QTL type, direction
# QTL info
# QTLd <- read_delim("VCFout_test_beforeshift.info",delim=" ")
# QTLd <- QTLd[order(QTLd$POS),]
# for(b in 1:dim(QTLd)[1]){
	# if(length(which(row.names(dat)%in%QTLd[b,1]))!=0){
# #		dat[which(row.names(dat)%in%QTLd[b,1]),dat[which(row.names(dat)%in%QTLd[b,1]),]==1] <- QTLd[b,2]
		# dat[which(row.names(dat)%in%QTLd[b,1]),dat[which(row.names(dat)%in%QTLd[b,1]),]==1] <- 2
	# }
# }
# #dat[dat==1] <- 0

# # Creating sub matrix with stripped down entries; QTLs and other sites, no more than 100
# if(dim(dat)[1]>100){
	# dat2 <- dat[sort(c( sample(which(rowSums(dat==2)==0),100-length(which(rowSums(dat==2)>0))), which(rowSums(dat==2)>0) )),]
# }

# # Heatmapping
# heatmap(t(data.matrix(dat2)),Colv=NA,Rowv=NA,col=c("white","black","red"),scale="none")