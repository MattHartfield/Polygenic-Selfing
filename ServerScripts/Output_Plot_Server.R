# 13th December 2019
# Script to read in polygenic selection simulation outputs and plot

# 24th Jan 2020
# Updated to take multiple traits into account

# 28th Jan 2020
# Plots several S values on the same graph

library(wesanderson)

tchange <- 25000	# Time at which optimum changes
gr <- (1+sqrt(5))/2 # Scaling ratio for plot outputs
z0 <- 1.0
mvar <- 0.25
self <- c(0,0.5,0.9,0.999)
no <- c(1,5,25)
sel <- matrix(data=NA,nrow=3,ncol=2)
sel[1,] <- c(0,0.02)
sel[2,] <- c(-0.02,0.02)
sel[3,] <- c(-0.02,0.2)
HoCV <- 4*0.028*0.1		# Expected House Of Cards Variance

for(i in 1:dim(sel)[1]){
	
	s <- sel[i,1]
	h <- sel[i,2]
	
	# Generating headings
	if(s == 0){
		midh1 <- ", no background deleterious mutation. "
	}else{
		midh1 <- paste0(" with background deleterious mutation (s = ",s,", h = ",h,"). ")
	}
	
	# Output Folder
	if(i == 1){
		outf <- "neutral"
	}else if(i == 2){
		outf <- "weakdom"
	}else if(i == 3){
		outf <- "strongdom"
	}

	for(N in no){

		if(N==1){
			endh1 <- "1 trait."
		}else{
			endh1 <- paste0(N," traits.")
		}

		# First plot: mean fitness, inbreeding depression
		fitmat <- vector(mode="list",length=length(self))
		maxgen <- 0
		maxmf <- 0
		minmf <- 1
		maxid <- 0
		minid <- 0
		pdf(file=paste0('/scratch/mhartfield/polyself_out/plots/',outf,'/PolyselPlot_Fitness_neutral_T',N,'_sel',s,'_h',h,'.pdf'),width=8*gr,height=8)
		par(mfrow=c(2,1),oma = c(0, 0, 2, 0))
		# First: read in data, determine x, y axes
		for(S in self)
		{
			dat <- read.table(paste0("/scratch/mhartfield/polyself_out/data/polyself_out_s",s,"_h",h,"_self",S,"_nt",N,"_newo",z0,"_mvar",mvar,".dat"),head=T)
			fitmat[[which(self%in%S)]] <- dat[,c("Generation","MeanFitness","InbreedingDepression")]
			maxgen <- max(maxgen,max(dat$Generation))
			maxmf <- max(maxmf,max(dat$MeanFitness))
			minmf <- min(minmf,min(dat$MeanFitness))
			maxid <- max(maxid,max(dat$InbreedingDepression))
			minid <- min(minid,min(dat$InbreedingDepression))
		}
		if(maxmf < 1){
			maxmf = 1
		}
		# Second: plot mean fitness
		for(S in self)
		{	
			if(which(self%in%S) == 1){
				plot(fitmat[[1]]$Generation,fitmat[[1]]$MeanFitness,type='l',xlab="Time",ylab="Mean Fitness",xlim=c(0,maxgen),ylim=c(minmf,maxmf),col=wes_palette(n=4, name="GrandBudapest1")[1],lwd=1.5)
				abline(v=tchange,lty=2)
				legend("bottomleft",legend=c("S = 0", "S = 0.5", "S = 0.9", "S = 0.999"),col=wes_palette(n=4, name="GrandBudapest1"),lty=1,cex=1,lwd=1.5)
			}else{
				lines(fitmat[[which(self%in%S)]]$Generation,fitmat[[which(self%in%S)]]$MeanFitness,col=wes_palette(n=4, name="GrandBudapest1")[which(self%in%S)],lwd=1.5)	
			}
		}
		# Third: plot inbreeding depression
		for(S in self)
		{
			if(which(self%in%S) == 1){
				plot(fitmat[[1]]$Generation,fitmat[[1]]$InbreedingDepression,type='l',xlab="Time",ylab="Inbreeding Depression",xlim=c(0,maxgen),ylim=c(minid,maxid),col=wes_palette(n=4, name="GrandBudapest1")[1],lwd=1.5)
				abline(v=tchange,lty=2)
			}else{
				lines(fitmat[[which(self%in%S)]]$Generation,fitmat[[which(self%in%S)]]$InbreedingDepression,col=wes_palette(n=4, name="GrandBudapest1")[which(self%in%S)],lwd=1.5)	
			}
		}
		
		mtext(paste0("Fitness, inbreeding depression over time",midh1,endh1), outer = TRUE, cex = 1.5)
		dev.off()
	
		# Second plot: trait values over time
		traitmat <- vector(mode="list",length=length(self))
		maxmt <- 0
		minmt <- 0
		varmt <- 0
		pdf(file=paste0('/scratch/mhartfield/polyself_out/plots/',outf,'/PolyselPlot_Traits_neutral_T',N,'_sel',s,'_h',h,'.pdf'),width=8*gr,height=8)
		par(mfcol=c(2,1),oma = c(0, 0, 2, 0))
		for(S in self)
		{
			dat <- read.table(paste0("/scratch/mhartfield/polyself_out/data/polyself_out_s",s,"_h",h,"_self",S,"_nt",N,"_newo",z0,"_mvar",mvar,".dat"),head=T)
			if(N == 1){
				tf <- dat[,c("Generation","MeanTrait1","GenVar1")]
			}else{
				tf <- cbind(dat[,c("Generation")],rowMeans(dat[,paste0("MeanTrait",1:N)]),rowMeans(dat[,paste0("GenVar",1:N)]))
			}
			tf <- as.data.frame(tf)
			colnames(tf) <- c("Generation","MeanTrait","MeanGenVar")
			traitmat[[which(self%in%S)]] <- tf
			maxmt <- max(maxmt,max(tf$MeanTrait))
			minmt <- min(minmt,min(tf$MeanTrait))
			varmt <- max(varmt,max(tf$MeanGenVar))
		}
		if(maxmt < z0){
			maxmt <- z0
		}
		for(S in self)
		{
			if(which(self%in%S) == 1){
				plot(traitmat[[which(self%in%S)]]$Generation,traitmat[[which(self%in%S)]]$MeanTrait,type='l',xlab="Time",ylab="Mean Trait Value",xlim=c(0,maxgen),ylim=c((minmt - ((maxmt-minmt)*0.04)), maxmt + ((maxmt-minmt)*0.04)),col=wes_palette(n=4, name="GrandBudapest1")[1],lwd=1.5)
				abline(v=tchange,lty=2)
				abline(h=0,lty=3,lwd=1.5)
				abline(h=z0,lty=2,lwd=1.5)
			}else{
				lines(traitmat[[which(self%in%S)]]$Generation,traitmat[[which(self%in%S)]]$MeanTrait,col=wes_palette(n=4, name="GrandBudapest1")[which(self%in%S)],lwd=1.5)	
			}
		}
		for(S in self)
		{
			if(which(self%in%S) == 1){
				plot(traitmat[[which(self%in%S)]]$Generation,traitmat[[which(self%in%S)]]$MeanGenVar,type='l',xlab="Time",ylab="Mean Genetic Variance Per Trait",xlim=c(0,maxgen),ylim=c((-((varmt)*0.04)), varmt + ((varmt)*0.04)),col=wes_palette(n=4, name="GrandBudapest1")[1],lwd=1.5)
				abline(v=tchange,lty=2)
				abline(h=HoCV,lty=2)		# Expected HoC variance
				legend("topleft",legend=c("S = 0", "S = 0.5", "S = 0.9", "S = 0.999"),col=wes_palette(n=4, name="GrandBudapest1"),lty=1,cex=1,lwd=1.5)
			}else{
				lines(traitmat[[which(self%in%S)]]$Generation,traitmat[[which(self%in%S)]]$MeanGenVar,col=wes_palette(n=4, name="GrandBudapest1")[which(self%in%S)],lwd=1.5)	
			}
		}

		mtext(paste0("Trait values over time",midh1,endh1), outer = TRUE, cex = 1.5)
		dev.off()
	
		# Third plot: number of fixed mutants
		fixedm <- vector(mode="list",length=length(self))
		maxfix <- 0
		maxmQ <- 0
		minmQ <- 0
		maxpQ <- 0
		maxpmQ <- 0
		pdf(file=paste0('/scratch/mhartfield/polyself_out/plots/',outf,'/PolyselPlot_FixedMuts_neutral_T',N,'_sel',s,'_h',h,'.pdf'),width=8*gr,height=8)
		par(mfrow=c(2,2),oma = c(0, 0, 2, 0))
		for(S in self)
		{
			dat <- read.table(paste0("/scratch/mhartfield/polyself_out/data/polyself_out_s",s,"_h",h,"_self",S,"_nt",N,"_newo",z0,"_mvar",mvar,".dat"),head=T)
			if(N == 1){
				tf2 <- dat[,c("Generation","FixedMuts","MeanFixedQTL1","PropPosQTL1","MeanPosQTL1")]
			}else{
				tf2 <- cbind(dat[,c("Generation","FixedMuts")],rowMeans(dat[,paste0("MeanFixedQTL",1:N)],na.rm=T),rowMeans(dat[,paste0("PropPosQTL",1:N)],na.rm=T),rowMeans(dat[,paste0("MeanPosQTL",1:N)],na.rm=T))
			}
			tf2 <- as.data.frame(tf2)
			colnames(tf2) <- c("Generation","FixedMuts","MeanFixedQTL","MeanPropPos","MeanPosQTL")
			fixedm[[which(self%in%S)]] <- tf2
			maxfix <- max(maxfix,max(tf2$FixedMuts))
			if(sum(!is.na(tf2$MeanFixedQTL)) != 0){
				maxmQ <- max(maxmQ,max(tf2$MeanFixedQTL,na.rm=T))
				minmQ <- min(minmQ,min(tf2$MeanFixedQTL,na.rm=T))				
			}
			if(sum(!is.na(tf2$MeanPropPos)) != 0){
				maxpQ <- max(maxpQ,max(tf2$MeanPropPos,na.rm=T))
			}
			if(sum(!is.na(tf2$MeanPosQTL)) != 0){			
				maxpmQ <- max(maxpmQ,max(tf2$MeanPosQTL,na.rm=T))
			}
		}
		# Panel 1: Number of fixed QTLs
		for(S in self){
			if(which(self%in%S) == 1){
				plot(fixedm[[1]]$Generation,fixedm[[1]]$FixedMuts,type='l',xlab="Time",ylab="Fixed Mutations",xlim=c(0,maxgen),ylim=c(0, maxfix),col=wes_palette(n=4, name="GrandBudapest1")[1],lwd=1.5)
				abline(v=tchange,lty=2)
				legend("topleft",legend=c("S = 0", "S = 0.5", "S = 0.9", "S = 0.999"),col=wes_palette(n=4, name="GrandBudapest1"),lty=1,cex=1,lwd=1.5)
			}else{
				lines(fixedm[[which(self%in%S)]]$Generation,fixedm[[which(self%in%S)]]$FixedMuts,col=wes_palette(n=4, name="GrandBudapest1")[which(self%in%S)],lwd=1.5)
			}
		}
		# Panel 2: Mean effect of fixed QTLs
		for(S in self){
			if(which(self%in%S) == 1){
				plot(fixedm[[1]]$Generation,fixedm[[1]]$MeanFixedQTL,type='l',xlab="Time",ylab="Mean effect of fixed QTL",xlim=c(0,maxgen),ylim=c(minmQ, maxmQ),col=wes_palette(n=4, name="GrandBudapest1")[1],lwd=1.5)
				abline(v=tchange,lty=2)
			}else{
				lines(fixedm[[which(self%in%S)]]$Generation,fixedm[[which(self%in%S)]]$MeanFixedQTL,col=wes_palette(n=4, name="GrandBudapest1")[which(self%in%S)],lwd=1.5)
			}
		}
		# Panel 3: Proportion of fixed QTLs with positive effects
		for(S in self){
			if(which(self%in%S) == 1){
				plot(fixedm[[1]]$Generation,fixedm[[1]]$MeanPropPos,type='l',xlab="Time",ylab="Mean proportion of positive-effect QTLs",xlim=c(0,maxgen),ylim=c(0, maxpQ),col=wes_palette(n=4, name="GrandBudapest1")[1],lwd=1.5)
				abline(v=tchange,lty=2)
			}else{
				lines(fixedm[[which(self%in%S)]]$Generation,fixedm[[which(self%in%S)]]$MeanPropPos,col=wes_palette(n=4, name="GrandBudapest1")[which(self%in%S)],lwd=1.5)
			}
		}
		# Panel 4: Proportion of fixed QTLs with positive effects
		for(S in self){
			if(which(self%in%S) == 1){
				plot(fixedm[[1]]$Generation,fixedm[[1]]$MeanPosQTL,type='l',xlab="Time",ylab="Mean effect of positive fixed QTLs",xlim=c(0,maxgen),ylim=c(0, maxpmQ),col=wes_palette(n=4, name="GrandBudapest1")[1],lwd=1.5)
				abline(v=tchange,lty=2)
			}else{
				lines(fixedm[[which(self%in%S)]]$Generation,fixedm[[which(self%in%S)]]$MeanPosQTL,col=wes_palette(n=4, name="GrandBudapest1")[which(self%in%S)],lwd=1.5)
			}
		}
		
		mtext(paste0("Number of fixed mutants",midh1,endh1), outer = TRUE, cex = 1.5)
		dev.off()
	}
}

quit(save="no")
