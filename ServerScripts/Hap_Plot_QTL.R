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
stype <- as.integer(args[7])	# Optimum shift type
ocsc <- as.integer(args[8])		# Is rescaled outcrossing type or not
k <- args[9] 					# Which timepoint to use

filenames <- c('time0','time1','time2','time3')

# Reading in and sorting data
dat <- read_delim(paste0("/data/hartfield/polyself/analyses/haps/polyself_out_s",s,"_h",h,"_self",self,"_nt",N,"_msd",msd,"_isnm",isnm,"_stype",stype,"_ocsc",ocsc,"_",k,"_rep1.vcf"),delim='\t',skip=12)[,-c(1,3:7,9)] %>% column_to_rownames("POS")
if(s!=0){
	del_idx <- grep(paste0("S=",s),dat[,1]) # Indices of deleterious variants
}
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
if(s!=0){
	dat[del_idx,] <- apply(dat[del_idx,],c(1,2),function(x) ifelse(x==1,x<-2,x<-0))
}

# Loading QTLs and assigning colour based on direction, mean strength
hqc <- rev(brewer.pal(11,"RdBu")[1:5])
lqc <- brewer.pal(11,"RdBu")[7:11]

QTLd <- read_delim(paste0("/data/hartfield/polyself/analyses/haps/polyself_out_s",s,"_h",h,"_self",self,"_nt",N,"_msd",msd,"_isnm",isnm,"_stype",stype,"_ocsc",ocsc,"_",k,"_rep1.info"),delim=" ")
QTLd <- QTLd[order(QTLd$POS),]
QTLd <- QTLd %>% mutate(QTLs=ifelse(MeanQTL>=0, ceiling(MeanQTL*8), ceiling(MeanQTL*(-8)) ))
QTLd[QTLd$QTLs>5,]$QTLs <- 5
QTLd <- QTLd %>% mutate(QTLcol=ifelse(MeanQTL>=0, hqc[QTLs], lqc[QTLs] ))

plotc <- c(rgb(242,242,242,255,max=255),"gray60","black")		# RGB code of entries
QTLc <- 3
Qidx <- c()
for(b in 1:dim(QTLd)[1]){
	if(length(which(row.names(dat)%in%QTLd[b,1]))!=0){
		Qidx2 <- which(row.names(dat)%in%QTLd[b,1])
		dat[Qidx2,dat[Qidx2,]==1] <- QTLc
		plotc <- c(plotc,QTLd[b,]$QTLcol)
		Qidx <- c(Qidx,Qidx2)
		QTLc <- QTLc + 1
	}
}
plotc <- unlist(plotc)

# Separating QTLs into fixed, non-fixed
if(length(Qidx)!=0){
	if(length(which(rowSums(dat[Qidx,]!=0)==100))!=0){
		Qfx <- Qidx[which(rowSums(dat[Qidx,]!=0)==100)]
		Qnfx <- Qidx[-which(rowSums(dat[Qidx,]!=0)==100)]
	}else{
		Qfx <- Qidx[which(rowSums(dat[Qidx,]!=0)==100)]
		Qnfx <- Qidx
	}
}else{
	Qfx <- Qidx
	Qnfx <- Qidx		
}

# Creating sub matrix with stripped down entries; Selection of QTLs (up to 100) and other sites if space allows. No more than 100
if(dim(dat)[1]>100){ 
	if( (length(Qidx) >= 100) ){
		dat2 <- dat[sort( sample(Qidx, 100) ),]
	}else{
		dat2 <- dat[sort(c( sample( which(!(c(1:dim(dat)[1])%in%Qidx)) ,100-length(Qidx)), Qidx )),]
	}
}else{
	dat2 <- dat
}

# Second sub matrix, but omitting fixed mutations
if(dim(dat)[1]>100){ 
	if( (length(Qnfx) >= 100) ){
		dat3 <- dat[sort( sample(Qnfx, 100) ),]
	}else{
		dat3 <- dat[sort(c( sample( which(!(c(1:dim(dat)[1])%in%Qidx)) ,100-length(Qnfx)), Qnfx )),]
	}
}else{
	dat3 <- dat
}

# Re-ordering entry numbers, so heatmap plotting works correctly after thinning
unm <- sort(unique(as.numeric(as.matrix(dat2)))) # Unique entries of matrix after thinning
for(j in 0:(length(unm)-1)){
	if(unm[j+1]!=j){
		dat2[dat2==unm[j+1]] <- j
	}
}
plotc2 <- plotc[unm+1]

unm2 <- sort(unique(as.numeric(as.matrix(dat3)))) # Unique entries of matrix after thinning
for(j in 0:(length(unm2)-1)){
	if(unm2[j+1]!=j){
		dat3[dat3==unm2[j+1]] <- j
	}
}
plotc3 <- plotc[unm2+1]

## START OF PLOTS

# Plotting haplotype snapshot, both with and without fixed mutations
mh <- switch(which(k==filenames),"Before Optimum Shift","40 Generations After","300 Generations After","1000 Generations After")
pdf(paste0("/data/hartfield/polyself/results/haps/HS_",k,"_s",s,"_h",h,"_self",self,"_nt",N,"_msd",msd,"_isnm",isnm,"_stype",stype,"_ocsc",ocsc,".pdf"),width=12,height=12)
par(cex.main=3)
heatmap.2(t(data.matrix(dat2)),Colv=F,Rowv=F,dendrogram="none",col=plotc2,scale="none",trace="none",key=F,labRow=F,labCol=F,lwid=c(0.1,1),lhei=c(0.75,4),main=mh)
dev.off()

pdf(paste0("/data/hartfield/polyself/results/haps/HS_",k,"_s",s,"_h",h,"_self",self,"_nt",N,"_msd",msd,"_isnm",isnm,"_stype",stype,"_ocsc",ocsc,"_no_fixed.pdf"),width=12,height=12)
par(cex.main=3)
heatmap.2(t(data.matrix(dat3)),Colv=F,Rowv=F,dendrogram="none",col=plotc3,scale="none",trace="none",key=F,labRow=F,labCol=F,lwid=c(0.1,1),lhei=c(0.75,4),main=mh)
dev.off()

# Plotting LD
datLD <- read_table2(paste0("/data/hartfield/polyself/analyses/haps/polyself_out_s",s,"_h",h,"_self",self,"_nt",N,"_msd",msd,"_isnm",isnm,"_stype",stype,"_ocsc",ocsc,"_",k,"_rep1_LD.hap.ld"))
datLD <- datLD %>% mutate(POS1Mb=POS1/1e6,POS2Mb=POS2/1e6)

myp <- ggplot(datLD,aes(POS1Mb,POS2Mb,fill=`R^2`)) + 
	geom_tile(height=1.01,width=1.01,show.legend=F) +
	labs(x="Position (Mb)",y="Position (Mb)",title=mh) +
	xlim(0,25) +
	ylim(0,25) +
	theme_bw(base_size=36) + 
	theme(plot.title=element_text(hjust=0.5))
ggsave(filename=paste0("/data/hartfield/polyself/results/haps/LDP_",k,"_s",s,"_h",h,"_self",self,"_nt",N,"_msd",msd,"_isnm",isnm,"_stype",stype,"_ocsc",ocsc,".pdf"),plot=myp,device="pdf",width=12,height=12)

# Plotting distribution of trait effects (just for first trait if N > 1)
max_x <- (QTLd$QTL1 %>% abs %>% max)*1.1
myt <- ggplot(QTLd,aes(QTL1,FREQ)) + 
	geom_point(show.legend=F) +
	labs(x="Effect size, first trait",y="Frequency",title=mh) +
	xlim(-max_x, max_x) +
	ylim(0,1) +
	theme_bw(base_size=36) + 
	theme(plot.title=element_text(hjust=0.5))
ggsave(filename=paste0("/data/hartfield/polyself/results/haps/MutDFE_",k,"_s",s,"_h",h,"_self",self,"_nt",N,"_msd",msd,"_isnm",isnm,"_stype",stype,"_ocsc",ocsc,".pdf"),plot=myt,device="pdf",width=12,height=12)


# EOF