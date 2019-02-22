# mapping factor scores back to square matrix
# devtools::install_github("mychan24/superheat")
library(superheat)
rm(list=ls())

##### Setup
load("./data/pca_result_centered_x_session.Rdata") # 
load("./data/grandatble_and_labels_20190204.Rdata") # 10 x 535252
labels[,'subjects_wb'] <- sprintf('%s_%s',labels$subjects_label,labels$wb)

sub1_label <- read.table("./data/parcel_community/sub-MSC01_node_parcel_comm.txt", sep=",")

# mean.fi <- getMeans(pca.res.subj$ExPosition.Data$fi, labels$subjects_edge_label) # with t(gt)
fi1 <- pca.res.subj$ExPosition.Data$fi[,1]
fi1_sub1 <- fi1[labels$subjects_label=="sub01"]
fi1_sub2 <- fi1[labels$subjects_label=="sub02"]
fi1_sub3 <- fi1[labels$subjects_label=="sub03"]

##### Make function

# check with labels
unique(labels$edges_label)

fi1_sub1_mat <- matrix(0, 602, 602)
fi1_sub1_mat[upper.tri(fi1_sub1_mat)] <- fi1_sub1
fi1_sub1_mat[lower.tri(fi1_sub1_mat)] <- t(fi1_sub1_mat)[lower.tri(fi1_sub1_mat)]

superheat(fi1_sub1_mat, y.axis.reverse = T,
          membership.rows = sub1_label$V3,
          membership.cols = sub1_label$V3)

# Compononet 2
fi2_sub1 <- pca.res.subj$ExPosition.Data$fi[labels$subjects_label=="sub01",2]
fi2_sub1_mat <- matrix(0, 602, 602)
fi2_sub1_mat[upper.tri(fi2_sub1_mat)] <- fi2_sub1
fi2_sub1_mat[lower.tri(fi2_sub1_mat)] <- t(fi2_sub1_mat)[lower.tri(fi2_sub1_mat)]


superheat(fi2_sub1_mat, y.axis.reverse = T,
          membership.rows = sub1_label$V3,
          membership.cols = sub1_label$V3)




