# Make Grand Table with all 10 MSC subjects only including the big networks
# 6/20/2019

rm(list=ls())

load(paste0("./data/grandatble_and_labels_MSC_allsubs_N10_20190418.Rdata")) # read the labels of grandtable

# Syslabel with consistent networks only
CommName <- read.csv("./data/parcel_community/bignetwork/systemlabel_bigcomm.txt",header = FALSE)

# Between Networks
bignet_between_count <- sapply(X = gtlabel$edges_label, 
                         FUN=function(x){strsplit(as.character(x), "_") %>% unlist %>% as.numeric %>% is.element(CommName$V1) %>% sum})
gtlabel$bignet <- "N"
gtlabel$bignet[bignet_between_count==2] <- "Y"
gtlabel$bignet[gtlabel$wb=="Within"] <- "Y"

save(file = "./data/grandatble_and_labels_bignetcol_MSC_allsubs_N10_20190620.Rdata", list = c("gt", "gtlabel"))
