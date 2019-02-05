Data Matrix Sanity Check
================

## MSC01

### Coding heatmap

``` r
c1_label <- data.frame(Comm=unique(sort(c1$Comm)))
c1_label <- merge(c1_label, systemlabel, by.x="Comm", by.y="CommNum", all.x=T)

for(session.count in 1:dim(s1)[3]){
hmap.name <- sprintf("hmap%s",session.count)
  assign(hmap.name, 
          superheat(s1[,,session.count], # smooth.heat = T, smooth.heat.type = "mean", 
                    membership.rows = c1$PlotLabel,
                    membership.cols = c1$Comm,
                    # clustering.method = NULL,
                  
                    extreme.values.na = FALSE, 
                    
                     heat.pal = rev(brewer.rdylbu(20)), 
                    # heat.pal = parula.col(12), 
                    heat.lim = c(-.3,.3),
                    heat.pal.values = c(0,.5,1),# c(0,.15,.3,.75,1),
                    
                    left.label.size = 0.08,
                    bottom.label.size = 0.05,
                    
                    y.axis.reverse = TRUE,
                    left.label.text.size = 3,
                    bottom.label.text.size = 2,
                    
                    left.label.col = c1_label$Color, 
                    bottom.label.col = c1_label$Color,  
                    
                    left.label.text.alignment = "left",
                    title = sprintf("Correlation matrix of #%s session",session.count)
          )
  )
}
```

### MSC01, Unthresholded Correlation Matrix

![](DataMatrixCheck_files/figure-gfm/sub1_pos_neg-1.png)<!-- -->

``` r
for(session.count in 1:dim(s1)[3]){
hmap.name <- sprintf("hmap_noneg%s",session.count)
  posmat <- s1[,,session.count]
  posmat[posmat<0] <- 0
  posmat[posmat==Inf] <- 0
assign(hmap.name, 
          superheat(posmat, 
                    membership.rows = c1$PlotLabel,
                    membership.cols = c1$Comm,
                    # clustering.method = NULL,
                  
                    extreme.values.na = FALSE, 
                    
                    # heat.pal = rev(brewer.rdylbu(20)), 
                    heat.pal = parula.col(12), 
                    heat.lim = c(0,.5),
                    heat.pal.values = c(0,.5,1),
                    
                    left.label.size = 0.08,
                    bottom.label.size = 0.05,
                    
                    y.axis.reverse = TRUE,
                    left.label.text.size = 3,
                    bottom.label.text.size = 2,
                    
                    left.label.col = c1_label$Color, 
                    bottom.label.col = c1_label$Color,  
                    
                    left.label.text.alignment = "left",
                    title = sprintf("Positive Correlation matrix of #%s session",session.count)
          )
  )
}
```

### MSC01, Thresholded Positive Correlation Matrix

![](DataMatrixCheck_files/figure-gfm/sub1_pos-1.png)<!-- -->

## MSC02

### MSC02, Unthresholded Correlation Matrix

![](DataMatrixCheck_files/figure-gfm/sub2_pos_neg-1.png)<!-- -->

### MSC02, Thresholded Positive Correlation Matrix

![](DataMatrixCheck_files/figure-gfm/sub2_pos-1.png)<!-- -->

## MSC03

### MSC03, Unthresholded Correlation Matrix

![](DataMatrixCheck_files/figure-gfm/sub3_pos_neg-1.png)<!-- -->

### MSC03, Thresholded Positive Correlation Matrix

![](DataMatrixCheck_files/figure-gfm/sub3_pos-1.png)<!-- -->
