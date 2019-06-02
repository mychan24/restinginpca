# Make cube for all subs
source("./tools/tp_to_rz.R")

# subs <- 1:10

subs <- c(4:7,9:10)

for(s in subs){
  par_label <- read.table(sprintf("./data/parcel_community/sub-MSC%02d_node_parcel_comm.txt",s), sep=",")
  nn <- nrow(par_label)
  
  cubes <- list()
  cubes$zcube <- array(data = NA, dim = c(nn,nn, 10))
  cubes$rcube <- array(data = NA, dim = c(nn,nn, 10))
  
  for(i in 1:10){
    tp <- as.matrix(read.table(sprintf("./data/tp/sub-MSC%02d_sess%02d_parcel_x_tp.txt",s,i), sep=","))
    
    r <- tp_to_rz(tp = tp, fisherz = F)
    z <- tp_to_rz(tp = tp, fisherz = T)
  
    cubes$rcube[,,i] <- r  
    cubes$zcube[,,i] <- z  
    
  }
  save(file = sprintf("./data/zmat/sub-MSC%02d_zcube_rcube.Rdata", s), cubes)
}

# sanity check
#superheat::superheat(cubes$rcube[,,1], y.axis.reverse = T, membership.rows = par_label$V3, membership.cols = par_label$V3)
#superheat::superheat(cubes$rcube[,,2], y.axis.reverse = T, membership.rows = par_label$V3, membership.cols = par_label$V3)