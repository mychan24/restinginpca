# partial factor scores
#factor scores
fi <- svd.res$ExPosition.Data$fi
subj.table <- as.vector(gtlabel$subjects_label)
# colnames(subj.table) <- unique(gtlabel$subjects_label)

gt.cen <- expo.scale(gt,center = TRUE, scale = FALSE)

pFi <- sapply(1:length(unique(subj.table)), function(x){
  length(unique(subj.table))/(sv[x])*gt.cen[,which(subj.table == unique(subj.table)[x])] %*% (svd.res$ExPosition.Data$pdq$q[which(subj.table == unique(subj.table)[x]),])
},
simplify = "array")
dimnames(pFi) <- list(rownames(gt.cen),c(1:length(svd.res$ExPosition.Data$eigs)),unique(subj.table))

ch1 <- apply(pFi,c(1:2),mean)
ch2 <- gt_preproc %*% (svd.res$ExPosition.Data$pdq$q)

