##############################################
### Testing with data of multiple subjects ###
##############################################
##     No centering and normalization
##============================================
# We are using the MSC data
# Edited by Ju-Chi Yu on Jan. 24th, 2019

# Procedure outline:-------------------------------
#--1. Correlation matrix (subj1) >> rectangular matrix (sessions x voxels by network) >> SVD
#--2. Correlation matirx (subj1-subj3) >> rectangular matrix [sessions x voxels by network by subject] >> SVD

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

# Read functions -----------------------------------
tool.path <- "tools/"
# SScomm.R: the function that compute sums of squares of a square matrix according to a design matrix
source(paste0(tool.path,"SScomm.R"))
source(paste0(tool.path,"vec2sqmat.R"))
# Read data  ---------------------------------------
## resting-state data:
#--- dimensions: voxel x voxel x 10 sessions
#--- data in each cell: z-transformed correlation (z)
zmat.path <- "data/zmat" # path for data
load(paste0(zmat.path,"/sub-MSC01_zcube_rcube.RData")) # read data

## the labels for each intersection of the correlation matirx
load(paste0("data/grandatble_and_labels_20190204.Rdata")) # read the labels of grandtable

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

# Check data ---------------------------------------
## They are called cubes
dim(cubes$rcube) # correlations
dim(cubes$zcube) # Fisher's z-transformed correlations
#--- WE USE ZCUBE

## Exclude negative correlations
# cubes$rcube[cubes$rcube < 0] <- 0
z.dat <- cubes$zcube
## Community assignment
head(vox.des)
dim(vox.des)

# # Reform the data -----------------------------------
# ## Create empty matrix for the correlation data
# #--- get the length of data in the upper triangle
# n.uptri <- ((dim(z.dat)[1]*dim(z.dat)[2])-dim(z.dat)[1])/2
# #--- create the empty matrix
# rect.dat <- matrix(NA, nrow = dim(z.dat)[3], ncol = n.uptri)
# 
# ## Get the upper triangle for all sessions
# rect.dat <- sapply(c(1:dim(z.dat)[3]), function(x) z.dat[,,x][upper.tri(z.dat[,,x])]) %>% t
# 
# ## Get the labels of edges
# labels1 <- labels[which(labels$subjects_label == "sub01"),"edges_label"]
# #--- use it as column name of the rectangular matrix
# colnames(rect.dat) <- labels1
# 
# ## Get the design matrix for the upper triangle of subject 1
# r.uptri.des <- makeNominalData(as.matrix(labels1))

# Visualize data so far ------------------------------
## Use heatmap...this takes a while
dev.new()
superheat(gt,
          membership.cols = labels$subjects_edge_label,
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
          left.label.text.alignment = "left",
          grid.vline = FALSE
)


## Categorize columns by between or within edges
#--- Create new column of sub-edgetype
sprintf('%s_%s',labels$subjects_label,labels$wb)
labels[,'subjects_wb'] <- sprintf('%s_%s',labels$subjects_label,labels$wb)
#--- Now draw the heatmap with columns arranged according to edgetype
dev.new()
superheat(gt,
          membership.cols = labels$subjects_wb,
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
          left.label.text.alignment = "left",
          grid.vline = FALSE
)

colnames(gt) <- labels$subjects_edge_label

# SVD on the rectangular data ------------------------
pca.res.subj <- epPCA(t(gt),scale = FALSE, center = FALSE, DESIGN = labels$subjects_edge_label, make_design_nominal = TRUE, graphs = FALSE)

dim(t(gt))
# Get the contributions for each variable ------------
#--- get the contribution of each component
cI <- pca.res.subj$ExPosition.Data$ci
#--- get the sum of contribution for each edge
c_edge <- labels$subjects_edge_label %>% as.matrix %>% makeNominalData %>% t %>% "%*%"(cI)
rownames(c_edge) <- sub(".","",rownames(c_edge))
#--- compute the sums of squares of each variable for each component
absCtrEdg <- as.matrix(c_edge) %*% diag(pca.res.subj$ExPosition.Data$eigs)
#--- get the contribution for component 1 AND 2 by sum(SS from 1, SS from 2)/sum(eigs 1, eigs 2)
edgCtr12 <- (absCtrEdg[,1] + absCtrEdg[,2])/(pca.res.subj$ExPosition.Data$eigs[1] + pca.res.subj$ExPosition.Data$eigs[2])
edgCtr23 <- (absCtrEdg[,3] + absCtrEdg[,2])/(pca.res.subj$ExPosition.Data$eigs[2] + pca.res.subj$ExPosition.Data$eigs[3])
#--- the important variables are the ones that contribute more than or equal to the average
importantEdg <- (edgCtr12 >= 1/length(edgCtr12))
importantEdg <- (edgCtr23 >= 1/length(edgCtr23))
#--- color for networks
col4ImportantEdg <- unique(pca.res.subj$Plotting.Data$fi.col) # get colors
col4NS <- 'gray90' # set color for not significant edges to gray
col4ImportantEdg[!importantEdg] <- col4NS # replace them in the color vector

# Compute means of factor scores for different edges----
mean.fi <- getMeans(pca.res.subj$ExPosition.Data$fi, labels$subjects_edge_label) # with t(gt)

BootCube.Comm <- Boot4Mean(pca.res.subj$ExPosition.Data$fi,
                           design = labels$subjects_edge_label,
                           niter = 100,
                           suppressProgressBar = TRUE)
BootFactorScores(pca.res.subj$ExPosition.Data$fi)


# Compute means of factor scores for different types of edges
mean.fi.bw <- getMeans(pca.res.subj$ExPosition.Data$fi, labels$subjects_wb) # with t(gt)
BootCube.Comm.bw <- Boot4Mean(pca.res.subj$ExPosition.Data$fi,
                           design = labels$subjects_wb,
                           niter = 100,
                           suppressProgressBar = TRUE)
# Plot -----------------------------------------------
#--- row factor scores:
plot.fi <- createFactorMap(pca.res.subj$ExPosition.Data$fi)
plot.fj <- createFactorMap(pca.res.subj$ExPosition.Data$fj) # with t(gt)

plot.fi$zeMap
dev.new()
plot.fj$zeMap
#--- column factor scores:
plot.fi <- createFactorMap(mean.fi, axis1 = 2, axis2 = 3,
                           col.points = col4ImportantEdg,
                           text.cex = 2,
                           force = 0.5)
dev.new()
plot.fi$zeMap_background + plot.fi$zeMap_dots
#--- plot only the significant edges
plot.fi <- createFactorMap(mean.fi[importantEdg,], axis1 = 2, axis2 = 3,
                           col.points = col4ImportantEdg[importantEdg],
                           text.cex = 2,
                           force = 0.5# how much ggrepel repels the labels
                           ) # with t(gt)
dev.new()
plot.fi$zeMap
plot.fi$zeMap_background + plot.fi$zeMap_text
plot.fi$zeMap_text
prettyPlot(mean.fi[importantEdg,], x_axis = 1, y_axis = 2)

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
fi1_sub1_sig <- fi1_sub1
fi1_sub1_sig[ci1_sub1 < 1/length(ci1_sub1)] <- 0
newmat <- vec2sqmat(fi1_sub1)
newmat <- vec2sqmat(fi1_sub1_sig)
superheat(newmat, y.axis.reverse = T,
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
