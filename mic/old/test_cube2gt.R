# Test cube2gt.R

rm(list=ls())

cube_paths <- list.files("./data/zmat/", pattern = "Rdata", full.names = T)
comm_paths <- list.files("./data/parcel_community/", pattern = "comm.txt", full.names = T)
comm_paths <- comm_paths[1:3]

source("./tools/cube2gt.R")
source("./tools/label_edges.R")

g <- cube2gt(cube_paths, comm_paths)

ngt <- g[[1]]
gtlabel <- g[[2]]

load("./data/grandatble_and_labels_20190204.Rdata")

# gt from function is the same as manual one
identical(ngt, gt)

