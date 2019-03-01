# DESCRIPTION:
#     Load .Rdata cubes and organize into grand table. 
# 
# Inputs:   cube_paths,   paths to node to node matrices stored in .Rdata
#                         e.g., cube_paths <- list.files("./data/zmat/", pattern = "Rdata", full.names = T)
#           comm_paths,   paths to node community to organize grand table. 
#                         e.g., comm_paths <- list.files("./data/parcel_community/", pattern = "comm.txt", full.names = T)
# Ouput:    gt,           grand table based on zcube
#           gtlabel,     grand table labels (edges_label, subjects_label, subjects_edge_label, within_between)
# #########################################################################
# myc, UTD 2019/03/01 - Initial
# #########################################################################
cube2gt <- function(cube_paths, comm_paths){
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
  
  nsub <- length(cube_paths)
  
  for(i in 1:nsub){
    cube <- loadRData(cube_paths[i])
    s <- cube$zcube
    c <- read.table(comm_paths[i], sep=",")[,3]
    
    # Take out negatives and Inf (usually diagonals) by setting to 0
    s[s<0] <- 0
    s[s=="Inf"] <- 0
    
    # Initialize sub-table
    subtab <- matrix(NA, dim(s)[3], sum(upper.tri(s[,,1]))) # session x upper-tri edges
    for(j in 1:dim(s)[3]){
      ss <- s[,,j]
      subtab[j,] <- ss[upper.tri(s[,,1])]
    }
    
    # Make edges label
    l <- label_edges(Ci = c)
    sublabel <- data.frame(edges_label=l, subjects_label=sprintf("sub%02d", i))
    
    # append to grand table
    if(exists("gt")){
      gt <- cbind(gt, subtab)
      gtlabel <- rbind(gtlabel, sublabel)
    }else{
      gt <- subtab
      gtlabel <- sublabel
    }
  }
  
  gtlabel$subjects_edge_label <- paste(gtlabel$subjects_label, gtlabel$edges_label, sep="_")
  gtlabel$wb <- "Within"
  gtlabel$wb[grep(pattern = "_", gtlabel$edges_label)] <- "Between"
  
  return(list(gt, gtlabel))
}
