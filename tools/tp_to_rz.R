# DESCRIPTION:
#     Load TP (node x timepoint matrix) and ouptut correlation matrix (z or r matrix).
#     Defaults to outputting Fisher's Z-transformed z matrix.
# Inputs:   tp,		   roi x time matrix
#           fisherz, z-transformed output correlation matrix 
#                    (DEFAULT = TRUE)
# Ouput:    x,       roi x roi correlation matrix
# #########################################################################
# myc, UTD 2018/12/12 - Initial
# #########################################################################
tp_to_rz <- function(tp, fisherz=TRUE){
  
  if(is.character(tp)){
    tp <- read.table(file = tp, sep=",") # read tp from file if tp is character 
  }
  x <- cor(t(tp)) # correlation
  
  if(fisherz==TRUE){
    x <- 0.5 * log((1+x)/(1-x)); # Fisher-z transform
  }
  return(x)
}

