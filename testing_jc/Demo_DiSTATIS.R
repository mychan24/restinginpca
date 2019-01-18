######################################
### DiSTATIS on resting state data ###
######################################
# We are using a toy data
# Edited by Ju-Chi Yu on Dec. 26th, 2018

# Procedure outline:-------------------------------
# Correlation matrix >> distance matrix >> DiSTATIS 

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
source(paste0(tool.path,"SScomm.R"))
# Read data  ---------------------------------------
zmat.path <- "data/zmat"
load(paste0(zmat.path,"/sub-MSC01_zcube_rcube.RData"))

parcel.comm.path <- "data/parcel_community"
vox.des <- read.table(paste0(parcel.comm.path,"/sub-MSC01_node_parcel_comm.txt"),sep = ",")
colnames(vox.des) <- c("NodeID","VertexID","Comm")
# rename communities
CommName <- read.csv(paste0(parcel.comm.path,"/systemlabel.txt"),sep = ",",header = FALSE)
colnames(CommName) <- c("Comm","CommLabel","CommColor","CommLabel.short")
for(i in 1:nrow(CommName)){
  vox.des$Comm.recode[vox.des$Comm==CommName$Comm[i]] <- as.character(CommName$CommLabel[i])
  vox.des$Comm.Col[vox.des$Comm==CommName$Comm[i]] <- as.character(CommName$CommColor[i])
  vox.des$Comm.rcd[vox.des$Comm==CommName$Comm[i]] <- as.character(CommName$CommLabel.short[i])
}
# Create design matrix for communities
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

# Transform into distances--------------------------
dcube <- cor2dist(cubes$rcube)
dcube

# Compute SS of each community----------------------
## SS of correlation
ss_rcube <- SScomm(cubes$rcube,vox.des.mat)
## SS of distance
ss_dcube <- SScomm(dcube,vox.des.mat)


# Plot heatmap--------------------------------------
## Specify color for each node and create color list for ExPosition
Comm.col <- list(oc = as.matrix(vox.des$Comm.Col), gc = as.matrix(CommName$CommColor))
rownames(Comm.col$oc) <- vox.des$NodeID
rownames(Comm.col$gc) <- CommName$CommLabel.short

## heapmat
superheat(cubes$rcube[,,1],
          membership.cols = vox.des$Comm.rcd,
          membership.rows = vox.des$Comm.rcd,
          clustering.method = NULL,
          heat.col.scheme = "viridis",
          left.label.size = 0.08,
          bottom.label.size = 0.05,
          y.axis.reverse = TRUE,
          left.label.col = Comm.col$gc[order(rownames(Comm.col$gc))], # order by community name
          bottom.label.col = Comm.col$gc[order(rownames(Comm.col$gc))],
          left.label.text.size = 3,
          bottom.label.text.size = 2,
          left.label.text.col = c(rep("black",8),rep("white",2),rep("black",3),"white",rep("black",3),rep("white",2)),
          bottom.label.text.col = c(rep("black",8),rep("white",2),rep("black",3),"white",rep("black",3),rep("white",2)),
          left.label.text.alignment = "left"
          )

# Plot heatmap (SS)---------------------------------
superheat(ss_rcube[,,1],
          membership.cols = rownames(ss_rcube[,,1]),
          membership.rows = colnames(ss_rcube[,,1]),
          clustering.method = NULL,
          heat.col.scheme = "viridis",
          left.label.size = 0.08,
          bottom.label.size = 0.05,
          y.axis.reverse = TRUE,
          left.label.col = Comm.col$gc[order(rownames(Comm.col$gc))], # order by community name
          bottom.label.col = Comm.col$gc[order(rownames(Comm.col$gc))],
          left.label.text.size = 3,
          bottom.label.text.size = 2,
          left.label.text.col = c(rep("black",8),rep("white",2),rep("black",3),"white",rep("black",3),rep("white",2)),
          bottom.label.text.col = c(rep("black",8),rep("white",2),rep("black",3),"white",rep("black",3),rep("white",2)),
          left.label.text.alignment = "left"
)
superheat(ss_dcube[,,1],
          membership.cols = rownames(ss_dcube[,,1]),
          membership.rows = colnames(ss_dcube[,,1]),
          clustering.method = NULL,
          heat.col.scheme = "viridis",
          left.label.size = 0.08,
          bottom.label.size = 0.05,
          y.axis.reverse = TRUE,
          left.label.col = Comm.col$gc[order(rownames(Comm.col$gc))], # order by community name
          bottom.label.col = Comm.col$gc[order(rownames(Comm.col$gc))],
          left.label.text.size = 3,
          bottom.label.text.size = 2,
          left.label.text.col = c(rep("black",8),rep("white",2),rep("black",3),"white",rep("black",3),rep("white",2)),
          bottom.label.text.col = c(rep("black",8),rep("white",2),rep("black",3),"white",rep("black",3),rep("white",2)),
          left.label.text.alignment = "left"
)

# DiSTATIS in R-------------------------------------
distatis.res <- distatis(dcube)

# Plot DiSTATIS result------------------------------
## Rv map ----
### eigen values
PlotScree(ev = distatis.res$res4Cmat$eigValues,
          title = "RV-map: Expained variance per dimension")
### Rv factor scores
rv.graph <- createFactorMap(distatis.res$res4Cmat$G,
                axis1 = 1, axis2 = 2)
### Dimension labels for the Rv map
rv.labels <- createxyLabels.gen(lambda = distatis.res$res4Cmat$eigValues,
                                tau = distatis.res$res4Cmat$tau,
                                axisName = "Dimension ")
### Show plot
Rvmap <- rv.graph$zeMap + rv.labels
print(Rvmap)

## Compromise map ----
### eigen values
PlotScree(ev = distatis.res$res4Splus$eigValues,
          title = "Compromise: Explained variance per dimension")
### Components of interest
x_cp <- 1
y_cp <- 2
### Factor scores
f.graph <- createFactorMap(distatis.res$res4Splus$F,
                           axis1 = x_cp, axis2 = y_cp,
                           title = "Compromise - Factor scores (nodes)",
                           col.points = Comm.col$oc,
                           alpha.points = .4, cex = 4)
f.labels <- createxyLabels.gen(x_axis = x_cp, y_axis = y_cp,
                               lambda = distatis.res$res4Splus$eigValues,
                               tau = distatis.res$res4Splus$tau,
                               axisName = "Dimension ")
### Show plot
f01.Fi.noLabel <- f.graph$zeMap_background + f.graph$zeMap_dots + f.labels
print(f01.Fi.noLabel)

## Compromise map with means, confidence intervals, and tolerance intervals ----
### Compute means for communities
BootCube.Comm <- Boot4Mean(distatis.res$res4Splus$F,
                         design = vox.des$Comm.rcd,
                         niter = 100,
                         suppressProgressBar = TRUE)

### Plot means
f.mean.graph <- createFactorMap(BootCube.Comm$GroupMeans,
                                axis1 = x_cp, axis2 = y_cp,
                                col.points = Comm.col$gc[rownames(BootCube.Comm$GroupMeans),],
                                constraints = f.graph$constraints,
                                col.labels = Comm.col$gc[rownames(BootCube.Comm$GroupMeans),],
                                alpha.points = .8,
                                pch = 15,
                                cex = 4)
### Plot bootstrapped confidence intervals for means
f.CI.graph <- MakeCIEllipses(BootCube.Comm$BootCube[,c(x_cp,y_cp),],
                                    names.of.factors = c(sprintf("Factor %s",x_cp),sprintf("Factor %s",y_cp)),
                                    col = Comm.col$gc[rownames(BootCube.Comm$GroupMeans),],
                                    p.level = .95)
### Plot tolerance intervals of each community
f.TI.graph <- MakeToleranceIntervals(distatis.res$res4Splus$F,
                                     axis1 = x_cp, axis2 = y_cp,
                                     design = vox.des$Comm,
                                     names.of.factors = c("Dim1", "Dim2"),
                                     col = Comm.col$gc[rownames(BootCube.Comm$GroupMeans),],
                                     line.size = .50,
                                     line.type = 3,
                                     alpha.ellipse = .2,
                                     alpha.line = .4,
                                     p.level =.95)
### Show plot
f02.Fi.CiTiMean <- f.graph$zeMap_background + f.TI.graph + f.graph$zeMap_dots + f.CI.graph + f.mean.graph$zeMap_dots + f.mean.graph$zeMap_text + f.labels
print(f02.Fi.CiTiMean)

f03.Fi.CiMean <- f.graph$zeMap_background + f.mean.graph$zeMap_dots + f.CI.graph + f.labels + f.mean.graph$zeMap_text
print(f03.Fi.CiMean)
