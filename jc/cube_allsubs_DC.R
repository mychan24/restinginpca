## Copied from mic/ to generate double-centered cubes
# Edited by JC 2019/08/01
#------------------------------
# Note: 
#    - I added the double-centering for r cube: rcube.dc
#    - I commented all lines for zcube and rcube, and only return rcube.dc and zcube.dc
#    - zcube.dc is the z-transformed matrix after double-centering
#=======================================================
# Make cube for all subs
source("./tools/tp_to_rz.R")
library(dplyr)

# subs <- 1

subs <- c(1:10)

for(s in subs){
  par_label <- read.table(sprintf("./data/parcel_community/sub-MSC%02d_node_parcel_comm.txt",s), sep=",")
  nn <- nrow(par_label)
  
  cubes <- list()
  cubes$zcube <- array(data = NA, dim = c(nn,nn, 10))
  cubes$rcube <- array(data = NA, dim = c(nn,nn, 10))
  ## cubes$rcube.dc <- array(data = NA, dim = c(nn,nn, 10))
  cubes$zcube.dc <- array(data = NA, dim = c(nn,nn, 10))
  
  for(i in 1:10){
    tp <- as.matrix(read.table(sprintf("./data/tp/sub-MSC%02d_sess%02d_parcel_x_tp.txt",s,i), sep=","))
    
    r <- tp_to_rz(tp = tp, fisherz = F)
    
    z <- tp_to_rz(tp = tp, fisherz = T)
    
    # Add double-centered the z-transformed correlation matrix ----
    z.dc <- z %>% scale(scale = FALSE) %>% t %>% scale(scale = FALSE)
    
    cubes$rcube[,,i] <- r
    cubes$zcube[,,i] <- z
    cubes$zcube.dc[,,i] <- z.dc  
  }
  save(file = sprintf("./data/zmat/sub-MSC%02d_zcube_rcube_DC.Rdata", s), cubes)
}

# sanity check
# superheat::superheat(cubes$rcube[,,1], y.axis.reverse = T)
#superheat::superheat(cubes$rcube[,,1], y.axis.reverse = T, membership.rows = par_label$V3, membership.cols = par_label$V3)
#superheat::superheat(cubes$rcube[,,2], y.axis.reverse = T, membership.rows = par_label$V3, membership.cols = par_label$V3)