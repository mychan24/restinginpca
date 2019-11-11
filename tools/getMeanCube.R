# DESCRIPTION:
#     Load .Rdata cube, reshape as a vector, take the mean network connectivity, and put back to a cube. 
# 
# Inputs:   cube_paths,   paths to node to node matrices stored in .Rdata
#                         e.g., cube_paths <- list.files("./data/zmat/", pattern = "Rdata", full.names = T)
#           comm_paths,   paths to node community to organize grand table. 
#                         e.g., comm_paths <- list.files("./data/parcel_community/", pattern = "comm.txt", full.names = T)#       
#       syslabel_paths,   paths to systemlabel.txt
#                         e.g., syslabel_paths <- "./data/parcel_community/bignetwork/systemlabel_bigcomm.txt"
#           out_file,     Rdata to save gt and gtlabel to. Default = NULL (won't save a file)
#
# Ouput:    mean.cube,    a network x network x session array of mean z-transformed connectivity
# #########################################################################
# JY,  UTD 2019/11/10 - Create function
# #########################################################################
# # TEST script:
# source("./tools/label_edges.R")
# require(tidyr)
# cube_paths <- sapply(X = 1, FUN=function(x){sprintf("./data/zmat/bignetwork/sub-MSC%02d_zcube_rcube_bignet.Rdata",x)})
# comm_paths <- sapply(X = 1, FUN=function(x){sprintf("./data/parcel_community/bignetwork/sub-MSC%02d_node_parcel_bigcomm.txt",x)})
# syslabel_paths <- "./data/parcel_community/bignetwork/systemlabel_bigcomm.txt"
# #########################################################################
getMeanCube <- function(cube_paths, comm_paths, syslabel_paths, out_file=NULL, subj_list=NULL){
  
  if(!exists("label_edges")){
    stop("Source label_edges.R (in ./tools)")
  }
  
  # length of cube and comm paths should match
  if(length(cube_paths)!=length(comm_paths)){
    stop("Length of cube and comm paths does not match. Make sure they are the same length and in the same order")
  }
  
  #########################################################
  # Mini function that loads .Rdata into a specific variable
  #########################################################  
  loadRData <- function(fileName){
    #loads an RData file, and returns it
    load(fileName)
    get(ls()[ls() != "fileName"])
  }
  
  cube <- loadRData(cube_paths)
  s <- cube$zcube
  c <- read.table(comm_paths, sep=",")[,3]
  l <- label_edges(Ci = c, double = TRUE)
  all.edge <- read.csv(syslabel_paths, header = FALSE)
  
  # number of networks
  n.comm <- length(unique(c))
  
  # Take out negatives and Inf (usually diagonals) by setting to 0
  s[s<0] <- 0
  s[s=="Inf"] <- 0
  
  
  # Initialize mean.cube
  mean.cube <- array(NA, dim = c(n.comm, n.comm, dim(s)[3]), dimnames = list(all.edge$V1, all.edge$V1,c())) # An network x network x session array
  # loop to create the mean correlation matrix
  for(j in 1:dim(s)[3]){
    ss <- s[,,j]
    ss.vec <- ss[upper.tri(s[,,1])]
    tab2save <- mean.cube[,,j]
    
    # compute mean connectivity of edges
    EdgeMean <- aggregate(ss.vec, by = list(l), FUN = mean) # get means
    tmp <- data.frame(label = EdgeMean$Group.1) # set labels as data.frame
    tmp$label <- as.character(tmp$label) # set labels as characters
    netlist <- strsplit(tmp$label, split = "_") %>% unlist %>% matrix(ncol = 2, byrow = T, dimnames = list(c(),c("N1","N2"))) %>% 
      data.frame %>% cbind(EdgeMean) # separate labels into two columns and combined with the mean connectivity table
    
    # place mean into a square matrix
    for (run.mean in 1:length(EdgeMean$x)){
      first_net <- as.character(netlist$N1[run.mean])
      second_net <- as.character(netlist$N2[run.mean])
      tab2save[first_net,second_net,j] <- EdgeMean$x[run.mean]
    }
    tab2save[lower.tri(tab2save)] <- t(tab2save)[lower.tri(tab2save)]
    mean.cube[,,j] <- tab2save
  }
  
  if(!is.null(out_file)){
    stop("Please specify the destination directory of the output")
  }
  return(mean.cube)
}
