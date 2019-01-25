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
load(paste0("data/grandatble_and_labels_20181231.Rdata")) # read the labels of grandtable

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

## Exclude negative correlations
r.dat <- cubes$rcube[cubes$rcube < 0] <- 0
## Community assignment
head(vox.des)
dim(vox.des)

# Reform the data -----------------------------------
## Create empty matrix for the correlation data
#--- get the length of data in the upper triangle
n.uptri <- ((dim(r.dat)[1]*dim(r.dat)[2])-dim(r.dat)[1])/2
#--- create the empty matrix
rect.dat <- matrix(NA, nrow = dim(r.dat)[3], ncol = n.uptri)

## Get the upper triangle for all sessions
rect.dat <- sapply(c(1:dim(r.dat)[3]), function(x) r.dat[,,x][upper.tri(r.dat[,,x])]) %>% t

## Get the labels of edges
labels1 <- labels[which(labels$subjects_label == "sub01"),"edges_label"]
#--- use it as column name of the rectangular matrix
colnames(rect.dat) <- labels1

## Get the design matrix for the upper triangle of subject 1
r.uptri.des <- makeNominalData(as.matrix(labels1))

# Visualize data so far ------------------------------
## Use heatmap...this takes a while
superheat(rect.dat,
          membership.cols = colnames(rect.dat),
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

# SVD on the rectangular data ------------------------
pca.res.subj1 <- epPCA(rect.dat,scale = FALSE, center = FALSE, DESIGN = r.uptri.des, make_design_nominal = FALSE)

# Compute means of factor scores for different edges----
mean.fj <- getMeans(pca.res.subj1$ExPosition.Data$fj, labels1)

# Plot -----------------------------------------------
#--- row factor scores:
plot.fi <- createFactorMap(pca.res.subj1$ExPosition.Data$fi)
plot.fi$zeMap 

#--- column factor scores:
plot.fj <- createFactorMap(mean.fj[1:100,])
plot.fj$zeMap
