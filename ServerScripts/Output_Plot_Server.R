# 13th December 2019
# Script to read in polygenic selection simulation outputs and plot

# 24th Jan 2020
# Updated to take multiple traits into account

# 28th Jan 2020
# Plots several S values on the same graph

library(wesanderson)

tchange <- 25000	# Time at which optimum changes
gr <- (1+sqrt(5))/2 # Scaling ratio for plot outputs
z0 <- 1
mvar <- 0.25
self <- c(0,0.5,0.9,0.999)
no <- c(1,5)
sel <- matrix(data=NA,nrow=3,ncol=2)
sel[1,] <- c(0,0.02)
sel[2,] <- c(-0.02,0.02)
sel[3,] <- c(-0.02,0.2)

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

		# First plot: mean, var in fitness		
		fitmat <- vector(mode="list",length=length(self))
		maxgen <- 0
		maxmf <- 0
		minmf <- 1
		maxvf <- 0
		pdf(file=paste0('/scratch/mhartfield/polyself_out/plots/',outf,'/PolyselPlot_Fitness_neutral_T',N,'_sel',s,'_h',h,'.pdf'),width=8*gr,height=8)
		par(mfrow=c(2,1),oma = c(0, 0, 2, 0))
		# First: read in data, determine x, y axes
		for(S in self)
		{
			dat <- read.table(paste0("/scratch/mhartfield/polyself_out/data/polyself_out_s",s,"_h",h,"_self",S,"_nt",N,"_newo",z0,"_mvar",mvar,".dat"),head=T)
			fitmat[[which(self%in%S)]] <- dat[,c("Generation","MeanFitness","VarFitness")]
			maxgen <- max(maxgen,max(dat$Generation))
			maxmf <- max(maxmf,max(dat$MeanFitness))
			minmf <- min(minmf,min(dat$MeanFitness))		
			maxvf <- max(maxvf,max(dat$VarFitness))
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
			}else{
				lines(fitmat[[which(self%in%S)]]$Generation,fitmat[[which(self%in%S)]]$MeanFitness,col=wes_palette(n=4, name="GrandBudapest1")[which(self%in%S)],lwd=1.5)	
			}
		}
		# Third: plot variance in fitness	
		for(S in self)
		{
			if(which(self%in%S) == 1){
				plot(fitmat[[1]]$Generation,fitmat[[1]]$VarFitness,type='l',xlab="Time",ylab="Variance in Fitness",xlim=c(0,maxgen),ylim=c(0,maxvf),col=wes_palette(n=4, name="GrandBudapest1")[1],lwd=1.5)
				abline(v=tchange,lty=2)	
				legend("topleft",legend=c("S = 0", "S = 0.5", "S = 0.9", "S = 0.999"),col=wes_palette(n=4, name="GrandBudapest1"),lty=1,cex=1,lwd=1.5)
			}else{
				lines(fitmat[[which(self%in%S)]]$Generation,fitmat[[which(self%in%S)]]$VarFitness,col=wes_palette(n=4, name="GrandBudapest1")[which(self%in%S)],lwd=1.5)	
			}
		}
		
		mtext(paste0("Fitness over time",midh1,endh1), outer = TRUE, cex = 1.5)
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
				abline(h=0.0056,lty=2)		# Expected HoC variance, 4*0.028*0.05
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
		pdf(file=paste0('/scratch/mhartfield/polyself_out/plots/',outf,'/PolyselPlot_FixedMuts_neutral_T',N,'_sel',s,'_h',h,'.pdf'),width=8*gr,height=8)
		for(S in self)
		{
			dat <- read.table(paste0("/scratch/mhartfield/polyself_out/data/polyself_out_s",s,"_h",h,"_self",S,"_nt",N,"_newo",z0,"_mvar",mvar,".dat"),head=T)
			fixedm[[which(self%in%S)]] <- dat[,c("Generation","FixedMuts")]
			maxfix <- max(maxfix,max(dat$FixedMuts))
		}
		for(S in self){
			if(which(self%in%S) == 1){
				plot(fixedm[[1]]$Generation,fixedm[[1]]$FixedMuts,type='l',xlab="Time",ylab="Fixed Mutations",xlim=c(0,maxgen),ylim=c(0, maxfix),col=wes_palette(n=4, name="GrandBudapest1")[1],lwd=1.5)
				abline(v=tchange,lty=2)
				legend("topleft",legend=c("S = 0", "S = 0.5", "S = 0.9", "S = 0.999"),col=wes_palette(n=4, name="GrandBudapest1"),lty=1,cex=1,lwd=1.5)
			}else{
				lines(fixedm[[which(self%in%S)]]$Generation,fixedm[[which(self%in%S)]]$FixedMuts,col=wes_palette(n=4, name="GrandBudapest1")[which(self%in%S)],lwd=1.5)
			}
		}
		
		mtext(paste0("Number of fixed mutants",midh1,endh1), outer = FALSE, cex = 1.5, line=2)
		dev.off()
	}
}

quit(save="no")
