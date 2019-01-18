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
library(psych)
library(tidyr)
library(magrittr)
library(DistatisR)
library(PTCA4CATA)
library(ExPosition) # myc added to use "makeNominalData"
library(pheatmap) # myc added to use "pheatmap"
# Read data  ---------------------------------------
zmat.path <- "data/zmat"
load(paste0(zmat.path,"/sub-MSC01_zcube_rcube.RData"))

parcel.comm.path <- "data/parcel_community"
vox.des <- read.table(paste0(parcel.comm.path,"/sub-MSC01_node_parcel_comm.txt"),sep = ",")
colnames(vox.des) <- c("NodeID","VertexID","Comm")
# recode communities with alphabets
vox.des$Comm.recode  <- dplyr::recode(vox.des$Comm, "0" = "A", "1" = "B", "2" = "C", "3" = "D", "4" = "E", "5" = "F", "6" = "G", "7" = "H", "8" = "I", "9" = "J", "10" = "K", "11" = "L", "12" = "M", "13" = "N", "14" = "O", "15" = "P", "16" = "Q", "17" = "R", "29" = "S")

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

# Plot heatmap--------------------------------------
## order nodes according to community
vox.order <- vox.des[order(vox.des$Comm.recode),]
rcube.order <- cubes$rcube[vox.order$NodeID,vox.order$NodeID,]
rownames(rcube.order) <- vox.order$NodeID
colnames(rcube.order) <- vox.order$NodeID
## Create colors from the community assignment vector
Comm.col <- vox.des$Comm %>% as.data.frame %>% makeNominalData %>% createColorVectorsByDesign(hsv = FALSE, offset = 25)
## rename the rows and take away the first two periods
rownames(Comm.col$gc) %<>% sub("..", "", .)
## design matrix
vox.order.df <- data.frame(Comm = factor(vox.order$Comm.recode), row.names = rownames(rcube.order[,,1]))
vox.order.col <- list(Comm = c("A" = Comm.col$gc[1],
                               "B" = Comm.col$gc[2],
                               "C" = Comm.col$gc[3],
                               "D" = Comm.col$gc[4],
                               "E" = Comm.col$gc[5],
                               "F" = Comm.col$gc[6],
                               "G" = Comm.col$gc[7],
                               "H" = Comm.col$gc[8],
                               "I" = Comm.col$gc[9],
                               "J" = Comm.col$gc[10],
                               "K" = Comm.col$gc[11],
                               "L" = Comm.col$gc[12],
                               "M" = Comm.col$gc[13],
                               "N" = Comm.col$gc[14],
                               "O" = Comm.col$gc[15],
                               "P" = Comm.col$gc[16],
                               "Q" = Comm.col$gc[17],
                               "R" = Comm.col$gc[18],
                               "S" = Comm.col$gc[19]))
value.col <- colorRamps::blue2red(100)
## heapmat
pheatmap(rcube.order[,,1],color = value.col,
         cluster_cols = FALSE, cluster_rows = FALSE,
         cellwidth = 0.5, cellheight = 0.5,
         annotation_col = vox.order.df,
         annotation_row = vox.order.df,
         annotation_legend = FALSE,
         annotation_names_col = FALSE,
         annotation_names_row = FALSE,
         annotation_colors = vox.order.col,
         breaks = seq(-1,1,by = 0.02),
         main="original correlation matrix")

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
                           alpha.points = .4, cex = .9)
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
                         design = vox.des$Comm.recode,
                         niter = 100,
                         suppressProgressBar = TRUE)

### Plot means
f.mean.graph <- createFactorMap(BootCube.Comm$GroupMeans,
                                axis1 = x_cp, axis2 = y_cp,
                                col.points = Comm.col$gc[rownames(BootCube.Comm$GroupMeans),],
                                constraints = f.graph$constraints,
                                col.labels = Comm.col$gc[rownames(BootCube.Comm$GroupMeans),],
                                alpha.points = .8,
                                cex = 4)
### Plot bootstrapped confidence intervals for means
f.CI.graph <- MakeCIEllipses(BootCube.Comm$BootCube[,c(x_cp,y_cp),],
                                    names.of.factors = c(sprintf("Factor %s",x_cp),sprintf("Factor %s",y_cp)),
                                    col = Comm.col$gc[rownames(BootCube.Comm$GroupMeans),],
                                    p.level = .95)
### Plot tolerance intervals of each community
f.TI.graph <- MakeToleranceIntervals(distatis.res$res4Splus$F,
                                     axis1 = 1, axis2 = 2,
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
