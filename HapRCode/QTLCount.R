# 1st Apr 2020
# Plots QTL counts per individual as histograms

args <- commandArgs(trailingOnly = TRUE)
s <- as.double(args[1])
h <- as.double(args[2])
S <- as.double(args[3])
z0 <- as.double(args[4])
N <- as.integer(args[5])
msd <- as.double(args[6])

# Different plot file prefixes
pt <- c("beforeshift","20gens","150gens")

for(i in 1:length(pt))
{
	dat <- read.table(paste0("/Users/hartfield/Documents/Polygenic Selection Selfing/SLiM Scripts/ServerPlots/haps/HS_",pt[i],"_s",s,"_h",h,"_self",S,"_nt",N,"_newo",z0,"_msd",msd,".count"))$V1
	pdf(file=paste0('/Users/hartfield/Documents/Polygenic Selection Selfing/SLiM Scripts/ServerPlots/haps/HS_',pt[i],'_s',s,'_h',h,'_self',S,'_nt',N,'_newo',z0,'_msd',msd,'.count.pdf'),width=8,height=8)
	barplot(table(dat),ylab="Count")
	dev.off()
}
