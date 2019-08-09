suppressMessages(library(PTCA4CATA))

tictoc::tic()
BootCube.Comm.bw <- Boot4Mean(svd.res$ExPosition.Data$fj,
                              parallelize = T,
                              design = gtlabel$subjects_wb,
                              niter = 100,
                              suppressProgressBar = TRUE)
tictoc::toc()