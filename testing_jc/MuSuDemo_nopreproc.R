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
tool.path <- "../tools/"
# SScomm.R: the function that compute sums of squares of a square matrix according to a design matrix
source(paste0(tool.path,"SScomm.R"))

# Read data  ---------------------------------------
## resting-state data:
#--- dimensions: voxel x voxel x 10 sessions
#--- data in each cell: Fisher's Z-transformed correlation (r)
zmat.path <- "data/zmat" # path for data
load(paste0(zmat.path,"/sub-MSC01_zcube_rcube.RData")) # read data

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
dim(cubes$zcube) # z-transformed correlations

## Exclude negative correlations
cubes$rcube[cubes$rcube < 0] <- 0
## Community assignment
head(vox.des)
dim(vox.des)
