Demonstrating STATIS normalization on a correlation matrix
================

## Idea

Before starting this project, we were not sure how we should normalize
our data to control for counding factors (e.g., voxel size and network
size) and keep important signals. (But what is really the important
information?) Since the correlation matrix we work on resemble a
distance matrix. We came up with the idea of matrix preprocessing steps
similar to that of DiSTATIS (i.e., STATIS for distance matrices). This
type of preprocessing consists of two steps:

  - Double-center
  - Normalized by the first eigenvalue of the double-centered matrix

## Objectives

Here, we illustrate how data are changed along these steps and how the
final singular value decomposition (SVD) results are affected.

## Start with an example data

### Fake data

We start with a fake data with blocks of
    correlation.

    ##      Ex1 Ex2 Ex3 Ex4 Ex5 Ex6 Ex7 Ex8 Ag1 Ag2 Ag3 Ag4 Ag5 Ag6 Ag7 Ag8 Ag9
    ## [1,]   5   2   4   4   4   3   3   3   2   4   5   3   3   3   3   4   4
    ## [2,]   2   2   4   4   4   3   2   2   3   4   4   4   4   4   4   4   5
    ## [3,]   3   2   4   3   2   2   2   5   1   1   1   5   1   1   1   1   4
    ## [4,]   2   2   2   2   2   3   2   4   2   5   5   3   3   3   4   4   4
    ## [5,]   4   3   2   3   3   3   4   4   2   4   5   2   2   3   4   4   5
    ## [6,]   5   4   2   4   4   4   4   5   2   4   5   4   4   4   2   2   4
    ##      Co1 Co2 Co3 Co4 Co5 Co6 Co7 Co8 Co9 Ne1 Ne2 Ne3 Ne4 Ne5 Ne6 Ne7 Ne8
    ## [1,]   5   4   5   2   3   4   4   4   3   3   4   5   5   2   1   3   4
    ## [2,]   3   2   4   3   4   4   4   4   4   2   2   4   3   2   2   2   2
    ## [3,]   1   1   2   4   1   5   4   1   5   5   5   1   5   5   5   5   2
    ## [4,]   3   4   5   2   2   4   4   4   5   5   3   2   4   3   2   2   3
    ## [5,]   5   1   5   1   2   5   4   5   2   2   3   4   3   4   3   4   3
    ## [6,]   4   4   5   5   2   4   4   5   2   4   4   4   5   2   4   1   2
    ##      Op1 Op2 Op3 Op4 Op5 Op6 Op7 Op8 Op9 Op10
    ## [1,]   2   5   3   4   2   3   5   5   3    4
    ## [2,]   5   5   5   5   4   4   4   5   4    4
    ## [3,]   5   4   1   3   4   1   1   5   5    2
    ## [4,]   4   5   5   5   3   4   2   5   4    5
    ## [5,]   3   4   4   4   4   5   4   4   5    2
    ## [6,]   4   4   4   2   2   5   4   2   5    4

### Fake correlation

Then, compute its correlation matrix.

``` r
### fake correlation: 
cor.X <- cor(X)
dim(cor.X)
## [1] 44 44
```

Setting up colors for
plotting

``` r
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
```

Plot the heatmap:

![](demo_STATISnorm4r_files/figure-gfm/show_cor-1.png)<!-- -->

## STATIS-like normalization

### STEP 1 : Double centering

Centering across columns and rows so that each row and column has a mean
of 0.

``` r
# center columns and rows
corX.c <- cor.X %>% scale(scale = FALSE) %>% t %>% scale(scale = FALSE)
```

Plot the heatmap:

![](demo_STATISnorm4r_files/figure-gfm/show_center-1.png)<!-- -->

### STEP 1.5: Eigen decomposition

Perform an eigen decomposition and record the eigenvalues.

``` r
# get the first eigenvalue
eig.res.corX <-eigen(corX.c)
Lambda.corX <- eig.res.corX$`values`
Q.corX <- eig.res.corX$vectors
Q1 <- as.matrix(diag(Q.corX[,1]))
rownames(Q1) <- colnames(X)
colnames(Q1) <- colnames(X)
```

Plot eigen vectors:

![](demo_STATISnorm4r_files/figure-gfm/show_eig-1.png)<!-- -->

### STEP 2 : Devided the double-centered matrix by the first eigenvalue

``` r
end.X <- corX.c/Lambda.corX[1]
```

Plot final result:

![](demo_STATISnorm4r_files/figure-gfm/show_endX-1.png)<!-- -->

With its sums of squares:

``` r
t(group.des.nominal) %*% end.X %*% group.des.nominal
##            .E          .A         .C         .N          .O
## .E  4.2267663 -0.80225281 -0.9179176 -0.7331618 -1.77343404
## .A -0.8022528  2.90658782 -0.7869110 -1.2391149 -0.07830909
## .C -0.9179176 -0.78691100  2.9176090 -0.8976655 -0.31511490
## .N -0.7331618 -1.23911492 -0.8976655  4.7031202 -1.83317795
## .O -1.7734340 -0.07830909 -0.3151149 -1.8331780  4.00003598
```

With its normalized sums of squares:

``` r
t(group.des.nomnorm) %*% end.X %*% group.des.nomnorm
##             .E           .A           .C          .N           .O
## .E  0.06604322 -0.011142400 -0.012748856 -0.01145565 -0.022167926
## .A -0.01114240  0.035883800 -0.009714951 -0.01720993 -0.000870101
## .C -0.01274886 -0.009714951  0.036019864 -0.01246758 -0.003501277
## .N -0.01145565 -0.017209929 -0.012467576  0.07348625 -0.022914724
## .O -0.02216793 -0.000870101 -0.003501277 -0.02291472  0.040000360
```

Plot the heatmap of the original matrix again to compare:

![](demo_STATISnorm4r_files/figure-gfm/show_cor2-1.png)<!-- -->

With its sums of squares:

``` r
t(group.des.nominal) %*% cor.X %*% group.des.nominal
##            .E        .A        .C        .N         .O
## .E 28.4255401  1.946205  2.764062 -6.571588 -0.3906893
## .A  1.9462055 29.023602  8.473558 -6.437500 15.4244372
## .C  2.7640617  8.473558 32.498222 -2.865429 15.8910825
## .N -6.5715876 -6.437500 -2.865429 21.070764 -7.1412312
## .O -0.3906893 15.424437 15.891083 -7.141231 45.2153249
```

With its normalized sums of squares:

``` r
t(group.des.nomnorm) %*% cor.X %*% group.des.nomnorm
##              .E          .A          .C          .N           .O
## .E  0.444149064  0.02703063  0.03838975 -0.10268106 -0.004883617
## .A  0.027030632  0.35831607  0.10461182 -0.08940973  0.171382635
## .C  0.038389746  0.10461182  0.40121262 -0.03979763  0.176567584
## .N -0.102681056 -0.08940973 -0.03979763  0.32923068 -0.089265390
## .O -0.004883617  0.17138264  0.17656758 -0.08926539  0.452153249
```

## Try PCA

Let’s see how the PCA results are changed after the STATIS-like
normalization.

``` r
# Group design
group.des <- c(rep(x=1,8),rep(x=2,9),rep(x=3,9),rep(x=4,8),rep(x=5,10))
# PCA with original correlation matrix
corX.pca.res <- epPCA(cor.X, center = FALSE, scale = FALSE, DESIGN = group.des, make_design_nominal = TRUE, graphs = FALSE)
# PCA with the STATIS-normalized matrix
endX.pca.res <- epPCA(end.X, center = FALSE, scale = FALSE, DESIGN = group.des, make_design_nominal = TRUE, graphs = FALSE)
```

#### PCA results with original correlation matrix

![](demo_STATISnorm4r_files/figure-gfm/pcaRes_corX-1.png)<!-- -->

#### PCA results with STATIS-normalized matrix

![](demo_STATISnorm4r_files/figure-gfm/pcaRes_endX-1.png)<!-- -->
