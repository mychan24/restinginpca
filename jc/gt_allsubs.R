# Make Grand Table with all 10 MSC subjects
# 4/18/2019

rm(list=ls())

source("./tools/cube2gt.R")
source("./tools/label_edges.R")

cube_paths <- list("./data/zmat/sub-MSC01_zcube_rcube.Rdata")

comm_paths <- list("./data/parcel_community/sub-MSC01_node_parcel_comm.txt"                  )

subj_list <- c("sub01")

p <- cube2gt(cube_paths = cube_paths, comm_paths = comm_paths, 
             out_file = sprintf("./data/grandatble_and_labels_MSC_subs1_%s.Rdata",format(Sys.time(),"%Y%m%d")),
             subj_list=subj_list)

# Sanity check
# superheat::superheat(X = p[[1]],
#                      membership.cols = p[[2]]$subjects_edge_label,
#                      y.axis.reverse = T,
#                      grid.vline = F)