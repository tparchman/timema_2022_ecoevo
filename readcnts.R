
# Code to quickly look at read counts for T7 lane (mostly Timema, with 96 Pinus)

T7_reads<-read.csv("T7_readcount_bc.csv", header=F)

#cols 1-576 are Timema
#cols 577-672 are Pinus

timema_T7_cnts<-T7_reads[1:576,]
pinus_T7_cnts<-T7_reads[577:672,]

hist(timema_T7_cnts[,5], breaks=100,col="grey")

hist()