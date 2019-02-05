load("./data/grandatble_and_labels_20190204.Rdata")

# ====  Plot Grand Table of 3 subjects 
png(sprintf("./mic/GrandTable_3subs_%s.png",format(Sys.time(),"%Y%m%d")), width = 3000, height = 2530)

superheat::superheat(gt,
          membership.cols = labels$subjects_edge_label,
          membership.rows = c(1:10),
          clustering.method = NULL,
          heat.col.scheme = "viridis",
          left.label.size = 0.05,
          bottom.label.size = 0.05,
          y.axis.reverse = TRUE,
          left.label.text.size = 3,
          bottom.label.text.size = 2,
          left.label.text.alignment = "left",
          title = "Grand Table: Subject/EdgeType (X) by Sessions (Y)"
)
dev.off()

##Plot matrix of single subject
# jet.colors <- colorRampPalette(c("#00007F", "blue", "#007FFF", "cyan", "#7FFF7F", "yellow", "#FF7F00", "red", "#7F0000"))
# jet_noneg.colors <- colorRampPalette(c("blue","cyan","#7FFF7F", "yellow", "#FF7F00", "red", "#7F0000"))
parula.col <- colorRampPalette(c("#352A87","#1D50CE","#0872DC","#1189D2","#06A2C9","#1AB1AF","#51BC8F","#91BE71","#C5BB5C","#F2BB44","#F9D428","#F9FB0E"))

quartz()
superheat::superheat(X = s3[,,1],
          membership.cols = c3,
          membership.rows = c3,
          clustering.method = NULL,
          heat.pal = parula.col(12), 
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


superheat::superheat(X = s2[,,1],
                     membership.cols = c2,
                     membership.rows = c2,
                     clustering.method = NULL,
                     heat.pal = parula.col(7), 
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

