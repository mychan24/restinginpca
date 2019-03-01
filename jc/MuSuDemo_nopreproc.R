##############################################
### Testing with data of multiple subjects ###
##############################################
##     No centering and normalization
##============================================
# We are using the MSC data
# Edited by Ju-Chi Yu on Feb. 28th, 2019

# Procedure outline:-------------------------------
#--1. Correlation matrix (subj1, sessions 1-10) >> rectangular matrix (sessions x voxels by network) >> SVD
#--2. Correlation matirx (subj1, sessions 1-5; 6-10) >> rectangular matrix [sessions x voxels by network by subject] >> SVD

# Library ------------------------------------------
## install.packages("psych")
## devtools::install_github('HerveAbdi/DistatisR')
## devtools::install_github('HerveAbdi/PTCA4CATA')
## devtools::install_github('mychan24/superheat')
## devtools::install_github('HerveAbdi/data4PCCAR')
library(psych)
library(tidyr)
library(magrittr)
library(DistatisR)
library(PTCA4CATA)
library(data4PCCAR)
library(ExPosition) # myc added to use "makeNominalData"
library(superheat)
library(pals)
library(magick)

# Read functions -----------------------------------
tool.path <- "tools/"
# SScomm.R: the function that compute sums of squares of a square matrix according to a design matrix
source(paste0(tool.path,"SScomm.R"))
source(paste0(tool.path,"vec2sqmat.R"))
#============================#
# One subject; sessions 1-10 # ----
#============================#
# > Read correlation matrix of subject 1 -------------
## resting-state data:
#--- dimensions: voxel x voxel x 10 sessions
#--- data in each cell: z-transformed correlation (z)
zmat.path <- "data/zmat" # path for data
load(paste0(zmat.path,"/sub-MSC01_zcube_rcube.RData")) # read data

# > Check data ---------------------------------------
## show data in 10 seesions
dim(cubes$rcube) # correlations
dim(cubes$zcube) # Fisher's z-transformed correlations

# > Information for communities -------------------
## the community (network) each voxel belongs to:
parcel.comm.path <- "data/parcel_community" # path for community information
# read community information: a table with each voxel on the rows with a NodeID, vertexID, and c
vox.des <- read.table(paste0(parcel.comm.path,"/sub-MSC01_node_parcel_comm.txt"),sep = ",")
colnames(vox.des) <- c("NodeID","VertexID","Comm")

## rename communities
#--- read the file with community information: label number & community name & color & abbreviation for community name
CommName <- read.csv(paste0(parcel.comm.path,"/systemlabel.txt"),sep = ",",header = FALSE)
colnames(CommName) <- c("Comm","CommLabel","CommColor","CommLabel.short")
#--- create three columns in the original table of community information: name, color, abbreviation
for(i in 1:nrow(CommName)){
  vox.des$Comm.recode[vox.des$Comm==CommName$Comm[i]] <- as.character(CommName$CommLabel[i])
  vox.des$Comm.Col[vox.des$Comm==CommName$Comm[i]] <- as.character(CommName$CommColor[i])
  vox.des$Comm.rcd[vox.des$Comm==CommName$Comm[i]] <- as.character(CommName$CommLabel.short[i])
}
#--- Create design matrix for communities
vox.des.mat <- makeNominalData(as.matrix(vox.des$Comm.rcd))
colnames(vox.des.mat) <- sub(".","",colnames(vox.des.mat))

#--- Create color for each communities
Comm.col <- list(oc = as.matrix(vox.des$Comm.Col), gc = as.matrix(CommName$CommColor))
rownames(Comm.col$oc) <- vox.des$NodeID
rownames(Comm.col$gc) <- CommName$CommLabel.short

# > Visualize 10 correlation matrix
img <- image_graph(800, 1000)
out <- lapply(1:10, function(session.count){
  hmap <- superheat(cubes$zcube[,,session.count],
                    membership.cols = vox.des$Comm.rcd,
                    membership.rows = vox.des$Comm.rcd,
                    clustering.method = NULL,
                    heat.lim = c(0, 0.6), 
                    heat.pal = parula(20),
                    heat.pal.values = c(0, 0.5, 1),
                    left.label.size = 0.08,
                    bottom.label.size = 0.05,
                    y.axis.reverse = TRUE,
                    left.label.col = Comm.col$gc[order(rownames(Comm.col$gc))], # order by community name
                    bottom.label.col = Comm.col$gc[order(rownames(Comm.col$gc))],
                    left.label.text.size = 3,
                    bottom.label.text.size = 2,
                    left.label.text.col = c(rep("black",8),rep("white",2),rep("black",3),"white",rep("black",3),rep("white",2)),
                    bottom.label.text.col = c(rep("black",8),rep("white",2),rep("black",3),"white",rep("black",3),rep("white",2)),
                    left.label.text.alignment = "left",
                    title = sprintf("Correlation matrix of #%s session",session.count))
  print(hmap$plot)
})
dev.off()
sess.animate <- image_animate(img, fps = 4)


# > Read grand table of subject 1 --------------------
## grand table and the labels for each intersection of the correlation matirx
load(paste0("data/grandatble_and_labels_20190204.Rdata")) # read the labels of grandtable
# gt: grand tabls
# labels: information for each edge in the rectangular grand table

## Categorize columns by between or within edges
#--- Create new column of sub-edgetype
sprintf('%s_%s',labels$subjects_label,labels$wb)
labels[,'subjects_wb'] <- sprintf('%s_%s',labels$subjects_label,labels$wb)

## get data from subject 1
gt.sub1 <- gt[,which(labels$subjects_label == "sub01")]
labels.sub1 <- labels[which(labels$subjects_label == "sub01"),]

# > Visualize grand table-----------------------------
## Use heatmap...this takes a while
dev.new()
superheat(gt.sub1,
          membership.cols = labels.sub1$subjects_edge_label,
          membership.rows = c(1:10),
          clustering.method = NULL,
          heat.lim = c(0, 0.6), 
          heat.pal = parula(20),
          heat.pal.values = c(0, 0.5, 1),
          left.label.size = 0.05,
          bottom.label.size = 0.05,
          y.axis.reverse = TRUE,
          # left.label.col = Comm.col$gc[order(rownames(Comm.col$gc))], # order by community name
          # bottom.label.col = Comm.col$gc[order(rownames(Comm.col$gc))],
          left.label.text.size = 3,
          bottom.label.text.size = 2,
          # left.label.text.col = c(rep("black",8),rep("white",2),rep("black",3),"white",rep("black",3),rep("white",2)),
          # bottom.label.text.col = c(rep("black",8),rep("white",2),rep("black",3),"white",rep("black",3),rep("white",2)),
          left.label.text.alignment = "left",
          grid.vline = FALSE
)


#--- Now draw the heatmap with columns arranged according to edgetype
dev.new()
superheat(gt.sub1,
          membership.cols = labels.sub1$subjects_wb,
          membership.rows = c(1:10),
          clustering.method = NULL,
          heat.lim = c(0, 0.6), 
          heat.pal = parula(20),
          heat.pal.values = c(0, 0.5, 1),
          left.label.size = 0.05,
          bottom.label.size = 0.05,
          y.axis.reverse = TRUE,
          # left.label.col = Comm.col$gc[order(rownames(Comm.col$gc))], # order by community name
          # bottom.label.col = Comm.col$gc[order(rownames(Comm.col$gc))],
          left.label.text.size = 3,
          bottom.label.text.size = 2,
          # left.label.text.col = c(rep("black",8),rep("white",2),rep("black",3),"white",rep("black",3),rep("white",2)),
          # bottom.label.text.col = c(rep("black",8),rep("white",2),rep("black",3),"white",rep("black",3),rep("white",2)),
          left.label.text.alignment = "left",
          grid.vline = FALSE
)

colnames(gt.sub1) <- labels.sub1$subjects_edge_label

# > SVD on the rectangular data ------------------------
pca.res.subj <- epPCA(t(gt.sub1),scale = FALSE, center = FALSE, DESIGN = labels.sub1$subjects_edge_label, make_design_nominal = TRUE, graphs = FALSE)

dim(t(gt.sub1))
# > Scree plot with explained variance (t) ------------
PlotScree(ev = pca.res.subj$ExPosition.Data$t,
          title = "Expained variance per dimension")
# > Get the contributions for each variable ------------
#--- get the contribution of each component
cI <- pca.res.subj$ExPosition.Data$ci
#--- get the sum of contribution for each edge
c_edge <- labels.sub1$subjects_edge_label %>% as.matrix %>% makeNominalData %>% t %>% "%*%"(cI)
rownames(c_edge) <- sub(".","",rownames(c_edge))
#--- compute the sums of squares of each variable for each component
absCtrEdg <- as.matrix(c_edge) %*% diag(pca.res.subj$ExPosition.Data$eigs)
#--- get the contribution for component 1 AND 2 by sum(SS from 1, SS from 2)/sum(eigs 1, eigs 2)
edgCtr12 <- (absCtrEdg[,1] + absCtrEdg[,2])/(pca.res.subj$ExPosition.Data$eigs[1] + pca.res.subj$ExPosition.Data$eigs[2])
edgCtr23 <- (absCtrEdg[,3] + absCtrEdg[,2])/(pca.res.subj$ExPosition.Data$eigs[2] + pca.res.subj$ExPosition.Data$eigs[3])
#--- the important variables are the ones that contribute more than or equal to the average
importantEdg12 <- (edgCtr12 >= 1/length(edgCtr12))
importantEdg23 <- (edgCtr23 >= 1/length(edgCtr23))
importantEdg1 <- (cI[,1] >= 1/length(cI[,1]))
importantEdg2 <- (cI[,2] >= 1/length(cI[,2]))
#--- color for networks
col4ImportantEdg <- unique(pca.res.subj$Plotting.Data$fi.col) # get colors
col4NS <- 'gray90' # set color for not significant edges to gray
col4ImportantEdg[!importantEdg12] <- col4NS # replace them in the color vector

# > Compute means of factor scores for different edges----
mean.fi <- getMeans(pca.res.subj$ExPosition.Data$fi, labels$subjects_edge_label) # with t(gt)

BootCube.Comm <- Boot4Mean(pca.res.subj$ExPosition.Data$fi,
                           design = labels.sub1$subjects_edge_label,
                           niter = 100,
                           suppressProgressBar = TRUE)
BootFactorScores(pca.res.subj$ExPosition.Data$fi)


# Compute means of factor scores for different types of edges
mean.fi.bw <- getMeans(pca.res.subj$ExPosition.Data$fi, labels$subjects_wb) # with t(gt)
BootCube.Comm.bw <- Boot4Mean(pca.res.subj$ExPosition.Data$fi,
                              design = labels.sub1$subjects_wb,
                              niter = 100,
                              suppressProgressBar = TRUE)
# > Plot -----------------------------------------------
#--- row factor scores (sessions):
plot.fj <- createFactorMap(pca.res.subj$ExPosition.Data$fj) # with t(gt)

dev.new()
plot.fj$zeMap
#--- column factor scores (edges):
plot.fi <- createFactorMap(mean.fi, axis1 = 2, axis2 = 3,
                           col.points = col4ImportantEdg,
                           text.cex = 2,
                           force = 0.5)
dev.new()
plot.fi$zeMap_background + plot.fi$zeMap_dots
#----- plot only the significant edges
plot.fi <- createFactorMap(mean.fi[importantEdg,], axis1 = 2, axis2 = 3,
                           col.points = col4ImportantEdg[importantEdg],
                           text.cex = 2,
                           force = 0.5# how much ggrepel repels the labels
) # with t(gt)
dev.new()
plot.fi$zeMap
plot.fi$zeMap_background + plot.fi$zeMap_text
prettyPlot(mean.fi[importantEdg,], x_axis = 1, y_axis = 2)

#--- show column factor scores in a square matrix
fi1_sqmat <- vec2sqmat(pca.res.subj$ExPosition.Data$fi[,1])
superheat(fi1_sqmat, y.axis.reverse = T,
          membership.rows =vox.des$Comm.rcd,
          membership.cols =vox.des$Comm.rcd,                    
          left.label.col=Comm.col$gc[order(rownames(Comm.col$gc))],
          bottom.label.col=Comm.col$gc[order(rownames(Comm.col$gc))],
          left.label.size = 0.08,
          bottom.label.size = 0.05,
          extreme.values.na = FALSE,
          heat.lim = c(-.6, .6),
          heat.pal = kovesi.diverging_bwr_40_95_c42(200),
          heat.pal.values = c(0,0.35,0.5,0.65,1),
          left.label.text.size = 3,
          bottom.label.text.size = 2,
          left.label.text.col = c(rep("black",8),rep("white",2),rep("black",3),"white",rep("black",3),rep("white",2)),
          bottom.label.text.col = c(rep("black",8),rep("white",2),rep("black",3),"white",rep("black",3),rep("white",2)),
          title="Node x Node Matrix of factor scores")

#----- plot only fi with significant contribution in a square matrix
fj_sig <- pca.res.subj$ExPosition.Data$fj
fj_sig[!importantEdg1] <- 0
fj_sig_sqmat <- vec2sqmat(fj_sig)
superheat(fj_sig_sqmat, y.axis.reverse = T,
          membership.rows =vox.des$Comm.rcd,
          membership.cols =vox.des$Comm.rcd,                    
          left.label.col=Comm.col$gc[order(rownames(Comm.col$gc))],
          bottom.label.col=Comm.col$gc[order(rownames(Comm.col$gc))],
          left.label.size = 0.08,
          bottom.label.size = 0.05,
          extreme.values.na = FALSE,
          heat.lim = c(-.6, .6),
          heat.pal = kovesi.diverging_bwr_40_95_c42(200),
          heat.pal.values = c(0,0.35,0.5,0.65,1),
          left.label.text.size = 3,
          bottom.label.text.size = 2,
          left.label.text.col = c(rep("black",8),rep("white",2),rep("black",3),"white",rep("black",3),rep("white",2)),
          bottom.label.text.col = c(rep("black",8),rep("white",2),rep("black",3),"white",rep("black",3),rep("white",2)),
          title="Node x Node Matrix of factor scores")


## Supplementary codes below: -----------------------
##=========THIS DOES NOT WORK=================
### Plot bootstrapped confidence intervals for means
f.CI.graph <- MakeCIEllipses(BootCube.Comm$BootCube[,c(1,2),],
                             names.of.factors = c("Factor 1","Factor 2"),
                             col = col4ImportantEdg[rownames(BootCube.Comm$GroupMeans),],
                             p.level = .95)

dev.new()
plot.fi$zeMap + f.CI.graph
plot.fi$zeMap_background + plot.fi$zeMap_dots + f.CI.graph
##============================================

#--- plot only the edge types
plot.fi.bw <- createFactorMap(mean.fi.bw, axis1 = 2, axis2 = 3,
                              text.cex = 2) # with t(gt)

dev.new()
plot.fi.bw$zeMap

##=========THIS DOES NOT WORK=================
### Plot bootstrapped confidence intervals for means
f.CI.graph.bw <- MakeCIEllipses(BootCube.Comm.bw$BootCube[,c(1,2),],
                                names.of.factors = c("Factor 1","Factor 2"),
                                p.level = .95)

dev.new()
plot.fi$zeMap_background + plot.fi$zeMap_dots + f.CI.graph.bw
##============================================
# heatmap of factor scores
ci1_sub1 <- pca.res.subj$ExPosition.Data$ci[labels$subjects_label=="sub01",1]

## See plot for edges ordered by fi_1
name4ImportantEdg1 <- rownames(mean.fi[importantEdg,])[sort(mean.fi[importantEdg,1],index.return = TRUE)$ix]
dev.new()
superheat(gt[,name4ImportantEdg1],
          # membership.cols = labels$subjects_edge_label[which(labels$subjects_label!="sub02")],
          membership.rows = c(1:10),
          clustering.method = NULL,
          heat.col.scheme = "viridis",
          left.label.size = 0.05,
          bottom.label.size = 0.05,
          y.axis.reverse = TRUE,
          # left.label.col = Comm.col$gc[order(rownames(Comm.col$gc))], # order by community name
          # bottom.label.col = Comm.col$gc[order(rownames(Comm.col$gc))],
          left.label.text.size = 3,
          bottom.label.text.size = 2,
          # left.label.text.col = c(rep("black",8),rep("white",2),rep("black",3),"white",rep("black",3),rep("white",2)),
          # bottom.label.text.col = c(rep("black",8),rep("white",2),rep("black",3),"white",rep("black",3),rep("white",2)),
          left.label.text.alignment = "left"
)

## See plot for edges ordered by fi_2
name4ImportantEdg2 <- rownames(mean.fi[importantEdg,])[sort(mean.fi[importantEdg,2],index.return = TRUE)$ix]
dev.new()
superheat(gt[,name4ImportantEdg2],
          # membership.cols = labels$subjects_edge_label[which(labels$subjects_label!="sub02")],
          membership.rows = c(1:10),
          clustering.method = NULL,
          heat.col.scheme = "viridis",
          left.label.size = 0.05,
          bottom.label.size = 0.05,
          y.axis.reverse = TRUE,
          # left.label.col = Comm.col$gc[order(rownames(Comm.col$gc))], # order by community name
          # bottom.label.col = Comm.col$gc[order(rownames(Comm.col$gc))],
          left.label.text.size = 3,
          bottom.label.text.size = 2,
          # left.label.text.col = c(rep("black",8),rep("white",2),rep("black",3),"white",rep("black",3),rep("white",2)),
          # bottom.label.text.col = c(rep("black",8),rep("white",2),rep("black",3),"white",rep("black",3),rep("white",2)),
          left.label.text.alignment = "left"
)
