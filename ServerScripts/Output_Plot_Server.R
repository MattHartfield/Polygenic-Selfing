# 13th December 2019
# Script to read in polygenic selection simulation outputs and plot

# 24th Jan 2020
# Updated to take multiple traits into account

# 28th Jan 2020
# Plots several S values over one another

library(wesanderson)

tchange <- 25000	# Time at which optimum changes
gr <- (1+sqrt(5))/2 # Scaling ratio for plot outputs
z0 <- 1
mvar <- 0.25
self <- c(0,0.5,0.9,0.999)
# Only do for neutral case with one trait for now: update later to consider selected cases
s <- 0
h <- 0.02
no <- 1

# First plot: mean, var in fitness
pdf(file=paste0('/scratch/mhartfield/polyself_out/plots/PolyselPlot_Fitness_neutral.pdf'),width=8*gr,height=8)
par(mfrow=c(2,1),oma = c(0, 0, 2, 0))
for(S in self){
	if(which(self%in%S) == 1){
		dat <- read.table(paste0("/scratch/mhartfield/polyself_out/data/polyself_out_s",s,"_h",h,"_self",S,"_nt",no,"_newo",z0,"_mvar",mvar,".dat"),head=T)
		plot(dat$Generation,dat$MeanFitness,type='l',xlab="Time",ylab="Mean Fitness",col=wes_palette(n=4, name="GrandBudapest1")[1],lwd=1.5)
		abline(v=tchange,lty=2)	
	}else{
		dat <- read.table(paste0("/scratch/mhartfield/polyself_out/data/polyself_out_s",s,"_h",h,"_self",S,"_nt",no,"_newo",z0,"_mvar",mvar,".dat"),head=T)
		lines(dat$Generation,dat$MeanFitness,col=wes_palette(n=4, name="GrandBudapest1")[which(self%in%S)],lwd=1.5)	
	}
}
for(S in self){
	if(which(self%in%S) == 1){
		dat <- read.table(paste0("/scratch/mhartfield/polyself_out/data/polyself_out_s",s,"_h",h,"_self",S,"_nt",no,"_newo",z0,"_mvar",mvar,".dat"),head=T)
		plot(dat$Generation,dat$VarFitness,type='l',xlab="Time",ylab="Mean Fitness",col=wes_palette(n=4, name="GrandBudapest1")[1],lwd=1.5)
		abline(v=tchange,lty=2)	
		legend("topleft",legend=c("S = 0", "S = 0.5", "S = 0.9", "S = 0.999"),col=wes_palette(n=4, name="GrandBudapest1"),lty=1,cex=1,lwd=1.5)
	}else{
		dat <- read.table(paste0("/scratch/mhartfield/polyself_out/data/polyself_out_s",s,"_h",h,"_self",S,"_nt",no,"_newo",z0,"_mvar",mvar,".dat"),head=T)
		lines(dat$Generation,dat$VarFitness,col=wes_palette(n=4, name="GrandBudapest1")[which(self%in%S)],lwd=1.5)	
	}
}
mtext("Fitness over time, no background deleterious mutation.", outer = TRUE, cex = 1.5)
dev.off()

# Second plot: trait values over time
pdf(file=paste0('/scratch/mhartfield/polyself_out/plots/PolyselPlot_Traits_neutral.pdf'),width=8*gr,height=8)
par(mfcol=c(2,no),oma = c(0, 0, 2, 0))
for(i in no){
	for(S in self){
		if(which(self%in%S) == 1){
			dat <- read.table(paste0("/scratch/mhartfield/polyself_out/data/polyself_out_s",s,"_h",h,"_self",S,"_nt",no,"_newo",z0,"_mvar",mvar,".dat"),head=T)
			incol <- parse(text=paste0("dat$MeanTrait",i))
			incv <- parse(text=paste0("dat$GenVar",i))
			if(max(eval(incol)) < z0){
				maxy <- z0
			}else if(max(eval(incol)) >= z0){
				maxy <- max(eval(incol))
			}
			plot(dat$Generation,eval(incol),type='l',xlab="Time",ylab=paste0("Mean Trait Value, Trait ",i),ylim=c((min(eval(incol)) - ((maxy-min(eval(incol)))*0.04)),maxy + ((maxy-min(eval(incol)))*0.04)),col=wes_palette(n=4, name="GrandBudapest1")[1],lwd=1.5)
			abline(v=tchange,lty=2)
			abline(h=0,lty=3,lwd=1.5)
			abline(h=z0,lty=2,lwd=1.5)
		}else{
			dat <- read.table(paste0("/scratch/mhartfield/polyself_out/data/polyself_out_s",s,"_h",h,"_self",S,"_nt",no,"_newo",z0,"_mvar",mvar,".dat"),head=T)
			incol <- parse(text=paste0("dat$MeanTrait",i))
			lines(dat$Generation,eval(incol),col=wes_palette(n=4, name="GrandBudapest1")[which(self%in%S)],lwd=1.5)	
		}
	}
	for(S in self){
		if(which(self%in%S) == 1){
			dat <- read.table(paste0("/scratch/mhartfield/polyself_out/data/polyself_out_s",s,"_h",h,"_self",S,"_nt",no,"_newo",z0,"_mvar",mvar,".dat"),head=T)
			incv <- parse(text=paste0("dat$GenVar",i))
			plot(dat$Generation,eval(incv),type='l',xlab="Time",ylab=paste0("Variance in Trait Value, Trait ",i),col=wes_palette(n=4, name="GrandBudapest1")[1],lwd=1.5)
			abline(v=tchange,lty=2)
			abline(h=0.0056,lty=2)		# Expected HoC variance, 4*0.028*0.05
			legend("topleft",legend=c("S = 0", "S = 0.5", "S = 0.9", "S = 0.999"),col=wes_palette(n=4, name="GrandBudapest1"),lty=1,cex=1,lwd=1.5)
		}else{
			dat <- read.table(paste0("/scratch/mhartfield/polyself_out/data/polyself_out_s",s,"_h",h,"_self",S,"_nt",no,"_newo",z0,"_mvar",mvar,".dat"),head=T)
			incv <- parse(text=paste0("dat$GenVar",i))
			lines(dat$Generation,eval(incv),col=wes_palette(n=4, name="GrandBudapest1")[which(self%in%S)],lwd=1.5)
		}
	}
}
mtext("Trait values over time, no background deleterious mutation.", outer = TRUE, cex = 1.5)
dev.off()

# Third plot: number of fixed mutants
pdf(file=paste0('/scratch/mhartfield/polyself_out/plots/PolyselPlot_FixedMuts_neutral.pdf'),width=8*gr,height=8)
for(S in self){
	if(which(self%in%S) == 1){
		dat <- read.table(paste0("/scratch/mhartfield/polyself_out/data/polyself_out_s",s,"_h",h,"_self",S,"_nt",no,"_newo",z0,"_mvar",mvar,".dat"),head=T)
		plot(dat$Generation,dat$FixedMuts,type='l',xlab="Time",ylab="Fixed Mutations",col=wes_palette(n=4, name="GrandBudapest1")[1],main="Number of Fixed Mutants, no background deleterious mutation.",lwd=1.5)
		abline(v=tchange,lty=2)
		legend("topleft",legend=c("S = 0", "S = 0.5", "S = 0.9", "S = 0.999"),col=wes_palette(n=4, name="GrandBudapest1"),lty=1,cex=1,lwd=1.5)
	}else{
		dat <- read.table(paste0("/scratch/mhartfield/polyself_out/data/polyself_out_s",s,"_h",h,"_self",S,"_nt",no,"_newo",z0,"_mvar",mvar,".dat"),head=T)
		lines(dat$Generation,dat$FixedMuts,col=wes_palette(n=4, name="GrandBudapest1")[which(self%in%S)],lwd=1.5)	
	}
}
dev.off()

quit(save="no")
