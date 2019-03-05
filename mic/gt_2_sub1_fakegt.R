## Make 5 rows x two Sub1 grand table from 3sub grand table

load("./data/grandatble_and_labels_20190204.Rdata")

gt_s1 <- matrix(NA, 5, (sum(labels$subjects_label=="sub01")*2))

gt_s1[,1:sum(labels$subjects_label=="sub01")] <- gt[1:5, labels$subjects_label=="sub01"]
gt_s1[,(sum(labels$subjects_label=="sub01")+1):(sum(labels$subjects_label=="sub01")*2)] <- gt[6:10, labels$subjects_label=="sub01"]

labels_s1 <- rbind(labels[labels$subjects_label=="sub01",],labels[labels$subjects_label=="sub01",])
labels_s1$subjects_label[1:sum(labels$subjects_label=="sub01")] <- gt[1:5, labels$subjects_label=="sub01"] <- "sub01_a"
labels_s1$subjects_label[(sum(labels$subjects_label=="sub01")+1):(sum(labels$subjects_label=="sub01")*2)] <- "sub01_b"

save(file = sprintf("./data/sub1_grandatble_and_labels_%s.Rdata",format(Sys.time(),"%Y%m%d")), 
     list = c("gt_s1", "labels_s1"))