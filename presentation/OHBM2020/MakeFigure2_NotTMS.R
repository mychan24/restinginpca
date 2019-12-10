# The script that helps create plots for the poster
#===================================================
## Date: Dec. 10, 2019
## Author: Ju-Chi Yu, Micaela CHan
#===================================================
rm(list = ls())
# Read data ----
load("././MuSu_simattack_4rows_18_HMFA_sub-edgetype.RData")
library(RColorBrewer)
library(pals)
library(PTCA4CATA)
library(dplyr)
library(plyr)

# Fig 2A
f.labels <- createxyLabels.gen(x_axis = 1, y_axis = 2,
                               lambda = svd.res$ExPosition.Data$eigs,
                               tau = svd.res$ExPosition.Data$t,
                               axisName = "Component ")

plot.f_sess4pF <- createFactorMap(svd.res$ExPosition.Data$fi,
                                  constraints = pF.constraints,
                                  col.points = c("maroon4","darkslateblue","maroon4","darkslateblue"),
                                  col.labels = c("maroon4","darkslateblue","maroon4","darkslateblue"),
                                  text.cex = 5,
                                  alpha.points = 1,
                                  col.background = adjustcolor('white',alpha.f = .2),
                                  title = "Mean Factor Score of Sessions & \nPartial Factor Scores of Subjects")
                                   # with t(gt)
plot.pf <- createPartialFactorScoresMap(
  factorScores = svd.res$ExPosition.Data$fi,
  partialFactorScores = pFi,#c(1,2,7,8,10)],
  axis1 = 1, axis2 = 2,
  size.points = 2,
  size.labels = 2,
  shape.points = 18,
  family.labels = 'sans',
  names4Partial = subj.name,#[c(1,2,7,8,10)],
  font.labels = "bold",
  colors4Blocks = cols25(10)
)
f_sess <- plot.f_sess4pF$zeMap_background + f.labels + plot.pf$mapColByBlocks + plot.f_sess4pF$zeMap_dots + plot.f_sess4pF$zeMap_text# + plot.pf$linesColByBlocks + plot.pf$pointsColByBlocks#(0mid-17right; topofgraybar-7bot)
Fig2A <- f_sess
Fig2A

# Fig 2B

# Loadings
bar.edge <- mean.edge.fj[importantCommEdg,1]
names(bar.edge) <- rownames(mean.edge.fj[importantCommEdg,])

edge.show <- names(bar.edge)
lookup.tab <- CommName[,c(1,4)]
colnames(lookup.tab) <- c("Num","Short")
lookup.tab$Short <- gsub('[[:digit:]]+', '', lookup.tab$Short)

name.bar <- c("Within DMN", 
              "Between DMN & Aud", 
              "Between DMN & FPN", 
              "Within hSMN", 
              "Between hSMN & Aud", 
              "Within Aud", 
              "Within lVis", 
              "Between lVis & hSMN", 
              "Between lVis & Aud", 
              "Between lVis & CON", 
              "Within FPN", 
              "Between FPN & DAN", 
              "Between FPN & CON", 
              "Within DAN", 
              "Between DAN & hSMN", 
              "Within CON",
              "Between CON & hSMN",
              "Between CON & Aud")
names(bar.edge) <- name.bar


Fig2b <- PrettyBarPlot2(bar.edge,horizontal = F,
               threshold = 0,
               color.bar = c("darkslateblue","maroon4","gray"),
               color.bord = c("darkslateblue","maroon4","gray"),
               color.letter = c("darkslateblue","maroon4","gray"),
               ylim = c(min(mean.edge.fj[importantCommEdg,1]),
                        0.01+max(mean.edge.fj[importantCommEdg,1])),
               main = "\n Mean significant loadings on Component 1")

Fig2b

# Fig 2C
load("././cfDiSTATIS_simattack_NOTTMS_GordonParcel.RData")

f.labels <- createxyLabels.gen(x_axis = x_cp, y_axis = y_cp,
                               lambda = distatis.res$res4Splus$eigValues,
                               tau = distatis.res$res4Splus$tau,
                               axisName = "Component ")

net.fi2plot <- net.fi[c(1:6,8:13),]
sess.pF.net2plot <- sess.pF.net[c(1:6,8:13),,]

netf.graph4sess <- createFactorMap(net.fi2plot,
                                   axis1 = x_cp, axis2 = y_cp,
                                   title = "DiSTATIS - \nMean Factor Score of Networks &\nPartial Factor Scores of Sessions
",
                                   col.points = CommColor.gc[rownames(net.fi2plot), "CommColor"],
                                   col.labels = CommColor.gc[rownames(net.fi2plot), "CommColor"],
                                   pch = 17,
                                   alpha.points = 1, cex = 2, text.cex = 3,
                                   constraints = minmaxHelper4Partial(net.fi,
                                                                      sess.pF.net))

dimnames(sess.pF.net2plot)[[3]] <- c("1","2","3","4")
netpf.sess <- createPartialFactorScoresMap(net.fi2plot,
                                           sess.pF.net2plot,
                                           axis1 = x_cp, axis2 = y_cp,
                                           colors4Blocks = c("maroon4","darkslateblue","maroon4","darkslateblue"),
                                           shape.points = 20,
                                           size.points = 2, size.labels = 2,
                                           alpha.points = 1, alpha.lines = .8, alpha.labels = 1,
                                           names4Partial = dimnames(sess.pF.net2plot)[[3]])


f02.netFpF.sess <- netf.graph4sess$zeMap_background + netf.graph4sess$zeMap_text +netpf.sess$mapColByBlocks + netf.graph4sess$zeMap_dots + f.labels
Fig2c <- f02.netFpF.sess
Fig2c

library(ggpubr)

png("Figure2.png", width = 400, height = 120, units = 'mm', res = 500)
ggarrange(Fig2A,Fig2b,Fig2c,
          labels = c("A","B","C"),
          ncol = 3, nrow = 1)
dev.off()
