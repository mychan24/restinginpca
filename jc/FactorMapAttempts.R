## This attempt tries to find the best way to show the results with all edges/sessions/subjects

## load .RData file from running the 7th analysis first
load("Tryout4No7.RData")
load("Tryout4No3.RData")

## Compute bootstrap ratio (p = .00001) ----
BootRatio.Comm <- boot.ratio.test(BootCube.Comm$BootCube, critical.value = qnorm(0.999995))$`sig.boot.ratios`
BootRatio.Comm.bw <- boot.ratio.test(BootCube.Comm.bw$BootCube, critical.value = qnorm(0.999995))$`sig.boot.ratios`

BootRatio.Comm12 <- (BootRatio.Comm[,1] + BootRatio.Comm[,2]) > 0
BootRatio.Comm.bw12 <- (BootRatio.Comm.bw[,1] + BootRatio.Comm.bw[,2]) > 0


## Contribution ----
edgeOI <- c("sub01_Between","sub02_Between")
edgeOI <- unique(net.edge)

cjplot_show <- createFactorMap(c_edge[which(importantEdg == TRUE & net.edge %in% edgeOI),],
                               axis1 = 1, axis2 = 2,
                               col.points = col4ImportantEdg[which(importantEdg == TRUE & net.edge %in% edgeOI)],
                               col.labels = col4ImportantEdg[which(importantEdg == TRUE & net.edge %in% edgeOI)],
                               text.cex = 2,
                               force = 2,
                               title = "Contibutions for all subject x edges")
cjplot_all$zeMap_background + cjplot_show$zeMap_dots + cjplot_show$zeMap_text

## Sesseions with pF ----
session2plot <- c(1,2,5,7,9)
sub2plot <- c(1:10)
# plot by subject
plot.pf_sess <- createPartialFactorScoresMap(
  factorScores = svd.res$ExPosition.Data$fi,
  partialFactorScores = pFi[,,sub2plot],
  axis1 = 1, axis2 = 2,
  names4Partial = subj.name[sub2plot],
  font.labels = "bold"
)

# plot by session
plot.pf_sess <- createPartialFactorScoresMap(
  factorScores = svd.res$ExPosition.Data$fi[session2plot,],
  partialFactorScores = pFi[session2plot,,],
  axis1 = 1, axis2 = 2,
  size.points = 2.5,
  size.labels = 2.5,
  names4Partial = subj.name,
  font.labels = "bold"
)

# add it to the factor map ** MYC this broke when there is 3 subjects, ask JC 20190410
dev.new()
plot.f_sess4pF$zeMap + f.labels + plot.pf_sess$mapColByBlocks

## Factor map ----
edgeOI <- c("sub01_Within","sub02_Within","sub03_Within","sub04_Within","sub05_Within","sub06_Within","sub07_Within","subj08_Within","subj09_Within","subj10_Within")
edgeOI <- c("sub01_Between","sub02_Between","sub03_Between","sub04_Between","sub05_Between","sub06_Between","sub07_Between","sub08_Between","sub09_Between","sub10_Between")
edgeOI <- unique(net.edge)
# plot the subset
mean.fj2plot <- mean.fj[which(importantEdg == TRUE & net.edge %in% edgeOI),] # filter for contribution
# mean.fj2plot <- mean.fj[which(net.edge %in% edgeOI),]

# get the furthest 10%
fj2plot.sq <- apply(mean.fj2plot[1:9],2,function(x){x^2}) # square the factor scores
dist2c <- sqrt(fj2plot.sq[,1]+fj2plot.sq[,2]) # take the sqrt of the ss of component 1+2
fj.ind <- sort(abs(dist2c),decreasing = TRUE, index.return = TRUE)$ix # sort the distance to the origen and get the index (big to small)
fj2plot.ind <- fj.ind[1:round(length(fj.ind)*0.25)]
col.max10 <- col4ImportantEdg[which(importantEdg == TRUE & net.edge %in% edgeOI)] %>% .[fj2plot.ind]
# col.max10 <- net.edge.col$oc[which(net.edge %in% edgeOI)] %>% .[fj2plot.ind] # for non-filered plot

plot.f_edge_imp <- createFactorMap(mean.fj2plot[fj2plot.ind,], axis1 = 1, axis2 = 2,
                                   # col.points = col4ImportantEdg[which(importantEdg == TRUE & net.edge %in% edgeOI)],
                                   # col.labels = col4ImportantEdg[which(importantEdg == TRUE & net.edge %in% edgeOI)],
                                   col.points = col.max10,
                                   col.labels = col.max10,
                                   text.cex = 2.5,
                                   force = 1.5,
                                   # box.padding = 0.05,
                                   title = "Significantly contributed factor scores - colored by subject_x_edge types")
f_netedge_plot02 <- plot.f_edge_imp$zeMap_background + plot.f_edge_imp$zeMap_dots + plot.f_edge_imp$zeMap_text + f.labels
f_netedge_plot02

## factor maps in dot charts ----
install.packages("ggpubr")
library(ggpubr)

# get factor scores
mean.fj2plot[,"edgename"] <- rownames(mean.fj2plot)
colnames(mean.fj2plot) <- c(sapply(c(1:9), function(x){sprintf("factor%s",x)}),"edgename")
# get contributions
c_edge2plot <- c_edge[which(importantEdg == TRUE & net.edge %in% edgeOI),1:2]
# sort factor scores according to contributions
c_index <- sort(c_edge2plot[,1],decreasing = TRUE,index.return = TRUE)$ix
mean.fj2plot.sort <- mean.fj2plot[c_index,]

dotchart(mean.fj2plot.sort[,1], labels = mean.fj2plot.sort$edgename)

ggdotchart(mean.fj2plot.sort, x = "edgename", y = "factor1",
           # color = "cyl",                                # Color by groups
           # palette = c("#00AFBB", "#E7B800", "#FC4E07"), # Custom color palette
           # sorting = "ascending",                       # Sort value in descending order
           rotate = TRUE,                                # Rotate vertically
           dot.size = 2,                                 # Large dot size
           y.text.col = TRUE,                            # Color y text by groups
           ggtheme = theme_pubr()                        # ggplot2 theme
)+
  theme_cleveland()                                      # Add dashed grids

# Or, we plot the absolute factor scores instead of the mean factor scores
# compute the absolute factor scores for each network edge
abs.fj <- aggregate(svd.res$ExPosition.Data$fj, list(gtlabel$subjects_edge_label), function(x){sum(abs(x))})
rownames(abs.fj) <- abs.fj$Group.1
abs.fj <- abs.fj[,-1]
# get what we want to plot
abs.fj2plot <- abs.fj[which(importantEdg == TRUE & net.edge %in% edgeOI),]
abs.fj2plot[,"edgename"] <- rownames(abs.fj2plot)
# rename the columns and rows factor scores
colnames(abs.fj2plot) <- c(sapply(c(1:9), function(x){sprintf("factor%s",x)}),"edgename")
# get contributions
c_edge2plot <- c_edge[which(importantEdg == TRUE & net.edge %in% edgeOI),1:2]
# sort factor scores according to contributions
c_index <- sort(c_edge2plot[,1],decreasing = TRUE,index.return = TRUE)$ix
abs.fj2plot.sort <- abs.fj2plot[c_index,]

dotchart(abs.fj2plot.sort[,1], labels = abs.fj2plot.sort$edgename)

## Plot with confidence intervals (subject x network edges)----
# get the bootstrap data for each network edge
edgename.cube <- dimnames(BootCube.Comm$BootCube)[[1]]
getBoot2plot_edge <- BootCube.Comm$BootCube[which(edgename.cube  %in% rownames(mean.fj2plot)),c(1,2),]
# plot the CI ellipses
f_impedge.CI <- MakeCIEllipses(getBoot2plot_edge[fj2plot.ind,,],
                               names.of.factors = c(sprintf("Factor %s", 1),sprintf("Factor %s", 2)),
                               # col = col4ImportantEdg[which(importantEdg == TRUE & fj2plot.ind),],
                               col = col.max10,
                               p.level = .95)
# create plot
f_CInetedge_plot01 <- plot.f_edge_imp$zeMap_background + plot.f_edge_imp$zeMap_dots + plot.f_edge_imp$zeMap_text +f_impedge.CI + f.labels
f_CInetedge_plot01

## Plot with confidence intervals (subject x edge type)----
# get the bootstrap data for each type of network edges
getBoot2plot_edge_bw <- BootCube.Comm.bw$BootCube[,c(1,2),]
# plot the CI ellipses
plot.CI.f_bw <- MakeCIEllipses(getBoot2plot_edge_bw,
                               names.of.factors = c(sprintf("Factor %s", 1),sprintf("Factor %s", 2)),
                               col = net.edge.col$gc[rownames(getBoot2plot_edge_bw),],
                               p.level = .95)
# create plot
f_CInetedge_plot03 <- plot.f_bw_imp$zeMap + plot.CI.f_bw + f.labels

