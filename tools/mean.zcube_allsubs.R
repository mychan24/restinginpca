# Make cube of means for all subjects
# JY; 11/10/2019

rm(list = ls())

# library to load
require(tidyr)
source("./tools/getMeanCube.R")
source("./tools/label_edges.R")

# set up parameters
cube_paths <- sapply(X = 1:10, FUN=function(x){sprintf("./data/zmat/bignetwork/sub-MSC%02d_zcube_rcube_bignet.Rdata",x)})
comm_paths <- sapply(X = 1:10, FUN=function(x){sprintf("./data/parcel_community/bignetwork/sub-MSC%02d_node_parcel_bigcomm.txt",x)})
syslabel_paths <- "./data/parcel_community/bignetwork/systemlabel_bigcomm.txt"

out_file <- sapply(X = 1:10, FUN=function(x){sprintf("./data/zmat/bignetwork_mean/sub-MSC%02d_node_parcel_bigcomm_mean.Rdata",x)})

# Get the mean cube for each participant
sapply(X = 1:10, FUN = function(X){getMeanCube(cube_paths[X], comm_paths[X], syslabel_paths, out_file[X])})
