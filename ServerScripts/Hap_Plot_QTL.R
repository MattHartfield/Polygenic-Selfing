# 10th Sept 2020
# Plotting haplotypes, and distribution of QTLs

library(tidyverse)
library(RColorBrewer)

filenames <- c('beforeshift','20gens','150gens')

for(k in filenames){

	# Reading in and sorting data
	dat <- read_delim(paste0("VCFout_test_",k,".vcf"),delim='\t',skip=13)[,-c(1,3:9)] %>% column_to_rownames("POS")
	fc <- c()
	for(a in 0:49){
		if(a!=49){
			dat <- separate(dat,paste0("i",a),c(paste0("A",a),paste0("B",a),paste0("C",a),paste0("D",a),paste0("E",a)),sep="|") %>% select(c(paste0("B",0:a),paste0("D",0:a),paste0("i",(a+1):49)))
		}else{
			dat <- separate(dat,paste0("i",a),c(paste0("A",a),paste0("B",a),paste0("C",a),paste0("D",a),paste0("E",a)),sep="|") %>% select(c(paste0("B",0:a),paste0("D",0:a)))
		}
		fc <- c(fc,a,a+50)
	}
	dat <- dat[,fc+1]
	
	# Plotting heatmap of just polymorphisms. NOTE USE OF 'SCALE=NONE', IMPORTANT!!!!
	# heatmap(t(data.matrix(dat)),Colv=NA,Rowv=NA,col=c("white","black"),scale="none")
	
	# Loading QTLs and assigning colour based on direction, mean strength
	
	hqc <- brewer.pal(9,"Reds")[5:8]
	lqc <- brewer.pal(9,"Blues")[6:9]
	
	QTLd <- read_delim(paste0("VCFout_test_",k,".info"),delim=" ")
	QTLd <- QTLd[order(QTLd$POS),]
	mq <-  max(QTLd[QTLd$MeanQTL>0,2])
	minq <- min(QTLd[QTLd$MeanQTL<0,2])
	QTLd <- QTLd %>% mutate(QTLs=ifelse(MeanQTL>=0, ceiling(MeanQTL/mq*4), ceiling(MeanQTL/minq*4) )) %>% mutate(QTLcol=ifelse(MeanQTL>=0, hqc[QTLs], lqc[QTLs] ))
	
	plotc <- c("white","black")
	QTLc <- 2
	for(b in 1:dim(QTLd)[1]){
		if(length(which(row.names(dat)%in%QTLd[b,1]))!=0){
			dat[which(row.names(dat)%in%QTLd[b,1]),dat[which(row.names(dat)%in%QTLd[b,1]),]==1] <- QTLc
			plotc <- c(plotc,QTLd[b,4])
			QTLc <- QTLc + 1
		}
	}
	plotc <- unlist(plotc)
	
	# Creating sub matrix with stripped down entries; QTLs and other sites, no more than 100
	if(dim(dat)[1]>100){
		dat2 <- dat[sort(c( sample(which(rowSums(dat>=2)==0),100-length(which(rowSums(dat>=2)>0))), which(rowSums(dat>=2)>0) )),]
	}
	
	pdf(paste0("Hap_Plot_",k,".pdf"),width=12,height=12)
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