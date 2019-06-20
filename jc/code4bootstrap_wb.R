suppressMessages(library(PTCA4CATA))

tictoc::tic()
BootCube.Comm.bw <- Boot4Mean(svd.res$ExPosition.Data$fj,
                              design = gtlabel$subjects_wb,
                              niter = 100,
                              suppressProgressBar = TRUE)
tictoc::toc()