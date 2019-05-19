library(netplot) # devtools::install_github("USCCANA/netplot")
poo <- list()
poo[[1]] <- list()
poo[[1]][[1]] <- as.grob(function() plot(net, layout=layout_with_fr, vertex.label=NA, vertex.size=5, vertex.color=parcel.list[[subj.name[subj.count]]]$vox.des$Comm.Col, alpha=.6, vertex.label.cex=0))

do.call(grid.arrange, c(poo[[1]], ncol=1))

netplot::nplot(net, 
               layout=1, 
               vertex.color=parcel.list[[subj.name[subj.count]]]$vox.des$Comm.Col)