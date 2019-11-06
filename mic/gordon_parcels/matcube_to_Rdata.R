library(R.matlab)

setwd("/data/datax/data3/MSC/RSFC_matrix/Gordon333")

for(i in 1:10){
  
  cube <- readMat(sprintf("./mat/sub-MSC%02d_sess1_10_r_z_cubes.mat",i))
  save(cube ,file=sprintf("./Rdata/sub-MSC%02d_sess1_10_r_z_cubes.Rdata",i))
}

