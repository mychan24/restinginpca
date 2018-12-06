#================================================================#
### Demonstrating STATIS normalization on a correlation matrix ###
#================================================================#
## load packages ----
#install.packages("colorRamps")
#install.packages("gridGraphics")
library(dplyr)
library(tidyr)
library(gridGraphics)
library(grid)
## create examplar data ---- 
### create a symmetric matrix with values resembles correlation
### fake data: 
####a rectangular matrix (need also to plan for blocks of high correlation)
X <- as.matrix(read.csv("BFIdata.csv"))
### fake correlation: 
cor.X <- cor(X)
dim(cor.X)
#### check for blocks on diagonal
group.col <- RColorBrewer::brewer.pal(5,"Set1")[c(rep(x=1,8),rep(x=2,9),rep(x=3,9),rep(x=4,8),rep(x=5,10))]
value.col <- colorRamps::blue2red(100)
heatmap(cor.X,
             scale = "none",
             ColSideColors = group.col,
             RowSideColors = group.col,
             Rowv = NA, Colv = NA,
             col = value.col)
### double centering:
#### center columns and rows
corX.c <- cor.X %>% scale(scale = FALSE) %>% t %>% scale(scale = FALSE)
#### check heatmap
heatmap(corX.c,
             scale = "none",
             ColSideColors = group.col,
             RowSideColors = group.col,
             Rowv = NA, Colv = NA,
             col = value.col,
             symm = TRUE)
### get the first eigenvalue:
eig.res.corX <-eigen(corX.c)
Lambda.corX <- eig.res.corX$`values`
Q.corX <- eig.res.corX$vectors
#### check heatmap
heatmap(diag(Q.corX[,1]),
             scale = "none",
             RowSideColors = group.col,
             Rowv = NA, Colv = NA,
             col = value.col)

### devided by the first eigenvalue:
end.X <- cor.X/Lambda.corX[1]
#### check heatmap
heatmap(end.X,
        scale = "none",
        ColSideColors = group.col,
        RowSideColors = group.col,
        Rowv = NA, Colv = NA,
        col = value.col)

