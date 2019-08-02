# DESCRIPTION:
#     Load .Rdata cubes and organize into grand table. 
# 
# Inputs:   cube_paths,   paths to node to node matrices stored in .Rdata
#                         e.g., cube_paths <- list.files("./data/zmat/", pattern = "Rdata", full.names = T)
#           comm_paths,   paths to node community to organize grand table. 
#                         e.g., comm_paths <- list.files("./data/parcel_community/", pattern = "comm.txt", full.names = T)
#           out_file,     Rdata to save gt and gtlabel to. Default = NULL (won't save a file)
#           subj_list,    vector of subjID as string, corresponding to order in cube/comm_paths
#           double_cent,  Option to double-center the matrix (STATIS-like prepro)
#       
#
# Ouput:    gt,           grand table based on zcube
#           gtlabel,     grand table labels (edges_label, subjects_label, subjects_edge_label, within_between)
# #########################################################################
# jc,  UTD 2019/08/01 - Comment out double-center option (it should be operated on the correlation matrix)
# jc,  UTD 2019/06/19 - Add option to double-center matrix
# myc, UTD 2019/04/11 - Add subj_list input
# myc, UTD 2019/03/01 - Initial
# #########################################################################
cube2gt <- function(cube_paths, comm_paths, out_file=NULL, subj_list=NULL, double_cent=NULL){
  
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
  
  print(sprintf("Total subjects: %d", nsub))
  
  for(i in 1:nsub){
    cube <- loadRData(cube_paths[[i]])
    s <- cube$zcube
    c <- read.table(comm_paths[[i]], sep=",")[,3]
    
    # Take out negatives and Inf (usually diagonals) by setting to 0
    s[s<0] <- 0
    s[s=="Inf"] <- 0
    
    
    # Initialize sub-table
    subtab <- matrix(NA, dim(s)[3], sum(upper.tri(s[,,1]))) # session x upper-tri edges
    for(j in 1:dim(s)[3]){
      
      ########################
      # Add double-centering #
      ########################=======
      # if (double_cent){
      #   s[,,j] <- s[,,j] %>% scale(scale = FALSE) %>% t %>% scale(scale = FALSE)
      # }
      #==============================
      
      ss <- s[,,j]
      subtab[j,] <- ss[upper.tri(s[,,1])]
    }
    
    # Make edges label
    l <- label_edges(Ci = c)
    sublabel <- data.frame(edges_label=l, subjects_label=sprintf("%s", subj_list[i]))
    
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
  
  if(!is.null(out_file)){
    save(file = out_file, list = c("gt", "gtlabel"))
  }
  
  return(list(gt, gtlabel))
}
