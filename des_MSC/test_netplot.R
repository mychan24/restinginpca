library(netplot) # devtools::install_github("USCCANA/netplot")
library(igraph)
net <- graph.adjacency(adjmatrix = z4, mode = "undirected", diag = F, weighted = T)

V(net)$id <- parcel.list[[subj.name[subj.count]]]$vox.des$NodeID
V(net)$community <- parcel.list[[subj.name[subj.count]]]$vox.des$Comm

net <- simplify(net, remove.multiple = F, remove.loops = T) 
edge_attr(net, "label") <- ""


poo <- list()
poo[[1]] <- list()
# poo[[1]][[1]] <- as.grob(function() plot(net, layout=layout_with_fr, vertex.size=5, vertex.label="", vertex.color=parcel.list[[subj.name[subj.count]]]$vox.des$Comm.Col, alpha=.6, vertex.label.cex=0, edge.label="1"))
poo[[1]][[1]] <- as.grob(function() nplot(net))

do.call(grid.arrange, c(poo[[1]], ncol=1))

netplot::nplot(net, 
               layout=1, 
               vertex.color=parcel.list[[subj.name[subj.count]]]$vox.des$Comm.Col)