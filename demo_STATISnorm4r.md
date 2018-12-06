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

    ##            E          A          C          N          O
    ## E 0.40341812 0.05888088 0.05096070 0.04262684 0.07734442
    ## A 0.05888088 0.28024455 0.06075964 0.06977575 0.03956499
    ## C 0.05096070 0.06075964 0.26490818 0.05677160 0.04878863
    ## N 0.04262684 0.06977575 0.05677160 0.51041531 0.07090428
    ## O 0.07734442 0.03956499 0.04878863 0.07090428 0.30050251

![](demo_STATISnorm4r_files/figure-gfm/ss_endX-1.png)<!-- -->

With its normalized sums of
    squares:

    ##              E            A            C            N            O
    ## E 0.0063034081 0.0008177901 0.0007077875 0.0006660444 0.0009668053
    ## A 0.0008177901 0.0034598093 0.0007501190 0.0009691077 0.0004396110
    ## C 0.0007077875 0.0007501190 0.0032704713 0.0007884945 0.0005420959
    ## N 0.0006660444 0.0009691077 0.0007884945 0.0079752392 0.0008863035
    ## O 0.0009668053 0.0004396110 0.0005420959 0.0008863035 0.0030050251

![](demo_STATISnorm4r_files/figure-gfm/NormSS_endX-1.png)<!-- -->

With its block means:

    ##             E            A            C           N            O
    ## E  0.06604322 -0.011142400 -0.012748856 -0.01145565 -0.022167926
    ## A -0.01114240  0.035883800 -0.009714951 -0.01720993 -0.000870101
    ## C -0.01274886 -0.009714951  0.036019864 -0.01246758 -0.003501277
    ## N -0.01145565 -0.017209929 -0.012467576  0.07348625 -0.022914724
    ## O -0.02216793 -0.000870101 -0.003501277 -0.02291472  0.040000360

![](demo_STATISnorm4r_files/figure-gfm/mean_endX-1.png)<!-- -->

Plot the heatmap of the original matrix again to compare:

![](demo_STATISnorm4r_files/figure-gfm/show_cor2-1.png)<!-- -->

With its sums of squares:

    ##           E         A         C         N         O
    ## E 16.408816  1.973762  1.759135  1.865285  1.674820
    ## A  1.973762 17.195436  3.916326  2.533291  4.487809
    ## C  1.759135  3.916326 19.344140  1.623011  5.818310
    ## N  1.865285  2.533291  1.623011 12.647106  1.945488
    ## O  1.674820  4.487809  5.818310  1.945488 25.977010

![](demo_STATISnorm4r_files/figure-gfm/ss_corX-1.png)<!-- -->

With its normalized sums of squares:

    ##            E          A          C          N          O
    ## E 0.25638775 0.02741336 0.02443243 0.02914508 0.02093525
    ## A 0.02741336 0.21228933 0.04834971 0.03518460 0.04986454
    ## C 0.02443243 0.04834971 0.23881655 0.02254181 0.06464789
    ## N 0.02914508 0.03518460 0.02254181 0.19761104 0.02431860
    ## O 0.02093525 0.04986454 0.06464789 0.02431860 0.25977010

![](demo_STATISnorm4r_files/figure-gfm/NormSS_corX-1.png)<!-- -->

With its block means:

    ##              E           A           C           N            O
    ## E  0.444149064  0.02703063  0.03838975 -0.10268106 -0.004883617
    ## A  0.027030632  0.35831607  0.10461182 -0.08940973  0.171382635
    ## C  0.038389746  0.10461182  0.40121262 -0.03979763  0.176567584
    ## N -0.102681056 -0.08940973 -0.03979763  0.32923068 -0.089265390
    ## O -0.004883617  0.17138264  0.17656758 -0.08926539  0.452153249

![](demo_STATISnorm4r_files/figure-gfm/mean_corX-1.png)<!-- -->

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
