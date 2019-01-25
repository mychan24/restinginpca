####################################################
### Make GrandTable and Labels (edges and subs)  ###
####################################################
# Load 3 subject's data and community labels to create Grand Table.
# Saved Grand Table and Label for mini-block (subjects) and edges label. 
###################################################
# myc, UTD 12/31/2018
###################################################
rm(list=ls())

source("./tools/label_edges.R")

# Load data
load("./data/zmat/sub-MSC01_zcube_rcube.Rdata") 
s1 <- cubes$zcube
load("./data/zmat/sub-MSC02_zcube_rcube.Rdata")
s2 <- cubes$zcube
load("./data/zmat/sub-MSC03_zcube_rcube.Rdata")
s3 <- cubes$zcube
rm(cubes)

# load community labels
c1 <- read.table("./data/parcel_community/sub-MSC01_node_parcel_comm.txt", sep=",")[,3]
c2 <- read.table("./data/parcel_community/sub-MSC02_node_parcel_comm.txt", sep=",")[,3]
c3 <- read.table("./data/parcel_community/sub-MSC03_node_parcel_comm.txt", sep=",")[,3]

# take out negatives
s1[s1<0] <- 0
s2[s2<0] <- 0
s3[s3<0] <- 0

# Take out diagonal (set to 0)
s1[s1=="Inf"] <- 0
s2[s2=="Inf"] <- 0
s3[s3=="Inf"] <- 0

# Make Grand Table (session x c(upper_tris))
allsubs_uppertri <- sum(sum(upper.tri(s1[,,1])), sum(upper.tri(s2[,,1])), sum(upper.tri(s3[,,1])))
gt <- matrix(NA, dim(s1)[3], allsubs_uppertri) 

for(i in 1:dim(s1)[3]){
  m1 <- s1[,,i]
  m2 <- s2[,,i]
  m3 <- s3[,,i]  
  gt[i,] <- c(m1[upper.tri(m1)], m2[upper.tri(m2)], m3[upper.tri(m3)])
}

# Make edges label
l1 <- label_edges(Ci = c1)
l2 <- label_edges(Ci = c2)
l3 <- label_edges(Ci = c3)

ne1 <- length(l1)
ne2 <- length(l2)
ne3 <- length(l3)

labels <- data.frame(edges_label=c(l1,l2,l3), subjects_label=NA)

# Make subject label
labels$subjects_label[1:ne1] <- "sub01"
labels$subjects_label[(ne1+1):(ne1+ne2)] <- "sub02"
labels$subjects_label[(ne1+ne2+1):nrow(labels)] <- "sub03"

labels$subjects_edge_label <- paste(labels$subjects_label, labels$edges_label, sep="_")
labels$wb <- "Within"
labels$wb[grep(pattern = "_", labels$edges_label)] <- "Between"

save(file = sprintf("./data/grandatble_and_labels_%s.Rdata",format(Sys.time(),"%Y%m%d")), list = c("gt", "labels"))
