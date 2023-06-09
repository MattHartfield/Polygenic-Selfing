# 13th December 2019
# Script to read in polygenic selection simulation outputs and plot
# 'cu' = 'close-up' version, only plots after optimum shift

# 23rd July 2021
# OCSC version; plot outcrossing pops with rescaled parameters against highly selfing results

# Updated 9th June 2023 to look at pre-shift state (has burn-in caused steady-state in variance?)

library(RColorBrewer)
library(plyr)

pop <- 5000				# Population size
tchange <- 2*pop		# Time at which optimum changes
gr <- (1+sqrt(5))/2 	# Scaling ratio for plot outputs
msd <- 0.25				# Standard deviation of mutational effect

args <- commandArgs(trailingOnly = TRUE)
s <- as.double(args[1])			# Selection coefficient, background mutations
h <- as.double(args[2])			# Dominance coefficient
N <- as.integer(args[3])		# Number of traits each QTL affects
a <- as.integer(args[4])		# Does mutation continue after optimum shift
b <- as.integer(args[5])		# Shift type
ocsc <- as.integer(args[6])		# Using rescaled parameters in outcrossing or not
clup <- as.integer(args[7])		# Time window around which to plot close-up values

reps <- 10						# Number of replicates per parameter set
pcol <- brewer.pal(n=4,name='Dark2')
pcol <- pcol[c(4,1)]

# Function for calculating mean
mnona <- function(x){
	return(mean(x,na.rm=T))
}

# Bootstrap 95% CI from list
bslist <- function(x,bsr){
	
	bsm <- vector(mode="list",length=bsr)
	for(i in 1:bsr)
	{
		bsl <- x[sample.int(length(x),length(x),replace=T)]
		bsm[[i]] <- t(as.matrix(apply(rbind.fill.matrix(bsl), 2, mnona)))
	}
	
	return(apply(rbind.fill.matrix(bsm), 2, function(x) quantile(x,c(0.025,0.975),na.rm=T)))

}

# Generating headings
if(s == 0){
	midh1 <- ", no background deleterious mutation. "
}else{
	midh1 <- paste0(" with background deleterious mutation (s = ",s,", h = ",h,"). ")
}

# Output Folder
if(s == 0){
	outf <- "neutral"
}else if(s != 0){
	if(h == 0.2){
		outf <- "strongdom"
	}else if(h == 0.02){
		outf <- "weakdom"
	}
}

# For output headings	
if(N==1){
	endh1 <- "1 trait."
}else{
	endh1 <- paste0(N," traits.")
}

# Start of main plot code
endp <- " Continuous mutation."
endfn <- '_withmut'
outf2 <- "contmut"
		
endpb <- " Rescaled outcrossing parameters."
endfnb <- '_ocsc'
outf3 <- "ocsc"	

# Repeat twice: once for post-shift, once for checking end of burn-in
for(z in 1:2){
	
	if(z==1){
		xax <- c(0,clup+1)
		endfz <- '_mainshift'
	}else if(z==2){
		xax <- c(-0.2*tchange,0)
		endfz <- '_burnin'
	}

	# First plot: trait value, mean fitness, var fitness, inbreeding depression
	fitmat <- vector(mode="list",length=2)
	maxmt <- 0
	minmt <- 0
	maxmf <- 0
	minmf <- 1
	maxvf <- 0
	minvf <- 1
	maxid <- 0
	minid <- 0
	pdf(file=paste0('/scratch/mhartfield/polyself_out/plots/',outf,'/',outf2,'/',outf3,'/PolyselPlot_Fitness_T',N,'_sel',s,'_h',h,endfn,endfnb,endfz,'_ocsc',ocsc,'.pdf'),width=8*gr,height=8)
	par(mfrow=c(2,2),oma = c(0, 1, 4, 0))
	# First: read in data, determine x, y axes
	for(S in c(1,2))
	{
		genl <- vector(mode="list",length=reps)
		mtl <- vector(mode="list",length=reps)
		mfl <- vector(mode="list",length=reps)
		vfl <- vector(mode="list",length=reps)			
		idl <- vector(mode="list",length=reps)
		if(S == 1){
			dat <- read.table(paste0("/scratch/mhartfield/polyself_out/data/polyself_out_s",s,"_h",h,"_self0.999_nt",N,"_msd",msd,"_isnm",a,"_stype",b,"_ocsc0_rep",1,".dat"),head=T)
		}else{
			dat <- read.table(paste0("/scratch/mhartfield/polyself_out/data/polyself_out_s",s,"_h",h,"_self0_nt",N,"_msd",msd,"_isnm",a,"_stype",b,"_ocsc1_rep",1,".dat"),head=T)
		}
		if(z==1){
			dat <- dat[ intersect(which(dat$Generation <= (tchange + clup + 1)),which(dat$Generation >= tchange)),]
		}else if(z==2){
			dat <- dat[ which(dat$Generation <= tchange),]
		}
		genl[[1]] <- t(as.matrix(dat[,c("Generation")]-tchange))
		if(N==1)
		{
			mtl[[1]] <- t(as.matrix(dat[,c("MeanTrait1")]))
		}
		else
		{
			mtl[[1]] <- t(as.matrix(rowMeans(dat[,paste0("MeanTrait",1:N)])))
		}		
		mfl[[1]] <- t(as.matrix(dat[,c("MeanFitness")]))
		vfl[[1]] <- t(as.matrix(dat[,c("VarFitness")]))
		idl[[1]] <- t(as.matrix(dat[,c("InbreedingDepression")]))
		for(j in 2:reps)
		{	
			if(S == 1){
				dat <- read.table(paste0("/scratch/mhartfield/polyself_out/data/polyself_out_s",s,"_h",h,"_self0.999_nt",N,"_msd",msd,"_isnm",a,"_stype",b,"_ocsc0_rep",j,".dat"),head=T)
			}else{
				dat <- read.table(paste0("/scratch/mhartfield/polyself_out/data/polyself_out_s",s,"_h",h,"_self0_nt",N,"_msd",msd,"_isnm",a,"_stype",b,"_ocsc1_rep",j,".dat"),head=T)
			}
			if(z==1){
				dat <- dat[ intersect(which(dat$Generation <= (tchange + clup + 1)),which(dat$Generation >= tchange)),]
			}else if(z==2){
				dat <- dat[ which(dat$Generation <= tchange),]
			}
			genl[[j]] <- t(as.matrix(dat[,c("Generation")]-tchange))
			if(N==1)
			{
				mtl[[j]] <- t(as.matrix(dat[,c("MeanTrait1")]))
			}
			else
			{
				mtl[[j]] <- t(as.matrix(rowMeans(dat[,paste0("MeanTrait",1:N)])))
			}
			mfl[[j]] <- t(as.matrix(dat[,c("MeanFitness")]))
			vfl[[j]] <- t(as.matrix(dat[,c("VarFitness")]))				
			idl[[j]] <- t(as.matrix(dat[,c("InbreedingDepression")]))
		}
		mt <- apply(rbind.fill.matrix(mtl),2, mnona)
		mf <- apply(rbind.fill.matrix(mfl),2, mnona)
		vf <- apply(rbind.fill.matrix(vfl),2, mnona)			
		id <- apply(rbind.fill.matrix(idl),2, mnona)
		mtci <- bslist(mtl,1000)
		mfci <- bslist(mfl,1000)
		vfci <- bslist(vfl,1000)			
		idci <- bslist(idl,1000)
		ng <- dim(rbind(mt,mtci,mf,mfci,vf,vfci,id,idci))[2]
		for(j in 1:reps)
		{
			if(length(genl[[j]]) == ng)
			{
				break
			}
		}
		thisdat <- as.data.frame(t(rbind(genl[[j]],mt,mtci,mf,mfci,vf,vfci,id,idci)))
		colnames(thisdat) <- c("Generation","MeanTrait","MTLowCI","MTHighCI","MeanFitness","MFLowCI","MFHighCI","VarFitness","VFLowCI","VFHighCI","InbreedingDepression","IDLowCI","IDHighCI")
		fitmat[[which(c(1,2)%in%S)]] <- thisdat
		maxmt <- max(maxmt,max(thisdat$MTHighCI))
		minmt <- min(minmt,min(thisdat$MTLowCI))
		maxmf <- max(maxmf,max(thisdat$MFHighCI))
		minmf <- min(minmf,min(thisdat$MFLowCI))
		maxvf <- max(maxvf,max(thisdat$VFHighCI))
		minvf <- min(minvf,min(thisdat$VFLowCI))			
		maxid <- max(maxid,max(thisdat$IDHighCI))
		minid <- min(minid,min(thisdat$IDLowCI))
	}
	if(maxmf < 1){
		maxmf = 1
	}
	if(maxmt < 1/sqrt(N)){
		maxmt <- 1/sqrt(N)
	}

	# First: Mean trait value
	for(S in c(1,2))
	{
		if(S == 1){
			plot(fitmat[[S]]$Generation, fitmat[[S]]$MeanTrait,type='l',xlab="Time since optimum shift",ylab="Mean Trait Value",xlim=xax,ylim=c((minmt - ((maxmt-minmt)*0.04)), maxmt + ((maxmt-minmt)*0.04)),col=pcol[1],lwd=1.5,cex.lab=1.5,cex.axis=1.5)
			polygon(c(fitmat[[1]]$Generation,rev(fitmat[[1]]$Generation)),c(fitmat[[1]]$MTLowCI,rev(fitmat[[1]]$MTHighCI)),col=adjustcolor(pcol[1], alpha.f=0.35),border=F)
			abline(v=0,lty=2)
			abline(h=1/sqrt(N),lty=3,lwd=1.5)
			legend("bottomright",legend=c("S = 0.999", "S = 0 rescaled"),col=pcol,lty=1,lwd=1.5,cex=1.15,pt.cex=1)
		}
		else
		{
			lines(fitmat[[2]]$Generation,fitmat[[2]]$MeanTrait,col=pcol[2],lwd=1.5)
			polygon(c(fitmat[[2]]$Generation,rev(fitmat[[2]]$Generation)),c(fitmat[[2]]$MTLowCI,rev(fitmat[[2]]$MTHighCI)),col=adjustcolor(pcol[2], alpha.f=0.35),border=F)	
		}
	}
	
	# Second: plot mean fitness
	for(S in c(1,2))
	{	
		if(S == 1){
			plot(fitmat[[1]]$Generation,fitmat[[1]]$MeanFitness,type='l',xlab="Time since optimum shift",ylab="Mean Fitness",xlim=xax,ylim=c(minmf,maxmf),col=pcol[1],lwd=1.5,cex.lab=1.5,cex.axis=1.5)
			abline(v=0,lty=2)
			polygon(c(fitmat[[1]]$Generation,rev(fitmat[[1]]$Generation)),c(fitmat[[1]]$MFLowCI,rev(fitmat[[1]]$MFHighCI)),col=adjustcolor(pcol[1], alpha.f=0.35),border=F)
		}
		else
		{
			lines(fitmat[[2]]$Generation,fitmat[[2]]$MeanFitness,col=pcol[2],lwd=1.5)
			polygon(c(fitmat[[2]]$Generation,rev(fitmat[[2]]$Generation)),c(fitmat[[2]]$MFLowCI,rev(fitmat[[2]]$MFHighCI)),col=adjustcolor(pcol[2], alpha.f=0.35),border=F)
		}
	}
	
	# Third: plot inbreeding depression
	for(S in c(1,2))
	{
		if(S == 1){
			plot(fitmat[[1]]$Generation,fitmat[[1]]$InbreedingDepression,type='l',xlab="Time since optimum shift",ylab="Inbreeding Depression",xlim=xax,ylim=c(minid,maxid),col=pcol[1],lwd=1.5,cex.lab=1.5,cex.axis=1.5)
			abline(v=0,lty=2)
			polygon(c(fitmat[[1]]$Generation,rev(fitmat[[1]]$Generation)),c(fitmat[[1]]$IDLowCI,rev(fitmat[[1]]$IDHighCI)),col=adjustcolor(pcol[1], alpha.f=0.35),border=F)
		}
		else
		{
			lines(fitmat[[2]]$Generation,fitmat[[2]]$InbreedingDepression,col=pcol[2],lwd=1.5)
			polygon(c(fitmat[[2]]$Generation,rev(fitmat[[2]]$Generation)),c(fitmat[[2]]$IDLowCI,rev(fitmat[[2]]$IDHighCI)),col=adjustcolor(pcol[2], alpha.f=0.35),border=F)
		}
	}
	
	# Fourth: plot variance in fitness
	for(S in c(1,2))
	{	
		if(S == 1){
			plot(fitmat[[1]]$Generation,fitmat[[1]]$VarFitness,type='l',xlab="Time since optimum shift",ylab="Variance in Fitness",xlim=xax,ylim=c(minvf,maxvf),col=pcol[1],lwd=1.5,cex.lab=1.5,cex.axis=1.5)
			abline(v=0,lty=2)
			polygon(c(fitmat[[1]]$Generation,rev(fitmat[[1]]$Generation)),c(fitmat[[1]]$VFLowCI,rev(fitmat[[1]]$VFHighCI)),col=adjustcolor(pcol[1], alpha.f=0.35),border=F)
		}
		else
		{
			lines(fitmat[[2]]$Generation,fitmat[[2]]$VarFitness,col=pcol[2],lwd=1.5)
			polygon(c(fitmat[[2]]$Generation,rev(fitmat[[2]]$Generation)),c(fitmat[[2]]$VFLowCI,rev(fitmat[[2]]$VFHighCI)),col=adjustcolor(pcol[2], alpha.f=0.35),border=F)
		}
	}
	
	mtext(paste0("Fitness, inbreeding depression over time",midh1,endh1,"\n",endp,endpb), outer = TRUE, cex = 1.5)
	dev.off()

	# Second plot: genetic variance decomposition over time
	traitmat <- vector(mode="list",length=2)
	varmt <- 0
	varmi <- 1
	Gvarmt <- 0
	Gvarmi <- 1
	IBvarmt <- 0
	IBvarmi <- 1
	LDvarmt <- 0
	LDvarmi <- 1
	pdf(file=paste0('/scratch/mhartfield/polyself_out/plots/',outf,'/',outf2,'/',outf3,'/PolyselPlot_Traits_T',N,'_sel',s,'_h',h,endfn,endfnb,endfz,'_ocsc',ocsc,'.pdf'),width=8*gr,height=8)
	par(mfrow=c(2,2), oma = c(0, 1, 4, 0), mar = c(5.1, 6.1, 4.1, 2.1))
	for(S in c(1,2))
	{
		genl <- vector(mode="list",length=reps)
		mgvl <- vector(mode="list",length=reps)
		mgenvl <- vector(mode="list",length=reps)
		ibvl <- vector(mode="list",length=reps)
		ldvl <- vector(mode="list",length=reps)
		if(S == 1){
			dat <- read.table(paste0("/scratch/mhartfield/polyself_out/data/polyself_out_s",s,"_h",h,"_self0.999_nt",N,"_msd",msd,"_isnm",a,"_stype",b,"_ocsc0_rep",1,".dat"),head=T)
		}else{
			dat <- read.table(paste0("/scratch/mhartfield/polyself_out/data/polyself_out_s",s,"_h",h,"_self0_nt",N,"_msd",msd,"_isnm",a,"_stype",b,"_ocsc1_rep",1,".dat"),head=T)
		}
		if(z==1){
			dat <- dat[ intersect(which(dat$Generation <= (tchange + clup + 1)),which(dat$Generation >= tchange)),]
		}else if(z==2){
			dat <- dat[ which(dat$Generation <= tchange),]
		}		
		genl[[1]] <- t(as.matrix(dat[,c("Generation")]-tchange))
		if(N==1)
		{
			mgvl[[1]] <- t(as.matrix(dat[,c("GenVar1")]))
			mgenvl[[1]] <- t(as.matrix(dat[,c("GeneticVar1")]))
			ibvl[[1]] <- t(as.matrix(dat[,c("InbredVar1")]))
			ldvl[[1]] <- t(as.matrix(dat[,c("LDVar1")]))				
		}
		else
		{
			mgvl[[1]] <- t(as.matrix(rowMeans(dat[,paste0("GenVar",1:N)])))
			mgenvl[[1]] <- t(as.matrix(rowMeans(dat[,paste0("GeneticVar",1:N)])))
			ibvl[[1]] <- t(as.matrix(rowMeans(dat[,paste0("InbredVar",1:N)])))
			ldvl[[1]] <- t(as.matrix(rowMeans(dat[,paste0("LDVar",1:N)])))
		}		
		for(j in 2:reps)
		{
			if(S == 1){
				dat <- read.table(paste0("/scratch/mhartfield/polyself_out/data/polyself_out_s",s,"_h",h,"_self0.999_nt",N,"_msd",msd,"_isnm",a,"_stype",b,"_ocsc0_rep",j,".dat"),head=T)
			}else{
				dat <- read.table(paste0("/scratch/mhartfield/polyself_out/data/polyself_out_s",s,"_h",h,"_self0_nt",N,"_msd",msd,"_isnm",a,"_stype",b,"_ocsc1_rep",j,".dat"),head=T)
			}
			if(z==1){
				dat <- dat[ intersect(which(dat$Generation <= (tchange + clup + 1)),which(dat$Generation >= tchange)),]
			}else if(z==2){
				dat <- dat[ which(dat$Generation <= tchange),]
			}
			genl[[j]] <- t(as.matrix(dat[,c("Generation")]-tchange))
			if(N==1)
			{
				mgvl[[j]] <- t(as.matrix(dat[,c("GenVar1")]))
				mgenvl[[j]] <- t(as.matrix(dat[,c("GeneticVar1")]))
				ibvl[[j]] <- t(as.matrix(dat[,c("InbredVar1")]))
				ldvl[[j]] <- t(as.matrix(dat[,c("LDVar1")]))						
			}
			else
			{
				mgvl[[j]] <- t(as.matrix(rowMeans(dat[,paste0("GenVar",1:N)])))
				mgenvl[[j]] <- t(as.matrix(rowMeans(dat[,paste0("GeneticVar",1:N)])))
				ibvl[[j]] <- t(as.matrix(rowMeans(dat[,paste0("InbredVar",1:N)])))
				ldvl[[j]] <- t(as.matrix(rowMeans(dat[,paste0("LDVar",1:N)])))					
			}
		}
		mgv <- apply(rbind.fill.matrix(mgvl),2, mnona)
		mgenv <- apply(rbind.fill.matrix(mgenvl),2, mnona)
		ibv <- apply(rbind.fill.matrix(ibvl),2, mnona)
		ldv <- apply(rbind.fill.matrix(ldvl),2, mnona)			
		mgvci <- bslist(mgvl,1000)
		mgenvci <- bslist(mgenvl,1000)
		ibvci <- bslist(ibvl,1000)
		ldvci <- bslist(ldvl,1000)	
		ng2 <- dim(rbind(mgv,mgvci,mgenv,mgenvci,ibv,ibvci,ldv,ldvci))[2]
		for(j in 1:reps)
		{
			if(length(genl[[j]]) == ng2)
			{
				break
			}
		}
		thisdat <- as.data.frame(t(rbind(genl[[j]],mgv,mgvci,mgenv,mgenvci,ibv,ibvci,ldv,ldvci)))
		colnames(thisdat) <- c("Generation","MeanGenVar","MGVLowCI","MGVHighCI","MeanGeneticVar","MGenVLowCI","MGenVHighCI","MeanInbreedVar","MIBVLowCI","MIBVHighCI","MeanLDVar","MLDVLowCI","MLDVHighCI")
		traitmat[[which(c(1,2)%in%S)]] <- thisdat
		varmt <- max(varmt,max(thisdat$MGVHighCI))
		Gvarmt <- max(Gvarmt,max(thisdat$MGenVHighCI))
		IBvarmt <- max(IBvarmt,max(thisdat$MIBVHighCI))
		LDvarmt <- max(LDvarmt,max(thisdat$MLDVHighCI))
		IBvarmi <- min(IBvarmi,min(thisdat$MIBVLowCI))
		LDvarmi <- min(LDvarmi,min(thisdat$MLDVLowCI))
		if(min(thisdat$MGVLowCI) != 0){
			varmi <- min(varmi,min(thisdat$MGVLowCI))
		}
		if(min(thisdat$MGenVLowCI) != 0){
			Gvarmi <- min(Gvarmi,min(thisdat$MGenVLowCI))
		}
	}

	# Panel 1: Genetic variance	
	for(S in c(1,2))
	{
		if(S == 1){
			plot(traitmat[[1]]$Generation,traitmat[[1]]$MeanGeneticVar,type='l',xlab="Time since optimum shift",ylab="Mean Genetic Variance\nPer Trait",xlim=xax,ylim=c(Gvarmi*0.96, Gvarmt + ((Gvarmt)*0.04)),col=pcol[1],lwd=1.5,cex.lab=1.5,cex.axis=1.5)
			polygon(c(traitmat[[1]]$Generation,rev(traitmat[[1]]$Generation)),c(traitmat[[1]]$MGenVLowCI,rev(traitmat[[1]]$MGenVHighCI)),col=adjustcolor(pcol[1], alpha.f=0.35),border=F)
			abline(v=0,lty=2)
			legend("topright",legend=c("S = 0.999", "S = 0 rescaled"),col=pcol,lty=1,lwd=1.5,cex=1.15,pt.cex=1)
		}
		else
		{
			lines(traitmat[[2]]$Generation,traitmat[[2]]$MeanGeneticVar,col=pcol[2],lwd=1.5)
			polygon(c(traitmat[[2]]$Generation,rev(traitmat[[2]]$Generation)),c(traitmat[[2]]$MGenVLowCI,rev(traitmat[[2]]$MGenVHighCI)),col=adjustcolor(pcol[2], alpha.f=0.35),border=F)
		}
	}
	
	# Panel 2: Genic variance
	for(S in c(1,2))
	{
		if(S == 1){
			plot(traitmat[[1]]$Generation,traitmat[[1]]$MeanGenVar,type='l',xlab="Time since optimum shift",ylab="Mean Genic Variance\nPer Trait",xlim=xax,ylim=c(varmi*0.96, varmt + ((varmt)*0.04)),col=pcol[1],lwd=1.5,cex.lab=1.5,cex.axis=1.5)
			polygon(c(traitmat[[1]]$Generation,rev(traitmat[[1]]$Generation)),c(traitmat[[1]]$MGVLowCI,rev(traitmat[[1]]$MGVHighCI)),col=adjustcolor(pcol[1], alpha.f=0.35),border=F)
			abline(v=0,lty=2)
	#		points(x=0,y=HoCV,pch=4,cex=2,col=pcol[1])		# Expected HoC variance
		}
		else
		{
			lines(traitmat[[2]]$Generation,traitmat[[2]]$MeanGenVar,col=pcol[2],lwd=1.5)
			polygon(c(traitmat[[2]]$Generation,rev(traitmat[[2]]$Generation)),c(traitmat[[2]]$MGVLowCI,rev(traitmat[[2]]$MGVHighCI)),col=adjustcolor(pcol[2], alpha.f=0.35),border=F)
		}
	}
	
	# Panel 3: Inbreeding covariance
	for(S in c(1,2))
	{
		if(S == 1){
			plot(traitmat[[1]]$Generation,traitmat[[1]]$MeanInbreedVar,type='l',xlab="Time since optimum shift",ylab="Mean Inbreeding Covariance\nPer Trait",xlim=xax,ylim=c(IBvarmi*0.96, IBvarmt + ((IBvarmt)*0.04)),col=pcol[1],lwd=1.5,cex.lab=1.5,cex.axis=1.5)
			polygon(c(traitmat[[1]]$Generation,rev(traitmat[[1]]$Generation)),c(traitmat[[1]]$MIBVLowCI,rev(traitmat[[1]]$MIBVHighCI)),col=adjustcolor(pcol[1], alpha.f=0.35),border=F)
			abline(v=0,lty=2)
		}
		else
		{
			lines(traitmat[[2]]$Generation,traitmat[[2]]$MeanInbreedVar,col=pcol[2],lwd=1.5)
			polygon(c(traitmat[[2]]$Generation,rev(traitmat[[2]]$Generation)),c(traitmat[[2]]$MIBVLowCI,rev(traitmat[[2]]$MIBVHighCI)),col=adjustcolor(pcol[2], alpha.f=0.35),border=F)
		}
	}
	
	# Panel 4: LD covariance
	for(S in c(1,2))
	{
		if(S == 1){
			plot(traitmat[[1]]$Generation,traitmat[[1]]$MeanLDVar,type='l',xlab="Time since optimum shift",ylab="Mean LD Covariance\nPer Trait",xlim=xax,ylim=c(LDvarmi*0.96, LDvarmt + ((LDvarmt)*0.04)),col=pcol[1],lwd=1.5,cex.lab=1.5,cex.axis=1.5)
			polygon(c(traitmat[[1]]$Generation,rev(traitmat[[1]]$Generation)),c(traitmat[[1]]$MLDVLowCI,rev(traitmat[[1]]$MLDVHighCI)),col=adjustcolor(pcol[1], alpha.f=0.35),border=F)
			abline(v=0,lty=2)
		}
		else
		{
			lines(traitmat[[2]]$Generation,traitmat[[2]]$MeanLDVar,col=pcol[2],lwd=1.5)
			polygon(c(traitmat[[2]]$Generation,rev(traitmat[[2]]$Generation)),c(traitmat[[2]]$MLDVLowCI,rev(traitmat[[2]]$MLDVHighCI)),col=adjustcolor(pcol[2], alpha.f=0.35),border=F)
		}
	}
	
	mtext(paste0("Genetic variance over time",midh1,endh1,"\n",endp, endpb), outer = TRUE, cex = 1.5)
	dev.off()

	# Third plot: number of fixed mutants
	fixedm <- vector(mode="list",length=2)
	maxfix <- 0
	maxmQ <- 0
	minmQ <- 0
	maxpQ <- 0
	maxpmQ <- 0
	pdf(file=paste0('/scratch/mhartfield/polyself_out/plots/',outf,'/',outf2,'/',outf3,'/PolyselPlot_FixedMuts_T',N,'_sel',s,'_h',h,endfn,endfnb,endfz,'_ocsc',ocsc,'.pdf'),width=8*gr,height=8)
	par(mfrow=c(2,2), oma = c(0, 1, 4, 0), mar = c(5.1, 6.1, 4.1, 2.1))
	for(S in c(1,2))
	{
		genl <- vector(mode="list",length=reps)
		fixml <- vector(mode="list",length=reps)
		mfql <- vector(mode="list",length=reps)
		ppql <- vector(mode="list",length=reps)
		mpql <- vector(mode="list",length=reps)
		if(S == 1){
			dat <- read.table(paste0("/scratch/mhartfield/polyself_out/data/polyself_out_s",s,"_h",h,"_self0.999_nt",N,"_msd",msd,"_isnm",a,"_stype",b,"_ocsc0_rep",1,".dat"),head=T)
		}else{
			dat <- read.table(paste0("/scratch/mhartfield/polyself_out/data/polyself_out_s",s,"_h",h,"_self0_nt",N,"_msd",msd,"_isnm",a,"_stype",b,"_ocsc1_rep",1,".dat"),head=T)
		}
		if(z==1){
			dat <- dat[ intersect(which(dat$Generation <= (tchange + clup + 1)),which(dat$Generation >= tchange)),]
		}else if(z==2){
			dat <- dat[ which(dat$Generation <= tchange),]
		}
		genl[[1]] <- t(as.matrix(dat[,c("Generation")]-tchange))
		fixml[[1]] <- t(as.matrix(dat[,c("FixedMuts")]))
		if(N==1)
		{
			mfql[[1]] <- t(as.matrix(dat[,c("MeanFixedQTL1")]))
			ppql[[1]] <- t(as.matrix(dat[,c("PropPosQTL1")]))
			mpql[[1]] <- t(as.matrix(dat[,c("MeanPosQTL1")]))				
		}
		else
		{
			mfql[[1]] <- t(as.matrix(rowMeans(dat[,paste0("MeanFixedQTL",1:N)],na.rm=T)))
			ppql[[1]] <- t(as.matrix(rowMeans(dat[,paste0("PropPosQTL",1:N)],na.rm=T)))
			mpql[[1]] <- t(as.matrix(rowMeans(dat[,paste0("MeanPosQTL",1:N)],na.rm=T)))
		}
		for(j in 2:reps)
		{
			if(S == 1){
				dat <- read.table(paste0("/scratch/mhartfield/polyself_out/data/polyself_out_s",s,"_h",h,"_self0.999_nt",N,"_msd",msd,"_isnm",a,"_stype",b,"_ocsc0_rep",j,".dat"),head=T)
			}else{
				dat <- read.table(paste0("/scratch/mhartfield/polyself_out/data/polyself_out_s",s,"_h",h,"_self0_nt",N,"_msd",msd,"_isnm",a,"_stype",b,"_ocsc1_rep",j,".dat"),head=T)
			}
			if(z==1){
				dat <- dat[ intersect(which(dat$Generation <= (tchange + clup + 1)),which(dat$Generation >= tchange)),]
			}else if(z==2){
				dat <- dat[ which(dat$Generation <= tchange),]
			}
			genl[[j]] <- t(as.matrix(dat[,c("Generation")]-tchange))
			fixml[[j]] <- t(as.matrix(dat[,c("FixedMuts")]))
			if(N == 1)
			{
				mfql[[j]] <- t(as.matrix(dat[,c("MeanFixedQTL1")]))
				ppql[[j]] <- t(as.matrix(dat[,c("PropPosQTL1")]))
				mpql[[j]] <- t(as.matrix(dat[,c("MeanPosQTL1")]))
			}
			else
			{
				mfql[[j]] <- t(as.matrix(rowMeans(dat[,paste0("MeanFixedQTL",1:N)],na.rm=T)))
				ppql[[j]] <- t(as.matrix(rowMeans(dat[,paste0("PropPosQTL",1:N)],na.rm=T)))
				mpql[[j]] <- t(as.matrix(rowMeans(dat[,paste0("MeanPosQTL",1:N)],na.rm=T)))
			}
		}
		fixm <- apply(rbind.fill.matrix(fixml),2, mnona)
		mfq <- apply(rbind.fill.matrix(mfql),2, mnona)
		ppq <- apply(rbind.fill.matrix(ppql),2, mnona)
		mpq <- apply(rbind.fill.matrix(mpql),2, mnona)
		fixmci <- bslist(fixml,1000)
		mfqci <- bslist(mfql,1000)
		ppqci <- bslist(ppql,1000)
		mpqci <- bslist(mpql,1000)
		ng3 <- dim(rbind(fixm,fixmci,mfq,mfqci,ppq,ppqci,mpq,mpqci))[2]
		for(j in 1:reps)
		{
			if(length(genl[[j]]) == ng3)
			{
				break
			}
		}
		thisdat <- as.data.frame(t(rbind(genl[[j]],fixm,fixmci,mfq,mfqci,ppq,ppqci,mpq,mpqci)))
		colnames(thisdat) <- c("Generation","FixedMuts","FMLowCI","FMHighCI","MeanFixedQTL","MFQLowCI","MFQHighCI","MeanPropPos","MPPLowCI","MPPHighCI","MeanPosQTL","MPQLowCI","MPQHighCI")
		fixedm[[which(c(1,2)%in%S)]] <- thisdat
		maxfix <- max(maxfix,max(thisdat$FMHighCI))
		if(sum(!is.na(thisdat$MeanFixedQTL)) != 0){
			maxmQ <- max(maxmQ,max(thisdat$MFQHighCI,na.rm=T))
			minmQ <- min(minmQ,min(thisdat$MFQLowCI,na.rm=T))				
		}
		if(sum(!is.na(thisdat$MeanPropPos)) != 0){
			maxpQ <- max(maxpQ,max(thisdat$MPPHighCI,na.rm=T))
		}
		if(sum(!is.na(thisdat$MeanPosQTL)) != 0){			
			maxpmQ <- max(maxpmQ,max(thisdat$MPQHighCI,na.rm=T))
		}
				
	}
	
	# Panel 1: Number of fixed QTLs
	for(S in c(1,2)){
		if(S == 1){
			plot(fixedm[[1]]$Generation,fixedm[[1]]$FixedMuts,type='l',xlab="Time since optimum shift",ylab="Fixed Mutations",xlim=xax,ylim=c(0, maxfix),col=pcol[1],lwd=1.5,cex.lab=1.5,cex.axis=1.5)
			polygon(c(fixedm[[1]]$Generation,rev(fixedm[[1]]$Generation)),c(fixedm[[1]]$FMLowCI,rev(fixedm[[1]]$FMHighCI)),col=adjustcolor(pcol[1], alpha.f=0.35),border=F)
			abline(v=0,lty=2)
		}
		else
		{
			lines(fixedm[[2]]$Generation,fixedm[[2]]$FixedMuts,col=pcol[2],lwd=1.5)
			polygon(c(fixedm[[2]]$Generation,rev(fixedm[[2]]$Generation)),c(fixedm[[2]]$FMLowCI,rev(fixedm[[2]]$FMHighCI)),col=adjustcolor(pcol[2], alpha.f=0.35),border=F)
		}
	}
	# Panel 2: Mean effect of fixed QTLs
	for(S in c(1,2)){
		if(S == 1){
			plot(fixedm[[1]]$Generation,fixedm[[1]]$MeanFixedQTL,type='l',xlab="Time since optimum shift",ylab="Mean effect of fixed QTL",xlim=xax,ylim=c(minmQ, maxmQ),col=pcol[1],lwd=1.5,cex.lab=1.5,cex.axis=1.5)
			polygon(c(fixedm[[1]]$Generation,rev(fixedm[[1]]$Generation)),c(fixedm[[1]]$MFQLowCI,rev(fixedm[[1]]$MFQHighCI)),col=adjustcolor(pcol[1], alpha.f=0.35),border=F)
			abline(v=0,lty=2)
		}
		else
		{
			lines(fixedm[[2]]$Generation,fixedm[[2]]$MeanFixedQTL,col=pcol[2],lwd=1.5)
			polygon(c(fixedm[[2]]$Generation,rev(fixedm[[2]]$Generation)),c(fixedm[[2]]$MFQLowCI,rev(fixedm[[2]]$MFQHighCI)),col=adjustcolor(pcol[2], alpha.f=0.35),border=F)
		}
	}
	# Panel 3: Proportion of fixed QTLs with positive effects
	for(S in c(1,2)){
		if(S == 1){
			plot(fixedm[[1]]$Generation,fixedm[[1]]$MeanPropPos,type='l',xlab="Time since optimum shift",ylab="Mean proportion of\npositive-effect QTLs",xlim=xax,ylim=c(0, maxpQ),col=pcol[1],lwd=1.5,cex.lab=1.5,cex.axis=1.5)
			polygon(c(fixedm[[1]]$Generation,rev(fixedm[[1]]$Generation)),c(fixedm[[1]]$MPPLowCI,rev(fixedm[[1]]$MPPHighCI)),col=adjustcolor(pcol[1], alpha.f=0.35),border=F)
			abline(v=0,lty=2)
			legend("bottomright",legend=c("S = 0.999", "S = 0 rescaled"),col=pcol,lty=1,lwd=1.5,cex=1.15,pt.cex=1)
		}
		else
		{
			lines(fixedm[[2]]$Generation,fixedm[[2]]$MeanPropPos,col=pcol[2],lwd=1.5)
			polygon(c(fixedm[[2]]$Generation,rev(fixedm[[2]]$Generation)),c(fixedm[[2]]$MPPLowCI,rev(fixedm[[2]]$MPPHighCI)),col=adjustcolor(pcol[2], alpha.f=0.35),border=F)
		}
	}
	# Panel 4: Proportion of fixed QTLs with positive effects
	for(S in c(1,2)){
		if(S == 1){
			plot(fixedm[[1]]$Generation,fixedm[[1]]$MeanPosQTL,type='l',xlab="Time since optimum shift",ylab="Mean effect of positive fixed QTLs",xlim=xax,ylim=c(0, maxpmQ),col=pcol[1],lwd=1.5,cex.lab=1.5,cex.axis=1.5)
			polygon(c(fixedm[[1]]$Generation,rev(fixedm[[1]]$Generation)),c(fixedm[[1]]$MPQLowCI,rev(fixedm[[1]]$MPQHighCI)),col=adjustcolor(pcol[1], alpha.f=0.35),border=F)
			abline(v=0,lty=2)
		}
		else
		{
			lines(fixedm[[2]]$Generation,fixedm[[2]]$MeanPosQTL,col=pcol[2],lwd=1.5)
			polygon(c(fixedm[[2]]$Generation,rev(fixedm[[2]]$Generation)),c(fixedm[[2]]$MPQLowCI,rev(fixedm[[2]]$MPQHighCI)),col=adjustcolor(pcol[2], alpha.f=0.35),border=F)
		}
	}
	
	mtext(paste0("Number of fixed mutants",midh1,endh1,"\n",endp,endpb), outer = TRUE, cex = 1.5)
	dev.off()

}

quit(save="no")
