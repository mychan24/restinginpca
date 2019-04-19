# Make Grand Table with all 10 MSC subjects
# 4/18/2019

rm(list=ls())

source("./tools/cube2gt.R")
source("./tools/label_edges.R")

cube_paths <- list("./data/zmat/sub-MSC01_zcube_rcube.Rdata",
                 "./data/zmat/sub-MSC02_zcube_rcube.Rdata",
                 "./data/zmat/sub-MSC03_zcube_rcube.Rdata",
                 "./data/zmat/sub-MSC04_zcube_rcube.Rdata",
                 "./data/zmat/sub-MSC05_zcube_rcube.Rdata",
                 "./data/zmat/sub-MSC06_zcube_rcube.Rdata",
                 "./data/zmat/sub-MSC07_zcube_rcube.Rdata",
                 "./data/zmat/sub-MSC08_zcube_rcube.Rdata",
                 "./data/zmat/sub-MSC09_zcube_rcube.Rdata",
                 "./data/zmat/sub-MSC10_zcube_rcube.Rdata")

comm_paths <- list("./data/parcel_community/sub-MSC01_node_parcel_comm.txt",
                    "./data/parcel_community/sub-MSC02_node_parcel_comm.txt",
                    "./data/parcel_community/sub-MSC03_node_parcel_comm.txt",
                    "./data/parcel_community/sub-MSC04_node_parcel_comm.txt",
                    "./data/parcel_community/sub-MSC05_node_parcel_comm.txt",
                    "./data/parcel_community/sub-MSC06_node_parcel_comm.txt",
                    "./data/parcel_community/sub-MSC07_node_parcel_comm.txt",
                    "./data/parcel_community/sub-MSC08_node_parcel_comm.txt",
                    "./data/parcel_community/sub-MSC09_node_parcel_comm.txt",
                    "./data/parcel_community/sub-MSC10_node_parcel_comm.txt"
                  )

subj_list <- c("sub01","sub02", "sub03",
               "sub04","sub05", "sub06",
               "sub07","sub08", "sub09","sub10")

p <- cube2gt(cube_paths = cube_paths, comm_paths = comm_paths, 
             out_file = sprintf("./data/grandatble_and_labels_MSC_allsubs_N10_%s.Rdata",format(Sys.time(),"%Y%m%d")),
             subj_list=subj_list)

# Sanity check
superheat::superheat(X = p[[1]],
                     membership.cols = p[[2]]$subjects_edge_label,
                     y.axis.reverse = T,
                     grid.vline = F)