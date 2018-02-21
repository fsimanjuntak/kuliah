# SOME Summarizing plots:

OverallTDL <- c(4.23,2.24,3.27,4.76,4.42,5.22,0.97)
OverallGINI <- c(0.72,0.24,0.63,0.6,0.83,0.86,-0.02)


ForGraph <- data.frame(OverallTDL,OverallGINI)

myLeftAxisLabs <- pretty(seq(0, max(ForGraph$OverallTDL), length.out = 10))
myRightAxisLabs <- pretty(seq(0, max(ForGraph$OverallGINI), length.out = 10))

myLeftAxisAt <- myLeftAxisLabs/max(ForGraph$OverallTDL)
myRightAxisAt <- myRightAxisLabs/max(ForGraph$OverallGINI)

ForGraph$OverallTDL1 <- ForGraph$OverallTDL/max(ForGraph$OverallTDL)
ForGraph$OverallGINI1 <- ForGraph$OverallGINI/max(ForGraph$OverallGINI)

op <- par(mar = c(5,4,4,4) + 0.1)

barplot(t(as.matrix(ForGraph[, c("OverallTDL1", "OverallGINI1")])), beside = TRUE, yaxt = "n", names.arg = c("Log","Neig", "Bay","SVM","Tr","RF","NN"), ylim=c(0, max(c(myLeftAxisAt, myRightAxisAt))), ylab =	"Top Decile Lift", legend = c("TDL","GINI"), main="Performance of the Machine Learning Algorithms")

axis(2, at = myLeftAxisAt, labels = myLeftAxisLabs)

axis(4, at = myRightAxisAt, labels = myRightAxisLabs)

mtext("GINI Coefficient", side = 4, line = 3, cex = par("cex.lab"))

mtext(c(paste(round(5,digits=2),""),
        paste(round(352.69,digits=2),""),
        paste(round(12.35,digits=2),""),
        paste(round(5400,digits=2),""),
        paste(round(2.412),""),
        paste(round(72.94,digits=2),""),
        paste(round(449,digits=2),"")), side = 1, line = 3, cex = par("cex.lab"), at = c(2.3,5,8,11,14,17,20))
mtext(c(paste(round(0.8924181055922690*100,digits=0),"%"),
        paste(round(0.892204931428977*100,digits=0),"%"),
        paste(round(0.871882327861863*100,digits=0),"%"),
        paste(round(0.894976195551766*100,digits=0),"%"),
        paste(round(0.910040503091025*100,digits=0),"%"),
        paste(round(0.887728273999858*100,digits=0),"%"),
        paste(round(0.894016911816954*100,digits=0),"%")), side = 1, line = 4, cex = par("cex.lab"), at = c(2.3,5,8,11,14,17,20))


#Percentage <- c(0.892418105592269, 0.892204931428977, 0.871882327861863, 0.894976195551766, 0.910040503091025, 0.887728273999858, 0.894016911816954)


mtext("time(sec)", side = 1, line = 3, cex = par("cex.lab"), at = -.8)
mtext("correct", side = 1, line = 4, cex = par("cex.lab"), at = -.8)
