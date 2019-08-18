## The fscore2cifti function doesn't work for Windows. So, this script is to generate the same plots in Windows system.
## (Edited from the fscore2cifti.R function)
#=========================================================
## Date: 8/18/2019
## Author: Ju-Chi Yu
##========================================================
library(cifti)

tool.path <- "./tools/"
source(paste0(tool.path,"vec2sqmat.R"))

# Start here.....#############################
methodnum <- 11 # Method number
load(sprintf("BigNet_%s.RData",methodnum)) # Read data file

# Set parameters
sb2map <- 1 # The subject to map
cp2map <- 1 # The factor score to map to the brain

# Options for function
outdir <- "C:/Users/juchi/Box Sync/Abdi_lab/Colaborations/restinginpca/jc/"
fj <- svd.res$ExPosition.Data$fj[,cp2map]
bignetwork <- TRUE

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

cifti_in_file <- sprintf("C:/Users/juchi/Box Sync/Abdi_lab/Colaborations/restinginpca/data/cifti/sub-MSC%02d/sub-MSC%02d_parcels.dtseries.nii",sb2map,sb2map) # subject's parcellation
cifti_out_file <- file.path(outdir, sprintf("%s_fj_sub-MSC%02d_cp%s.dtseries.nii",methodnum,sb2map,cp2map))

cii <- read_cifti(cifti_in_file)
parcel_info <- read.table(sprintf("./data/parcel_community/sub-MSC%02d_node_parcel_comm.txt",sb2map), sep=",", 
                          col.names = c("Index","ParcelNum","Comm"))

# Reduce parcel info if only big networks were used to generate factor scores

sys <- read.csv("./data/parcel_community/bignetwork/systemlabel_bigcomm.txt", header=F)
parcel_info <- parcel_info[is.element(parcel_info$Comm, sys$V1),]


cii_fj <- cii
cii_fj$data[!is.element(cii$data,parcel_info$ParcelNum)] <- 0

for(j in 1:nrow(parcel_info)){
  parcel_i <- parcel_info$ParcelNum[j]
  cii_fj$data[cii$data==parcel_i] <- mfj[[sb2map]][j]
}

# write fj mapped to cifti postioin to textfile 
fj_file <- sprintf("C:/Users/juchi/Box Sync/Abdi_lab/Colaborations/restinginpca/jc/MSC%02d_fj_temp.txt",sb2map)
write.table(cii_fj$data, file = fj_file, sep = " ", col.names = F, row.names = F, quote = F)

#########################################
### Use workbench: this goes into cmd ###
#########################################
sprintf("wb_command -cifti-convert -from-text %s %s %s", fj_file, cifti_in_file, cifti_out_file) 
# Box Sync in the output needs to be changed to "Box Sync" manually before entering to cmd