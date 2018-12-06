Demonstrating STATIS normalization on a correlation matrix
================

## Info

## STATIS-like normalization

## Fake data

## Fake correlation

``` r
### fake correlation: 
cor.X <- cor(X)
dim(cor.X)
## [1] 44 44
```

Plot the heatmap

![](demo_STATISnorm4r_files/figure-gfm/show_cor-1.png)<!-- -->

### Double centering

``` r
# center columns and rows
corX.c <- cor.X %>% scale(scale = FALSE) %>% t %>% scale(scale = FALSE)
```

Plot the heatmap:

![](demo_STATISnorm4r_files/figure-gfm/show_center-1.png)<!-- -->

### Eigen decomposition

``` r
# get the first eigenvalue
eig.res.corX <-eigen(corX.c)
Lambda.corX <- eig.res.corX$`values`
Q.corX <- eig.res.corX$vectors
```

Plot eigen vector

![](demo_STATISnorm4r_files/figure-gfm/show_eig-1.png)<!-- -->

### devided by the first eigenvalue

``` r
end.X <- cor.X/Lambda.corX[1]
```

Plot final result

![](demo_STATISnorm4r_files/figure-gfm/show_endX-1.png)<!-- -->

Plot the heatmap again

![](demo_STATISnorm4r_files/figure-gfm/show_cor2-1.png)<!-- -->
