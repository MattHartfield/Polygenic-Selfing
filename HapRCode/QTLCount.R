# 1st Apr 2020
# Plots QTL counts and mean effects per individual as histograms

args <- commandArgs(trailingOnly = TRUE)
s <- as.double(args[1])
h <- as.double(args[2])
S <- as.double(args[3])
N <- as.integer(args[4])
msd <- as.double(args[5])
issv <- as.integer(args[6])

# Different plot file prefixes
# if(issv==0)
# {
	# pt <- c("20gens","150gens")
# }else if(issv==1)
# {

# }
pt <- c("time0","time1","time2","time3")

for(i in 1:length(pt))
{
	dat <- read.table(paste0("/Users/hartfield/Documents/Polygenic Selection Selfing/SLiM Scripts/OutputPlots/haps/HS_",pt[i],"_s",s,"_h",h,"_self",S,"_nt",N,"_msd",msd,"_isnm",issv,".count"))

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
		
	# QTL count, total effect per individual
	pdf(file=paste0('/Users/hartfield/Documents/Polygenic Selection Selfing/SLiM Scripts/OutputPlots/haps/HS_',pt[i],'_s',s,'_h',h,'_self',S,'_nt',N,'_msd',msd,'_isnm',issv,'.count.pdf'),width=18,height=42)
	par(mfrow=c(3,1),mar = c(5.1, 5.1, 4.1, 2.1))
	barplot(table(dat$V1),xlab="Number of QTLs per individual",ylab="Count",cex.names=2.3,cex.axis=2.5,cex.lab=2.5)
	if(is.na(dat$V2[1])!=T){
		hist(dat$V2,col="gray70",xlab="Mean QTL effect per individual",ylab="Count",main="",cex.lab=2.5,cex.axis=2.5)
		barplot(cdat,xlab="Rank of genotype occurrence",ylab="Count",cex.names=2.3,cex.axis=2.5,cex.lab=2.5)
	}else{
		cdat <- c(50)
		names(cdat) <- "NA"
		barplot(cdat,xlab="Mean QTL effect per individual",ylab="Count",col="white",cex.names=2.3,cex.axis=2.5,cex.lab=2.5)
		barplot(cdat,xlab="Rank of genotype occurrence",ylab="Count",col="white",cex.names=2.3,cex.axis=2.5,cex.lab=2.5)
	}
	dev.off()
	
	# QTL frequency histogram
	dfreq <- read.table(paste0("/Users/hartfield/Documents/Polygenic Selection Selfing/SLiM Scripts/OutputPlots/haps/HS_",pt[i],"_s",s,"_h",h,"_self",S,"_nt",N,"_msd",msd,"_isnm",issv,".freq"))
	pdf(file=paste0('/Users/hartfield/Documents/Polygenic Selection Selfing/SLiM Scripts/OutputPlots/haps/HS_',pt[i],'_s',s,'_h',h,'_self',S,'_nt',N,'_msd',msd,'_isnm',issv,'.freq.pdf'),width=12,height=12)
	par(mar = c(5.1, 5.1, 4.1, 2.1))
	if(is.na(dfreq$V2[1])!=T){
		barplot(table(dfreq$V2),xlab="QTL frequency",ylab="Count", cex.names=2.3, cex.axis=2.5, cex.lab=2.5)
	}else{
		dfreq <- c(1)
		names(dfreq) <- "NA"
		barplot(dfreq,xlab="QTL frequency",ylab="Count", col="white", cex.names=2.3, cex.axis=2.5, cex.lab=2.5, yaxt="n")
	}
	dev.off()
}
