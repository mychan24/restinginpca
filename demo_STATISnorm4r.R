#================================================================#
### Demonstrating STATIS normalization on a correlation matrix ###
#================================================================#
## load packages ----
#install.packages("colorRamps")
#install.packages("gridGraphics")
#install.packages("pheatmap")
#devtools::install_github('HerveAbdi/PTCA4CATA')
library(dplyr)
library(tidyr)
library(PTCA4CATA)
library(ExPosition)
library(pheatmap)
## create examplar data ---- 
### create a symmetric matrix with values resembles correlation
### fake data: 
####a rectangular matrix (need also to plan for blocks of high correlation)
X <- as.matrix(read.csv("FakeData.csv"))
### fake correlation: 
cor.X <- cor(X)
dim(cor.X)
#### check for blocks on diagonal
group.col <- RColorBrewer::brewer.pal(5,"Set1")[c(rep(x=1,8),rep(x=2,9),rep(x=3,9),rep(x=4,8),rep(x=5,10))]
group.des <- c(rep("E",8),rep("A",9),rep("C",9),rep("N",8),rep("O",10))
group.des.nominal <- makeNominalData(as.matrix(group.des))
group.des.nomnorm <- group.des.nominal/c(rep(8,8),rep(9,9),rep(9,9),rep(8,8),rep(10,10))
group.des.df <- data.frame(group = factor(group.des),row.names = colnames(X))
group.des.col <- list(group = c(E = RColorBrewer::brewer.pal(5,"Set1")[1],
                                A = RColorBrewer::brewer.pal(5,"Set1")[2],
                                C = RColorBrewer::brewer.pal(5,"Set1")[3],
                                N = RColorBrewer::brewer.pal(5,"Set1")[4],
                                O = RColorBrewer::brewer.pal(5,"Set1")[5]))
value.col <- colorRamps::blue2red(100)
pheatmap(cor.X, color = value.col,
         cluster_cols = FALSE, cluster_rows = FALSE,
         annotation_col = group.des.df,
         annotation_row = group.des.df,
         annotation_legend = FALSE,
         annotation_names_col = FALSE,
         annotation_names_row = FALSE,
         annotation_colors = group.des.col,
         breaks = seq(-1,1,by = 0.02))
# heatmap(cor.X,
#         scale = "none",
#         ColSideColors = group.col,
#         RowSideColors = group.col,
#         Rowv = NA, Colv = NA,
#         col = value.col)

### double centering:
#### center columns and rows
corX.c <- cor.X %>% scale(scale = FALSE) %>% t %>% scale(scale = FALSE)
#### check heatmap
pheatmap(corX.c, color = value.col,
         cluster_cols = FALSE, cluster_rows = FALSE,
         annotation_col = group.des.df,
         annotation_row = group.des.df,
         annotation_legend = FALSE,
         annotation_names_col = FALSE,
         annotation_names_row = FALSE,
         annotation_colors = group.des.col,
         breaks = seq(-1,1,by = 0.02))
# heatmap(corX.c,
#         scale = "none",
#         ColSideColors = group.col,
#         RowSideColors = group.col,
#         Rowv = NA, Colv = NA,
#         col = value.col,
#         symm = TRUE)

### get the first eigenvalue:
eig.res.corX <-eigen(corX.c)
Lambda.corX <- eig.res.corX$`values`
Q.corX <- eig.res.corX$vectors
Q1 <- as.matrix(diag(Q.corX[,1]))
rownames(Q1) <- colnames(X)
colnames(Q1) <- colnames(X)
#### check heatmap
pheatmap(Q1, color = value.col,
         cluster_cols = FALSE, cluster_rows = FALSE,
         annotation_col = group.des.df,
         annotation_row = group.des.df,
         annotation_legend = FALSE,
         annotation_names_col = FALSE,
         annotation_names_row = FALSE,
         annotation_colors = group.des.col,
         )
# heatmap(diag(Q.corX[,1]),
#         scale = "none",
#         RowSideColors = group.col,
#         Rowv = NA, Colv = NA,
#         col = value.col)

### devided by the first eigenvalue:
end.X <- corX.c/Lambda.corX[1]
#### check heatmap
pheatmap(end.X, color = value.col,
         cluster_cols = FALSE, cluster_rows = FALSE,
         annotation_col = group.des.df,
         annotation_row = group.des.df,
         annotation_legend = FALSE,
         annotation_names_col = FALSE,
         annotation_names_row = FALSE,
         annotation_colors = group.des.col,
         breaks = seq(-0.2,0.2,by = 0.004))
# heatmap(end.X,
#         scale = "none",
#         ColSideColors = group.col,
#         RowSideColors = group.col,
#         Rowv = NA, Colv = NA,
#         col = value.col)

#### check sums of squares of the correlation matrix
t(group.des.nominal) %*% cor.X^2 %*% group.des.nominal
#### check sums of squares of the normalized matrix
t(group.des.nominal) %*% end.X^2 %*% group.des.nominal
#### check normalized sums of squares of the correlation matrix
t(group.des.nomnorm) %*% cor.X^2 %*% group.des.nomnorm
#### check normalized sums of squares of the normalized matrix
t(group.des.nomnorm) %*% end.X^2 %*% group.des.nomnorm
#### check block means of the correlation matrix
t(group.des.nomnorm) %*% cor.X %*% group.des.nomnorm
#### check block means of the normalized matrix
t(group.des.nomnorm) %*% end.X %*% group.des.nomnorm

### try PCA ----
#### with original correlation matrix
corX.pca.res <- epPCA(cor.X, center = FALSE, scale = FALSE, DESIGN = group.des, make_design_nominal = TRUE, graphs = FALSE)
corX.p <- createFactorMap(corX.pca.res$ExPosition.Data$fi,
                          col.points = group.col,
                          col.labels = group.col,
                          display.points = TRUE,
                          display.labels = TRUE
)
labels4corX <- createxyLabels.gen(
  lambda = corX.pca.res$ExPosition.Data$eigs ,
  tau = corX.pca.res$ExPosition.Data$t,
  axisName = "Dimension ")
print(corX.p$zeMap + labels4corX)
#### with STATIS-normalized matrix
endX.pca.res <- epPCA(end.X, center = FALSE, scale = FALSE, DESIGN = group.des, make_design_nominal = TRUE, graphs = FALSE)
endX.p <- createFactorMap(endX.pca.res$ExPosition.Data$fi,
                          col.points = group.col,
                          col.labels = group.col,
                          display.points = TRUE,
                          display.labels = TRUE
)
labels4endX <- createxyLabels.gen(
  lambda = endX.pca.res$ExPosition.Data$eigs ,
  tau = endX.pca.res$ExPosition.Data$t,
  axisName = "Dimension ")
print(endX.p$zeMap + labels4endX)
