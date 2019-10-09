MuSu\_(NA, c, HMFA-edge) - MSC All Subjects (N=10) Big Networks 4
Sessions (rows)- Sim Attack
================

> Reduce grandtable to have consistent networks only & only 4 sessions
> (rows)

``` r
gt <- gt[,gtlabel$bignet=="Y"]
gtlabel <- gtlabel[gtlabel$bignet=="Y",]

gt <- gt[2:5,]

# check dim
dim(gt); dim(gtlabel)
```

    ## [1]       4 1181892

    ## [1] 1181892       6

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
i_edges <- which(is.element(gtlabel$edges_label, c("1","1_3","1_5"))) 

## Commented out code that would be used to only manipulate even-# subjects
# i_sub <- which(is.element(gtlabel$subjects_label, sprintf("sub%02d", seq(2,length(subj.name),2))))
# i_attack <- intersect(i_edges, i_sub)
# gt[seq(2, nrow(gt), 2), i_attack] <- gt[seq(2, nrow(gt), 2), i_attack]/2  # reduce 50%

gt[seq(2, nrow(gt), 2), i_edges] <- gt[seq(2, nrow(gt), 2), i_edges]/2  # reduce 50%
```

> This is an SVD with centered columns and hierarchical (network edges
> -\> subjects) MFA-normalized tables.

##### Data:

The data are from the morning scan club (MSC) resting-state data where
the participants were each scanned 10 times. The data that are analyzed
here are the z-transformed coefficients of correlation between regions.
These regions can be categorized into different networks:

| Comm | Community | CommLabel.short |
| :--: | :-------: | :-------------: |
|  1   |  Default  |      01DMN      |
|  2   |  LatVis   |     02lVis      |
|  3   | FrontoPar |      03FPN      |
|  5   | DorsAttn  |      05DAN      |
|  6   | Premotor  |      06PMo      |
|  9   | CingOperc |      09CON      |
|  10  |  HandSM   |     10hSMN      |
|  11  |  FaceSM   |     11faSMN     |
|  12  | Auditory  |      12Aud      |
|  13  |  AntMTL   |     13aMTL      |
|  15  | ParMemory |      15PMN      |

``` r
# read parcel labels for each subject
parcel.list <- lapply(1:length(parcelfile2read), function(x){
  parcel <- read.table(paste0(parcel.comm.path, parcelfile2read[x]),sep = ",")
  getVoxDes(parcel,CommName)
})
names(parcel.list) <- subj.name
#-- Create colors for heatmap 
labelcol <- list()
textcol <- list()
for(i in 1:length(subj.name)){
  labelcol[[i]] <- parcel.list[[i]]$Comm.col$gc[order(rownames(parcel.list[[i]]$Comm.col$gc))]
  names(labelcol)[i] <- subj.name[i]
  
  textcol[[i]] <- rep("black", length(labelcol[[i]]))
  textcol[[i]][as(colorspace::hex2RGB(labelcol[[i]]), "polarLUV")@coords[,1] < 35] <- "white"  # Convert hex2RGB to lum
}
```

> The correlation matrices were turned into a rectangular matrix

##### Rectangular data:

  - Rows: 4 sessions

  - Columns: Different edges (e.g, *within DMN*, *between DMN & CON*,
    *between DMN & FPN*, etc.) of different subjects

*Note: The data was transformed from the upper triangle of the
correlation matrices. From the correlation matrix of each session, its
upper triangle are reshape as a vector. These reshaped vectors of
different sessions are then concatenated on the rows and those of
different subjects are concatenated on the columns.*

##### Method:

  - Centering: across sessions (rows) (i.e., the columns are centered)

  - Normalizing: hierarchical MFA normalized by network edges then
    subjects

First we compute the weights that are used to MFA-normalized each
subject table. These weights are computed as the inverse of the first
singular value:

Then, the preprocessed data are decomposed by the SVD:

##### Results:

###### Scree plot

First, the scree plot illustrates the eigen value with percentage of
explained variance of each component. The results showed that there are
three important components with the percentage of explained variance
more than average (i.e., 1/10).

![](MuSu_bignet_simattack_4rows__NA,_c,_HMFA-edge__files/figure-gfm/scree-1.png)<!-- -->

###### Contributions

Before checking the factor scores, we first plot the contributions to
check the importance of network edges. The important edges are defined
as those that with significant mean contribution to both components 1
and 2.

We first compute the contribution and find the important edges and
sessions:

``` r
#--- get the contribution of each component
cI <- svd.res$ExPosition.Data$ci
cJ <- svd.res$ExPosition.Data$cj

#--- get the sum of contribution for each edge
c_edge <- aggregate(cJ,list(edge = gtlabel$subjects_edge_label),sum)
rownames(c_edge) <- c_edge$edge
c_edge <- c_edge[,-1]
rownames(cI) <- c(1:nrow(gt))

## Find important sessions
#--- get the contribution for component 1 AND 2 by sum(SS from 1, SS from 2)/sum(eigs 1, eigs 2)
sesCtr12 <- (cI[,1]+cI[,2])/(svd.res$ExPosition.Data$eigs[1] + svd.res$ExPosition.Data$eigs[2])

#--- the important sessions are the ones that contribute more than or equal to the average
importantSes <- (sesCtr12 >= 1/length(sesCtr12))
importantSes1 <- (cI[,1] >= 1/length(cI[,1]))
importantSes2 <- (cI[,2] >= 1/length(cI[,2]))

#--- color for sessions
col4ImportantSes <- as.matrix(rep("mediumorchid4",nrow(cI)))  # get colors
col4NS <- 'gray48'                                            # set color for not significant edges to gray
col4ImportantSes[!importantSes] <- col4NS                     # replace them in the color vector

## Find important edges
#--- compute the sums of squares of each variable for each component
absCtrEdg <- as.matrix(c_edge) %*% diag(svd.res$ExPosition.Data$eigs)

#--- get the contribution for component 1 AND 2 by sum(SS from 1, SS from 2)/sum(eigs 1, eigs 2)
edgCtr12 <- (absCtrEdg[,1] + absCtrEdg[,2])/(svd.res$ExPosition.Data$eigs[1] + svd.res$ExPosition.Data$eigs[2])

#--- the important variables are the ones that contribute more than or equal to the average
importantEdg <- (edgCtr12 >= 1/length(edgCtr12))
importantEdg1 <- (absCtrEdg[,1] >= 1/length(absCtrEdg[,1]))
importantEdg2 <- (absCtrEdg[,2] >= 1/length(absCtrEdg[,2]))

#--- find the between/within description for each network edge
net.edge <- matrix(NA, nrow = nrow(c_edge),ncol = 1)
for (i in 1:nrow(c_edge)){
  edge2check <- rownames(c_edge)[i]
  net.edge[i,1] <- unique(gtlabel[which(gtlabel$subjects_edge_label == edge2check),"subjects_wb"])
}

#--- create color based on the between/within description for network edges
net.edge.col <- list(oc = as.matrix(plyr::mapvalues(net.edge,from = unique(net.edge), to = rep(cols25(10),each = 2))),
                     gc = as.matrix(rep(cols25(10),each = 2)))
rownames(net.edge.col$oc) <- rownames(c_edge)
rownames(net.edge.col$gc) <- unique(net.edge)
#--- color for networks
col4ImportantEdg <- net.edge.col$oc # get colors
col4NS <- 'gray90' # set color for not significant edges to gray
col4ImportantEdg[!importantEdg] <- col4NS # replace them in the color vector
```

Then the contributions are shown in plots

![](MuSu_bignet_simattack_4rows__NA,_c,_HMFA-edge__files/figure-gfm/grid_ciplot-1.png)<!-- -->

The contribution for each network edge is computed by dividing its total
SS across region edges and dimensions (i.e., the cross product of
contribution and eigenvalues) by the total eigenvalues of the two
components.

###### Factor scores

First, we plot the factor scores for the 4 sessions

![](MuSu_bignet_simattack_4rows__NA,_c,_HMFA-edge__files/figure-gfm/plot_f_sess-1.png)<!-- -->

We can also plot the partial factor scores that show how each subject
contribute to different sesssions.

``` r
# We can also compute the partial factor scores for each participant:
subj.table <- gtlabel$subjects_label
table2normalize <- subtab_i

n_subj <- length(unique(gtlabel$subjects_label))
n_table2normalize <- sapply(1:n_subj, function(x){
  length(unique(table2normalize[[1]][which(subj.table == unique(subj.table)[x])]))})

# compute partial factor scores: K.sub x sv[1] x sv[2] x X_k x Q_k
pFi <- sapply(1:n_subj, function(x){
  # weighted by the inverse of "the # of tables contributed for each subject"
  (sum(n_table2normalize)/n_table2normalize[x])*gt_preproc[,which(subj.table == unique(subj.table)[x])] %*% (svd.res$ExPosition.Data$pdq$q[which(subj.table == unique(subj.table)[x]),])
}, simplify = "array")

# name the dimension of the array that stores partial F
dimnames(pFi) <- list(rownames(cgt),colnames(svd.res$ExPosition.Data$fi),unique(subj.table))

## Check barycentric
ch1 <- apply(pFi,c(1:2),mean)
ch2 <- gt_preproc %*% (svd.res$ExPosition.Data$pdq$q)
```

Note that ALL subjects’ EVEN numbered sessions are induced with reduced
connectivity in default, default-FP and default-VAN.

![](MuSu_bignet_simattack_4rows__NA,_c,_HMFA-edge__files/figure-gfm/plot_pf_sess-1.png)<!-- -->

To have a clearer view of the factor scores for the subject x edges, we
first compute the mean factor scores for the each network edge.

``` r
# Compute means of factor scores for different edges----
mean.fj <- getMeans(svd.res$ExPosition.Data$fj, gtlabel$subjects_edge_label) # with t(gt)
colnames(mean.fj) <- paste("Factor", 1:ncol(mean.fj))

tictoc::tic()
BootCube.Comm <- Boot4Mean(svd.res$ExPosition.Data$fj,
                           parallelize = T,
                           design = gtlabel$subjects_edge_label,
                           niter = 100,
                           suppressProgressBar = TRUE)
tictoc::toc()
```

    ## 206.42 sec elapsed

``` r
# compute mean factor scores for each edge and the partial factor scores of each subject for these factor scores
### use split string to separate the subject and edge labels (this is done at this step because we want to take the average across them after averaging across regions that belong to the same edge and subject)
mean.fj.label <- strsplit(sub('(^[^_]+)_(.*)$', '\\1 \\2', rownames(mean.fj)), ' ') %>% 
                    unlist %>% 
                    matrix(ncol = 2, byrow = T, dimnames = list(rownames(mean.fj),c("sub","edge"))) %>% 
                    data.frame

### compute means
mean.edge.fj <- getMeans(mean.fj, mean.fj.label$edge)

### create array for partial factor scores
edge.pF <- array(data = NA, 
                 dim = (c(nrow(mean.edge.fj), ncol(mean.fj), length(unique(mean.fj.label$sub)))), 
                 dimnames = list(rownames(mean.edge.fj), colnames(mean.fj), unique(mean.fj.label$sub)))

### fill the array of partial factor scores
n.edges <- dim(edge.pF)[1]

for (i in 1:length(subj.name)){
  for (j in 1:n.edges){
    tbname <- subj.name[i]
    rwname <- rownames(edge.pF)[j]
    edge.pF[rwname,,tbname] <- as.matrix(mean.fj[which(mean.fj.label$sub == tbname & mean.fj.label$edge == rwname),])
  }
}

tictoc::tic()
BootCube.Comm.edge <- Boot4Mean(mean.fj,
                                parallelize = T,
                                design = mean.fj.label$edge,
                                niter = 100,
                                suppressProgressBar = TRUE)
tictoc::toc()
```

    ## 5.22 sec elapsed

``` r
# Compute means of factor scores for different types of edges
mean.fj.bw <- getMeans(svd.res$ExPosition.Data$fj, gtlabel$subjects_wb) # with t(gt)
colnames(mean.fj.bw) <- paste("Factor", 1:ncol(mean.fj.bw))

tictoc::tic()
BootCube.Comm.bw <- Boot4Mean(svd.res$ExPosition.Data$fj,
                              parallelize = T,
                              design = gtlabel$subjects_wb,
                              niter = 100,
                              suppressProgressBar = TRUE)
tictoc::toc()
```

    ## 94.27 sec elapsed

Next, we plot the factor scores for the subject x edges (a mess): Dim 1
& 2

![](MuSu_bignet_simattack_4rows__NA,_c,_HMFA-edge__files/figure-gfm/grid_f_netedge_plot-1.png)<!-- -->

Note that a network edge with its region edges significantly contribute
to the components both positively and negatively results in a
significant mean factor score that is close to the origin. Also, a
network edge with only few region edges will lead to a small total SS as
compared to the total eigenvalues; this type of network edge might not
be significant even when being far away from the origin. (This is shown
in the chunk named `checkCtr` which is hidden/commented in the .rmd.)

We can also add boostrap intervals for the factor scores

    ## Warning: Removed 4 rows containing non-finite values (stat_ellipse).

    ## Warning: Removed 32 rows containing non-finite values (stat_ellipse).

![](MuSu_bignet_simattack_4rows__NA,_c,_HMFA-edge__files/figure-gfm/grid_f_netedgeCI_plot-1.png)<!-- -->

We can also show the factor scores for network edges as square matrix of
each subject.

Node x Node Matrix of Factor Score: Dim 1 & Dim 2

    ## [1] "Dimension 1"

![](MuSu_bignet_simattack_4rows__NA,_c,_HMFA-edge__files/figure-gfm/grid_heat_fi-1.png)<!-- -->

    ## [1] "Dimension 2"

![](MuSu_bignet_simattack_4rows__NA,_c,_HMFA-edge__files/figure-gfm/grid_heat_fi-2.png)<!-- -->

Factor score (Dim 1) in square matrix that have significant contribution
only

Node x Node Matrix of Factor Score w/ Sig Contribution: Dim 1
![](MuSu_bignet_simattack_4rows__NA,_c,_HMFA-edge__files/figure-gfm/grid_heat_sigfj1-1.png)<!-- -->

Smoothed Sig Factor Score (Dim 1)

Smoothed Node x Node Matrix of Factor Score w/ Sig Contribution: Dim 1
![](MuSu_bignet_simattack_4rows__NA,_c,_HMFA-edge__files/figure-gfm/grid_smheat_sigfj1-1.png)<!-- -->

Factor score (Dim 2) in square matrix that have significant contribution
only

Node x Node Matrix of Factor Score w/ Sig Contribution: Dim 2
![](MuSu_bignet_simattack_4rows__NA,_c,_HMFA-edge__files/figure-gfm/grid_heat_sigfj2-1.png)<!-- -->

Smoothed Sig Factor Score (Dim 2)

Smoothed Node x Node Matrix of Factor Score w/ Sig Contribution: Dim 2
![](MuSu_bignet_simattack_4rows__NA,_c,_HMFA-edge__files/figure-gfm/grid_smheat_sigfj2-1.png)<!-- -->
