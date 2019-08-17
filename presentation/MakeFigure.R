# The script that helps create plots for the poster
#===================================================
## Date: Aug. 16, 2019
## Author: Ju-Chi Yu
#===================================================
rm(list = ls())
# Read data ----
load("BigNet_11.RData")
library(RColorBrewer)
library(pals)
library(PTCA4CATA)
library(dplyr)

# Scree plots ----
PlotScree(svd.res$ExPosition.Data$eigs,title = "",plotKaiser = T,lwd4Kaiser = 1)
Scree <- recordPlot()

# Plot sessions with pFs
plot.f_sess4pF <- createFactorMap(svd.res$ExPosition.Data$fi,
                                  constraints = pF.constraints,
                                  col.points = "maroon4",
                                  col.labels = "maroon4",
                                  alpha.points = 1,
                                  col.background = adjustcolor('white',alpha.f = .2))
                                   # with t(gt)
plot.pf <- createPartialFactorScoresMap(
  factorScores = svd.res$ExPosition.Data$fi[c(1,2,3,6,7,9),],
  partialFactorScores = pFi[c(1,2,3,6,7,9),,],#c(1,2,7,8,10)],
  axis1 = 1, axis2 = 2,
  size.points = 3,
  size.labels = 2,
  shape.points = 18,
  family.labels = 'sans',
  names4Partial = subj.name,#[c(1,2,7,8,10)],
  font.labels = "bold",
  colors4Blocks = cols25(10)
)
f_sess <- plot.f_sess4pF$zeMap + f.labels + plot.pf$mapColByBlocks #(0mid-17right; topofgraybar-7bot)
f_sess

# Plot edges
mean.fj2plot <- mean.fj[which(importantEdg == TRUE),] 
# mean.fj2plot <- mean.fj

getBoot2plot_edge <- BootCube.Comm$BootCube[importantEdg,c(1,2),]
# getBoot2plot_edge <- BootCube.Comm$BootCube[,c(1,2),]

fj2plot.sq <- apply(mean.fj2plot[1:9],2,function(x){x^2}) # square the factor scores
dist2c <- sqrt(fj2plot.sq[,1]+fj2plot.sq[,2]) # take the sqrt of the ss of component 1+2
fj.ind <- sort(abs(dist2c),decreasing = TRUE, index.return = TRUE)$ix # sort the distance to the origen and get the index (big to small)
fj2plot.ind <- fj.ind[1:round(length(fj.ind)*.2)] # plot furthest 25% 
col.max10 <- col4ImportantEdg[which(importantEdg == TRUE)] %>% .[fj2plot.ind]
# col.max10 <- col4ImportantEdg %>% .[fj2plot.ind]

plot.f_edge_imp <- createFactorMap(mean.fj2plot[fj2plot.ind,], axis1 = 1, axis2 = 2,
                                   col.points = col.max10,
                                   col.labels = col.max10,
                                   text.cex = 2.5,
                                   force = 1.5,
                                   box.padding = 0.05,
                                   title = "",
                                   col.background = adjustcolor('white',alpha.f = .2),
                                   constraints = lapply(minmaxHelper(mean.fj2plot[fj2plot.ind,]),"*",1.5)
                                   )
f_impedge.CI <- MakeCIEllipses(getBoot2plot_edge[fj2plot.ind,,],
                               names.of.factors = c(sprintf("Factor %s", 1),sprintf("Factor %s", 2)),
                               col = col.max10,
                               p.level = .95)
f_CInetedge <- plot.f_edge_imp$zeMap_background + plot.f_edge_imp$zeMap_dots + plot.f_edge_imp$zeMap_text + f_impedge.CI + f.labels
f_CInetedge

# Plot edges type
plot.f_bw_imp <- createFactorMap(mean.fj.bw, axis1 = 1, axis2 = 2,
                                 col.points = net.edge.col$gc[rownames(mean.fj.bw),],
                                 col.labels = net.edge.col$gc[rownames(mean.fj.bw),],
                                 text.cex = 3,
                                 force = 0.5,
                                 title = "",
                                 col.background = adjustcolor('white',alpha.f = .2))

plot.f_bw_imp$zeMap + f.labels
# get the bootstrap data for each type of network edges
getBoot2plot_edge_bw <- BootCube.Comm.bw$BootCube
# plot the CI ellipses
plot.CI.f_bw <- MakeCIEllipses(getBoot2plot_edge_bw[,c(1,2),],
                               names.of.factors = c(sprintf("Factor %s", 1),sprintf("Factor %s", 2)),
                               col = as.vector(net.edge.col$gc[rownames(getBoot2plot_edge_bw),]),
                               p.level = .95)
# create plot
# f_CInetedge_bw <- plot.f_bw_imp$zeMap_background + plot.f_bw_imp$zeMap_dots + plot.f_bw_imp$zeMap_text + plot.CI.f_bw + f.labels
# f_CInetedge_bw

saving.pptx <-  saveGraph2pptx(file2Save.pptx = 'bignet_3', 
                               title = "" , 
                               addGraphNames = TRUE)
