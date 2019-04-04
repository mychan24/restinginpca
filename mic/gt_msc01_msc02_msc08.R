# MSC01, MSC02, MSC08

rm(list=ls())

source("./tools/cube2gt.R")
source("./tools/label_edges.R")

cubepath <- list("./data/zmat/sub-MSC01_zcube_rcube.Rdata",
                 "./data/zmat/sub-MSC02_zcube_rcube.Rdata",
                 "./data/zmat/sub-MSC08_zcube_rcube.Rdata")

commpath <- list("./data/parcel_community/sub-MSC01_node_parcel_comm.txt",
                 "./data/parcel_community/sub-MSC02_node_parcel_comm.txt",
                 "./data/parcel_community/sub-MSC08_node_parcel_comm.txt")


p <- cube2gt(cube_paths = cubepath, comm_paths = commpath, 
             out_file = sprintf("./data/grandatble_and_labels_MSC01_MSC02_MSC08_%s.Rdata",format(Sys.time(),"%Y%m%d")))

# Sanity check
# superheat::superheat(X = p[[1]], membership.cols = p[[2]]$wb)