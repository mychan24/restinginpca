# Make Grand Table with all 10 MSC subjects only including the big networks
# 8/6/2019

rm(list=ls())

load(paste0("./data/grandatble_and_labels_MSC_allsubs_N10_20190418.Rdata")) # read the labels of grandtable

# Syslabel with consistent networks only
CommName <- read.csv("./data/parcel_community/bignetwork/systemlabel_bigcomm.txt",header = FALSE)

bignet_count <- sapply(X = gtlabel$edges_label, 
                            FUN=function(x){strsplit(as.character(x), "_") %>% 
                           unlist %>%
                           is.element(CommName$V1) %>%
                           sum})
# Between Networks
gtlabel$bignet <- "N"
gtlabel$bignet[bignet_count==2] <- "Y"

# Within netowrk
gtlabel$bignet[gtlabel$wb=="Within" & bignet_count==1] <- "Y"

save(file = "./data/grandatble_and_labels_bignetcol_MSC_allsubs_N10_20190620.Rdata", list = c("gt", "gtlabel"))
