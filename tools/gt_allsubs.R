# Make Grand Table with all 10 MSC subjects - with double centered correlation matrix
# 8/13/2019 - Use sapply for paths and subs
# 8/1/2019

rm(list=ls())

source("./tools/cube2gt.R")
source("./tools/label_edges.R")
library(tidyr)

#### ==== EDIT THIS PART ==== ####
# switch to FALSE if not double centered
double_center <- TRUE 
#### ======================== ####

# Define paths where cubes, community are saved and subject naem
cube_paths <- sapply(X = 1:10, FUN=function(x){sprintf("./data/zmat/sub-MSC%02d_zcube_rcube.Rdata",x)})
comm_paths <- sapply(X = 1:10, FUN=function(x){sprintf("./data/parcel_community/sub-MSC%02d_node_parcel_comm.txt",x)})
subj_list <- paste("sub", sprintf("%02d",1:10), sep="")

## Run and save double-centered or non-double-ceneterd gt table with diff out_file and doubt_cent option
if(double_center==TRUE){
  p <- cube2gt(cube_paths = cube_paths, comm_paths = comm_paths,
               out_file = sprintf("./data/grandatble_and_labels_MSC_allsubs_DC_%s.Rdata",format(Sys.time(),"%Y%m%d")),
               subj_list=subj_list, double_cent = TRUE)
  }else{
    p <- cube2gt(cube_paths = cube_paths, comm_paths = comm_paths, 
             out_file = sprintf("./data/grandatble_and_labels_MSC_allsubs_%s.Rdata",format(Sys.time(),"%Y%m%d")),
             subj_list=subj_list, double_cent = FALSE)
  }
