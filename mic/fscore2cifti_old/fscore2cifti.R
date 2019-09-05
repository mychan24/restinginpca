# DESCRIPTION:
#     Save factor score to CIFTI files (brain) 
# 
# Inputs:   outdir,       paths to where CIFTI files for each subject's factor score is outputted#                     
#           fj,           factor score (single column)
#           gtlabel,      a gtlabel object that matches the fj object
#           bignetwork,   TRUE if big networks were used, FALSE If not (Default=TRUE)
#           wb_path,      path to workbench, if NULL, assumes default
#                         e.g., ("C:\\Users\<user>\Documents\wokrbench\bin_windows64")
#
# Ouput:    CIFTI files outputted in outdir
#
# Example Usage:
#     fscore2cifti(outdir = "./result_folder/component1/", 
#                  fj = svd.res$ExPosition.Data$fj[,1],
#                  gtlabel = gtlabel, 
#                  bignetwork = TRUE,
#                  wb_path = NULL)
# #########################################################################
# myc, UTD 2019/08/16 - initial
# #########################################################################
fscore2cifti = function(outdir, fj, gtlabel, bignetwork=TRUE, wb_path=NULL) {

library(cifti)

tool.path <- "./tools/"
source(paste0(tool.path,"vec2sqmat.R"))

###############################################
#### Get mean factor score for each parcel ####
###############################################
subj.name <- levels(gtlabel$subjects_label)

fj_sqmat <- list()
for(i in 1:length(subj.name)){
  fj_sqmat[[i]] <- vec2sqmat(fj[gtlabel$subjects_label==subj.name[i]])
}

mfj <- lapply(fj_sqmat, FUN = rowSums)

names(mfj) <- paste("sub", sprintf("%02d",1:10), sep = "")

#################################################################
#### ==== Load parcellation cifti and parcellation info ==== ####
#################################################################

for(i in 1:length(subj.name)){
  cifti_in_file <- sprintf("./data/cifti/sub-MSC%02d/sub-MSC%02d_parcels.dtseries.nii",i,i) # subject's parcellation
  cifti_out_file <- file.path(outdir, sprintf("fj_sub-MSC%02d.dtseries.nii",i))
  
  cii <- read_cifti(cifti_in_file)
  parcel_info <- read.table(sprintf("./data/parcel_community/sub-MSC%02d_node_parcel_comm.txt",i), sep=",", 
                            col.names = c("Index","ParcelNum","Comm"))
  
  # Reduce parcel info if only big networks were used to generate factor scores
  if(bignetwork==TRUE){
    sys <- read.csv("./data/parcel_community/bignetwork/systemlabel_bigcomm.txt", header=F)
    parcel_info <- parcel_info[is.element(parcel_info$Comm, sys$V1),]
  }
  
  cii_fj <- cii
  cii_fj$data[!is.element(cii$data,parcel_info$ParcelNum)] <- 0
  
  for(j in 1:nrow(parcel_info)){
    parcel_i <- parcel_info$ParcelNum[j]
    cii_fj$data[cii$data==parcel_i] <- mfj[[i]][j]
  }

  ##############################
  ### Uee workbench command ###
  ##############################
  # write fj mapped to cifti postioin to textfile 
  fj_file <- "./fj_temp.txt"
  write.table(cii_fj$data, file = fj_file, sep = " ", col.names = F, row.names = F, quote = F)
  
  if(is.null(wb_path)){
    switch(Sys.info()[['sysname']],
           Linux = {wbcommand <- "wb_command"}, # Need to update for Windows ***
           Windows= {wbcommand <- "C:\\Program Files\\workbench\\bin_macosx64\\wb_command"},
           Darwin = {wbcommand <- "/Applications/workbench/bin_macosx64/wb_command"})
  }else{
    wbcommand <- file.path(wb_path, "wb_command")
  }
  
  system(sprintf("%s -cifti-convert -from-text %s %s %s", wbcommand, fj_file, cifti_in_file, cifti_out_file))
  
  file.remove(fj_file) # remove temp fj text file
  }
}
