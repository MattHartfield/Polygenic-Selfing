# 1st Apr 2020
# Plots QTL counts and mean effects per individual as histograms

args <- commandArgs(trailingOnly = TRUE)
s <- as.double(args[1])
h <- as.double(args[2])
S <- as.double(args[3])
N <- as.integer(args[4])
msd <- as.double(args[5])
isnm <- as.integer(args[6])
stype <- as.integer(args[7])
ocsc <- as.integer(args[8])

# Different plot file prefixes
pt <- c("time0","time1","time2","time3")

# 1: Number QTLs per individual
pdf(file=paste0('/Users/hartfield/Documents/Polygenic Selection Selfing/SLiM Scripts/OutputPlots/haps/HS_s',s,'_h',h,'_self',S,'_nt',N,'_msd',msd,'_isnm',isnm,'_stype',stype,'_ocsc',ocsc,'_count1.pdf'),width=40,height=10)
par(mfrow=c(1,length(pt)),mar = c(12.1, 12.1, 8.1, 2.1), mgp = c(5,3,0), oma=c(3,4,3,0))
for(i in 1:length(pt))
{		
	dat <- read.table(paste0("/Users/hartfield/Documents/Polygenic Selection Selfing/SLiM Scripts/OutputPlots/haps/HS_",pt[i],"_s",s,"_h",h,"_self",S,"_nt",N,"_msd",msd,"_isnm",isnm,"_stype",stype,"_ocsc",ocsc,".count"))	
	# QTL count, total effect per individual
	barplot(table(dat$V1),cex.names=5.0,cex.axis=5.0,cex.lab=5.0)
	title(paste0("Time ",i),line=3,cex.main=5)
}
mtext(text="Number of QTLs per individual",side=1,outer=T,cex=4)
mtext(text="Count",side=2,outer=T,cex=4)
dev.off()

# 2: Effect per individual
pdf(file=paste0('/Users/hartfield/Documents/Polygenic Selection Selfing/SLiM Scripts/OutputPlots/haps/HS_s',s,'_h',h,'_self',S,'_nt',N,'_msd',msd,'_isnm',isnm,'_stype',stype,'_ocsc',ocsc,'_count2.pdf'),width=40,height=10)
par(mfrow=c(1,length(pt)),mar = c(12.1, 12.1, 4.1, 2.1), mgp = c(5,3,0), oma=c(3,4,0,0))
for(i in 1:length(pt))
{
	dat <- read.table(paste0("/Users/hartfield/Documents/Polygenic Selection Selfing/SLiM Scripts/OutputPlots/haps/HS_",pt[i],"_s",s,"_h",h,"_self",S,"_nt",N,"_msd",msd,"_isnm",isnm,"_stype",stype,"_ocsc",ocsc,".count"))
	if(is.na(dat$V2[1])!=T){
		hist(dat$V2,col="gray70",xlab="",ylab="",main="",cex.lab=5.0,cex.axis=5.0)
	}else{
		cdat <- c(50)
		names(cdat) <- "NA"
		barplot(cdat,xlab="",ylab="",col="white",cex.names=5.0,cex.axis=5.0,cex.lab=5.0)
	}
}
mtext(text="Mean QTL effect per individual",side=1,outer=T,cex=4)
mtext(text="Count",side=2,outer=T,cex=4)
dev.off()

# 3: Effect per individual
pdf(file=paste0('/Users/hartfield/Documents/Polygenic Selection Selfing/SLiM Scripts/OutputPlots/haps/HS_s',s,'_h',h,'_self',S,'_nt',N,'_msd',msd,'_isnm',isnm,'_stype',stype,'_ocsc',ocsc,'_count3.pdf'),width=40,height=10)
par(mfrow=c(1,length(pt)),mar = c(12.1, 12.1, 4.1, 2.1), mgp = c(5,3,0), oma=c(3,4,0,0))
for(i in 1:length(pt))
{
	dat <- read.table(paste0("/Users/hartfield/Documents/Polygenic Selection Selfing/SLiM Scripts/OutputPlots/haps/HS_",pt[i],"_s",s,"_h",h,"_self",S,"_nt",N,"_msd",msd,"_isnm",isnm,"_stype",stype,"_ocsc",ocsc,".count"))
	# Counting how common genotypes are, based on number of QTLs and effect per individuals
	if(is.na(dat$V2[1])!=T){
		cdat <- vector(mode="numeric",length=dim(dat)[1])
		cdat <- rep(0,dim(dat)[1])
		cdat[1] <- 1
		names(cdat) = c(1:dim(dat)[1])
		for(k in 2:dim(dat)[1])
		{
			ismatch = 0
			for(j in 1:(k-1))
			{
				if(sum(dat[k,]==dat[j,])==2)
				{
					ismatch = 1
					break
				}
			}
			if(ismatch == 1)
			{
				cdat[which(names(cdat)==j)] <- cdat[which(names(cdat)==j)] + 1
			}else if(ismatch == 0)
			{
				cdat[which(names(cdat)==k)] <- cdat[which(names(cdat)==k)] + 1
			}
		}
		cdat <- cdat[cdat!=0]
		cdat <- sort(cdat,decreasing=T)
		names(cdat)=c(1:length(cdat))
	}
	
	if(is.na(dat$V2[1])!=T){
		barplot(cdat,xlab="",ylab="",cex.names=5.0,cex.axis=5.0,cex.lab=5.0)
	}else{
		cdat <- c(50)
		names(cdat) <- "NA"
		barplot(cdat,xlab="",ylab="",col="white",cex.names=5.0,cex.axis=5.0,cex.lab=5.0)
	}
}
mtext(text="Rank of genotype occurrence",side=1,outer=T,cex=4)
mtext(text="Count",side=2,outer=T,cex=4)
dev.off()

# 4: QTL frequency histogram
pdf(file=paste0('/Users/hartfield/Documents/Polygenic Selection Selfing/SLiM Scripts/OutputPlots/haps/HS_s',s,'_h',h,'_self',S,'_nt',N,'_msd',msd,'_isnm',isnm,'_stype',stype,'_ocsc',ocsc,'_freq.pdf'),width=40,height=10)
par(mfrow=c(1,length(pt)),mar = c(12.1, 12.1, 4.1, 2.1), mgp = c(5,3,0), oma=c(3,4,0,0))
for(i in 1:length(pt))
{
	dfreq <- read.table(paste0("/Users/hartfield/Documents/Polygenic Selection Selfing/SLiM Scripts/OutputPlots/haps/HS_",pt[i],"_s",s,"_h",h,"_self",S,"_nt",N,"_msd",msd,"_isnm",isnm,"_stype",stype,"_ocsc",ocsc,".freq"))
	if(is.na(dfreq$V2[1])!=T){
		barplot(table(dfreq$V2),xlab="",ylab="", cex.names=5.0, cex.axis=5.0, cex.lab=5.0)
	}else{
		dfreq <- c(1)
		names(dfreq) <- "NA"
		barplot(dfreq,xlab="",ylab="", col="white", cex.names=5.0, cex.axis=5.0, cex.lab=5.0, yaxt="n")
	}
}
mtext(text="QTL frequency",side=1,outer=T,cex=4)
mtext(text="Count",side=2,outer=T,cex=4)
dev.off()
