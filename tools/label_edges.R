# DESCRIPTION:
#     Take a community label vector and output a vector of label for edges.
#     The output vector labels the upper-triangle of a symmetrical matrix.
# Inputs:   Ci, Community indexing vector
#   
# Ouput:    L,   Label of edge 
# #############################################################################
# myc, UTD 1/25/2019 - make sysA-sysB connection labeled the same as sysB-sysA
# myc, UTD 12/31/2018 - Initial
# #############################################################################
label_edges <- function(Ci){
  n <- length(Ci)
  u <- unique(Ci)
  
  labelmat <- matrix(NA, n,n)
  
  # Labels a symmetrical matrix based on Ci
  for(i in 1:length(u)){ 
    for(j in 1:length(u)){
      if(i==j){   
        labelmat[Ci==u[i], Ci==u[j]] <- sprintf("%s",u[i])          # within commmunity
      }else{
        # whichever system # is smaller goes first
        if(u[i] < u[j]){
          firstsys <- u[i]
          secondsys <- u[j]
        }else{
          firstsys <- u[j]
          secondsys <- u[i]
        }
        labelmat[Ci==u[i], Ci==u[j]] <- sprintf("%s_%s",firstsys, secondsys) # between commmunities
      }
    }
  }
  L <- labelmat[upper.tri(labelmat)] # extract upper triangle for output
  
  return(L)
}
  


