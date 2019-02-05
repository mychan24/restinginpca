# Convert Cubes in .mat (matlab) to Rdata

library(R.matlab)

for(i in 1:3){
cubes <- readMat(sprintf("./data/zmat/matlab/sub-MSC%02d_zcube_rcube.mat",i))

save(cubes, file = sprintf("./data/zmat/sub-MSC%02d_zcube_rcube.Rdata",i))

}