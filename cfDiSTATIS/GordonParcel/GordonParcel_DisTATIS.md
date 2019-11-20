DiSTATIS on edges derived from Gordon Group parcellation (n nodes = 333)
================

## Objectives

This attempt perform DiSTATIS on mean connectivity of edges (e.g., mean
connectivity between DMN and FPN, mean connectivity within DMN) of
common networks across participants. The results from this analysis can
be compared to regular DiSTATIS of rs*f*MRI.

## Read data

This is a data cube of mean correlations: networks x networks x 4
sessions (2-5)

``` r
# Dimensions
dim(all.cubes)
## [1] 333 333  40
```

Create colors based on design

Run DiSTATIS with the negative z-transformed correlation matrix (seen as
covariance matrix) is equivalent to run DiSTATIS with distance matrices

``` r
distatis.res <- distatis(all.cubes, Distance = FALSE)
```

## Plot results

### Rv space

This results show how similar the tables are to one another.

#### Eigenvalues

![](GordonParcel_DisTATIS_files/figure-gfm/Rv.scree-1.png)<!-- -->

#### Factor scores

``` r
### Rv factor scores
rv.graph <- createFactorMap(distatis.res$res4Cmat$G,
                axis1 = 1, axis2 = 2,
                col.points = table.color$oc,
                col.labels = table.color$oc,
                text.cex = 2)
### Dimension labels for the Rv map
rv.labels <- createxyLabels.gen(lambda = distatis.res$res4Cmat$eigValues,
                                tau = distatis.res$res4Cmat$tau,
                                axisName = "Dimension ")
### Show plot
Rvmap <- rv.graph$zeMap + rv.labels
print(Rvmap)
```

![](GordonParcel_DisTATIS_files/figure-gfm/Rv.f-1.png)<!-- -->

### Compromise space

#### Eigenvalues

![](GordonParcel_DisTATIS_files/figure-gfm/scree-1.png)<!-- -->

Set the components of interest

``` r
x_cp <- 1
y_cp <- 2
```

#### Factor scores

![](GordonParcel_DisTATIS_files/figure-gfm/plot_fig_f-1.png)<!-- -->

``` r
fi <- distatis.res$res4Splus$F

# mean factor scores for each network
net.fi <- getMeans(fi, factor = CommName$Community)
# network colors
CommColor.gc <- unique((CommName[,c("Community", "CommColor")]))
rownames(CommColor.gc) <- CommColor.gc$Community

# plot
netf.graph <- createFactorMap(net.fi,
                           axis1 = x_cp, axis2 = y_cp,
                           title = "Compromise - Factor scores (networks): cp 1 & 2",
                           col.points = CommColor.gc[rownames(net.fi), "CommColor"],
                           col.labels = CommColor.gc[rownames(net.fi), "CommColor"],
                           alpha.points = .4, cex = 5, text.cex = 5)
netf.graph.23 <- createFactorMap(net.fi,
                           axis1 = 2, axis2 = 3,
                           title = "Compromise - Factor scores (networks): cp 2 & 3",
                           col.points = CommColor.gc[rownames(net.fi), "CommColor"],
                           col.labels = CommColor.gc[rownames(net.fi), "CommColor"],
                           alpha.points = .4, cex = 5, text.cex = 5)

# Show plot
f01.netF <- netf.graph$zeMap + f.labels
f01.netF.cp3 <- netf.graph.23$zeMap + f.labels.23
```

![](GordonParcel_DisTATIS_files/figure-gfm/plot_fig_netf-1.png)<!-- -->

#### Partial factor scores

Component 1 & 2

![](GordonParcel_DisTATIS_files/figure-gfm/plot_fig_pF-1.png)<!-- -->

Component 2 & 3

![](GordonParcel_DisTATIS_files/figure-gfm/plot_fig_pF_cp3-1.png)<!-- -->

#### Mean partial factor scores

Component 1 & 2

![](GordonParcel_DisTATIS_files/figure-gfm/plot_fig_netpF-1.png)<!-- -->

Component 2 & 3

![](GordonParcel_DisTATIS_files/figure-gfm/plot_fig_pF_cp3_net-1.png)<!-- -->
