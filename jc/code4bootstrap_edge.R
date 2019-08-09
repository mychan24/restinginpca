suppressMessages(library(PTCA4CATA))

tictoc::tic()
BootCube.Comm <- Boot4Mean(svd.res$ExPosition.Data$fj,
                           parallelize = T, 
                           design = gtlabel$subjects_edge_label,
                           niter = 100,
                           suppressProgressBar = TRUE)
tictoc::toc()
