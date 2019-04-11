# MSC01 and MSC08

rm(list=ls())

source("./tools/cube2gt.R")
source("./tools/label_edges.R")

cube_paths <- list("./data/zmat/sub-MSC01_zcube_rcube.Rdata",
                 "./data/zmat/sub-MSC08_zcube_rcube.Rdata")

comm_paths <- list("./data/parcel_community/sub-MSC01_node_parcel_comm.txt",
                 "./data/parcel_community/sub-MSC08_node_parcel_comm.txt")


p <- cube2gt(cube_paths = cube_paths, comm_paths = comm_paths, 
             out_file = sprintf("./data/grandatble_and_labels_MSC01_MSC08_%s.Rdata",format(Sys.time(),"%Y%m%d")))

# Sanity check
# superheat::superheat(X = p[[1]], membership.cols = p[[2]]$wb)