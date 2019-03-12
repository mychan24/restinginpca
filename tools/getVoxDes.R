## From the parcellation of each subject's correlation matrix, generate the design matrix for regions and color matrix
## Created by Ju-Chi Yu, 03/12/2019
##====================================================
## Function name: getVoxDes
## Input:
##      (1) parcel: a parcel community matrix contains 3 columns:
##            - Row number (i.e., node number)
##            - Parcel number (the vertex number on fsLR)
##            - System assignment numebr (i.e., community assignment)
##      (2) CommName: a reference list for information of the communities contains 5 columns
##            - Comm: community #
##            - CommLabel: Labels for communities
##            - CommColor: Colors for communities
##            - CommLabel.short: Abbreviations for community info
##            - Community: Full name for the communities
## Output:
##      out.vox.des: A vox.des matrix adding three columns to the input parcel matrix
##            - Comm.recode: `Community #`_`full name of the community`
##            - Comm.col: color for each community
##            - Comm.rcd: `Community #``abbreviation`
##      out.vox.des.mat: A design matirx of Comm.col from vox.des
##      out.comm.col: A list with object and group color for the vox.des
##            - oc
##            - gc
#=====================================================
getVoxDes <- function(parcel,CommName){
  # read parcel labels
  vox.des <- parcel
  colnames(vox.des) <- c("NodeID","VertexID","Comm")
  #--- create three columns in the original table of community information: name, color, abbreviation
  for(i in 1:nrow(CommName)){
    vox.des$Comm.recode[vox.des$Comm==CommName$Comm[i]] <- as.character(CommName$CommLabel[i])
    vox.des$Comm.Col[vox.des$Comm==CommName$Comm[i]] <- as.character(CommName$CommColor[i])
    vox.des$Comm.rcd[vox.des$Comm==CommName$Comm[i]] <- as.character(CommName$CommLabel.short[i])
  }
  #--- Create design matrix for communities
  vox.des.mat <- makeNominalData(as.matrix(vox.des$Comm.rcd))
  colnames(vox.des.mat) <- sub(".","",colnames(vox.des.mat))
  
  #--- Create color for each communities
  new.ref.list <- vox.des[!duplicated(vox.des$Comm),]
  Comm.col <- list(oc = as.matrix(vox.des$Comm.Col), gc = as.matrix(new.ref.list$Comm.Col))
  rownames(Comm.col$oc) <- vox.des$NodeID
  rownames(Comm.col$gc) <- new.ref.list$Comm.rcd
  
  # Return
  return(list(vox.des = vox.des, 
              vox.des.mat = vox.des.mat,
              Comm.col = Comm.col)
  )
}