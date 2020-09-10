# 10th Sept 2020
# Plotting haplotypes, and distribution of QTLs

library(tidyverse)

# Reading in and sorting data
dat <- read_delim("VCFout_test_beforeshift.vcf",delim='\t',skip=13)[,-c(1,3:9)] %>% column_to_rownames("POS")
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

# Plotting heatmap
heatmap(t(data.matrix(dat)),Colv=NA,Rowv=NA,col=c("white","black"))

# QTL info
QTLd <- read_delim("VCFout_test_beforeshift.info",delim=" ")
QTLd <- QTLd[order(QTLd$POS),]
#datQ <- dat[1,]
for(b in 1:dim(QTLd)[1]){
	if(length(which(row.names(dat)%in%QTLd[b,1]))!=0){
		dat[which(row.names(dat)%in%QTLd[b,1]),dat[which(row.names(dat)%in%QTLd[b,1]),]==1] <- QTLd[b,2]
#		datQ <- rbind(datQ,dat[which(row.names(dat)%in%QTLd[b,1]),])
	}
}
dat[dat==1] <- 0
# Creating sub matrix with stripped down entries
dat[sort(c( sample(which(rowSums(data.matrix(dat))==0),95),which(rowSums(data.matrix(dat))!=0))),]->dat2
# Heatmapping
heatmap(t(data.matrix(dat2)),Colv=NA,Rowv=NA,scale="column",col=brewer.pal(11,"Blues"))