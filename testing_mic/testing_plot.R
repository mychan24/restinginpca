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

superheat(gt[,labels$subjects_label=="sub01"],
          membership.cols = labels$edges_label[labels$subjects_label=="sub01"],
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


## Single subject
jet.colors <- colorRampPalette(c("#00007F", "blue", "#007FFF", "cyan", "#7FFF7F", "yellow", "#FF7F00", "red", "#7F0000"))
jet_noneg.colors <- colorRampPalette(c("blue","cyan","#7FFF7F", "yellow", "#FF7F00", "red", "#7F0000"))

quartz()
superheat(X = s3[,,1],
          membership.cols = c3,
          membership.rows = c3,
          clustering.method = NULL,
          heat.pal = jet_noneg.colors(7), 
          heat.lim = c(0,.5),
          heat.pal.values = c(0,.5,1),
          extreme.values.na = FALSE, # outside of range shows as maximum
          left.label.size = 0.05,
          bottom.label.size = 0.05,
          y.axis.reverse = TRUE,
          left.label.text.size = 3,
          bottom.label.text.size = 2,
          left.label.text.alignment = "left"
)
