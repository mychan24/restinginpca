## Compute Sums of Squares of each network (community)
## Created by Ju-Chi Yu, 01/18/2019
##====================================================
## Function name: SScomm
## Input:
##      (1) data: n x n x m array; 
##                a 3-D array with matching lengths (n) of the first two dimensions (i.e., an array of m square matrices)
##      (2) des.mat: n x #group disjuctively coded matrix ; 
##                  according to this design matrix, we want to compute SS of each table along the 3rd dimension of data
## Output:
##      An #group x #group x m array
#=====================================================
SScomm <- function(data,des.mat){
  # Order the volumns and rows of the design matrix
  des.mat.order <- des.mat[,order(colnames(des.mat))]
  # Compute and place into an array
  out.res <- simplify2array(lapply(c(1:dim(data)[3]),function(x) t(des.mat.order) %*% data[,,x]^2 %*% des.mat.order))
  # Return
  return(out.res)
}