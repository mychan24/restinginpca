# First bootstrap ----
BootCube.Comm <- PTCA4CATA::Boot4Mean(svd.res$ExPosition.Data$fj,
                           design = gtlabel$subjects_edge_label,
                           niter = 100,
                           suppressProgressBar = TRUE)

# Second bootstrap ----
BootCube.Comm.bw <- PTCA4CATA::Boot4Mean(svd.res$ExPosition.Data$fj,
                              design = gtlabel$subjects_wb,
                              niter = 100,
                              suppressProgressBar = TRUE)
