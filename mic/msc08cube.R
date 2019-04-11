# Make MSC08 cube

source("./tools/tp_to_rz.R")

par_label <- read.table("./data/parcel_community/sub-MSC08_node_parcel_comm.txt", sep=",")
nn <- nrow(par_label)

cubes <- list()
cubes$zcube <- array(data = NA, dim = c(nn,nn, 10))
cubes$rcube <- array(data = NA, dim = c(nn,nn, 10))

for(i in 1:10){
  tp <- as.matrix(read.table(sprintf("./data/tp/sub-MSC08_sess%02d_parcel_x_tp.txt",i), sep=","))
  
  r <- tp_to_rz(tp = tp, fisherz = F)
  z <- tp_to_rz(tp = tp, fisherz = T)

  cubes$rcube[,,i] <- r  
  cubes$zcube[,,i] <- z  
  
}
save(file = "./data/zmat/sub-MSC08_zcube_rcube.Rdata", cubes)

# sanity check
#superheat::superheat(cubes$rcube[,,1], y.axis.reverse = T, membership.rows = par_label$V3, membership.cols = par_label$V3)
#superheat::superheat(cubes$rcube[,,2], y.axis.reverse = T, membership.rows = par_label$V3, membership.cols = par_label$V3)