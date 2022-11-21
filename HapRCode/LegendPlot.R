# 23rd October 2020
# Plotting legend for use with hap plots
# 'No-Plot' Trick from https://stackoverflow.com/questions/48966645/how-can-i-create-a-legend-without-a-plot-in-r

# Haplotype snapshot (without, and with deleterious mutation legend)
library(RColorBrewer)
pdf(paste0("/Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HapPlotLegend.pdf"),width=12,height=12)
plot(NULL,xlim=c(0:1),ylim=c(0:1),xaxt='n',yaxt='n',xlab="",ylab="",bty="n")
legend("left",c("Neutral","Maximum positive trait value","Maximum negative trait value"),fill=c("gray60",brewer.pal(11,"RdBu")[c(1,11)]),cex=3,box.lwd=4)
dev.off()

pdf(paste0("/Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/HapPlotLegendDel.pdf"),width=12,height=12)
plot(NULL,xlim=c(0:1),ylim=c(0:1),xaxt='n',yaxt='n',xlab="",ylab="",bty="n")
legend("left",c("Neutral","Deleterious","Maximum positive trait value","Maximum negative trait value"),fill=c("gray60","black",brewer.pal(11,"RdBu")[c(1,11)]),cex=3,box.lwd=4)
dev.off()

# LD plots
pdf(paste0("/Users/hartfield/Documents/Polygenic\ Selection\ Selfing/SLiM\ Scripts/OutputPlots/haps/LDPlotLegend.pdf"),width=12,height=12)
plot(NULL,xlim=c(0:1),ylim=c(0:1),xaxt='n',yaxt='n',xlab="",ylab="",bty="n")
legend("left",c(expression(paste(r^2," = 0")),expression(paste(r^2," = 1"))),fill=c("#132B43","#56B1F7"),cex=3,box.lwd=4)
dev.off()
