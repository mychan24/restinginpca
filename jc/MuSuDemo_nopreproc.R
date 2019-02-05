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
library(psych)
library(tidyr)
library(magrittr)
library(DistatisR)
library(PTCA4CATA)
library(ExPosition) # myc added to use "makeNominalData"
library(superheat)

# Read functions -----------------------------------
tool.path <- "tools/"
# SScomm.R: the function that compute sums of squares of a square matrix according to a design matrix
source(paste0(tool.path,"SScomm.R"))

# Read data  ---------------------------------------
## resting-state data:
#--- dimensions: voxel x voxel x 10 sessions
#--- data in each cell: correlation (r)
zmat.path <- "data/zmat" # path for data
load(paste0(zmat.path,"/sub-MSC01_zcube_rcube.RData")) # read data

## the labels for each intersection of the correlation matirx
load(paste0("data/grandatble_and_labels_20190125.Rdata")) # read the labels of grandtable

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

# Reform the data -----------------------------------
## Create empty matrix for the correlation data
#--- get the length of data in the upper triangle
n.uptri <- ((dim(z.dat)[1]*dim(z.dat)[2])-dim(z.dat)[1])/2
#--- create the empty matrix
rect.dat <- matrix(NA, nrow = dim(z.dat)[3], ncol = n.uptri)

## Get the upper triangle for all sessions
rect.dat <- sapply(c(1:dim(z.dat)[3]), function(x) z.dat[,,x][upper.tri(z.dat[,,x])]) %>% t

## Get the labels of edges
labels1 <- labels[which(labels$subjects_label == "sub01"),"edges_label"]
#--- use it as column name of the rectangular matrix
colnames(rect.dat) <- labels1

## Get the design matrix for the upper triangle of subject 1
r.uptri.des <- makeNominalData(as.matrix(labels1))

# Visualize data so far ------------------------------
## Use heatmap...this takes a while
dev.new()
superheat(gt[,which(labels$subjects_label!="sub02")],
          membership.cols = labels$subjects_edge_label[which(labels$subjects_label!="sub02")],
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

colnames(gt) <- labels$subjects_edge_label
# SVD on the rectangular data ------------------------
pca.res.subj <- epPCA(t(gt[,which(labels$subjects_label=="sub01")]),scale = FALSE, center = FALSE, DESIGN = labels$subjects_edge_label[which(labels$subjects_label=="sub01")], make_design_nominal = TRUE, graphs = FALSE)

# Compute means of factor scores for different edges----
mean.fj <- getMeans(pca.res.subj1$ExPosition.Data$fj, labels$subjects_edge_label)
mean.fi <- getMeans(pca.res.subj$ExPosition.Data$fi, labels$subjects_edge_label[which(labels$subjects_label=="sub01")]) # with t(gt)

# Plot -----------------------------------------------
#--- row factor scores:
plot.fi <- createFactorMap(pca.res.subj1$ExPosition.Data$fi)
plot.fj <- createFactorMap(pca.res.subj$ExPosition.Data$fj) # with t(gt)

plot.fi$zeMap
dev.new()
plot.fj$zeMap
#--- column factor scores:
plot.fj <- createFactorMap(mean.fj, axis1 = 2, axis2 = 3)
plot.fi <- createFactorMap(mean.fi, axis1 = 2, axis2 = 3,
                           col.points = unique(pca.res.subj$Plotting.Data$fi.col),
                           text.cex = 1) # with t(gt)
dev.new()
plot.fi$zeMap
plot.fi$zeMap_background + plot.fi$zeMap_dots
prettyPlot(mean.fi, x_axis = 2, y_axis = 3)

## See plot
dev.new()
superheat(gt[,c("sub01_4_8","sub01_8","sub01_6_10","sub01_8_29","sub01_6","sub01_4_29","sub01_29","sub01_9","sub01_14","sub01_11_29","sub01_12_17","sub01_12","sub01_10_17")],
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
