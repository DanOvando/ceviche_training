#This code runs LBSPR method from Adrian's github.  This is an R package with vignette that provides examples
#this package can run two of Adrian's versions (1) his Growth-Type-Group model (Hordyk et at. 2016) or
# (2)  Age-Structured model (Hordyk et al. 2015):



#input Chita params
ChitaPars <- new("LB_pars")
slotNames(ChitaPars)


ChitaPars@Species<-"Chita"
ChitaPars@Linf <- 61.44
ChitaPars@L50 <- 21
ChitaPars@L95 <- 25
ChitaPars@MK <- 2.4
ChitaPars@BinWidth <- 1


#load lfreq catch data
# setwd("C:/Code_Files/DLM_SNAP/Chita_Rawfiles")
datdir=

Lens <- new("LB_lengths", LB_pars=ChitaPars, file='chita assessment data/LFreq_Cortina_LBSPR.csv', dataType="freq", header=TRUE)

#fit returns smoothed estimates
fit<-LBSPRfit(ChitaPars, Lens)

#save raw estimates
rawfit<-data.frame(rawSL50=fit@SL50, rawSL95=fit@SL95, rawFM=fit@FM, rawSPR=fit@SPR)

#results
smooth_fits=fit@Ests
rownames(smooth_fits)=2012:2015

rownames(rawfit)=2012:2015


modelfit=plotSize(fit)
selmat=plotMat(fit)

#do with his age structured model
fit2<-LBSPRfit(ChitaPars, Lens,Control=list(modtype="absel"))
smooth_fits2=fit2@Ests


#plot results for smoothed LBSPR results using GTG, length-based method
spr=as.data.frame(smooth_fits)
sprall=cbind(spr[,3:4],rawfit[,3:4])
sprall$Year=2012:2015
spr_long=melt(sprall,id="Year")
spr_long$Reference=rep(c("F/M","SPR"),each=4,2)
spr_long$Fishing_Zone=rep(c("PISCO","SANTA ROSA"),each=2,4)
levels(spr_long$variable)[1:2]=c("smoothFM","smoothSPR")

lbspr_plot=ggplot(spr_long, aes(x=Year,y=value,colour=variable)) +
  geom_line()+geom_point(size=3)+facet_grid(Reference ~ Fishing_Zone,scales="free")+
  theme(panel.background = element_rect(fill = "gray77"))+
  scale_x_continuous(breaks = 2012:2015, labels = 2012:2015)




#plotting of SPR over different F/M
MyPars <- new("LB_pars")

FMVec <- seq(from=0, to=4, by=0.05)
SPROut <- matrix(NA, nrow=length(FMVec), ncol=2)

MyPars@Linf <- 61.44
MyPars@MK <- 2.4
MyPars@L50 <- 21
MyPars@L95 <- 25
MyPars@SPR <- numeric() # make sure SPR slot is empty

MyPars@BinMin <- 0
MyPars@BinMax <- 62
MyPars@BinWidth <- 1

for (ind in seq_along(FMVec)) {
  MyPars@SL50 <- 20.9
  MyPars@SL95 <- 23.3
  MyPars@FM <- FMVec[ind]
  SPROut[ind, 1] <- LBSPRsim(MyPars)@SPR

  MyPars@SL50 <- 22.6
  MyPars@SL95 <- 25.5
  MyPars@FM <- FMVec[ind]
  SPROut[ind, 2] <- LBSPRsim(MyPars)@SPR
}

# plot(range(FMVec), c(0,1), xlab="F/M", ylab="SPR", bty="n", type="n")
# lines(FMVec, SPROut[,1], lwd=2)
# lines(FMVec, SPROut[,2], lwd=2, lty=2)
# legend("topright", lty=1:2, lwd=2, title="Selectivity", legend=c("@Maturity", "Higher"), bty="n")


