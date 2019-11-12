DiSTATIS on mean connectivity of edges derived from indivisual
parcellation + simmulations
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
## [1] 11 11 40
```

> Induce system-level changes (sim attack)

**Attack 1**

  - In all *subjects* and Even-numbered *sessions* (2 & 4), Reduce
    within connectivity in Default Mode (Syslabel: 1), Default-FP (1\_3)
    and Default\_VAN (1\_5).
      - identify within default connectivity, default-FP and default-VAN
      - Simulate reduced connectivity by dividing edges that were
        identified by above and reduce 50% of connectivity (/2)

<!-- end list -->

``` r

# specify intersection to do simattack
i_edges <- matrix(c(1,1,
                    1,3,
                    1,4,
                    3,1,
                    4,1), nrow = 5, ncol = 2, byrow = TRUE, dimnames = list(c(1:5), c("N1","N2"))) %>% data.frame

session2attack <- which(tab.design$session %in% c("sess2","sess4"))
for (tab.count in session2attack){
  for (edge.count in 1:nrow(i_edges)){
    all.cubes[i_edges$N1[edge.count], i_edges$N2[edge.count], tab.count] <- all.cubes[i_edges$N1[edge.count], i_edges$N2[edge.count], tab.count]/2
  }
}
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

![](simattack_IndivParcel_EdgeMeans_files/figure-gfm/Rv.scree-1.png)<!-- -->

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

![](simattack_IndivParcel_EdgeMeans_files/figure-gfm/Rv.f-1.png)<!-- -->

### Compromise space

#### Eigenvalues

![](simattack_IndivParcel_EdgeMeans_files/figure-gfm/scree-1.png)<!-- -->

Set the components of interest

``` r
x_cp <- 1
y_cp <- 2
```

#### Factor scores

![](simattack_IndivParcel_EdgeMeans_files/figure-gfm/plot_fig_f-1.png)<!-- -->

#### Partial factor scores

Component 1 & 2

![](simattack_IndivParcel_EdgeMeans_files/figure-gfm/plot_fig_pF-1.png)<!-- -->

Component 2 & 3

![](simattack_IndivParcel_EdgeMeans_files/figure-gfm/plot_fig_pF_cp3-1.png)<!-- -->
