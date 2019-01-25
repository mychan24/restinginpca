# 
# load("./data/grandatble_and_labels_20181231.Rdata")
# 
# dim(labels)
# dim(gt)
# 
# parcel1 <- read.table("./data/parcel_community/sub-MSC01_node_parcel_comm.txt")
# 
# s1 <- gt[,labels$subjects_label=="sub01"]
# l1 <- labels$edges_label[labels$subjects_label=="sub01"]
# 
# s1[,l1=="8_29"]
# s1[,l1=="29_8"]

load("./data/grandatble_and_labels_20190125.Rdata")

labels$subjects_edge_label <- NA
for(i in 1:nrow(labels)){
  labels$subjects_edge_label[i] <- paste(labels$subjects_label[i], labels$edges_label[i], sep = "_")
}

ss <- superheat(gt,
          membership.cols = labels$subjects_edge_label,
          membership.rows = c(1:10),
          clustering.method = NULL,
          heat.col.scheme = "viridis",
          left.label.size = 0.05,
          bottom.label.size = 0.05,
          y.axis.reverse = TRUE,
          # left.label.col = Comm.col$gc[order(rownames(Comm.col$gc))], # order by community name
          # bottom.label.col = Comm.col$gc[order(rownames(Comm.col$gc))],
          left.label.text.size = 3,
          bottom.label.text.size = 2,
          # left.label.text.col = c(rep("black",8),rep("white",2),rep("black",3),"white",rep("black",3),rep("white",2)),
          # bottom.label.text.col = c(rep("black",8),rep("white",2),rep("black",3),"white",rep("black",3),rep("white",2)),
          left.label.text.alignment = "left"
)