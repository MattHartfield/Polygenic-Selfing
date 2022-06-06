# 6th June 2022
# Plotting polygenic score associated with sample

library(tidyverse)

# args <- commandArgs(trailingOnly = TRUE)
# s <- as.double(args[1])			# Selection coefficient, background mutations
# h <- as.double(args[2])			# Dominance coefficient
# self <- as.double(args[3])		# Selfing rate
# N <- as.integer(args[4])		# Number of traits each QTL affects
# msd <- as.double(args[5])		# Standard deviation of mutational effect
# isnm <- as.integer(args[6])		# Is mutation stopped after optimum shift
# stype <- as.integer(args[7])	# Optimum shift type
# ocsc <- as.integer(args[8])		# Is rescaled outcrossing type or not
# k <- args[9] 

# Uncomment to use test values
s <- -0.02
h <- 0.02
self <- 0.99
N <- 5
msd <- 0.25
isnm <- 0
stype <- 0
ocsc <- 0
k <- "time1"
i <- 1

# Table of calculations
## to do here:
## CREATE TIBBLE OF SCORES, ONE FOR EACH SELF RATE AND SIMULATION REP
## CALCULATE PSCORE AND ADD TO TIBBLE
## USE FULL TIBBLE TO GGPLOT OVER TIME, SPLITTING BY SELFING RATE

# Read in info, frequency files of quantitative trait variants
infos <- read_delim(paste0("/scratch/mhartfield/polyself_out/haps/polyself_out_s",s,"_h",h,"_self",self,"_nt",N,"_msd",msd,"_isnm",isnm,"_stype",stype,"_ocsc",ocsc,"_",k,"_rep",i,".info"),delim=" ")
vcfin <- read_delim(paste0("/scratch/mhartfield/polyself_out/haps/polyself_out_s",s,"_h",h,"_self",self,"_nt",N,"_msd",msd,"_isnm",isnm,"_stype",stype,"_ocsc",ocsc,"_",k,"_rep",i,".vcf"),delim='\t',skip=12)[,c(2,8)] %>% filter(grepl("MT=3",INFO))
infos <- infos[infos$POS%in%vcfin$POS,]

FREQS <- vcfin %>% select(INFO) %>% apply(.,1,function(x) strsplit(x,split=";")) %>% lapply(.,function(x) strsplit(x[[1]][7],split="=")[[1]][2]) %>% unlist %>% as.numeric
FREQS <- FREQS/100
qtlfr <- cbind(vcfin[1],FREQS) %>% as_tibble
qtlfr <- inner_join(qtlfr,infos) %>% mutate(pscore=FREQS*MeanQTL)
colSums(qtlfr)[4] # Polygenic score for sample