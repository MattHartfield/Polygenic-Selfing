# 5th Mar 2020
# Plots PCA of haplotype structure from haplostrips output

args <- commandArgs(trailingOnly = TRUE)
s <- as.double(args[1])
h <- as.double(args[2])
S <- as.double(args[3])
z0 <- as.double(args[4])
N <- as.integer(args[5])
msd <- as.double(args[6])

coff <- 2		# MAC cutoff
ns <- 100		# Number haplotypes

# Different plot file prefixes
pt <- c("beforeshift","20gens","150gens")

for(i in 1:length(pt))
{	
	dat <- read.table(paste0("/Users/hartfield/Documents/Polygenic Selection Selfing/SLiM Scripts/OutputPlots/haps/HS_",pt[i],"_s",s,"_h",h,"_self",S,"_nt",N,"_newo",z0,"_msd",msd,".haps"))
	dat <- dat[,-c(1:4)]
	dat <- dat[intersect(which(apply(dat,1,sum)>=coff),which(apply(dat,1,sum) <= (ns-coff))),]
	row.names(dat) <- c(1:dim(dat)[1])
	pdf(file=paste0('/Users/hartfield/Documents/Polygenic Selection Selfing/SLiM Scripts/OutputPlots/haps/HS_',pt[i],'_s',s,'_h',h,'_self',S,'_nt',N,'_newo',z0,'_msd',msd,'.pca.pdf'),width=8,height=8)
	plot(prcomp(dat)[[2]][,1:2],pch=16)
	dev.off()
}
